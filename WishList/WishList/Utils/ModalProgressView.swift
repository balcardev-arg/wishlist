//
//  ModalProgressView.swift
//  WishList
//
//  Created by Gian Franco Lopez on 03/02/2023.
//

import SwiftUI

struct ModalProgressView: View {
    var body: some View {
        HStack {
            ProgressView().scaleEffect(3)
                .tint(.blue)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0, green: 0, blue: 0, opacity: 0.5))
        
    }
}

struct ModalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ModalProgressView()
    }
}
