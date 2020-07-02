//
//  SquencingGesturesView.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/28/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct SquencingGesturesView: View {
    // how far the circle has been dragged
    @State private var offset = CGSize.zero
    
    // wheather it is currently being dragged or not
    @State private var isDragging = false
    
    var body: some View {
        // a drag gesture that updated offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                    self.isDragging = false
                }
        }
        
        // a long press gesture that enables isDragging
        
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    self.isDragging = false
                }
        }
        
        // a combined gesture that forses the user to long press then drag
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        return Circle()
            .fill(Color.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}

struct SquencingGesturesView_Previews: PreviewProvider {
    static var previews: some View {
        SquencingGesturesView()
    }
}
