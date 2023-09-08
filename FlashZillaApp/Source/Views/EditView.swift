//
//  EditView.swift
//  FlashZillaApp
//
//  Created by Danjuma Nasiru on 14/03/2023.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = CardsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $vm.newPrompt).modifier(ClearButton(text: $vm.newPrompt))
                    TextField("Answer", text: $vm.newAnswer).clearBtn(text: $vm.newAnswer)
                    Button("Add card") { vm.addCards() }
                }
                
                Section {
                    ForEach(vm.cards, id: \.self) { card in
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: vm.removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done") { dismiss() }
            }
            .listStyle(.grouped)
            .onAppear(perform: vm.loadData)
        }
    }
    
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
