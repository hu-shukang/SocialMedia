//
//  ProfilePage.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/19.
//

import SwiftUI

struct ProfilePage: View {
    @ObservedObject var userVM = UserViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack{
                ResuableProfileContent(profileURL: userVM.profileURL, username: userVM.userNameStored, about: userVM.userAboutStored, bioLink: userVM.userBioLinkStored)
                .refreshable {
                    // MARK: Refresh User Data
                    Task {
                        await userVM.fetchUser()
                    }
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button("Logout", action: userVM.logout)
                        Button("Delete Account", role: .destructive, action: userVM.deleteAccount)
                    }, label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.primaryColor)
                    })
                }
            }
        }
        .overlay {
            Loading(show: $userVM.isLoading)
        }
        .alert(userVM.errorMessage, isPresented: $userVM.showError, actions: {})
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
