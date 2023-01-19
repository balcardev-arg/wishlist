//
//  Productos.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import Foundation

struct FakeItem : Identifiable {
    var id : Int
    var name : String
    var precio : Int
    var description : String
}

extension FakeItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
