//
//  CreateItemScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 23/01/2023.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct CreateItemScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var items: [Item]
    
    @State var url = ""
    @State var description = ""
    @StateObject var photoPicker: PhotoPicker = PhotoPicker()
    @State var presentPhotoPicker = false
    
    @State var isCreatingItem = false
    
    var body: some View {
        VStack {
            Text("Url")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            TextField("Insert URL", text : $url)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
                .textInputAutocapitalization(.never)
            
            Text("Description")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            TextField("Insert description", text : $description)
                .padding()
                .background(Color.black.opacity(0.05))
                .frame(width: 375)
            
            Text("Image")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            VStack {
                photoPicker.image
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                Button(action: showImagePicker){
                    Text("Change Image").frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                }
            }.photosPicker(isPresented: $presentPhotoPicker, selection: $photoPicker.photoSelection, photoLibrary: .shared())
            
            Spacer()
            let validFields = !description.isEmpty && url.isValidUrl()
            
            Button(action: uploadImage){
                Text("Create")
            }.frame(width: 350, height: 40)
                .foregroundColor(.white)
                .background(validFields ? .blue : .gray)
                .padding()
                .disabled(!validFields)
        }.overlay {
            if isCreatingItem {
                ModalProgressView()
            }
        }
        
    }
    
    private func showImagePicker() {
        presentPhotoPicker.toggle()
    }
    
    private func uploadImage() {
        isCreatingItem = true
        let storageReference = Storage.storage().reference()
        
        
        let data = photoPicker.imageData
        let imageReference = storageReference.child("\(CredentialsManager().userId())/\(Date()).jpg")
        
        
        imageReference.putData(data) { (metadata, error) in
            guard let _ = metadata else {
                //Error
                isCreatingItem = false
                return
            }
            
            // You can also access to download URL after upload.
            imageReference.downloadURL { (url, error) in
                guard let imageUrl = url else {
                    //Error
                    isCreatingItem = false
                    return
                }
                createItem(with: imageUrl.absoluteString)
            }
        }
    }
    
    private func createItem(with imageUrl: String) {
        
        guard let url = URL(string: "\(Configuration.baseUrl)/items")else{
            isCreatingItem = false
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let itemDictionary = [
            "url": self.url,
            "description": self.description,
            "imageUrl": imageUrl,
            "userId": CredentialsManager().userId()
        ]
        
        request.httpBody = try? JSONEncoder().encode(itemDictionary)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            isCreatingItem = false
            guard let data = data,
                  let item = try? JSONDecoder().decode(Item.self, from: data) else {
                return
            }
            
            self.items.append(item)
            presentationMode.wrappedValue.dismiss()
            
            
        }.resume()
    }
}



struct CreateItemScreen_Previews: PreviewProvider {
    @State static var fakeItems = [Item]()
    
    static var previews: some View {
        CreateItemScreen(items: $fakeItems)
    }
}
