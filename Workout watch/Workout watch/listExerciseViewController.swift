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
    var day:String?
    
    
    @IBAction func clickStepper(_ sender: AnyObject) {
        if stepper.value > 15
        {
            stepper.value = 15
        }
        else
        {
            containerViewController?.setNumberExercise(Int(stepper.value))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tmp = containerViewController?.dictName.count
        stepper.value = double_t(tmp!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            containerViewController = segue.destination as? exerciseTableViewController
            containerViewController?.day = day!
        }
    }
 
}
