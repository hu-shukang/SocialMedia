//
//  LoginPage.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/18.
//

import SwiftUI

struct LoginPage: View {
    @ObservedObject var userVM = UserViewModel.shared
    @State var createAccount: Bool = false
    
    var body: some View {
        VStack(spacing: 19) {
            Text("Lets Sign you in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .hAlign(.leading)
            
            Text("Welcome Back,\nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            // MARK: - Sign in Form
            
            VStack(spacing: 12) {
                TextField("Email", text: $userVM.email)
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .border(1, .borderColor)
                    .padding(.top, 25)
                
                SecureField("Password", text: $userVM.password)
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)
                    .border(1, .borderColor)
                
                Button("Reset password", action: userVM.resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.primaryColor)
                    .hAlign(.trailing)
                
                Button(action: userVM.login, label: {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.primaryColor)
                })
                .padding(.top, 10)
            }
            
            // MARK: - Register Button
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.secondaryTextColor)
                
                Button("Register Now") {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.primaryColor)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .fullScreenCover(isPresented: $createAccount) {
            RegisterPage()
        }
        .onAppear {
            userVM.initFileds()
        }
        .alert(userVM.errorMessage, isPresented: $userVM.showError, actions: {})
        .overlay {
            Loading(show: $userVM.isLoading)
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
