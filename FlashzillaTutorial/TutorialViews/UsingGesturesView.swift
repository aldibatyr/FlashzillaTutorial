//
//  UsingGesturesView.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/28/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct UsingGesturesView: View {
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            //            Text("Hey")
            //                .onTapGesture(count: 2) {
            //                    print("Double Tapped")
            //            }
            //            Text("LongPress")
            //                .onLongPressGesture(minimumDuration: 2) {
            //                    print("Long Press Detected")
            //            }
            //            Text("Multiple Closures")
            //                .onLongPressGesture(minimumDuration: 1, pressing: {inProgress in
            //                    print("In progress: \(inProgress)!")
            //                }) {
            //                    print("Long Pressed")
            //            }
            //            .padding(.bottom)
            
            // using complex gesture
            //
            //            Text("Pinch ME")
            //            .scaleEffect(finalAmount + currentAmount)
            //            .gesture(
            //                MagnificationGesture()
            //                    .onChanged { amount in
            //                        self.currentAmount = amount - 1
            //                }
            //                .onEnded { amount in
            //                    self.finalAmount += self.currentAmount
            //                    self.currentAmount = 0
            //                }
            //            )
            
            // USING CLASHING GESTURES
            
            Text("CLASHING GESTURE")
                .onTapGesture {
                    print("Text Tapped")
            }
        }
//        .highPriorityGesture(
//            TapGesture()
//                .onEnded { _ in
//                    print("VStack tapped")
//            }
//        )
        
        // or we can use simultanious gestures
        
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
            }
        )
    }
}

struct UsingGesturesView_Previews: PreviewProvider {
    static var previews: some View {
        UsingGesturesView()
    }
}
