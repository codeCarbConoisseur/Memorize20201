//
//  RuleModifier.swift
//  Memorize
//
//  Created by Захар  Сегал on 11.01.2022.
//  Copyright © 2022 Philipp. All rights reserved.
//

import Foundation
import SwiftUI

struct Rule: ViewModifier {
    
    var font: Font
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .font(font)
            .foregroundColor(.orange)
    }
}

extension View {
    func ruleModified(fontType: Font = Font.callout) -> some View {
        modifier(Rule(font: fontType))
    }
}
