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
        setNavigationViewAppearance()
        setTabViewAppearance()
    }
    
    private func setNavigationViewAppearance() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .systemBlue
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    private func setTabViewAppearance() {
        let coloredAppearance = UITabBarAppearance()
        coloredAppearance.backgroundColor = .systemBlue
        coloredAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        coloredAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        coloredAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        coloredAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
        
        UITabBar.appearance().standardAppearance = coloredAppearance
        UITabBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
    }
}
