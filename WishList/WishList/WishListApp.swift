//
//  WishListApp.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

@main
struct WishListApp: App {
    @State var email: String = ""
    init(){
        UINavigationBar.appearance().backgroundColor = .systemBlue
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
            if email.isValidEmailAddress(){
                
            }
        }
    }
}
