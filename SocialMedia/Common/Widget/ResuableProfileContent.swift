//
//  ResuableProfileContent.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResuableProfileContent: View {
    var profileURL: String
    var username: String
    var about: String
    var bioLink: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                HStack(spacing: 12) {
                    WebImage(url: URL(string: profileURL)).placeholder{
                        Image("NullProfile")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(username)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(about)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        // MARK: - Displaying Bio link, if given while signing up profile page
                        if let link = URL(string: bioLink) {
                            Link(bioLink, destination: link)
                                .font(.callout)
                                .tint(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.leading)
                }
                
                Text("Post's")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAlign(.leading)
                    .padding(.vertical, 15)
            }
            .padding(15)
        }
    }
}

//struct ResuableProfileContent_Previews: PreviewProvider {
//    static var previews: some View {
//        ResuableProfileContent()
//    }
//}
