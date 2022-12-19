//
//  ContentView.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userVM = UserViewModel.shared
    
    var body: some View {
        if userVM.logStatus {
            Text("Main View")
        } else {
            LoginPage()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
