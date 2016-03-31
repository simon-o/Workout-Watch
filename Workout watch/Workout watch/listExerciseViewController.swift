//
//  listExerciseViewController.swift
//  Workout watch
//
//  Created by Antoine Simon on 31/03/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit


class listExerciseViewController: UIViewController {

    @IBOutlet var stepper: UIStepper!
    @IBOutlet var containerView: UIView!
    var containerViewController: exerciseTableViewController?
    // segue "embed"
    
    @IBAction func clickStepper(sender: AnyObject) {
        containerViewController?.setNumberExercise(Int(stepper.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embed" {
            containerViewController = segue.destinationViewController as? exerciseTableViewController
        }
    }
 
}