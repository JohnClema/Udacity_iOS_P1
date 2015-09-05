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
        let path = String(stringInterpolationSegment: receivedAudio.filePathURL)
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        player.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    @IBAction func stopPlayingSounds(sender: AnyObject) {
        player?.stop()
    }
    @IBAction func playSlowSound(sender: AnyObject) {
        playSoundWithRate(0.5)
    }
    @IBAction func playFastSound(sender: AnyObject) {
        playSoundWithRate(2.0)
    }
    @IBAction func playChipmunkAudio(sender: AnyObject) {
       playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    func playSoundWithRate(rate: Float) {
        player?.stop()
        player.rate = rate
        player.currentTime = 0.0
        player?.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
