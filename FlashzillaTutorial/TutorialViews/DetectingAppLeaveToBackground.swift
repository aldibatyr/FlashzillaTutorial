//
//  DetectingAppLeaveToBackground.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/29/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct DetectingAppLeaveToBackground: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                    print("Moving to the background")
                })
            
            Text("Print's Statement when app returns to the view")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("Moving to the foreground")
            }
            
            Text("Detect user taking screenshot")
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification), perform: { _ in
                    print("User took a screenshot")
                })
        }
    }
}

struct DetectingAppLeaveToBackground_Previews: PreviewProvider {
    static var previews: some View {
        DetectingAppLeaveToBackground()
    }
}
