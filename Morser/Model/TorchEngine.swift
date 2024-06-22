//
//  TorchEngine.swift
//  Morser
//
//  Created by Giuseppe Francione on 27/05/24.
//

import Foundation
import AVFoundation

class TorchEngine: ObservableObject {
    @Published var torchIsOn: Bool = false
    static let shared = TorchEngine()
    private init() {}
    func toggleTorchFor(_ time: TimeInterval) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
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
        } else {
            torchIsOn = true
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
                self.torchIsOn = false
            }
        }
    }
    func deviceHasTorch() -> Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }

        return device.hasTorch
    }
}
