//
//  EggTime.swift
//  EggTimer
//
//  Created by Visarut Tippun on 31/12/20.
//

import Foundation

enum EggTime:Int {
    
    case none = 1
    case soft = 3
    case medium = 4
    case hard = 7
    
    var title:String {
        get{
            switch self {
            case .none:     return "How do you like your eggs?"
            case .soft:     return "Soft"
            case .medium:   return "Medium"
            case .hard:     return "Hard"
            }
        }
    }
    
    var totalSeconds:Int {
        get{
            return self.rawValue * 60
        }
    }
    
}
