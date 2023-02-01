//
//  ItemDetailsScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 18/01/2023.
//

import SwiftUI

struct ItemDetailsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var items: [Item]
    let item: Item
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "photo").resizable().frame(width: 370,height: 370)
                Text(item.description).padding(30)
                Spacer(minLength: 70)
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    items = items.filter{$0 != item}
                    presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "trash.fill")   
                }
            }
        }.overlay(alignment: .bottom){
            Button(action: {
                print("View Item")
            }, label: {
                Text("View Item")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 40)
                    .background(.blue)
                    .font(.body)
                    .padding()
            })
        }
    }
}

struct ItemDetailsScreenUIPreviews: PreviewProvider {
    @State static var fakeList = [Item]()
    @State static var fakeItem = Item(id:"1", url:"www... ", imageUrl: "michi", authorId: "Lay", description: "michiLay")
    
    static var previews: some View {
        ItemDetailsScreen(items: $fakeList, item: fakeItem)
    }
}
