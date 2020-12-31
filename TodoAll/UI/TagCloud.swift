//
//  TagCloud.swift
//  TodoAll
//
//  Created by Franklin Cruz on 27-12-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

struct TagCloud: View {
    @Binding var tags: [String]
    @State var isEditing = false
    
    @State var onSelection: (String) -> Void = { _ in }
    
    @State private var newTag: String = ""
    
    var body: some View {
        VStack {
            SingleAxisGeometryReader(alignment: .topLeading) { width in
                generateContent(withWidth: width)
            }
            if isEditing {
                HStack {
                    TextField(
                        "Add Tag",
                        text: self.$newTag,
                        onEditingChanged: { _ in },
                        onCommit: {
                            addNewTag()
                        })
                        .padding([.vertical, .leading])
                    Button(action: {
                        addNewTag()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .padding()
                    })
                }
            }
        }
    }
    
    private var image: Image? {
        if isEditing {
            return Image(systemName: "minus.circle.fill")
        } else {
            return nil
        }
    }
    
    private func generateContent(withWidth availableWidth: CGFloat) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                TagView(
                    text: tag,
                    color: Color(.systemTeal),
                    image: self.image,
                    action: {
                        if isEditing {
                            if let index = self.tags.firstIndex(of: tag) {
                                self.tags.remove(at: index)
                            }
                        } else {
                            self.onSelection(tag)
                        }
                    }
                )
                .padding([.horizontal, .vertical], 2)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > availableWidth) {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if tag == self.tags.last! {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if tag == self.tags.last! {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }
    }
    
    private func addNewTag() {
        self.tags.append(self.newTag)
        self.newTag = ""
    }
}

struct TagCloud_Previews: PreviewProvider {
    static var previews: some View {
        TagCloud(
            tags: .constant(["Tag1", "Tag 2", "Taaaaaaag3", "Tag4", "Tag5", "Tag6", "Tag7", "Tag8", "Some long tag"]),
            isEditing: true
        )
        
        TagCloud(
            tags: .constant(["Tag1", "Tag 2", "Taaaaaaag3", "Tag4", "Tag5", "Tag6", "Tag7", "Tag8", "Some long tag"]),
            isEditing: false
        )
        
        TagCloud(
            tags: .constant(["Tag1"]),
            isEditing: false
        )
    }
}
