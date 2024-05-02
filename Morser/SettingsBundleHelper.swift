//
//  SettingsBundleHelper.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let Slider = "slider_preference"
        static let Sound = "sound_enabled"
    }
   
    static func getSliderPreference() -> Double {
        print("Settings value:  \(Double(UserDefaults.standard.integer(forKey: SettingsBundleKeys.Slider)))")
        print("Current haptics speed:   \(Double(UserDefaults.standard.integer(forKey: SettingsBundleKeys.Slider)) / 10.0)")
        if UserDefaults.standard.integer(forKey: SettingsBundleKeys.Slider) == 0 {
            print("Error! For some reason haptics speed is set to 0, resetting to 1")
            UserDefaults.standard.set(1, forKey: SettingsBundleKeys.Slider)
            return 0.1
        }
        else {
            return Double(UserDefaults.standard.integer(forKey: SettingsBundleKeys.Slider)) / 10.0
        }
    }
    
    static func getSoundPreference() -> Bool {
        return UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)
    }
    
}
