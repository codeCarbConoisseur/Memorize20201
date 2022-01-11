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
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .font(.callout)
            .foregroundColor(.orange)
    }
}

extension View {
    func ruleModified() -> some View {
        modifier(Rule())
    }
}
