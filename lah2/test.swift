//
//  test.swift
//  lah2
//
//  Created by Shivam Dave on 1/31/16.
//  Copyright © 2016 ShivamDave. All rights reserved.
//

import Foundation
import MapKit
import AVFoundation
import UIKit

class test: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var resultLabel: UITextField!
    @IBOutlet weak var load: UIProgressView!
    @IBOutlet weak var decibelLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    var dbLevel: Float = 0
    var actualDb: Float = 0
    var totalDb: Float = 0
    var trackLoad = 0
    var brightness: Int = 0{
        didSet{
            brightnessLabel.text = "\(brightness)"
        }
    }
    var avgFive: Int = 0{
        didSet{
            decibelLabel.text = "\(avgFive)"
        }
    }
    var timer: NSTimer?
    var timerDecibel: NSTimer?
    var timerLoad : NSTimer?
    var audioRecorder:AVAudioRecorder!
    //    var track: Double = 0 {
    //        didSet{
    //            counter.text = "\(track)"
    //        }
    //    }
    //    var soundWave: FVSoundWaveView?
    //    let audioKit = AKManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //       let oscillator = AKOscillator()
        //        audioKit.audioOutput = oscillator
        //        audioKit.start()
        //        oscillator.start()
        
    }
    var startPressedAgain = false
    
    
    @IBAction func startTest(sender: AnyObject) {
        totalDb = 0
        load.progress = 0
        dataText.hidden = false
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    //                    print("granted")
                    
                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    
                    
                    //get documnets directory
                    let documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
                    let str =  documents.stringByAppendingPathComponent("recordTest.caf")
                    let url = NSURL.fileURLWithPath(str as String)
                    
                    //create AnyObject of settings
                    let settings: [String : AnyObject] = [
                        AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
                        AVSampleRateKey:44100.0,
                        AVNumberOfChannelsKey:2,
                        AVEncoderBitRateKey:12800,
                        AVLinearPCMBitDepthKey:16,
                        AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
                    ]
                    
                    //record
                    try! self.audioRecorder = AVAudioRecorder(URL: url, settings: settings)
                    self.audioRecorder.delegate = self
                    self.audioRecorder.meteringEnabled = true
                    self.audioRecorder.prepareToRecord()
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), {
                        self.audioRecorder.recordForDuration(5)
                        //                        while status {
                        //                            self.track++
                        //                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            //                            self.soundWave = FVSoundWaveView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
                            //                            let bundle = NSBundle.mainBundle()
                            //                            let file = bundle.pathForResource("recordTest", ofType: "caf")
                            //                            let player = AKAudioPlayer(file!)
                            //                            let tracker = AKFrequencyTracker(player, minimumFrequency: 400, maximumFrequency: 600)
                            //
                            //                            AKPlaygroundLoop(every: 1){
                            //                                let amp = tracker.amplitude
                            //                                let freq = tracker.frequency
                            //
                            //                            }
                            self.timerDecibel = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "startAudioMetering", userInfo: nil, repeats: true);
                            NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "count", userInfo: nil, repeats: true);
                            self.timerLoad = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "loadBar", userInfo: nil, repeats: true);
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "changeLoad", userInfo: nil, repeats: true)
                            
                        })
                    })
                    
                } else{
                }
                
            })
        }
    }
    func changeLoad(){
        if trackLoad == 0 {
            dataText.text = "Gathering data.."
            trackLoad = 1
        }
        else if trackLoad == 1 {
            dataText.text = "Gathering data..."
            trackLoad = 2
        }
        else if trackLoad == 2 {
            dataText.text = "Gathering data."
            trackLoad = 0
        }
        
    }
    func loadBar() {
        if self.load.progress == 1{
            return
        }
        self.load.progress += 0.004
    }
    func count() {
        //        if self.audioRecorder.currentTime > 5 {
        //            self.track = 5.0
        //        }else { self.track = self.audioRecorder.currentTime }
        //        self.track = round(self.track * 10) / 10
        if self.audioRecorder.currentTime > 5 {
            startPressedAgain = false
            avgFive = Int(totalDb / 5)
            brightness = Int(round(UIScreen.mainScreen().brightness * 100))
            
            //            print(avgFive)
            
            showResults(avgFive, brightness: brightness)
        }
    }
    func showResults(decibel: Int, brightness: Int){
        if decibel > 70 || brightness < 20 {
            resultLabel.text = "This is a bad environment. :("
            UIView.animateWithDuration(1.5, animations: {
                self.view.backgroundColor = UIColor.redColor()
                
            })
        }
        else if brightness >= 20 && brightness < 30 || decibel > 60 && decibel <= 70 {
            resultLabel.text = "This is a mediocre environment. :|"
            UIView.animateWithDuration(1.5, animations: {
                self.view.backgroundColor = UIColor.orangeColor()
                
            })
            
        }
        else if brightness >= 30 && brightness <= 90 || decibel > 10 && decibel <= 60 {
            resultLabel.text = "This is a great environment! :)"
            UIView.animateWithDuration(1.5, animations: {
                self.view.backgroundColor = UIColor.greenColor()
                
            })
            
        }
        else {
            resultLabel.text = "This is a mediocre environment. :|"
        }
        timer?.invalidate()
        timerDecibel?.invalidate()
        timerLoad?.invalidate()
        dataText.hidden = true
    }
    func startAudioMetering(){
        self.audioRecorder.updateMeters()
        dbLevel = self.audioRecorder.averagePowerForChannel(0)
        actualDb = dbLevel + 98
        if actualDb > -75 {
            totalDb+=actualDb
            //            print(totalDb)
        }
        print(totalDb)
    }
}
extension String {
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString  
        
        return nsSt.stringByAppendingPathExtension(ext)  
    }
}