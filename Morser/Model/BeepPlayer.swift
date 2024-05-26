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
    init(frequency: Float, duration: TimeInterval) {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()

        // Collega il playerNode all'engine
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: engine.outputNode.outputFormat(forBus: 0))

        // Avvia l'engine
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try engine.start()
        } catch {
            print("Error starting AVAudioEngine: \(error.localizedDescription)")
        }
        let sampleRate: Double = 44100
        let frameCount = Int(sampleRate * duration)
        // Genera la forma d'onda sinusoidale
        let waveform = (0..<frameCount).map { index -> Float in
            let phase = Float(index) / Float(sampleRate) * frequency * 2.0 * Float.pi
            return sin(phase)
        }
        // Crea un buffer audio con la forma d'onda generata
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(frameCount))!
        audioBuffer.frameLength = AVAudioFrameCount(frameCount)
        let audioBufferPtr = audioBuffer.floatChannelData![0]
        for index in 0..<frameCount {
            audioBufferPtr[index] = waveform[index]
        }
        // Assicurati che il formato del buffer audio corrisponda al formato dell'output dell'engine
        let outputFormat = engine.outputNode.outputFormat(forBus: 0)
        // Crea un convertitore audio per la conversione del formato del buffer
        guard let converter = AVAudioConverter(from: audioFormat, to: outputFormat) else {
            print("Error creating audio converter")
            return
        }
        // Converti il buffer audio nel formato dell'output dell'engine
        guard let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat,
                                                     frameCapacity: AVAudioFrameCount(frameCount)) else {
            print("Error creating converted audio buffer")
            return
        }
        self.convertedBuffer = convertedBuffer
        // Esegui la conversione del buffer audio
        let inputBlock: AVAudioConverterInputBlock = { (_, outStatus) -> AVAudioBuffer? in
            outStatus.pointee = .haveData
            return audioBuffer
        }
        var error: NSError?
        let status = converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)
        if status == .error {
            print("Error converting audio buffer: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
    }
    func playSound() {
        if convertedBuffer != nil {
            // Avvia la riproduzione del suono utilizzando AVAudioPlayerNode
            playerNode.scheduleBuffer(convertedBuffer!, completionHandler: nil)
            playerNode.play()
        }
    }
}
