//
//  ItemCell.swift
//  WishList
//
//  Created by Gian Franco Lopez on 24/01/2023.
//

import SwiftUI

struct ItemCell: View {
    @Binding var items: [Item]
    var item: Item
    var body: some View {
        NavigationLink(destination: ItemDetailsScreen(items: $items, item: item)) {
            HStack {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.scaledToFit()
                    .cornerRadius(30)
                    .frame(width: 60, height: 60)
                
                Text(item.description)
                    .lineLimit(3)
                    .padding(10)
            }
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    @State static var items: [Item] = []
    static var previews: some View {
        ItemCell(items: $items, item: Item(id: "1", url: "", imageUrl: "https://img.buzzfeed.com/buzzfeed-static/static/2018-09/24/6/campaign_images/buzzfeed-prod-web-05/16-imagenes-de-stock-que-darian-para-hacer-la-pel-2-1792-1537786166-2_dblbig.jpg?resize=1200:*", authorId: "", description: "This is a description of the item. :)"))
    }
}
