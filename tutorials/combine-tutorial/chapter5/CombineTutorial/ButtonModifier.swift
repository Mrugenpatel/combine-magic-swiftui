//
//  ButtonModifier.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 11/8/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content.font(.footnote)
        .padding(10)
        .foregroundColor(Color.white)
        .frame(minWidth: 80)
        .background(backgroundColor)
        .cornerRadius(12)
    }
}
