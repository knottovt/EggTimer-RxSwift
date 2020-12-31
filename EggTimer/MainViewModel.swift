//
//  MainViewModel.swift
//  EggTimer
//
//  Created by Visarut Tippun on 31/12/20.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    var totalSeconds:Int = 1
    var secondsRemaining = BehaviorRelay<Int>(value: 1)
    var progress = BehaviorRelay<Float>(value: 1)
    
    init() {
        
    }
    
    func setTimer(eggTime:EggTime) {
        self.secondsRemaining.accept(eggTime.totalSeconds)
        self.totalSeconds = eggTime.totalSeconds
    }
    
    func updateTimer() -> Bool {
        var current = self.secondsRemaining.value
        current -= 1
        self.progress.accept(Float(current) / Float(self.totalSeconds))
        if current > 0 {
            self.secondsRemaining.accept(current)
            return true
        }else{
            self.secondsRemaining.accept(0)
            return false
        }
    }
    
    func reset() {
        self.totalSeconds = 1
        self.secondsRemaining.accept(1)
        self.progress.accept(1)
    }
    
    func getSoundUrl() -> URL? {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {
            return nil
        }
        return url
    }
    
}
