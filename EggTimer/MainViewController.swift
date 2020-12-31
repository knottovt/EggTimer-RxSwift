//
//  MainViewController.swift
//  EggTimer
//
//  Created by Visarut Tippun on 31/12/20.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

enum EggTime:Int {
    
    case none = 1
    case soft = 2
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

class MainViewController: UIViewController {
    
    @IBOutlet weak var softEggButton: UIButton!
    @IBOutlet weak var mediumEggButton: UIButton!
    @IBOutlet weak var hardEggButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    var timer = Timer()
    var player:AVAudioPlayer!
    var secondsRemaining = BehaviorRelay<Int>(value: 1)
    var totalTime:Int = 1
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetButton.isHidden = true
        self.remainingLabel.isHidden = true
        
        self.secondsRemaining.map({ Float($0) / Float(self.totalTime) }).bind(to: self.progressBar.rx.progress).disposed(by: self.bag)
        self.secondsRemaining.map({ String($0) + "s" }).bind(to: self.remainingLabel.rx.text).disposed(by: self.bag)
        
        self.softEggButton.rx.tap.bind {
            self.setTimer(time: .soft)
        }.disposed(by: self.bag)
        
        self.mediumEggButton.rx.tap.bind {
            self.setTimer(time: .medium)
        }.disposed(by: self.bag)
        
        self.hardEggButton.rx.tap.bind {
            self.setTimer(time: .hard)
        }.disposed(by: self.bag)
        
        self.resetButton.rx.tap.bind {
            self.setTimer(time: .none)
        }.disposed(by: self.bag)
    }
    
    func setTimer(time:EggTime) {
        self.timer.invalidate()
        self.titleLabel.text = time.title
        self.totalTime = time.totalSeconds
        self.secondsRemaining.accept(time.totalSeconds)
        self.resetButton.isHidden = time == .none
        self.remainingLabel.isHidden = time == .none
        if time != .none {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
        }
    }
    
    @objc func updateTimer() {
        var current = self.secondsRemaining.value
        current -= 1
        if current > 0 {
            self.secondsRemaining.accept(current)
        }else{
            self.secondsRemaining.accept(0)
            self.timer.invalidate()
            self.titleLabel.text = "DONE!"
            self.playSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        do{
            self.player = try? AVAudioPlayer(contentsOf: url)
            self.player.play()
        }
    }
    
}

