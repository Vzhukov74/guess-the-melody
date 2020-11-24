//
//  GTMGameSoundEngine.swift
//  guess the melody
//
//  Created by Maximal Mac on 31.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class GTMSoundConfig {
    //private static let soundConfigKey = "ru.soundConfigKey"
    private static var _isSoundOn: Bool = true//?
    
    class func isSoundOn() -> Bool {
//        if GTMSoundConfig._isSoundOn == nil {
//            if let value = UserDefaults.standard.value(forKey: GTMSoundConfig.soundConfigKey) as? Bool {
//                GTMSoundConfig._isSoundOn = value
//                return GTMSoundConfig._isSoundOn!
//            } else {
//                GTMSoundConfig._isSoundOn = true
//                return GTMSoundConfig._isSoundOn!
//            }
//        } else {
            return GTMSoundConfig._isSoundOn//!
//        }
    }
    
//    class func toggleSound() {
//        guard var value = GTMSoundConfig._isSoundOn else { return }
//
//        value = !value
//        GTMSoundConfig._isSoundOn = value
//
//        UserDefaults.standard.set(value, forKey: GTMSoundConfig.soundConfigKey)
//    }
}

class GTMGameSound {
    static let countdown = NSURL(fileURLWithPath: Bundle.main.path(forResource: "countdown", ofType: "wav")!) as URL
    static let wrongAnswer = NSURL(fileURLWithPath: Bundle.main.path(forResource: "error", ofType: "wav")!) as URL
    static let correctAnswer = NSURL(fileURLWithPath: Bundle.main.path(forResource: "okay", ofType: "wav")!) as URL
    static let levelPass = NSURL(fileURLWithPath: Bundle.main.path(forResource: "levelup", ofType: "mp3")!) as URL
}

class GTMGameSoundEngine {
    private var player: AVAudioPlayer?
    private let queue = DispatchQueue(label: "md.vz.audio")

    func play(melodyURL: URL, isVibrationActice: Bool = false) {
        if GTMSoundConfig.isSoundOn() {
            queue.async {
                do {
                    //try AVAudioSession.sharedInstance()//.setCategoryconvertFromAVAudioSessionCategory(AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    try self.player = AVAudioPlayer(contentsOf: melodyURL)
                    self.player!.prepareToPlay()
                    self.player!.play()
                    if isVibrationActice {
                        self.vibration()
                    }
                } catch {
                    //SwiftyBeaver.error(error.localizedDescription)
                }
            }
        }
    }
    
    func stop() {
        queue.async {
            guard self.player != nil else { return }
            
            if self.player!.isPlaying {
                self.player!.stop()
            }
        }
    }
    
    private func vibration() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
}

// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
//	return input.rawValue
//}
