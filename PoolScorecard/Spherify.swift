//
//  Spherify.swift
//  Set
//
//  Created by Robert Fasciano on 11/24/24.
//

import SwiftUI

struct Spherify: ViewModifier, Animatable {
    var x: CGFloat
    var y: CGFloat
    var mark: Bool
    
    init(angle: Double = 50, mark: Bool = false) {
        self.x = 0.5 + 0.5 * Constants.shine.radius * cos(-(angle / 180) * 3.14159)
        self.y = 0.5 + 0.5 * Constants.shine.radius * sin(-(angle / 180) * 3.14159)
        self.mark = mark
    }

    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader {geo in
                    ZStack {
                        Rectangle()
                            .fill(RadialGradient(
                                colors: [.clear, .black],
                                center: UnitPoint(
                                    x: x,
                                    y: y),
                                startRadius: 0, endRadius: CGFloat(geo.size.width)*1.1))
                            .opacity(Constants.shine.shadow)
                        Rectangle()
                            .fill(RadialGradient(
                                colors: [.white, .clear],
                                center: UnitPoint(
                                    x: x,
                                    y: y),
                                startRadius: 0, endRadius: CGFloat(geo.size.width)*0.25))
                            .opacity(Constants.shine.reflect)
                        Rectangle()
                            .fill(.black)
                            .aspectRatio(1, contentMode: .fit)
                            .opacity(mark ? 0.6 : 0)
                    }
                }
            }
        
        .clipShape(Circle())
        .shadow(color: .black, radius: 2)    }
        
    struct Constants {
        struct shine {
            static let radius = 0.8
            static let shadow = 0.7
            static let reflect = 0.3
        }
    }
}

extension View {
    func spherify(angle: Double = 50, mark: Bool = false) -> some View {
        modifier(Spherify(angle: angle, mark: mark))
    }
}

