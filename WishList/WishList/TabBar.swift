//
//  TabBar.swift
//  WishList
//
//  Created by Layla Cisneros on 19/01/2023.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            MyBoardView().tabItem {
                Image(systemName: "gift.fill")
                Text("My Board")
            }
            
            
            
            FriendsView().tabItem {
                Image(systemName: "person.2.fill")
                Text("Friends")
            }
            
            Text("Menú").tabItem {
                Image(systemName: "list.bullet")
                Text("Menu")
                
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}