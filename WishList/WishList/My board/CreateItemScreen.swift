//
//  CreateItemScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 23/01/2023.
//

import SwiftUI

struct CreateItemScreen: View {
    
    @State var url = ""
    @State var description = ""
    
    var body: some View {
        VStack {
            Text("Url")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            TextField("Insert URL", text : $url)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
                
            Text("Description")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            TextField("Insert description", text : $description)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
            
            Text("Image")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Image(systemName: "photo.circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
            
            Button(action: {}, label: { Text("Change Image").frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
            })
            
            Spacer()
        
            Button(action: {}, label: {
                        Text("Create")
                            .foregroundColor(.white)
                            .frame(width: 350, height: 40)
                            .background(.blue)
                            .font(.body)
                            .padding()
                    })
        }
    }
}

struct CreateItemScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateItemScreen()
    }
}
