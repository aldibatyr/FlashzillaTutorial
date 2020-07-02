//
//  ContentView.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/28/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differetiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var isActive = true
    @State private var showingEditScreen = false
    @State private var engine: CHHapticEngine?
    @State private var showingEndOfTimeScreen = false
    @State private var cards = [Card]()
    @State private var timeRemaining = 10
    @State private var timeAboutToRunOut = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(timeAboutToRunOut ? Color.red : Color.black)
                            .opacity(0.75)
                )
                ZStack {
                    if showingEndOfTimeScreen  {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 300, alignment: .center)
                            .cornerRadius(20)
                        .shadow(radius: 20)
                        Text("Time is out")
                    } else {
                        ForEach(0..<cards.count, id: \.self) { index in
                            CardView(card: self.cards[index]) {
                                withAnimation {
                                    self.removeCard(at: index)
                                }
                            }
                            .stacked(at: index, in: self.cards.count)
                            .allowsHitTesting(index == self.cards.count - 1)
                            .accessibility(hidden: index < self.cards.count - 1)
                        }
                    }
                }
                .transition(.move(edge: .bottom))
                .allowsHitTesting(timeRemaining > 0)
                if cards.isEmpty || showingEndOfTimeScreen {
                    Button("Start Again") {
                        self.resetCards()
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingEditScreen = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    })
                }
                Spacer()
            }
            if differetiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        })
                            .accessibility(label: Text("Wrong"))
                            .accessibility(hint: Text("Mark your answer as being incorrect"))
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }, label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        })
                            .accessibility(label: Text("Correct"))
                            .accessibility(hint: Text("Mark your answer as being correct"))
                        
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: {
            EditCardsView()
        })
            .onAppear(perform: resetCards)
            .onAppear(perform: prepareCoreHaptics)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                self.isActive = false
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                if self.cards.isEmpty == false {
                    self.isActive = true
                }
            })
            .onReceive(timer, perform: { time in
                guard self.isActive else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
                if self.timeRemaining == 0 {
                    withAnimation {
                        self.showingEndOfTimeScreen = true
                    }
                }
                if self.timeRemaining == 5 {
                    self.timeAboutToRunOut = true
                    self.playTimeRunoutFeedback()
                }
                
            })
        
    }
    
    
    
    func playTimeRunoutFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        var events = [CHHapticEvent]()
        for i in stride(from: 0, to: 1, by: 0.33) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: TimeInterval(i))
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play the pattern: \(error.localizedDescription)")
        }
        
    }
    
    func prepareCoreHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        do {
            self.engine = try CHHapticEngine()
            try self.engine?.start()
            
        } catch {
            print("problem starting haptic engine \(error.localizedDescription)")
        }
    }
    
    func resetCards() {
        timeRemaining = 10
        isActive = true
        timeAboutToRunOut = false
        withAnimation {
            showingEndOfTimeScreen = false
        }
        loadData()
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
