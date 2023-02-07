//
//  FriendCell.swift
//  WishList
//
//  Created by Layla Cisneros on 06/02/2023.
//

import SwiftUI

struct FriendCell: View {
    @Binding var friends: [User]
    
    @State var friend: User
    
    var body: some View {
        NavigationLink(destination: FriendBoardScreen(friend: friend)) {
            HStack {
                AsyncImage(url: URL(string: friend.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(30)
                            .frame(width: 60, height: 60)
                    } else if phase.error == nil {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(30)
                            .frame(width: 60, height: 60)
                    } else {
                        ProgressView()
                    }
                }
                Text(friend.name)
                    .foregroundColor(.black)
                    .padding(10)
            }
        }
    }
}

struct FriendCell_Previews: PreviewProvider {
    @State static var friend : [User] = []
    static var previews: some View {
        FriendCell(friends: $friend, friend: User(email: "", friends: [], imageUrl:"https://img.buzzfeed.com/buzzfeed-static/static/2018-09/24/6/campaign_images/buzzfeed-prod-web-05/16-imagenes-de-stock-que-darian-para-hacer-la-pel-2-1792-1537786166-2_dblbig.jpg?resize=1200:*", name: "Pepe", isFriend: true))
    }
}

