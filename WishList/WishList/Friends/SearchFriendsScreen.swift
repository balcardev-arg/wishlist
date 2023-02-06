//
//  SearchFriendsScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 24/01/2023.
//

import SwiftUI

struct SearchFriendsScreen: View {
    
    @State private var searchText : String = ""
    @State private var showInitialMessage = true
    
    @State private var friends : [User] = []
    
    var body: some View {
        NavigationView(){
            
            if showInitialMessage {
                Text("Type a least 3 characters and \n press enter to perform a \n search of people to add as friends.")
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                
            }else {
                List(friends) { friend in
                    NavigationLink(destination: { Text(friend.name)}) {
                        Text("\(friend.id.lowercased())   \(friend.name.lowercased())")
                    }
                }.overlay{
                    if friends.count == 0 {
                        Text("There are not people for this \n criteria. Try again with a \n different name.")
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search friends")
            .overlay{
                Button(action: {
                    searchFriend()
                }){Text("LIST") }
            }
        
    }
    
    private func searchFriend(){
        guard let url = URL(string:
            "\(Configuration.baseUrl)/users/search?searchTerm\(searchText)")else{
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,
                  let friends = try? JSONDecoder().decode([User].self, from: data) else {
                return
            }
            
           self.friends = friends
        }.resume()

    }
}

struct SearchFriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsScreen()
    }
}
