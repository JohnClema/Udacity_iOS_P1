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
        player = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        player.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathURL)
    }

    @IBAction func stopPlayingSounds(sender: AnyObject) {
        stopAudio()
    }
    @IBAction func playSlowSound(sender: AnyObject) {
        playSoundWithRate(0.5)
    }
    @IBAction func playFastSound(sender: AnyObject) {
        playSoundWithRate(2.0)
    }
    @IBAction func playChipmunkAudio(sender: AnyObject) {
       playSoundWithVariablePitch(1000)
    }
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playSoundWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        playSoundWithDelay(2)
    }
    
    func playSoundWithVariablePitch(pitch: Float) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        audioPlayerNode.play()
        
    }
    
    func playSoundWithDelay(delay: Double) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(delay)
        echoNode.feedback = 0.2
        echoNode.lowPassCutoff = 10
        echoNode.wetDryMix = 0.5
        audioEngine.attachNode(echoNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: audioFile.processingFormat)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: audioFile.processingFormat)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
        
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
