//
//  CredentialsManager.swift
//  WishList
//
//  Created by Layla Cisneros on 31/01/2023.
//

import Foundation

class CredentialsManager: ObservableObject {
    
    @Published private var isLogged: Bool = false
    
    var isLoggedIn: Bool {
        get{
            return UserDefaults().bool(forKey: "isLogged")
        }
        set {
            UserDefaults().set(newValue, forKey: "isLogged")
            DispatchQueue.main.async{
                self.isLogged = newValue
            }
        }
    }
    
    func login(user: User) {
        isLoggedIn = true
        UserDefaults().set(user.email, forKey: "userId")
    }
    
    func logout() {
        UserDefaults().removeObject(forKey: "userId")
        isLoggedIn = false
    }
    
    func userId() -> String? {
        return UserDefaults().string(forKey: "userId")
    }
}
