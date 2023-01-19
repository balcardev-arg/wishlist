//
//  SignInView.swift
//  WishList
//
//  Created by Gian Lopez on 16/01/2023.
//

import SwiftUI



struct SignInView: View {
    
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordView: Bool = false
    @State private var isPasswordSecure: Bool = true
    
    
    var body: some View {
        NavigationView(){
            VStack(spacing: 20.0) {
                Image("Logo")
                    .resizable()
                    .frame(width: 180, height: 180).clipShape(Circle())
                    .background(.gray)
                    .cornerRadius(90)
                    .shadow(radius: 2)
                    
                
                Text("Email")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Email", text: $email)
                    .frame(width: 350, height: 50)
                    .background(Color.black.opacity(0.00))
                
                
                Text("Password")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    
                    if isPasswordSecure {
                        SecureField("Password", text: $password)
                    .frame(width: 350, height: 50)
                            .background(Color.black.opacity(0.00))
                    }else {
                        TextField("Password", text: $password)
                            .frame(width: 350, height: 50)
                            .background(Color.black.opacity(0.00))
                    }
                    
                    Button(action:{
                        isPasswordSecure.toggle()
                    },label:{
                        Image(systemName: isPasswordSecure ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .frame(minWidth: 10, alignment: .trailing)
                    })
                }
                
                //se alterno el validfields para que cambie de color el boton cuando se complete el campo de mail y pass
                let validFields = self.email.isValidEmailAddress() && self.password.isPassword()
                
                Button("Sign in"){
                }.foregroundColor(.white)
                    .frame(width: 300,height: 50)
                    .background(validFields ? .blue : .gray)
                    .cornerRadius(10)
                    .disabled(!validFields)
                
                
                Button("Forgot Password?"){
                    showForgotPasswordView = true
                    //componente button
                }.sheet(isPresented: $showForgotPasswordView){
                    ZStack{
                        Color.white.ignoresSafeArea()
                        Text("pantalla nueva")
                    }
                }
                
                
                NavigationLink(destination: {Text("Pantalla")}){
                Text("Sign up")
                }
                
            }
            .padding()
        }
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

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

