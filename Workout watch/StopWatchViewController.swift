//
//  StopWatchViewController.swift
//  Workout watch
//
//  Created by Antoine Simon on 29/03/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit
import AVFoundation

class StopWatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var displayTime: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var minuteSet = "0"
    var secondesSet = "30"
    var reset = true
    var elapsedTime: double_t = 0
    var tmp: double_t = 0
    
    @IBAction func start(sender:AnyObject){
        if !timer.valid {
            if reset == true{
                //play first or stop
                stopButton.setTitle("Stop", forState: .Normal)
                let aSelector : Selector = #selector(StopWatchViewController.updateTime)
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                reset = false
                if tmp != 0{
                startTime = startTime + (NSDate.timeIntervalSinceReferenceDate() - tmp)
                }
                }
            else{
                //play if resume
                let aSelector : Selector = #selector(StopWatchViewController.updateTime)
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                startTime = NSDate.timeIntervalSinceReferenceDate()
            }
        }
    }
    @IBAction func stop(sender:AnyObject){
        if timer.valid{
            //stop
            timer.invalidate()
            tmp = NSDate.timeIntervalSinceReferenceDate()
            stopButton.setTitle("Reset", forState: .Normal)
            reset = true
        }
        else{
            //resume
            displayTime.text = "00:00:00"
            stopButton.setTitle("Stop", forState: .Normal)
            startTime = 0
            reset = false
        }
    }
    
    let pickerData = [
        ["00","01","02","03","04"],
        ["00", "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    ]
    
    enum PickerComponent:Int{
        case min = 0
        case sec = 1
    }
    
    var set = 0
    
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var locker: UIButton!
    @IBAction func lock(sender:AnyObject){
        if locker.imageForState(.Normal) == UIImage.animatedImageNamed("lock.png", duration: 0){
            locker.setImage(UIImage.animatedImageNamed("security.png", duration: 0), forState: .Normal)
            picker.userInteractionEnabled = true
        }
        else {
            locker.setImage(UIImage.animatedImageNamed("lock.png", duration: 0), forState: .Normal)
            picker.userInteractionEnabled = false
        }
    }
    
    var audioPlayer = AVAudioPlayer()
    
    func updateLabel(){
        let sizeComponent = PickerComponent.min.rawValue
        let toppingComponent = PickerComponent.sec.rawValue
        minuteSet = pickerData[sizeComponent][picker.selectedRowInComponent(sizeComponent)]
        secondesSet = pickerData[toppingComponent][picker.selectedRowInComponent(toppingComponent)]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locker.setImage(UIImage.animatedImageNamed("lock.png", duration: 0), forState: .Normal)
        picker.selectRow(2, inComponent: PickerComponent.min.rawValue, animated: false)
        setLabel.text = "set : \(set)"
        startTime = NSDate.timeIntervalSinceReferenceDate()
        updateLabel()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        elapsedTime = currentTime - startTime
        
        let minutes = UInt8(elapsedTime/60.0)
        elapsedTime -= (NSTimeInterval(minutes)*60)
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        let fraction = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        displayTime.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        if strMinutes >= minuteSet && strSeconds >= secondesSet{
            let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep Sound", ofType: "mp3")!)
            do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            }
            catch{
                fatalError("Error loading url")
            }
            timer.invalidate()
            let aSelector : Selector = #selector(StopWatchViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            if set == 5{
                set = 0
            }
            else{
                set += 1
            }
            setLabel.text = "set : \(set)"
        }
    }
}
