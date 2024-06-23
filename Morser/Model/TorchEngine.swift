//
//  TorchEngine.swift
//  Morser
//
//  Created by Giuseppe Francione on 27/05/24.
//

import Foundation
import AVFoundation
import SwiftUI

class TorchEngine: ObservableObject {
    @AppStorage("flashlight") private var flashlight = false
    @AppStorage("softwareFlashlight") private var softwareFlashlight = false
    enum TorchType {
        case hardware
        case software
        case both
    }
    @Published var torchIsOn: Bool = false
    static let shared = TorchEngine()
    static var torchType: TorchType = {
        #if os(iOS)
        if TorchEngine.shared.deviceHasTorch() {
            return .hardware
        } else {
            return .software
        }
        #else
        return .software
        #endif
    }()
    private init() {}
    func toggleTorchFor(_ time: TimeInterval) {
        #if os(iOS)

        if let device = AVCaptureDevice.default(for: .video), device.hasTorch && flashlight {
            do {
                try device.lockForConfiguration()
                device.torchMode = .on
                Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
                    device.torchMode = .off
                    device.unlockForConfiguration()
                }
            } catch {
                print("Torch could not be used: \(error)")
            }
        }
        #endif
        if softwareFlashlight {
            #if os(macOS)
            temporaryMaxBrightness(time/4)
            #endif
            #if os(iOS)
            let oldBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
            #endif
            torchIsOn = true
            Timer.scheduledTimer(withTimeInterval: time / 4, repeats: false) { _ in
                self.torchIsOn = false
                #if os(iOS)
                UIScreen.main.brightness = oldBrightness
                #endif
            }

        }
    }
    func deviceHasTorch() -> Bool {
        #if os(iOS)
        guard let device = AVCaptureDevice.default(for: .video) else { return false }

        return device.hasTorch
        #else
        return true
        #endif
    }
}
#if os(macOS)
import IOKit
import CoreGraphics

func getCurrentBrightness() -> Float {
    var brightness: Float = 0.0
    let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IODisplayConnect"))

    IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
    IOObjectRelease(service)
    return brightness
}

func setBrightness(level: Float) {
    let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IODisplayConnect"))

    let brightness = max(min(level, 1.0), 0.0)
    IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, brightness)
    IOObjectRelease(service)
}

func temporaryMaxBrightness(_ duration: TimeInterval) {
    let originalBrightness = getCurrentBrightness()
    setBrightness(level: 1.0)  // Set to maximum brightness

    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
        setBrightness(level: originalBrightness)  // Reset to original brightness
    }
}
#endif
