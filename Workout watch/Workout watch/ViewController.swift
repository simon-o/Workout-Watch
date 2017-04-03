//
//  ViewController.swift
//  MyWatch
//
//  Created by Antoine Simon on 13/02/2017.
//  Copyright © 2017 Antoine Simon. All rights reserved.
//

import UIKit
import UICircularProgressRing
import AVFoundation
import GoogleMobileAds

var global = 0

extension Date {
    func dayOfWeek() -> Int! {
        guard
            let cal: Calendar = Calendar.current,
            let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self) else { return nil }
        return comp.weekday! + global
    }
}

class ViewController: UIViewController, GADBannerViewDelegate {
    
    //var timer: Timer?
    var currentTime = 0
    var numberSet = 0
    var ExerciseIndex = 0
    var ExerciseTime = 0
    var WatchRunning = false
    var audioPlayer = AVAudioPlayer()
    var dictName: Array = [""]
    var dictSet: Array = [0]
    var dictSec: Array = [0]
    var numberSetTab: Array = [0]
    
    var elapsedTime: double_t = 0
    var startTime = TimeInterval()
    var timer = Timer()
    
    @IBOutlet weak var spotifyButton: UIButton!
    @IBOutlet weak var LabelNext: UILabel!
    @IBOutlet weak var LabelTime: UILabel!
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var ButtonStop: UIButton!
    @IBOutlet weak var LabelExercise: UILabel!
    @IBOutlet weak var AdView: GADBannerView!
    
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AdView.adUnitID = "ca-app-pub-4348180862135845/2314946814"
        AdView.rootViewController = self
        AdView.load(GADRequest())
        UIApplication.shared.isIdleTimerDisabled = true
        self.numberSet = self.numberSetTab[self.ExerciseIndex]
        self.displayExerciseName()
        
        let instagramHooks = "spotify://"
        let instagramUrl = NSURL(string: instagramHooks)
        if !UIApplication.shared.canOpenURL(instagramUrl! as URL)
        {
            self.spotifyButton.isHidden = true;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.displayExerciseName()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let day = Date().dayOfWeek()
        {
            if let exoName = defaults.object(forKey: "\(day)Name"), let tmp = exoName as? Array<String>{
                dictName = tmp
            }
            if let exoSet = defaults.object(forKey: "\(day)Set"), let tmp = exoSet as? Array<Int>{
                dictSet = tmp
            }
            if let exoSec = defaults.object(forKey: "\(day)Sec"), let tmp = exoSec as? Array<Int>{
                dictSec = tmp
            }
            displayExerciseName()
        }
        else{
            //message d'erreur
        }
    }
    
    func addDay() -> Void {
        let day = Date().dayOfWeek() - global
        global += 1
        
        if ((day + global) > 7){
            switch day {
            case 1:
                global = 0
            case 2:
                global = -1
            case 3:
                global = -2
            case 4:
                global = -3
            case 5:
                global = -4
            case 6:
                global = -5
            case 7:
                global = -7
            default:
                global = 0
            }
        }
        self.ExerciseIndex = 0
        self.viewWillAppear(false)
    }
    
