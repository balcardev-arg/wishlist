//
//  CreateItemScreen.swift
//  WishList
//
//  Created by Layla Cisneros on 23/01/2023.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import LinkPresentation
import MobileCoreServices

struct CreateItemScreen: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var items: [Item]
    
    @State var url = ""
    @State var metadataImageData: Data = Data()
    @State var description = ""
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
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
                if let metadataImage = UIImage(data: metadataImageData) {
                    Image(uiImage: metadataImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                }
            }
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
        .onChange(of: url) { value in
            getMetaData(urlString: url)
        }.alert(errorMessage, isPresented: $showingErrorAlert){}
    }
    
    private func getMetaData(urlString: String) {
        let metadataProvider = LPMetadataProvider()
        
        guard let url = URL(string: urlString) else {
            errorMessage = Configuration.genericErrorMessage
            showingErrorAlert = true
            return
        }
        metadataProvider.startFetchingMetadata(for: url) { metadata, error in
            guard let metadata = metadata else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            let _ = metadata.imageProvider?.loadDataRepresentation(for: UTType.image) { (data, imageError) in
                guard let data = data else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    return
                }
                DispatchQueue.main.async {
                    self.metadataImageData = data
                }
            }
            self.description = metadata.title ?? Configuration.genericErrorMessage
        }
    }
    
    private func uploadImage() {
        isCreatingItem = true
        let storageReference = Storage.storage().reference()
        
        let data = metadataImageData
        let imageReference = storageReference.child("\(CredentialsManager().userId())/\(Date()).jpg")
        
        imageReference.putData(data) { (metadata, error) in
            guard let _ = metadata else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                isCreatingItem = false
                return
            }
            // You can also access to download URL after upload.
            imageReference.downloadURL { (url, error) in
                guard let imageUrl = url else {
                    errorMessage = Configuration.genericErrorMessage
                    showingErrorAlert = true
                    isCreatingItem = false
                    return
                }
                createItem(with: imageUrl.absoluteString)
            }
        }
    }
    
    private func createItem(with imageUrl: String) {
        guard let url = URL(string: "\(Configuration.baseUrl)/items") else {
            errorMessage = Configuration.genericErrorMessage
            showingErrorAlert = true
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
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = Configuration.genericErrorMessage
                showingErrorAlert = true
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data,
                      let item = try? JSONDecoder().decode(Item.self, from: data) else {
                    return
                }
                self.items.append(item)
                presentationMode.wrappedValue.dismiss()
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



struct CreateItemScreen_Previews: PreviewProvider {
    @State static var fakeItems = [Item]()
    
    static var previews: some View {
        CreateItemScreen(items: $fakeItems)
    }
}
