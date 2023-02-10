//
//  SignUpView.swift
//  WishList
//
//  Created by Layla Cisneros on 25/01/2023.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct SignUpView: View {
    
    @EnvironmentObject var credentialsManager: CredentialsManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var userName = ""
    @State private var isPresented = false
    @State private var passwordIsVisible = false
    @State private var confirmationPasswordIsVisible = false
    
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    @StateObject var photoPicker: PhotoPicker = PhotoPicker()
    @State var presentPhotoPicker = false
    @State var isCreatingUser = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Spacer()
                Text("Profile picture")
                    .fontWeight(.black)
                (photoPicker.image ?? Image(systemName: "photo.circle.fill"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                Button(action: showImagePicker){
                    Text("Select image")
                }
                Spacer()
                VStack (alignment: .leading, spacing: 10) {
                    Text("Email")
                    
                    TextField("Name@example.com", text: $email)
                        .padding()
                        .background(Color.black.opacity(0.05))
                        .frame(width: 380)
                        .textInputAutocapitalization(.never)
                    
                    Text("Password")
                }
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
                
                Text("Password Confirmation")
                
                HStack () {
                    if self.confirmationPasswordIsVisible {
                        TextField("Password Confirmation", text: $passwordConfirmation)
                            .textInputAutocapitalization(.never)
                    } else {
                        SecureField("Password Confirmation", text: $passwordConfirmation)
                    }
                    Button (action: {
                        self.confirmationPasswordIsVisible.toggle()
                    }) {
                        Image(systemName: self.confirmationPasswordIsVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }.padding()
                    .background(Color.black.opacity(0.05))
                    .frame(width: 380)
                
                VStack (alignment: .leading, spacing: 10){
                    
                    Text("Name")
                    
                    TextField("User Name", text: $userName)
                        .padding()
                        .background(Color.black.opacity(0.05))
                        .frame(width: 380)
                    
                    Spacer()
                    
                    let samePassword = password == passwordConfirmation
                    
                    let validFields = self.email.isValidEmailAddress() && self.password.isPassword() && self.passwordConfirmation.isPassword() && samePassword && !self.userName.isEmpty && photoPicker.image != nil
                    
                    Button(action: createUser){
                        Text("Sign up")
                    }.foregroundColor(.white)
                        .frame(width: 350, height: 40)
                        .background(validFields ? .blue : .gray)
                        .disabled(!validFields)
                        .padding()
                }.sheet(isPresented: $isPresented) {
                    MyBoardView()
                }
                .alert(errorMessage, isPresented: $showingErrorAlert) {}
            }
        }.photosPicker(isPresented: $presentPhotoPicker, selection: $photoPicker.photoSelection, photoLibrary: .shared())
        
    }
    
    private func createUser() {
        /*
         creas una url con la URL del recurso
         url
         creas una request a partir de esa URL
         url =>request
         
         le asignas el http method a la request
         request -> http method  .
         POST crear
         DELETE borrar
         GEt traer
         PUT actualizar
         
         le asignas los headers. Content-Type y Accept con "Application/json"  es para que sepa que va a recibir y devolver informacion en formato JSON. Hay otros headers.
         request -> headers
         
         Se crea un diccionario con la informaci'on que necesita el servidor
         dictionary : [String:String]
         
         Se convierte el diccionario en una data JSON
         JSONEncoder().encode(dictionary)
         
         se crea la tarea que va a ejecutar la request
         URLSession.shared.dataTask(with: request)
         
         y se ejecuta la request con .resume()
         
         El parametro ' completionHandler'  es el bloque de codigo que se ejecuta cuando el servidor responde, con los parametros opcionales  (data, response, error)
         Se usa el data, si es que existe, para crear el objeto que necesitemos ( en caso de necesitarlo ).
         
         */
        
        isCreatingUser = true
        
        guard let url = URL(string: "\(Configuration.baseUrl)/users") else {
            errorMessage = Configuration.genericErrorMessage
            showingErrorAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary = [
            "email": email,
            "password": password,
            "name": userName
        ]
        
        request.httpBody = try? JSONEncoder().encode(userDictionary)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data,
                      let user = try? JSONDecoder().decode(User.self, from: data) else {
                    showingErrorAlert = true
                    return
                }
                uploadImage(for: user)
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                errorMessage = errorDictionary["error"] ?? Configuration.genericErrorMessage
                showingErrorAlert = true
            }
        }.resume()
    }
    
    private func showImagePicker() {
        presentPhotoPicker.toggle()
    }
    
    private func uploadImage(for user: User) {
        
        let storageReference = Storage.storage().reference()
        
        let data = photoPicker.imageData
        let imageReference = storageReference.child("\(user.id)/profilePicture.jpg")
        
        imageReference.putData(data) { (metadata, error) in
            guard let _ = metadata else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                isCreatingUser = false
                credentialsManager.login(user: user)
                return
            }
            // You can also access to download URL after upload.
            imageReference.downloadURL { (url, error) in
                guard let imageUrl = url else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    isCreatingUser = false
                    credentialsManager.login(user: user)
                    return
                }
                updateProfileImage(with: imageUrl.absoluteString, user: user)
            }
        }
    }
    
    private func updateProfileImage(with imageUrl: String, user: User) {
        guard let url = URL(string: "\(Configuration.baseUrl)/users/profile") else {
            credentialsManager.login(user: user)
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary = [
            "userId": user.id,
            "imageUrl": imageUrl
        ]
        request.httpBody = try? JSONEncoder().encode(userDictionary)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                credentialsManager.login(user: user)
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                errorMessage = errorDictionary["error"] ?? Configuration.genericErrorMessage
                showingErrorAlert = true
            }
        }.resume()
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
