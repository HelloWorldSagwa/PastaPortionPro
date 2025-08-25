//
//  TabType.swift
//  PastaPortionPro(SwiftUI)
//
//  Created by Refactoring on 2024/12/25.
//

import Foundation

enum TabType: String, CaseIterable {
    case home = "Home"
    case history = "History"
    case portion = "Portion"
    case timer = "Timer"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .home:
            return "house.circle"
        case .history:
            return "chart.bar.doc.horizontal.fill"
        case .portion:
            return "circle.circle"
        case .timer:
            return "timer.circle"
        case .settings:
            return "person.circle.fill"
        }
    }
    
    var displayName: String {
        switch self {
        case .settings:
            return "MY"
        default:
            return self.rawValue
        }
    }
}