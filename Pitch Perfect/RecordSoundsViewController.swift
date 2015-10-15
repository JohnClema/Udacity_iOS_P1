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
        recordingLabel.text = "Tap to record"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        stopButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            audio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            microphoneButton.enabled = true
            stopButton.hidden = true
            recordingLabel.hidden = true

            performSegueWithIdentifier("stopRecording", sender: audio)
        }
        else {
            let alert: UIAlertController = UIAlertController(title: "Error", message: "Recording was not successful", preferredStyle: .Alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion:nil)
            
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
        recordingLabel.text = "Recording"

        
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
        recordingLabel.text = "Tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

