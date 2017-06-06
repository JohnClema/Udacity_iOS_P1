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
        recordingLabel.text = "Tap to Record"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        microphoneButton.isEnabled = true
        recordingLabel.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stopButton.isHidden = true
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            audio = RecordedAudio(filePathURL: recorder.url as NSURL, title: recorder.url.lastPathComponent)
            microphoneButton.isEnabled = true
            stopButton.isHidden = true

            performSegue(withIdentifier: "stopRecording", sender: audio)
        }
        else {
            let alert: UIAlertController = UIAlertController(title: "Error", message: "Recording was not successful", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion:nil)
            
            microphoneButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func recordAudio(sender: AnyObject) {
        //TODO: "Show recording in process
        //TODO: Record the Users voice
        microphoneButton.isEnabled = false
        stopButton.isHidden = false
        recordingLabel.text = "Recording"

        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 
        let recordingName = "recording.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        audioRecorder = try? AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self

        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        print("in recordAudio")
    }
    @IBAction func stopRecording(sender: AnyObject) {
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

