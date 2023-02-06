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
                    .textInputAutocapitalization(.never)
                
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
                            .textInputAutocapitalization(.never)
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
                    signIn()
                    
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
                
                NavigationLink(destination: SignUpView().environmentObject(credentialsManager)){
                    Text("Sign up")
                }
            }
            .padding()
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
        guard let url = URL(string: "\(Configuration.baseUrl)/users/login")else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONEncoder().encode(userDictionary)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                return
            }
            credentialsManager.login(user: user)
            
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(CredentialsManager())
    }
}


