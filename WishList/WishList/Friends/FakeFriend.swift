//
//  FakeFriend.swift
//  WishList
//
//  Created by Gian Franco Lopez on 23/01/2023.
//

import Foundation

struct FakeFriend: Identifiable {
    let id: String
    let name: String
    let urlImage: String
    var isFriend: Bool
}
extension FakeFriend: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

