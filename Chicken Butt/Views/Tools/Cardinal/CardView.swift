//
//  CardView.swift
//  Cardinal
//
//  Created by lemin on 8/31/23.
//

import Foundation
import SwiftUI

struct CardView: View {
    let fm = FileManager.default
    
    @State var kfd: UInt64
    @State var vnodeOrig: UInt64
    @State var fullPath: String
    
    @State var showSheet: Bool = false
    
    @Binding var card: Card
    @Binding var changedSomething: Bool
    
//    @State var changingImage: Bool = false
//    @State var cardImage = UIImage()
    
    var body: some View {
        ZStack {
            Image(uiImage: card.changingImage ? card.newImage : UIImage(contentsOfFile: "\(fullPath)/\(card.cardPath)/\(card.imagePath)")!).resizable().aspectRatio(contentMode: .fit).frame(width: 320).zIndex(0).cornerRadius(5).onTapGesture {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                ImagePickerBView(sourceType: .photoLibrary, selectedImage: self.$card)
            }
            .onChange(of: self.card.newImage) { newImage in
                card.changingImage = true
                changedSomething = true
            }
            
            if fm.fileExists(atPath: "\(fullPath)/\(card.cardPath)/\(card.imagePath).backup") {
                Button {
                    MainCardController.resetChanges(kfd, vnodeOrig: vnodeOrig, card: card, fullPath: fullPath)
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill").resizable().scaledToFit().frame(width: 40).foregroundColor(Color.red)
                }
                .zIndex(1)
                .padding(.top, 265)
            }
        }
    }
}
