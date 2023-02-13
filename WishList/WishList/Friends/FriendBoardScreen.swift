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
                            } else if phase.error == nil {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 150,height: 150)
                                    .background(.gray)
                                    .clipShape(Circle())
                                    .padding()
                            } else {
                                ProgressView()
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
        
        let urlString = "\(Configuration.baseUrl)/items?userId=\(userId)&authorId=\(friend.id)"
        guard let url = URL(string: urlString ) else {
            errorMessage = Configuration.genericErrorMessage
            showingErrorAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        isLoading = true
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isLoading = false
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data,
                      let friendsItems = try? JSONDecoder().decode([Item].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                self.friendItems = friendsItems
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                errorMessage = errorDictionary["error"] ?? Configuration.genericErrorMessage
                showingErrorAlert = true
            }
        }.resume()
    }
    
    private func addFriend(){
        guard let url = URL(string: "\(Configuration.baseUrl)/friends") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary = [
            "userId": credentialsManager.userId(),
            "friendId": friend.email
        ]
        request.httpBody = try? JSONEncoder().encode(userDictionary)
        isLoading = true
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isLoading = false
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                friend.isFriend = true
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                errorMessage = errorDictionary["error"] ?? Configuration.genericErrorMessage
                showingErrorAlert = true
            }
        }.resume()
    }
    
    private func deleteFriend(){
        guard let url = URL(string: "\(Configuration.baseUrl)/friends") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary = [
            "userId": credentialsManager.userId(),
            "friendId": friend.email
        ]
        request.httpBody = try? JSONEncoder().encode(userDictionary)
        isLoading = true
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isLoading = false
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                friend.isFriend = false
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                errorMessage = errorDictionary["error"] ?? Configuration.genericErrorMessage
                showingErrorAlert = true
            }
        }.resume()
    }
    
}

struct FriendBoardScreen_Previews: PreviewProvider {
    @State static var currentFriend = User(email: "", friends: [], imageUrl: "", name: "", privateProfile: false, isFriend: true)
    static var previews: some View {
        FriendBoardScreen(friend: currentFriend)
    }
}
