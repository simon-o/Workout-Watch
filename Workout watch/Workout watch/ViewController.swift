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

extension Date {
    func dayOfWeek() -> Int! {
        guard
            let cal: Calendar = Calendar.current,
            let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self) else { return nil }
        return comp.weekday
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
        
        let logo = UIImage(named: "noun_314420_cc")
        let imageView = UIImageView(image:logo)
        self.NavBar.titleView = imageView
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
    
    func popUp(view: AnyObject, errrorMessage: String, backToRoot: Bool) -> Void {
        
        let alertController = UIAlertController(title: "StopWatch", message: errrorMessage, preferredStyle: UIAlertControllerStyle.alert)
        if (backToRoot == false){
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
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
                popUp(view: self, errrorMessage: "No previous exercise", backToRoot: false)
            }
        }
        else{
            popUp(view: self, errrorMessage: "Not allowed when timer is running", backToRoot: false)
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
                    popUp(view: self, errrorMessage: "No more exercise for today", backToRoot: false)
                    self.Stop(self)
                    return
                }
                popUp(view: self, errrorMessage: "No next exercise", backToRoot: false)
            }
        }
        else{
            popUp(view: self, errrorMessage: "Not allowed when timer is running", backToRoot: false)
        }
    }
    
    @IBAction func Start(_ sender: Any) {
        //calcul du temp
        if (self.numberSet == self.dictSet[self.ExerciseIndex] && self.ExerciseIndex == self.dictName.count - 1){
            popUp(view: self, errrorMessage: "No more exercise for today", backToRoot: false)
            return
        }
        if (self.dictSet[self.ExerciseIndex] == 0 || self.dictSec[self.ExerciseIndex] == 0){
            popUp(view: self, errrorMessage: "The exercise is empty", backToRoot: false)
            self.next()
            return
        }
        if (WatchRunning == false){
            WatchRunning = true
            
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
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
            popUp(view: self, errrorMessage: "You do not have Spotify on your phone", backToRoot: false)
        }
    }
}

