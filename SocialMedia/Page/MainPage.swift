//
//  MainPage.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/19.
//

import SwiftUI

struct MainPage: View {
    var body: some View {
        TabView {
            Text("Recent Post's")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post's")
                }
            
            ProfilePage()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.primaryColor)
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
