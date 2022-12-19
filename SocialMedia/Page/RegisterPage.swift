//
//  RegisterPage.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/18.
//

import SwiftUI
import PhotosUI

struct RegisterPage: View {
    @ObservedObject var userVM = UserViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 19) {
            Text("Lets Register Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .hAlign(.leading)
            
            Text("Hello user,have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            // MARK: - Sign in Form
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    RegisterForm()
                }
                RegisterForm()
            }
            
            
            // MARK: - Register Button
            HStack {
                Text("Alread have an account?")
                    .foregroundColor(.secondaryTextColor)
                
                Button("Login Now") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .onAppear {
            userVM.initFileds()
        }
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            // MARK: - Extracting UIImage From PhotoItem
            Task {
                await userVM.selectPhoto(newValue)
            }
        }
    }
    
    @ViewBuilder
    func RegisterForm() -> some View {
        VStack(spacing: 12) {
            ZStack {
                if let imageData = userVM.profilePicData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .padding(.top, 25)
            .onTapGesture {
                showImagePicker.toggle()
            }
            
            TextField("UserName", text: $userVM.userName)
                .textInputAutocapitalization(.never)
                .border(1, .borderColor)
            
            TextField("Email", text: $userVM.email)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
                .border(1, .borderColor)
            
            SecureField("Password", text: $userVM.password)
                .textInputAutocapitalization(.never)
                .textContentType(.password)
                .border(1, .borderColor)
            
            TextField("About You", text: $userVM.about, axis: .vertical)
                .textInputAutocapitalization(.never)
                .frame(minHeight: 100, alignment: .topLeading)
                .border(1, .borderColor)
            
            TextField("Bio Link (Option)", text: $userVM.bioLink)
                .textInputAutocapitalization(.never)
                .textContentType(.URL)
                .border(1, .borderColor)
            
            Button("Reset password", action: {})
                .font(.callout)
                .fontWeight(.medium)
                .tint(.primaryColor)
                .hAlign(.trailing)
            
            Button(action: userVM.register, label: {
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.primaryColor)
            })
            .disableWithOpacity(userVM.registerButtonDisable)
            .padding(.top, 10)
        }
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage()
    }
}
