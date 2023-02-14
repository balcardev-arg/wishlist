//
//  ItemDetailsScreen.swift
//  WishList
//
//  Created by Giancito on 18/01/2023.
//

import SwiftUI

struct ItemDetailsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isDeleting: Bool = false
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    @Binding var items: [Item]
    let item: Item
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: item.imageUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else {
                            ProgressView().scaleEffect(2).frame(height: 300)
                        }
                    }
                    Text(item.description).padding(30)
                    Spacer(minLength: 100)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if item.authorId == CredentialsManager().userId() {
                        Button(action: self.delete) {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
            }.overlay(alignment: .bottom){
                Button(action: {
                    guard let url = URL(string: item.url) else {return}
                    UIApplication.shared.open(url)
                }, label: {
                    Text("View Item")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 40)
                        .background(.blue)
                        .cornerRadius(25)
                        .font(.body)
                        .padding()
                })
            }
            if isDeleting {
                ModalProgressView()
            }
        }.alert(errorMessage, isPresented: $showingErrorAlert){}
    }
    
    private func delete() {
        let userDictionary = [
            "id": item.id,
            "userId": CredentialsManager().userId()
        ]
        let request = NetworkManager().createRequest(resource: "/items", method: "DELETE", parameters: userDictionary)
        isDeleting = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isDeleting = false
            if let error = error {
                errorMessage = error
                showingErrorAlert = true
                return
            }
            items = items.filter{$0 != item}
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ItemDetailsScreenUIPreviews: PreviewProvider {
    @State static var fakeList = [Item]()
    @State static var fakeItem = Item(id:"1", url:"www... ", imageUrl: "michi", authorId: "Lay", description: "michiLay")
    
    static var previews: some View {
        ItemDetailsScreen(items: $fakeList, item: fakeItem)
    }
}
