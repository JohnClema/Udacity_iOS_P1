//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by John Clema on 26/08/2015.
//  Copyright (c) 2015 JohnClema. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var player : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = receivedAudio.filePathURL {
            print(url)
            player = try? AVAudioPlayer(contentsOf: url as URL)
        }
        player.enableRate = true
        audioEngine = AVAudioEngine()
        if let url = receivedAudio.filePathURL {
            print(url)
            audioFile = try? AVAudioFile(forReading: url as URL)
        }
    }

    @IBAction func stopPlayingSounds(sender: AnyObject) {
        stopAudio()
    }
    @IBAction func playSlowSound(sender: AnyObject) {
        playSoundWithRate(rate: 0.5)
    }
    @IBAction func playFastSound(sender: AnyObject) {
        playSoundWithRate(rate: 2.0)
    }
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playSoundWithVariablePitch(pitch: 1000)
    }
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playSoundWithVariablePitch(pitch: -1000)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        playSoundWithDelay(delay: 2)
    }
    
    func playSoundWithVariablePitch(pitch: Float) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        audioPlayerNode.play()
        
    }
    
    func playSoundWithDelay(delay: Double) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = TimeInterval(delay)
        echoNode.feedback = 0.2
        echoNode.lowPassCutoff = 10
        echoNode.wetDryMix = 0.5
        audioEngine.attach(echoNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: audioFile.processingFormat)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler:nil)
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        audioPlayerNode.play()
    }
    
    func playSoundWithRate(rate: Float) {
        stopAudio()
        player.rate = rate
        player.currentTime = 0.0
        player?.play()
    }
    
    //TODO: Create function to stop all sound
    func stopAudio() {
        player.stop()
        audioEngine.stop()
        audioEngine.reset()

    }
}
