//
//  FriendBoardScreen.swift
//  WishList
//
//  Created by Gian Franco Lopez on 24/01/2023.
//

import SwiftUI

struct FriendBoardScreen: View {
    
    @State private var friendItems: [Item] = [
        Item(id: "1", url: "www...", imageUrl: "perrito", author: "Andres", description: ""),
        Item(id: "2", url: "www...", imageUrl: "michi", author: "Gian", description: "www..."),
        Item(id: "3", url: "", imageUrl: "mango", author: "Lay", description: "")
        
    ]
    @Binding var friends: [FakeFriend]
    @State var friend: FakeFriend
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "person.fill").resizable()
                        .frame(width: 150,height: 150)
                        .background(.gray)
                        .clipShape(Circle())
                    Spacer()
                    Text(friend.name)
                        .padding(50)
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                }
                List(friendItems) { item in
                    ItemCell(items: $friendItems, item: item)
                }.overlay {
                    if (friendItems.count == 0) {
                        Text("This person has no items yet!")
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }.background(.gray.opacity(0.2))
            
            
        }.accentColor(.black)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    friend.isFriend = !friend.isFriend
                }){
                    Image(systemName: friend.isFriend ? "person.crop.circle.badge.minus.fill" : "person.crop.circle.badge.plus.fill"  )
                }
            
            }
        }
        .accentColor(.black)
    }
    
}

struct FriendBoardScreen_Previews: PreviewProvider {
    @State static var currentFriend = FakeFriend(id: "1", name: "Fixed friend", urlImage: "", isFriend: false)
    @State static var fakeFriends: [FakeFriend] = [FakeFriend(id: "1", name: "Fixed friend", urlImage: "", isFriend: false)]
    static var previews: some View {
        FriendBoardScreen(friends: $fakeFriends, friend: currentFriend)
    }
}
