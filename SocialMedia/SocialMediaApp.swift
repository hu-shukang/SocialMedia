//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/18.
//

import SwiftUI
import Firebase

@main
struct SocialMediaApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
