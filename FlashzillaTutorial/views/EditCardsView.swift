//
//  EditCardsView.swift
//  FlashzillaTutorial
//
//  Created by Aldiyar Batyrbekov on 6/30/20.
//  Copyright © 2020 Aldiyar Batyrbekov. All rights reserved.
//

import SwiftUI

struct EditCardsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add New Card"), content: {
                    TextField("Prompt", text: $newPrompt).modifier(ClearButton(text: $newPrompt))
                    TextField("Answer", text: $newAnswer).modifier(ClearButton(text: $newAnswer))
                    Button("Add card", action: addCard)
                })
                
                Section(header: Text("All Cards"), content: {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 0, content: {
                            Text(self.cards[index].prompt)
                                .font(.headline)
                            Text(self.cards[index].answer)
                                .foregroundColor(.secondary)
                        })
                        
                    }
                .onDelete(perform: removeCards)
                })
            }
        .navigationBarTitle("Edit Cards")
        .navigationBarItems(trailing: Button("Done", action: dismiss))
        .listStyle(GroupedListStyle())
        .onAppear(perform: loadData)
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
