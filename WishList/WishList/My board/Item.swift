//
//  Item.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import Foundation

struct Item : Identifiable {
    let id: String
    let url: String
    let imageUrl: String
    let author: String
    let description: String
}

extension Item: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
