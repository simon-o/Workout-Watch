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
    var day:String!
    var dictName: NSMutableArray = [""]
    var dictSet: NSMutableArray = [0]
    
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dictName.count
    }
    
    func setNumberExercise(number: Int) {
        if number > numberOFExercise {
            dictName.addObject("")
            dictSet.addObject(0)
        }
        else{
            dictName.removeObjectAtIndex(number)
            dictSet.removeObjectAtIndex(number)
        }
        viewWillDisappear(true)
        numberOFExercise = number
        tableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        //save data
 
        var i = 0
        let tmp = dictName.count
        
        while i < tmp {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! exerciseTableViewCell!
            
            if cell != nil{
            dictName.replaceObjectAtIndex(i, withObject: cell.name.text!)
            dictSet.replaceObjectAtIndex(i, withObject: cell.stepperRep.value)
            }
            i += 1
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        print("\(dictName) \(dictSet)")
        
        defaults.setObject(dictName, forKey: "\(day)Name")
        
        defaults.setObject(dictSet, forKey: "\(day)Set")
        
        defaults.synchronize()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "exercise"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! exerciseTableViewCell
        
        let row = indexPath.row
        cell.name.text = dictName[row] as? String
        cell.numberRep.text = String(dictSet[row])
        cell.stepperRep.value = Double(dictSet[row] as! NSNumber)
        //do the stepper here
        
        let color1 = UIColor.init(red: 230/255, green: 240/255, blue: 248/255, alpha: 1)
        let color2 = UIColor.init(red: 242/255, green: 247/255, blue: 251/255, alpha: 1)
        
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
        let defaults = NSUserDefaults.standardUserDefaults()
        
//        if (defaults.objectForKey("\(day)numberSet") != nil){
//            numberOfSet = defaults.integerForKey("\(day)numberSet")
//        }
//        if numberOfSet > 0 {
            if (defaults.objectForKey("\(day)Name") != nil) {
                dictName = defaults.mutableArrayValueForKey("\(day)Name")
            }
            if (defaults.objectForKey("\(day)Set") != nil) {
                dictSet = defaults.mutableArrayValueForKey("\(day)Set")
                //}
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
