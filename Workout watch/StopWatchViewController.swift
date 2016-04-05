//
//  StopWatchViewController.swift
//  Workout watch
//
//  Created by Antoine Simon on 29/03/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit
import AVFoundation

extension NSDate {
    func dayOfWeek() -> Int! {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) else { return nil }
        return comp.weekday
    }
}

class StopWatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var displayTime: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var typeofExercise: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var locker: UIButton!
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var minuteSet = "0"
    var secondesSet = "30"
    var reset = true
    var elapsedTime: double_t = 0
    var tmp: double_t = 0
    var stringOne:Double!
    var setNumber:Int!
    var IndexExercise = 0
    var dictName: NSMutableArray = [""]
    var dictSet: NSMutableArray = [0]
    
    let pickerData = [
        ["00","01","02","03","04"],
        ["00", "01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    ]
    
    enum PickerComponent:Int{
        case min = 0
        case sec = 1
    }
    
    var set = 0
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let i = defaults.doubleForKey("numberSet")
        stringOne = i
        setLabel.text = "set : \(set)/\(i)"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locker.setImage(UIImage.animatedImageNamed("lock.png", duration: 0), forState: .Normal)
        picker.selectRow(2, inComponent: PickerComponent.min.rawValue, animated: false)
        
        //setLabel.text = "set : \(set)/5"
        
        setExercise()
        updateLabel()
    }
    
    override func viewDidAppear(animated: Bool) {
        setExercise()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setExercise()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey("\(NSDate().dayOfWeek())Name") != nil) {
            dictName = defaults.mutableArrayValueForKey("\(NSDate().dayOfWeek())Name")
            if IndexExercise < dictName.count{
                typeofExercise.text = dictName.objectAtIndex(IndexExercise) as? String
            }
            else{
                stop(self)
            }
        }
        if (defaults.objectForKey("\(NSDate().dayOfWeek())Set") != nil) {
            dictSet = defaults.mutableArrayValueForKey("\(NSDate().dayOfWeek())Set")
            if IndexExercise < dictSet.count{
                stringOne = dictSet.objectAtIndex(IndexExercise) as! Double
                setNumber = Int(stringOne)
                setLabel.text = "set : \(set)/\(setNumber)"
            }
        }
    }
    
    @IBAction func start(sender:AnyObject){
        if !timer.valid && locker.imageForState(.Normal) == UIImage.animatedImageNamed("lock.png", duration: 0){
            if reset == true{
                //play first or stop
                stopButton.setTitle("Stop", forState: .Normal)
                let aSelector : Selector = #selector(StopWatchViewController.updateTime)
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                reset = false
                if tmp != 0{
                    startTime = startTime + (NSDate.timeIntervalSinceReferenceDate() - tmp)
                }
                else
                {
                    startTime = NSDate.timeIntervalSinceReferenceDate()
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
            set = 0
            IndexExercise = 0
            setExercise()
            reset = false
        }
    }
    
    @IBAction func lock(sender:AnyObject){
        if locker.imageForState(.Normal) == UIImage.animatedImageNamed("lock.png", duration: 0){
            locker.setImage(UIImage.animatedImageNamed("security.png", duration: 0), forState: .Normal)
            picker.userInteractionEnabled = true
            picker.hidden = false
            timer.invalidate()
        }
        else {
            locker.setImage(UIImage.animatedImageNamed("lock.png", duration: 0), forState: .Normal)
            picker.userInteractionEnabled = false
            picker.hidden = true
        }
    }
    
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
            
            set += 1
            if set >= Int(stringOne!){
                IndexExercise = IndexExercise + 1
                setExercise()
                if timer.valid{
                    set = 0
                }
            }
            setLabel.text = "set : \(set)/\(setNumber)"
        }
    }
}
