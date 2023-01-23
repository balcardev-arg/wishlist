//
//  ItemDetailsScreenUI.swift
//  WishList
//
//  Created by Layla Cisneros on 18/01/2023.
//

import SwiftUI

struct ItemDetailsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var items: [FakeItem]
    let item: FakeItem
    
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
                }, label: { Image(systemName: "trash.fill") })
                
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
//
//struct ItemDetailsScreenUIPreviews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsScreenUI()
//    }
//}
