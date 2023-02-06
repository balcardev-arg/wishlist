//
//  User.swift
//  WishList
//
//  Created by Layla Cisneros on 31/01/2023.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String {
        get {
            return email
        }
    }
    var email: String
    var friends: [String]
    var imageUrl: String
    var name: String
    var isFriend: Bool
}
