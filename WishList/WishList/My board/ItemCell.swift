//
//  ItemCell.swift
//  WishList
//
//  Created by Gian Franco Lopez on 24/01/2023.
//

import SwiftUI

struct ItemCell: View {
    @Binding var items: [FakeItem]
    var item: FakeItem
    var body: some View {
        NavigationLink(destination: ItemDetailsScreen(items: $items, item: item)) {
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .cornerRadius(20)
                Text(item.description)
                    .lineLimit(3)
            }
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    @State static var fakeItems: [FakeItem] = []
    static var previews: some View {
        ItemCell(items: $fakeItems, item: FakeItem(id: 1, name: "", precio: 100, description: "Description"))
    }
}
