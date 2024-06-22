//
//  BeepPlayer.swift
//  Morser
//
//  Created by Giuseppe Francione on 02/05/24.
//

import Foundation
import AVFoundation

class BeepPlayer {
    private var engine: AVAudioEngine
    private var playerNode: AVAudioPlayerNode
    private var convertedBuffer: AVAudioPCMBuffer?

    init?(frequency: Float, duration: TimeInterval) {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        // Attach playerNode to the engine
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: engine.outputNode.outputFormat(forBus: 0))

        // Start the engine
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try engine.start()
        } catch {
            print("Error starting AVAudioEngine: \(error.localizedDescription)")
            return nil
        }

        let sampleRate: Double = 44100
        let frameCount = Int(sampleRate * duration)

        // Generate sine waveform
        let waveform = (0..<frameCount).map { index -> Float in
            let phase = Float(index) / Float(sampleRate) * frequency * 2.0 * Float.pi
            return sin(phase)
        }

        // Create audio buffer
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(frameCount)) else {
            print("Error creating audio format or buffer")
            return nil
        }

        audioBuffer.frameLength = AVAudioFrameCount(frameCount)
        let audioBufferPtr = audioBuffer.floatChannelData![0]
        for index in 0..<frameCount {
            audioBufferPtr[index] = waveform[index]
        }

        // Ensure the buffer format matches the engine output format
        let outputFormat = engine.outputNode.outputFormat(forBus: 0)

        // Create audio converter
        guard let converter = AVAudioConverter(from: audioFormat, to: outputFormat),
              let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(frameCount)) else {
            print("Error creating audio converter or converted buffer")
            return nil
        }
        self.convertedBuffer = convertedBuffer

        // Perform the conversion
        let inputBlock: AVAudioConverterInputBlock = { (_, outStatus) -> AVAudioBuffer? in
            outStatus.pointee = .haveData
            return audioBuffer
        }

        var error: NSError?
        let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)
        if status == .error {
            print("Error converting audio buffer: \(error?.localizedDescription ?? "Unknown error")")
            return nil
        }
    }

    func playSound() {
        guard let convertedBuffer = convertedBuffer else { return }

        // Stop the player node before scheduling a new buffer
        playerNode.stop()

        // Schedule and play the buffer
        playerNode.scheduleBuffer(convertedBuffer, completionHandler: nil)
        playerNode.play()
    }

    deinit {
        // Stop the engine and detach nodes when the instance is deallocated
        playerNode.stop()
        engine.stop()
    }
}
