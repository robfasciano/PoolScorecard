//
//  Spherify.swift
//  Set
//
//  Created by Robert Fasciano on 11/24/24.
//

import SwiftUI

struct Spherify: ViewModifier, Animatable {
    
//    init(isFaceUp: Bool, isSelected: Bool) {
//        rotation = isFaceUp ? 0 : 180
//        self.isSelected = isSelected
//    }
    
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader {geo in
                    ZStack {
                        Rectangle()
                            .fill(RadialGradient(
                                colors: [.clear, .black],
                                center: UnitPoint(
                                    x: Constants.shine.x,
                                    y: Constants.shine.y),
                                startRadius: 0, endRadius: CGFloat(geo.size.width)*1.1))
                            .opacity(Constants.shine.shadow)
                        Rectangle()
                            .fill(RadialGradient(
                                colors: [.white, .clear],
                                center: UnitPoint(
                                    x: Constants.shine.x,
                                    y: Constants.shine.y),
                                startRadius: 0, endRadius: CGFloat(geo.size.width)*0.25))
                            .opacity(Constants.shine.reflect)
                    }
                }
            }
        
        .clipShape(Circle())
        .shadow(color: .black, radius: 2)    }
        
    struct Constants {
        struct shine {
            static let x = 0.7
            static let y = 0.2
            static let shadow = 0.7
            static let reflect = 0.3
        }
    }
}

extension View {
    func spherify() -> some View {
        modifier(Spherify())
    }
}

