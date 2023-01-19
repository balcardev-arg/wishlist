//
//  WishListApp.swift
//  WishList
//
//  Created by Layla Cisneros on 16/01/2023.
//

import SwiftUI

@main
struct WishListApp: App {
    init(){
        UINavigationBar.appearance().backgroundColor = .systemBlue
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MyBoardView()
                
                GeometryReader { reader in
                    Color.blue
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea()
                }
            }
        }
    }
}
