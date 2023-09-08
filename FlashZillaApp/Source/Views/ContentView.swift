//
//  ContentView.swift
//  FlashZillaApp
//
//  Created by Danjuma Nasiru on 09/03/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var vm = CardsViewModel()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(vm.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(vm.cards.indices, id: \.self) { index in
                        CardView(card: vm.cards[index]) {
                            withAnimation{
                                vm.removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: vm.cards.count)
                        .allowsHitTesting(index == vm.cards.count - 1)
                        .accessibilityHidden(index < vm.cards.count - 1)
                    }
                }
                .allowsHitTesting(vm.timeRemaining > 0)
                
                
                if vm.cards.isEmpty {
                    Button("Start Again", action: vm.resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        vm.showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                vm.removeCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
            
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if vm.cards.isEmpty == false {
                    vm.isActive = true
                }
            } else {
                vm.isActive = false
            }
        }
        .sheet(isPresented: $vm.showingEditScreen, onDismiss: vm.resetCards, content: EditView.init)/*Note that passing edit view like this will only work when the initializer expects no parameter*/
        .onAppear(perform: vm.resetCards)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

extension View {
    func stacked(at position : Int, in total : Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}
