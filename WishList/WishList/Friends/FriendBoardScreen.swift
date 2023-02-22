//
//  FriendBoardScreen.swift
//  WishList
//
//  Created by Gian Franco Lopez on 24/01/2023.
//

import SwiftUI

struct FriendBoardScreen: View {
    
    @State private var friendItems: [Item] = []
    @State var friend: User
    private let credentialsManager = CredentialsManager()
    @State private var isLoading: Bool = false
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: friend.imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .padding()
                            } else {
                                ProgressView().scaleEffect(2).padding(40)
                            }
                        }
                        Spacer()
                        Text(friend.name)
                            .fontWeight(.black)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .padding(30)
                    }.background(Color .gray.opacity(0.2))
                    List(friendItems) { item in
                        ItemCell(items: $friendItems, item: item)
                    }.overlay {
                        if (friendItems.count == 0) {
                            Text("This person has no items yet!")
                                .fontWeight(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                if isLoading {
                    ModalProgressView()
                }
            }
            
        }.onAppear{
            getItems()
        }
        .accentColor(.black)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: friend.isFriend ? deleteFriend  : addFriend){
                    Image(systemName: friend.isFriend ? "person.crop.circle.badge.minus.fill" : "person.crop.circle.badge.plus.fill"  )
                }.foregroundColor(.black)
            }
        }.alert(errorMessage, isPresented: $showingErrorAlert){}
            .accentColor(.blue)
    }
    
    private func getItems() {
        
        let userId = credentialsManager.userId()
        
        let request = NetworkManager().createRequest(resource: "/items?userId=\(userId)&authorId=\(friend.id)", method: "GET")
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            guard let data = data,
                  let friendsItems = try? JSONDecoder().decode([Item].self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }
            self.friendItems = friendsItems
        }
    }
    
    private func addFriend(){
        let userDictionary = [
            "userId": credentialsManager.userId(),
            "friendId": friend.email
        ]
        let request = NetworkManager().createRequest(resource: "/friends", method: "POST", parameters: userDictionary)
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            if let error = error {
                errorMessage = error
                showingErrorAlert = true
                return
            }
            friend.isFriend = true
        }
    }
    
    private func deleteFriend(){
        let userDictionary = [
            "userId": credentialsManager.userId(),
            "friendId": friend.email
        ]
        let request = NetworkManager().createRequest(resource: "/friends", method: "DELETE",parameters: userDictionary)
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            if let error = error {
                errorMessage = error
                showingErrorAlert = true
                return
            }
            friend.isFriend = false
        }
    }
}

struct FriendBoardScreen_Previews: PreviewProvider {
    @State static var currentFriend = User(email: "", friends: [], imageUrl: "", name: "", privateProfile: false, isFriend: true)
    static var previews: some View {
        FriendBoardScreen(friend: currentFriend)
    }
}
