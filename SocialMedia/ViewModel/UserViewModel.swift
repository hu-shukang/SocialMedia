//
//  UserViewModel.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/18.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var about: String = ""
    @Published var bioLink: String = ""
    @Published var profilePicData: Data?
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_uid") var uidStored: String = ""
    
    static let shared = UserViewModel()
    
    var registerButtonDisable: Bool {
        return email == "" || password == "" || userName == "" || about == "" || profilePicData == nil
    }
    
    func initFileds() {
        email = ""
        password = ""
        userName = ""
        about = ""
        bioLink = ""
        profilePicData = nil
    }
    
    func selectPhoto(_ selectedItem: PhotosPickerItem?) async {
        if let item = selectedItem {
            do {
                guard let imageData = try await item.loadTransferable(type: Data.self) else {
                    return
                }
                await MainActor.run(body: {
                    profilePicData = imageData
                })
            } catch {
                
            }
        }
    }
    
    func login() {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
            } catch {
                await setError(error)
            }
        }
    }
    
    func register() {
        closeKeyboard()
        Task {
            do {
                // hushukang
                // s-ko@beat-tech.co.jp
                // 123456
                // about me
                
                // Step1: Creating firebase account
                try await Auth.auth().createUser(withEmail: email, password: password)
                // Step2: Uploading profile photo into firebase storage
                guard let uid = Auth.auth().currentUser?.uid else { return }
                guard let imageData = profilePicData else { return }
                let storageRef = Storage.storage().reference().child("profile_images").child(uid)
                let _ = try await storageRef.putDataAsync(imageData)
                // Step3: Downloading photo url
                let downloadURL = try await storageRef.downloadURL()
                // Step4: Creating a user firestore object
                let user: [String: Any] = ["username": userName, "about": about, "bioLink": bioLink, "uid": uid, "email": email, "profileURL": downloadURL.absoluteString]
                print(user)
                // Step5: Saving user doc into firestore database
                try await Firestore.firestore().collection("users").document(uid).setData(user)
                await MainActor.run(body: {
                    userNameStored = userName
                    uidStored = uid
                    profileURL = downloadURL.absoluteString
                    logStatus = true
                })
                print("DEBUG: Register successful")
            } catch {
                // Deleteing created account in case of failure
                print("DEBUG: Register fail")
                print("DEBUG: delete user")
                try await Auth.auth().currentUser?.delete()
                await setError(error)
            }
        }
    }
    
    func resetPassword() {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Link send")
            } catch {
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
