//
//  TriggeringEventsRepetedly.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/29/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct TriggeringEventsRepetedly: View {
    //tolerance adds optimization since it can be delayed slightly to fire simultaniously with other tasks
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onReceive(timer, perform: { time in
                    print("The time is now \(time)")
                })
            Button("Stop Timer") {
                self.timer.upstream.connect().cancel()
            }
            
        }
    }
}

struct TriggeringEventsRepetedly_Previews: PreviewProvider {
    static var previews: some View {
        TriggeringEventsRepetedly()
    }
}
