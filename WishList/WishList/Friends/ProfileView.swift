//
//  ProfileView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 25/01/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var credentialsManager: CredentialsManager
    
    @State private var privateProfile = false
    
    var body: some View {
        VStack{
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 150, height: 150)
            
            Text("Andres gerace")
                .font(.largeTitle)
                .padding()
            
            Toggle(isOn: $privateProfile) {
                Text("Private")
            }.padding()
            
            Spacer()
            
            Button (action: {
                credentialsManager.logout()
            }){
                Text("Logout")
            }.frame(width: 200, height: 50, alignment: .center)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
