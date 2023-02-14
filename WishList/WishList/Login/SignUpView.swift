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
    @State private var passwordIsVisible = false
    @State private var confirmationPasswordIsVisible = false
    @State private var isLoading = false
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    @StateObject var photoPicker: PhotoPicker = PhotoPicker()
    @State var presentPhotoPicker = false
    @State var isCreatingUser = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .center) {
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
                }
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
                        .cornerRadius(25)
                        .disabled(!validFields)
                        .padding()
                }.alert(errorMessage, isPresented: $showingErrorAlert) {}
                if isLoading {
                    ModalProgressView()
                }
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
        let userDictionary = [
            "email": email,
            "password": password,
            "name": userName
        ]
        let request = NetworkManager().createRequest(resource: "/users", method: "POST", parameters: userDictionary)
        isCreatingUser = true
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            guard let data = data,
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }
            uploadImage(for: user)
        }
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
        let userDictionary = [
            "userId": user.id,
            "imageUrl": imageUrl
        ]
        let request = NetworkManager().createRequest(resource: "/users/profile", method: "PUT", parameters: userDictionary)
        isLoading = true
        
        NetworkManager().executeRequest(request: request) { (data, error) in
            isLoading = false
            guard let data = data,
                  let currentUser = try? JSONDecoder().decode(User.self, from: data) else {
                errorMessage = error!
                showingErrorAlert = true
                return
            }
            credentialsManager.login(user: currentUser)
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
