//
//  SignInView.swift
//  WishList
//
//  Created by Gian Lopez on 16/01/2023.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var credentialsManager: CredentialsManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordView: Bool = false
    @State private var isPasswordSecure: Bool = true
    @State private var passwordIsVisible = false
    @State private var showingErrorAlert = false
    @State private var isLoading = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView(){
            VStack(spacing: 20.0) {
                Image("Logo")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                //TODO: check how this looks with the LOGO.
                    .overlay(Circle().stroke(Color(.gray)))
                    .shadow(radius:2)
                
                Text("Email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .frame(width: 380)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                Text("Password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack () {
                    if self.passwordIsVisible {
                        TextField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button (action: {
                        self.passwordIsVisible.toggle()
                    }) {
                        Image(systemName: self.passwordIsVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }.padding()
                    .background(Color.black.opacity(0.05))
                    .frame(width: 380)
                //se alterno el validfields para que cambie de color el boton cuando se complete el campo de mail y pass
                let validFields = self.email.isValidEmailAddress() && self.password.isPassword()
                
                Button("Sign in"){
                    signIn()
                }.foregroundColor(.white)
                    .frame(width: 300,height: 50)
                    .background(validFields ? .blue : .gray)
                    .cornerRadius(25)
                    .disabled(!validFields)
                
                Button("Forgot Password?"){
                    showForgotPasswordView = true
                    //componente button
                }
                .sheet(isPresented: $showForgotPasswordView){
                    ZStack{
                        Color.white.ignoresSafeArea()
                    }
                }
                NavigationLink(destination: SignUpView().environmentObject(credentialsManager)){
                    Text("Sign up")
                }
            }
            .padding()
            .overlay {
                if isLoading {
                    ModalProgressView()
                }
            }
        }
    }
    private func signIn() {
        /*
         creas una url con la URL del recurso
         url
         creas una request a partir de esa URL
         url =>request
         le asignas el http method a la request
         request -> http method .
         POST crear
         DELETE borrar
         GEt traer
         PUT actualizar
         le asignas los headers. Content-Type y Accept con "Application/json" es para que sepa que va a recibir y devolver informacion en formato JSON. Hay otros headers.
         request -> headers
         Se crea un diccionario con la informaci'on que necesita el servidor
         dictionary : [String:String]
         Se convierte el diccionario en una data JSON
         JSONEncoder().encode(dictionary)
         se crea la tarea que va a ejecutar la request
         URLSession.shared.dataTask(with: request)
         y se ejecuta la request con .resume()
         El parametro ' completionHandler' es el bloque de codigo que se ejecuta cuando el servidor responde, con los parametros opcionales (data, response, error)
         Se usa el data, si es que existe, para crear el objeto que necesitemos ( en caso de necesitarlo ).
         */
        let userDictionary = [
            "email": email,
            "password": password
        ]
        let request = NetworkManager().createRequest(resource: "/users/login", method: "POST", parameters: userDictionary)
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            guard let data = data,
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }
            credentialsManager.login(user: user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(CredentialsManager())
    }
}


