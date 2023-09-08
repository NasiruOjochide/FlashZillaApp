//
//  CardsViewModel.swift
//  FlashZillaApp
//
//  Created by Danjuma Nasiru on 08/09/2023.
//

import Combine
import Foundation

class CardsViewModel: ObservableObject {
    
    @Published var isActive = true
    @Published var cards = [Card]()
    @Published var timeRemaining = 100
    @Published var showingEditScreen = false
    @Published var newPrompt = ""
    @Published var newAnswer = ""
    var timer: AnyCancellable? = nil
    
    init() {
        subscribeToTimer()
    }
    
    func subscribeToTimer() {
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { _ in
                guard self.isActive else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            })
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards){
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCards() {
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
