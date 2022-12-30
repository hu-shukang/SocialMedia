//
//  NewPostPage.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/30.
//

import SwiftUI

struct PostsPage: View {
    @State private var createNewPosts: Bool = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .hAlign(.center)
            .vAlign(.center)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    createNewPosts.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(13)
                        .background(Color.primaryColor, in: Circle())
                })
                .padding(15)
            }
            .fullScreenCover(isPresented: $createNewPosts) {
                CreateNewPost { post in
                    
                }
            }
    }
}

struct PostsPage_Previews: PreviewProvider {
    static var previews: some View {
        PostsPage()
    }
}
