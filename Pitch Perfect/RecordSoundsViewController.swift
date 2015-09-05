//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by John Clema on 26/08/2015.
//  Copyright (c) 2015 JohnClema. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController : UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var audio: RecordedAudio!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        microphoneButton.enabled = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            audio = RecordedAudio()
            audio.filePathURL = recorder.url
            audio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("stopRecording", sender: audio)
        }
        else {
            println("Recording was not successful")
            microphoneButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }

    @IBAction func recordAudio(sender: AnyObject) {
        //TODO: "Show recording in process
        //TODO: Record the Users voice
        microphoneButton.enabled = false
        stopButton.hidden = false
        recordingLabel.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self

        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
        println("in recordAudio")
    }
    @IBAction func stopRecording(sender: AnyObject) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

