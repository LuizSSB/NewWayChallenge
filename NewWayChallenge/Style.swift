//
//  Style.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/25/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation
import UIKit

class Style {
    static let navigationBarColor =
        UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
    
    static let navigationBarTintColor = UIColor.white
    
    static let highlightColor = UIColor(red: 221/255, green: 146/255, blue: 36/255, alpha: 1)
    
    static let titleColor = UIColor(red: 120/255, green: 157/255, blue: 180/255, alpha: 1)
    
    static func setup() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = navigationBarColor
        navBarAppearance.tintColor = navigationBarTintColor
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: navigationBarTintColor
        ]
    }
    
    // luizssb: static class
    fileprivate init() {}
}
