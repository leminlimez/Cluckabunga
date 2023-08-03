//
//  Haptic++.swift
//  Chicken Butt
//
//  Created by lemin on 8/2/23.
//

import Foundation
import UIKit

class Haptic {
    static let shared = Haptic()

    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
