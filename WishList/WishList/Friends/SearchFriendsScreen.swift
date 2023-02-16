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
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    
    @State private var people : [User] = []
    
    var body: some View {
        NavigationView(){
            if showInitialMessage {
                Text("Type a least 3 characters and press enter to perform a search of people to add as friends.")
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .padding(30)
            } else {
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
            .alert(errorMessage, isPresented: $showingErrorAlert){}
    }
    
    private func searchFriend(){
        if searchText.count < 3 {
            return
        }
        showInitialMessage = false
        
        let request = NetworkManager().createRequest(resource: "/users/search?searchTerm=\(searchText)&userId=\(CredentialsManager().userId())", method: "GET")
        
        searching = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            searching = false
            guard let data = data,
                  let people = try? JSONDecoder().decode([User].self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }
            self.people = people
        }
    }
}

struct SearchFriendsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsScreen()
    }
}
