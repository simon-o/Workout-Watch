//
//  exerciseTableViewController.swift
//  Workout watch
//
//  Created by Antoine Simon on 31/03/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit

class exerciseTableViewController: UITableViewController {
    
    var numberOFExercise:Int = 0
    var day:String = ""
    var dictName: Array = [""]
    var dictSet: Array = [0]
    var dictSec: Array = [0]
    
    var numberOfSet:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fill the dict here
        catchExercise()
        numberOFExercise = dictName.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dictName.count
    }
    
    func setNumberExercise(_ number: Int) {
        if number > numberOFExercise {
            dictName.append("")
            dictSet.append(0)
            dictSec.append(0)
        }
        else{
            dictName.remove(at: number)
            dictSet.remove(at: number)
            dictSec.remove(at: number)
        }
        viewWillDisappear(true)
        numberOFExercise = number
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save data
        
        var i = 0
        let tmp = dictName.count
        
        while i < tmp {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as! exerciseTableViewCell!
            {
                dictName[i] = cell.name.text!
                dictSet[i] = Int(cell.stepperRep.value)
                dictSec[i] = Int(cell.SliderSec.value)
            }
            i += 1
        }
        let defaults = UserDefaults.standard
        print("\(dictName) \(dictSet) \(dictSec) for \(day)Name")
        
        defaults.set(dictName, forKey: "\(day)Name")
        
        defaults.set(dictSet, forKey: "\(day)Set")
        
        defaults.set(dictSec, forKey: "\(day)Sec")
        
        defaults.synchronize()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "exercise"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! exerciseTableViewCell
        
        let row = indexPath.row
        cell.name.text = dictName[row]
        cell.numberRep.text = String(describing: dictSet[row])
        cell.stepperRep.value = Double(dictSet[row] as NSNumber)
        cell.SliderSec.value = Float(dictSec[row] as NSNumber)
        cell.LabelSec.text = String(describing: dictSec[row])
        //do the stepper here
        
        let color1 = UIColor.init(red: 210/255, green: 240/255, blue: 248/255, alpha: 1)
        let color2 = UIColor.init(red: 252/255, green: 227/255, blue: 231/255, alpha: 1)
        
        if (indexPath.row % 2) == 0 {
            cell.backgroundColor = color1
        }
        else{
            cell.backgroundColor = color2
        }
        
        
        return cell
    }
    
    func catchExercise()
    {
        let defaults = UserDefaults.standard
        
        if let tmpName = defaults.object(forKey: "\(day)Name"), let tmp = tmpName as? Array<String> {
            dictName = tmp
        }
        if let tmpSet = defaults.object(forKey: "\(day)Set"), let tmp = tmpSet as? Array<Int>{
            dictSet = tmp
        }
        if let tmpSec = defaults.object(forKey: "\(day)Sec"), let tmp = tmpSec as? Array<Int> {
            dictSec = tmp
        }
    }
}
