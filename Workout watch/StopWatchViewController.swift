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
    @IBOutlet weak var typeofExercise: UILabel!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var locker: UIButton!
    
    var startTime = TimeInterval()
    var timer = Timer()
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
    
    //var closeButton = UIButton.init(type: UIButtonType.System)
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        let i = defaults.double(forKey: "numberSet")
        stringOne = i
        setLabel.text = "set : \(set)/\(i)"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            print("first")
            performSegue(withIdentifier: "tuto", sender: self)
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
        }
        self.navigationItem .setHidesBackButton(true , animated: true)
        
//        //ADS
//        closeButton.frame = CGRectMake(10, 10, 20, 20)
//        closeButton.layer.cornerRadius = 10
//        closeButton.setTitle("x", forState: .Normal)
//        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        closeButton.backgroundColor = UIColor.whiteColor()
//        closeButton.layer.borderColor = UIColor.blackColor().CGColor
//        closeButton.layer.borderWidth = 1
//        closeButton.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchDown)
        
        picker.selectRow(2, inComponent: PickerComponent.min.rawValue, animated: false)
      
        setExercise()
        updateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setExercise()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setExercise()
    {
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "\(Date().dayOfWeek())Name") != nil) {
            dictName = defaults.mutableArrayValue(forKey: "\(Date().dayOfWeek())Name")
            if IndexExercise < dictName.count{
                typeofExercise.text = dictName.object(at: IndexExercise) as? String
            }
            else{
                stop(self)
            }
        }
        if (defaults.object(forKey: "\(Date().dayOfWeek())Set") != nil) {
            dictSet = defaults.mutableArrayValue(forKey: "\(Date().dayOfWeek())Set")
            if IndexExercise < dictSet.count{
                stringOne = dictSet.object(at: IndexExercise) as! Double
                setNumber = Int(stringOne)
                setLabel.text = "set : \(set)/\(setNumber)"
            }
        }
    }
    
    @IBAction func start(_ sender:AnyObject){
        if !timer.isValid && locker.image(for: UIControlState()) == UIImage.animatedImageNamed("lock.png", duration: 0){
            if reset == true{
                //play first or stop
                stopButton.setTitle("Stop", for: UIControlState())
                let aSelector : Selector = #selector(StopWatchViewController.updateTime)
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                reset = false
                if tmp != 0{
                    startTime = startTime + (Date.timeIntervalSinceReferenceDate - tmp)
                }
                else
                {
                    startTime = Date.timeIntervalSinceReferenceDate
                }
            }
            else{
                //play if resume
                let aSelector : Selector = #selector(StopWatchViewController.updateTime)
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                startTime = Date.timeIntervalSinceReferenceDate
            }
        }
    }
    
    @IBAction func stop(_ sender:AnyObject){
         if timer.isValid{
            //stop
            timer.invalidate()
            tmp = Date.timeIntervalSinceReferenceDate
            stopButton.setTitle("Reset", for: UIControlState())
            reset = true
        }
        else{
            //resume
            displayTime.text = "00:00"
            stopButton.setTitle("Stop", for: UIControlState())
            startTime = 0
            set = 0
            IndexExercise = 0
            setExercise()
            reset = false
        }
    }
    
    @IBAction func lock(_ sender:AnyObject){
        if locker.image(for: UIControlState()) == UIImage.animatedImageNamed("lock.png", duration: 0){
            locker.setImage(UIImage.animatedImageNamed("security.png", duration: 0), for: UIControlState())
            picker.isUserInteractionEnabled = true
            picker.isHidden = false
            timer.invalidate()
        }
        else {
            locker.setImage(UIImage.animatedImageNamed("lock.png", duration: 0), for: UIControlState())
            picker.isUserInteractionEnabled = false
            picker.isHidden = true
            //ADS
            //load()
        }
    }
    
    func updateLabel(){
        let sizeComponent = PickerComponent.min.rawValue
        let toppingComponent = PickerComponent.sec.rawValue
        minuteSet = pickerData[sizeComponent][picker.selectedRow(inComponent: sizeComponent)]
        secondesSet = pickerData[toppingComponent][picker.selectedRow(inComponent: toppingComponent)]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        elapsedTime = currentTime - startTime
        
        let minutes = UInt8(elapsedTime/60.0)
        elapsedTime -= (TimeInterval(minutes)*60)
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        //let fraction = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strFraction = String(format: "%02d", fraction)
        
        displayTime.text = "\(strMinutes):\(strSeconds)"
        if strMinutes >= minuteSet && strSeconds >= secondesSet{
            let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Beep Sound", ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
                
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            catch{
                fatalError("Error loading url")
            }
            timer.invalidate()
            let aSelector : Selector = #selector(StopWatchViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
            
            set += 1
            if set >= Int(stringOne!){
                IndexExercise = IndexExercise + 1
                setExercise()
                if timer.isValid{
                    set = 0
                }
            }
            setLabel.text = "set : \(set)/\(setNumber)"
        }
    }
}
