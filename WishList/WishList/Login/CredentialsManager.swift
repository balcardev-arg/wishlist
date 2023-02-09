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
        storeUser(user)
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults().removeObject(forKey: "userId")
        storeUser(nil)
    }
    
    func userId() -> String {
        return UserDefaults().string(forKey: "userId") ?? ""
    }
    
    
    private func storeUser(_ user: User?) {
        guard let user = user else {
            UserDefaults().removeObject(forKey: "user")
            return
        }
        
        let userData = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(userData, forKey: "user")
    }
    
    func getUser() -> User? {
        guard let userData = UserDefaults.standard.data(forKey: "user") else {
            return nil
        }
        
        return try? JSONDecoder().decode(User.self, from: userData)
    }
    
}
