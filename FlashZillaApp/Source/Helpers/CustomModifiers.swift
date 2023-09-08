//
//  CustomModifiers.swift
//  FlashZillaApp
//
//  Created by Danjuma Nasiru on 08/09/2023.
//

import Foundation
import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        
        ZStack(alignment: .trailing)
        {
            content
            
            if !text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

extension TextField{
    func clearBtn(text: Binding<String>) -> some View{
        modifier(ClearButton(text: text))
    }
}
