//
//  SignUpView.swift
//  WishList
//
//  Created by Layla Cisneros on 25/01/2023.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    @State var passwordConfirmation = ""
    @State var name = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Profile picture")
                .fontWeight(.black)
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("Email")
            
            TextField("name@example.com", text: $email)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
            
            Text("Password")
            
            SecureField("password", text: $password)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
            
            Text("Password Confirmation")
            
            SecureField("name@example.com", text: $passwordConfirmation)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
            
            
            VStack (alignment: .leading) {
                Text("Name")
                
                TextField("Lay", text: $name)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .frame(width: 375)
                
                Spacer()
                
                Button(action: {}){
                    Text("Sign up")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 40)
                        .background(.blue)
                        .font(.body)
                        .padding()
                }
            }
            
            
        }.padding()
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
