//
//  CreateNewPost.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/30.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct CreateNewPost: View {
    // Callback
    var onPost: (Post) -> ()
    // Post Properties
    @State var postText: String = ""
    @State var postImageData: Data?
    // Stored User Data From UserDefaults(AppStorage)
    @AppStorage("user_profile_url") private var profileURL: String = ""
    @AppStorage("user_name") private var userNameStored: String = ""
    @AppStorage("user_uid") private var uidStored: String = ""
    // View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack {
            HStack {
                Menu(content: {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                }, label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.primaryColor)
                })
                .hAlign(.leading)
                
                Button(action: createPost, label: {
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(Color.primaryColor, in: Capsule())
                })
                .disableWithOpacity(postText == "")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    TextField("What's happending?", text: $postText, axis: .vertical)
                        .textInputAutocapitalization(.never)
                        .focused($showKeyboard)
                    if let postImageData, let image = UIImage(data: postImageData) {
                        GeometryReader { reader in
                            let size = reader.size
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(alignment: .topTrailing) {
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            self.postImageData = nil
                                        }
                                    }, label: {
                                        Image(systemName: "multiply")
                                            .tint(.primaryColor)
                                            .padding(4)
                                            .background(Color.white, in: Circle())
                                    })
                                    .compositingGroup()
                                    .shadow(color: .borderColor, radius: 4, x: 2, y: 2)
                                    .padding(10)
                                }
                        }
                        .clipped()
                        .frame(height: 200)
                    }
                }
                .padding(15)
            }
            
            Divider()
            
            HStack {
                Button(action: {
                    showImagePicker.toggle()
                }, label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                })
                .hAlign(.leading)
                
                Button("Done") {
                    showKeyboard = false
                }
            }
            .foregroundColor(.primaryColor)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .vAlign(.top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compresedImageData = image.jpegData(compressionQuality: 0.5) {
                        await MainActor.run(body: {
                            postImageData = compresedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay {
            Loading(show: $isLoading)
        }
    }
    
    // MARK: - Post Content To Firebase
    func createPost() {
        isLoading = true
        showKeyboard = false
        Task {
            do {
                // Step1: Uploading Image if any
                // userd to delete the Post
                let imageReferenceId = "\(uidStored)\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceId)
                
                var post = Post(text: postText, imageReferenceId: imageReferenceId, userName: userNameStored, userUid: uidStored, userProfileUrl: profileURL)
                // Step2: Create image
                if let postImageData {
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let url = try await storageRef.downloadURL()
                    post.imageUrl = url.absoluteString
                }
                // Step3: Create Post object
                try await createDocumentAtFirebase(post)
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Post) async throws {
        let _ = try Firestore.firestore().collection("Posts").addDocument(from: post, completion: { error in
            if error == nil {
                isLoading = false
                onPost(post)
                dismiss()
            }
        })
    }
    
    // MARK: - Displaying Errors as Alert
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError = true
        })
    }
}

struct CreateNewPost_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPost { post in
            print(post)
        }
    }
}
