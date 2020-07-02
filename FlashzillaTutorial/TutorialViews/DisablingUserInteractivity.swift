//
//  DisablingUserInteractivity.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/28/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct DisablingUserInteractivity: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 300, height: 300)
                .onTapGesture {
                    print("Rectangle tapped!")
            }
            
            Circle()
                .fill(Color.red)
                .frame(width: 300, height: 300)
                //you can specify the tapable shape of other form
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Circle Tapped")
            }
                
                // disables tapability
        .allowsHitTesting(false)
        }
    }
}

struct DisablingUserInteractivity_Previews: PreviewProvider {
    static var previews: some View {
        DisablingUserInteractivity()
    }
}
