//
//  Post.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/30.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var imageUrl: String?
    var imageReferenceId: String
    var publishedDate: Date = Date()
    var likedIds: [String] = []
    var userName: String
    var userUid: String
    var userProfileUrl: String
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageUrl
        case imageReferenceId
        case publishedDate
        case likedIds
        case userName
        case userUid
        case userProfileUrl
    }
}
