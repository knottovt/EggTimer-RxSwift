//
//  MainViewController.swift
//  EggTimer
//
//  Created by Visarut Tippun on 31/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var softEggButton: UIButton!
    @IBOutlet weak var mediumEggButton: UIButton!
    @IBOutlet weak var hardEggButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    var viewModel = MainViewModel()
    var timer = Timer()
    var player:AVAudioPlayer!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetButton.isHidden = true
        self.remainingLabel.isHidden = true
        
        self.viewModel.progress.bind(to: self.progressBar.rx.progress).disposed(by: self.bag)
        self.viewModel.secondsRemaining.map({ String($0) + "s" }).bind(to: self.remainingLabel.rx.text).disposed(by: self.bag)
        
        self.softEggButton.rx.tap.bind {
            self.setTimer(eggTime: .soft)
        }.disposed(by: self.bag)
        
        self.mediumEggButton.rx.tap.bind {
            self.setTimer(eggTime: .medium)
        }.disposed(by: self.bag)
        
        self.hardEggButton.rx.tap.bind {
            self.setTimer(eggTime: .hard)
        }.disposed(by: self.bag)
        
        self.resetButton.rx.tap.bind {
            self.setTimer(eggTime: .none)
        }.disposed(by: self.bag)
    }
    
    func setTimer(eggTime:EggTime) {
        self.titleLabel.text = eggTime.title
        self.resetButton.isHidden = eggTime == .none
        self.remainingLabel.isHidden = eggTime == .none
        self.timer.invalidate()
        if eggTime != .none {
            self.viewModel.setTimer(eggTime: eggTime)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
        }else{
            self.viewModel.reset()
        }
    }
    
    @objc func updateTimer() {
        let isValid = self.viewModel.updateTimer()
        if !isValid {
            self.timer.invalidate()
            self.titleLabel.text = "DONE!"
            self.playSound()
        }
    }
    
    func playSound() {
        if let url = self.viewModel.getSoundUrl() {
            self.player = try? AVAudioPlayer(contentsOf: url)
            self.player.play()
        }
    }
    
}

