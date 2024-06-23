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
            #if !os(watchOS)
            let oldBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
            #endif
            torchIsOn = true
            Timer.scheduledTimer(withTimeInterval: time / 4, repeats: false) { _ in
                self.torchIsOn = false
                #if !os(watchOS)
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
