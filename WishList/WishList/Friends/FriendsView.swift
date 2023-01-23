//
//  FriendsView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 19/01/2023.
//

import SwiftUI

struct FriendsView: View {
    
    private var friends: [FakeFriend] = [
        FakeFriend(id: "1", name: "Gian El homoe", urlImage: ""),
        FakeFriend(id: "2", name: "Andres el k-po", urlImage: ""),
        FakeFriend(id: "3", name: "Layla", urlImage: ""),
        FakeFriend(id: "4", name: "Tu vieja", urlImage: "")
    ]
    
    var body: some View {
        NavigationView {
            
            List(friends, id: \.id) { friend in
                NavigationLink(destination: {Text("Friend Profile")}){
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .cornerRadius(20)
                        Text(friend.name)
                            .lineLimit(3)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "magnifyingglass").foregroundColor(.black)
                    }
                }
            }
            
        }
    }
}

struct FriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
