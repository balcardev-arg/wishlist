//
//  ProfileView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 25/01/2023.
//


import SwiftUI
import FirebaseStorage
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var credentialsManager: CredentialsManager
    @State var user: User
    
    @StateObject var photoPicker: PhotoPicker = PhotoPicker()
    @State private var presentPhotoPicker = false
    @State private var isUploadingImage = false
    
    var body: some View {
        ZStack {
            VStack{
                AsyncImage(url: URL(string: user.imageUrl))
                    .frame(width: 150, height: 150)
                Button(action: { presentPhotoPicker = true }){
                    Text("Change Image").frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                
                Text(user.name)
                    .font(.largeTitle)
                    .padding()
                
                Toggle(isOn: $user.privateProfile) {
                    Text("Private")
                }
                .padding()
                
                Spacer()
                
                Button (action: {
                    credentialsManager.logout()
                }){
                    Text("Logout")
                }.frame(width: 200, height: 50, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            if isUploadingImage {
                ModalProgressView()
            }
        }
        
        .onChange(of: user.privateProfile) { isPrivate in
            setPrivateProfile(isPrivate: isPrivate)
        }
        .onChange(of: photoPicker.imageData) { newImageData in
            uploadImage(data: newImageData)
        }
        .photosPicker(isPresented: $presentPhotoPicker, selection: $photoPicker.photoSelection)
    }
    
    private func uploadImage(data: Data) {
        isUploadingImage = true
        let storageReference = Storage.storage().reference()
        
        let imageReference = storageReference.child("\(CredentialsManager().userId())/profilePicture.jpg")
        
        imageReference.putData(data) { (metadata, error) in
            guard let _ = metadata else {
                //Error
                isUploadingImage = false
                return
            }
            
            // You can also access to download URL after upload.
            imageReference.downloadURL { (url, error) in
                isUploadingImage = false
                guard let imageUrl = url else {
                    //Error
                    
                    return
                }
                user.imageUrl = imageUrl.absoluteString
            }
        }
    }
    
    private func setPrivateProfile(isPrivate: Bool) {
        
        guard let url = URL(string: "\(Configuration.baseUrl)/users/profile")else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let userDictionary : [String:Any] = [
            "userId": credentialsManager.userId(),
            "private": isPrivate
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: userDictionary)
        let data = try! JSONEncoder().encode(jsonData)

        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        
            guard let httpResponse = response as? HTTPURLResponse else {
                //error
                return
            }
            
            if httpResponse.statusCode == 200 {
                //Todo bien
            }
            
        }.resume()
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var fakeItems = [Item]()
    private static let user = User(email: "balcarce@gmail.com", friends: [], imageUrl: "", name: "", privateProfile: true, isFriend: false)
    
    static var previews: some View {
        ProfileView(user: user)
    }
}
