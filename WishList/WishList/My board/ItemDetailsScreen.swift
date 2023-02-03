//
//  ItemDetailsScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 18/01/2023.
//

import SwiftUI

struct ItemDetailsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isDeleting: Bool = false
    @Binding var items: [Item]
    let item: Item
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Image(systemName: "photo").resizable().frame(width: 370,height: 370)
                    Text(item.description).padding(30)
                    Spacer(minLength: 70)
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
                        .font(.body)
                        .padding()
                })
            }
            if isDeleting {
                ModalProgressView()
            }
        }
    }
    
    private func delete() {
        
        guard let url = URL(string: "\(Configuration.baseUrl)/items")else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary = [
            "id": item.id,
            "userId": CredentialsManager().userId()
        ]
        request.httpBody = try? JSONEncoder().encode(userDictionary)
        //Se cambia la variable a true para mostrar el progress view antes de hacer la llamada a backend
        isDeleting = true
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Se cambia la variable a false cuando se recibe la respuesta de backend para ocultar el progress view
            DispatchQueue.main.async {
                isDeleting = false
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    }else {
                        print("error: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }
}

struct ItemDetailsScreenUIPreviews: PreviewProvider {
    @State static var fakeList = [Item]()
    @State static var fakeItem = Item(id:"1", url:"www... ", imageUrl: "michi", authorId: "Lay", description: "michiLay")
    
    static var previews: some View {
        ItemDetailsScreen(items: $fakeList, item: fakeItem)
    }
}