    func popUp(view: AnyObject, errrorMessage: String, backToRoot: Bool) -> Void {
        
        let alertController = UIAlertController(title: "StopWatch", message: errrorMessage, preferredStyle: UIAlertControllerStyle.alert)
        if (backToRoot == false)
        {
            alertController.message = alertController.message! + " Do you want to see tomorrow exercise ?"
            
            let cancelAction1 = UIAlertAction(title: "No", style: .default) { (action) in
                view.navigationController?!.popToRootViewController(animated: true)
            }
            alertController.addAction(cancelAction1)
            
            let cancelAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                view.navigationController?!.popToRootViewController(animated: true)
                self.addDay()
            }
            alertController.addAction(cancelAction)
            
        }
        else{
            let cancelAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                view.navigationController?!.popToRootViewController(animated: true)
            }
            alertController.addAction(cancelAction)
        }
        view.present(alertController, animated: true, completion: nil)
    }
    
    func displayExerciseName() -> Void {
        if (dictName.count != 0){
            LabelExercise.text = "Exercise: \(dictName[self.ExerciseIndex]) \(self.numberSet)/\(self.dictSet[self.ExerciseIndex])\n"
            self.progressRing.maxValue = CGFloat(dictSec[self.ExerciseIndex])
            if (dictName.count > self.ExerciseIndex + 1){
                self.LabelNext.text = "Next: \(self.dictName[self.ExerciseIndex + 1])"
            }
            else{
                self.LabelNext.text = "Next:"
            }
        }
        else{
            LabelExercise.text = "Exercise: None Today"
            dictSec.append(0)
            dictSet.append(0)
        }
    }
    
    func previous() -> Void {
        //Pour retourner a l'exo precedent
        if (!timer.isValid){
            if (self.ExerciseIndex > 0){
                self.numberSetTab[self.ExerciseIndex] = numberSet
                self.ExerciseIndex = self.ExerciseIndex - 1
                self.numberSet = self.numberSetTab[self.ExerciseIndex]
                self.displayExerciseName()
                self.Stop(self)
            }else{
                popUp(view: self, errrorMessage: "No previous exercise.", backToRoot: true)
            }
        }
        else{
            popUp(view: self, errrorMessage: "Not allowed when timer is running.", backToRoot: true)
        }
    }
    
    func next() -> Void {
        //Pour aller a l'exo suivant
        if (!timer.isValid){
            if (self.ExerciseIndex < dictName.count - 1){
                self.numberSetTab[self.ExerciseIndex] = numberSet
                self.ExerciseIndex += 1
                if (self.numberSetTab.count - 1 < self.ExerciseIndex){
                    self.numberSetTab.append(0)
                }
                self.numberSet = self.numberSetTab[self.ExerciseIndex]
                self.displayExerciseName()
                self.Stop(self)
            }
            else{
                if (self.numberSet == self.dictSet[self.ExerciseIndex] && self.ExerciseIndex == self.dictName.count - 1){
                    popUp(view: self, errrorMessage: "No more exercise for today.", backToRoot: true)
                    self.Stop(self)
                    return
                }
                popUp(view: self, errrorMessage: "No next exercise.", backToRoot: false)
            }
        }
        else{
            popUp(view: self, errrorMessage: "Not allowed when timer is running.", backToRoot: true)
        }
    }
    
    @IBAction func Start(_ sender: Any) {
        //calcul du temp
        if (self.numberSet == self.dictSet[self.ExerciseIndex] && self.ExerciseIndex == self.dictName.count - 1){
            popUp(view: self, errrorMessage: "No more exercise for today.", backToRoot: true)
            return
        }
        if (self.dictSet[self.ExerciseIndex] == 0 || self.dictSec[self.ExerciseIndex] == 0){
            popUp(view: self, errrorMessage: "The exercise is empty.", backToRoot: false)
            self.next()
            return
        }
        if (WatchRunning == false){
            WatchRunning = true
            
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func updateTime() -> Void {
        let currentTime = Date.timeIntervalSinceReferenceDate
        elapsedTime = currentTime - startTime
        let minutes = UInt8(elapsedTime/60.0)
        elapsedTime -= (TimeInterval(minutes)*60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        self.LabelTime.text = "\(strMinutes):\(strSeconds)"
        let tmp = currentTime - startTime
        
        self.progressRing.setProgress(value: CGFloat(tmp), animationDuration: 0.05) {
        }
        
        //si le temps match avec celui de l'exo
        if (self.dictSec[self.ExerciseIndex] < Int(tmp)){
            self.numberSet += 1
            let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Beep Sound", ofType: "mp3")!)
            do{
                self.audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            }
            catch{
                fatalError("Error loading url")
            }
            if (self.numberSet < self.dictSet[self.ExerciseIndex] ){
                self.Stop(self)
            }
            else{
                timer.invalidate()
                self.next()
            }
        }
    }
    
    @IBAction func Stop(_ sender: Any) {
        //si l'user stop
        timer.invalidate()
        self.LabelTime.text = "00:00"
        WatchRunning = false
        self.progressRing.value = 0
        self.currentTime = 0
        self.displayExerciseName()
    }
    
    @IBAction func NextClick(_ sender: Any) {
        self.next()
    }
    @IBAction func PreviousClick(_ sender: Any) {
        self.previous()
    }
    @IBAction func OpenMusic(_ sender: Any) {
        let instagramHooks = "spotify://"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL)
        {
            UIApplication.shared.open(instagramUrl as! URL, options: [:], completionHandler: nil)
        }
        else{
            popUp(view: self, errrorMessage: "You do not have Spotify on your phone.", backToRoot: false)
        }
    }
}

