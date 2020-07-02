//
//  MakingVibationsWithUINotifications.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/28/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct MakingVibationsWithUINotifications: View {
    @State private var engine: CHHapticEngine?
    var body: some View {
        Text("HEY")
        .onAppear(perform: prepareHaptics)
            .onTapGesture {
                self.complexSuccess()
        }
    }
    
    // CoreHaptics haptic
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch  {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
    // UIKit haptic
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct MakingVibationsWithUINotifications_Previews: PreviewProvider {
    static var previews: some View {
        MakingVibationsWithUINotifications()
    }
}
