//
//  TagView.swift
//  TodoAll
//
//  Created by Franklin Cruz on 26-12-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @State var text = "A Tag"
    @State var color = Color.random()
    @State var image: Image?
    
    var action = { }
    
    var body: some View {
        HStack {
            Text(self.text)
                .font(.caption)
                .padding(5)
            self.image
                .padding(5)
        }
        .background(self.color)
        .foregroundColor(self.color.contrastFontColor)
        .cornerRadius(10)
        .padding(2)
        .onTapGesture {
            self.action()
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(image: Image(systemName: "minus.circle.fill"))
            .previewLayout(.sizeThatFits)
        
        TagView()
            .previewLayout(.sizeThatFits)
    }
}
