//
//  StringExtension.swift
//  WishList
//
//  Created by Gian Franco Lopez on 19/01/2023.
//

import Foundation

extension String {
    
    func isValidEmailAddress() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailValidation = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailValidation.evaluate(with: self)
    }
    func isPassword() -> Bool {
        return self.count >= 6
    }
}
