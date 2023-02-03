//
//  PhotoPicker.swift
//  WishList
//
//  Created by Layla Cisneros on 03/02/2023.
//

import Foundation
import PhotosUI
import SwiftUI

class PhotoPicker: ObservableObject {
    @Published var image: Image = Image(systemName: "photo.circle.fill")
    @Published var photoSelection: PhotosPickerItem? {
        didSet {
            if let photoSelection {
                loadTransferable(from: photoSelection)
            }
        }
    }
    var imageData = Data()
    
    private func loadTransferable(from photoSelection: PhotosPickerItem) {
        photoSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard photoSelection == self.photoSelection else { return }
                switch result {
                case .success(let data):
                    let uiImage = UIImage(data: data!)
                    self.image = Image(uiImage: uiImage!)
                    self.imageData = data!
                case .failure(let error):
                    print("Error load transferable \(error)")
                    self.image = Image(systemName: "multiply.circle.fill")
                }
            }
            
        }
    }
}
