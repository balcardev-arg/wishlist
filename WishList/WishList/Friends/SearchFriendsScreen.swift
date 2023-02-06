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
    @State private var searching : Bool = false
    
    @State private var people : [User] = []
    
    var body: some View {
        NavigationView(){
            if showInitialMessage {
                Text("Type a least 3 characters and press enter to perform a search of people to add as friends.")
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .padding(30)
                
            }else {
                ZStack {
                    List(people) { person in
                        FriendCell(friends: $people, friend: person.self)
                    }.overlay{
                        if people.count == 0 {
                            Text("There are not people for this criteria. Try again with a different name.")
                                .fontWeight(.black)
                                .multilineTextAlignment(.center)
                                .padding(30)
                            
                        }
                    }
                    if searching {
                        ModalProgressView()
                    }
                }
            }
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search friends")
            .onSubmit(of: .search) {
                searchFriend()
            }
            .textInputAutocapitalization(.never)
    }
    
    private func searchFriend(){
        if searchText.count < 3 {
            return
        }
        
        showInitialMessage = false
        
        guard let url = URL(string:"\(Configuration.baseUrl)/users/search?searchTerm=\(searchText)")  else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        searching = true
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            searching = false
            guard let data = data,
                  let people = try? JSONDecoder().decode([User].self, from: data) else {
                return
            }
            
            self.people = people
        }.resume()
    }
}

struct SearchFriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsScreen()
    }
}
