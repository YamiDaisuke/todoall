//
//  TaskCheckMark.swift
//  TodoAll
//
//  Created by Franklin Cruz on 23/10/20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import SwiftUI

func deg2rad(_ number: Double) -> Double {
    return number * Double.pi / 180
}

struct Spark: Hashable {
    var size: CGFloat = 15
    var x: CGFloat = 0
    var y: CGFloat = 0
    var x2: CGFloat = 0
    var y2: CGFloat = 0
    var duration: Double = 1.5
    var delay: Double = 1.2
    var color: Double
}

struct TaskCheckMark: View {

    @Binding var isOn: Bool
    var size: CGFloat = 40

    private var positions: [Spark] {
        var arr: [Spark] = []
        let distance: Double = Double(self.size * 0.8)
        let size: CGFloat = self.size * 0.4
        
        let sparks = 8
        for i in 0...sparks {
            let angle = (Double(i) * (360 / Double(sparks)))
            let rad = deg2rad(angle)
            arr.append(Spark(
                size: i % 2 == 0 ? size * 0.5 : size,
                x: CGFloat(distance * cos(rad)),
                y: CGFloat(distance * sin(rad)),
                delay: 1.2,
                color: angle
            ))

            let angle2 = angle + 10;
            let rad2 = deg2rad(angle2)
            arr.append(Spark(
                size: i % 2 == 0 ? size * 0.3 : size * 0.2,
                x: CGFloat((distance - distance * 0.9) * cos(rad2)),
                y: CGFloat((distance - distance * 0.9) * sin(rad2)),
                delay: 1.2,
                color: angle2
            ))
        }
        return arr
    }

    private var sparks: some View {
        ZStack {
            ForEach(positions, id: \.self) { pos in
                Image(systemName: "star.fill").font(.system(size: pos.size, weight: .ultraLight))
                    .foregroundColor(Color(.systemRed))
                    .hueRotation(Angle(degrees: pos.color + 360))
                    .frame(width: pos.size, height: pos.size)
                    .opacity(self.isOn ? 1 : 0)
                    .offset(x: self.isOn ? pos.x : 0, y: self.isOn ? pos.y : 0)
                    .animation(Animation.spring(response: 0.4, dampingFraction: 0.2).speed(0.8))
                    .scaleEffect(x: self.isOn ? 0 : 1, y: self.isOn ? 0 : 1, anchor: .center)
                    .animation(Animation.linear.delay(0.8))

            }
        }
    }

    var body: some View {
        ZStack {
            self.sparks
            
            Circle()
                .frame(width: self.size, height: self.size)
                .foregroundColor(Color(.systemBackground))
            
            if self.isOn {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: self.size, weight: .ultraLight))
                    .foregroundColor(Color(.systemTeal))
            } else {
                Image(systemName: "circle")
                    .font(.system(size: self.size, weight: .ultraLight))
                    .foregroundColor(Color(.systemTeal))
            }
        }.onTapGesture {
            self.isOn.toggle()
        }
    }
}

#if DEBUG
struct TaskCheckMark_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            TaskCheckMark(isOn: .constant(true), size: 48)
                .padding()
                .previewLayout(PreviewLayout.fixed(width: 100, height: 100))
            Spacer()
        }
    }
}
#endif
