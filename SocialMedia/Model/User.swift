//
//  User.swift
//  SocialMedia
//
//  Created by 胡书康 on 2022/12/18.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var about: String
    var bioLink: String
    var uid: String
    var email: String
    var profileURL: String
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case about
        case bioLink
        case uid
        case email
        case profileURL
    }
}
