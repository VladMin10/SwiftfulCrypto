//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Vladyslav Mi on 28.03.2024.
//

import Foundation
import SwiftUI

class HapticManager{
    
    static let generator = UINotificationFeedbackGenerator()
    static func notification(type : UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}
