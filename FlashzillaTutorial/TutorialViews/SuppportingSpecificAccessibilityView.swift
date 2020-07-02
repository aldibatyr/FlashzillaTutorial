//
//  SuppportingSpecificAccessibilityView.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/29/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct SuppportingSpecificAccessibilityView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    // accessibility for transparency
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .scaleEffect(scale)
                .onTapGesture {
                    if self.reduceMotion {
                        self.scale *= 1.5
                    } else {
                        withAnimation {
                            self.scale *= 1.5
                        }
                    }
            }
            
            // alternative
            Text("Alternate reduce motion")
                .scaleEffect(scale)
                .onTapGesture {
                    self.withOptionalAnimation {
                        self.scale *= 1.5
                    }
            }
        }
    }
    
    //    var body: some View {
    //        HStack {
    //            if differentiateWithoutColor {
    //                Image(systemName: "checkmark.circle")
    //            }
    //
    //            Text("Success")
    //        }
    //        .padding()
    //        .background(differentiateWithoutColor ? Color.black : Color.green)
    //        .foregroundColor(Color.white)
    //        .clipShape(Capsule())
    //    }
    
    func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        if UIAccessibility.isReduceMotionEnabled {
            return try body()
        } else {
            return try withAnimation(animation, body)
        }
    }
}

struct SuppportingSpecificAccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        SuppportingSpecificAccessibilityView()
    }
}
