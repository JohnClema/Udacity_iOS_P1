//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by John Clema on 26/08/2015.
//  Copyright (c) 2015 JohnClema. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController : UIViewController, AVAudioRecorderDelegate, UIAlertViewDelegate {

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
        recordingLabel.enabled = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            audio = RecordedAudio(filePathURL: recorder.url)
            audio.filePathURL = recorder.url
            audio.title = recorder.url.lastPathComponent
            microphoneButton.enabled = true
            stopButton.hidden = true
            recordingLabel.hidden = true

            performSegueWithIdentifier("stopRecording", sender: audio)
        }
        else {
            UIAlertController(title: "Error", message: "Recording was not successful", preferredStyle: .Alert)
            
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
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let recordingName = "recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self

        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        
        print("in recordAudio")
    }
    @IBAction func stopRecording(sender: AnyObject) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

