//
//  GTMGameSoundEngine.swift
//  guess the melody
//
//  Created by Maximal Mac on 31.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
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

class GameSound {
    
}

enum Sound {
    case countdown
    case wrongAnswer
    case correctAnswer
    case levelPass
}

extension Sound {
    var url: URL {
        switch self {
        case .countdown: return NSURL(fileURLWithPath: Bundle.main.path(forResource: "countdown", ofType: "wav")!) as URL
        case .wrongAnswer: return NSURL(fileURLWithPath: Bundle.main.path(forResource: "error", ofType: "wav")!) as URL
        case .correctAnswer: return NSURL(fileURLWithPath: Bundle.main.path(forResource: "okay", ofType: "wav")!) as URL
        case .levelPass: return NSURL(fileURLWithPath: Bundle.main.path(forResource: "levelup", ofType: "mp3")!) as URL
        }
    }
}

class SoundEngine {
    private var player: AVAudioPlayer?
    private let queue = DispatchQueue(label: "md.vz.audio")

    func play(melodyURL: URL, isVibrationActice: Bool = false) {
        if GTMSoundConfig.isSoundOn() {
            queue.async {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.playback.rawValue))
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    try self.player = AVAudioPlayer(contentsOf: melodyURL)
                    self.player!.prepareToPlay()
                    self.player!.play()
                    if isVibrationActice {
                        self.vibration()
                    }
                } catch {
                    print(error.localizedDescription)
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

extension SoundEngine {
    func play(melody: Sound, isVibrationActice: Bool = false) {
        self.play(melodyURL: melody.url, isVibrationActice: isVibrationActice)
    }
}
