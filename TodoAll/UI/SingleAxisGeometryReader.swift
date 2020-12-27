//
//  SingleAxisGeometryReader.swift
//  TodoAll
//
//  Created by Franklin Cruz on 27-12-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

/*
 This implementation is not mine it is taken from this blog post
 https://www.wooji-juice.com/blog/stupid-swiftui-tricks-single-axis-geometry-reader.html
 
 All credit goes to the writter! Amazing utility
 */
struct SingleAxisGeometryReader<Content: View>: View
{
    private struct SizeKey: PreferenceKey
    {
        static var defaultValue: CGFloat { 10 }
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat)
        {
            value = max(value, nextValue())
        }
    }

    @State private var size: CGFloat = SizeKey.defaultValue

    var axis: Axis = .horizontal
    var alignment: Alignment = .center
    let content: (CGFloat)->Content

    var body: some View
    {
        content(size)
            .frame(maxWidth:  axis == .horizontal ? .infinity : nil,
                   maxHeight: axis == .vertical   ? .infinity : nil,
                   alignment: alignment)
            .background(GeometryReader
            {
                proxy in
                Color.clear.preference(key: SizeKey.self, value: axis == .horizontal ? proxy.size.width : proxy.size.height)
            })
            .onPreferenceChange(SizeKey.self) { size = $0 }
    }
}

struct SingleAxisGeometryReader_Previews: PreviewProvider {
    static var previews: some View {
        SingleAxisGeometryReader { width in
            Text("Hello")
                .frame(width: width)
                .background(Color.red)
        }
        
        SingleAxisGeometryReader(axis: .vertical) { height in
            Text("Hello")
                .frame(height: height)
                .background(Color.red)
        }
    }
}
