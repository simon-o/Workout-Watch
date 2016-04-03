//
//  settingViewController.swift
//  Workout watch
//
//  Created by Antoine Simon on 30/03/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit

class settingViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelSet: UILabel!
    
    @IBAction func slideAction(sender: UISlider) {
        var selectedValue = Double(sender.value)
        selectedValue = round(selectedValue * 10) * 1
        
        labelSet.text = String(stringInterpolationSegment: selectedValue)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(selectedValue, forKey: "numberSet")
       defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.doubleForKey("numberSet").isNormal == true{
            slider.value = float_t(defaults.doubleForKey("numberSet")) / 10
            labelSet.text = String(stringInterpolationSegment: slider.value)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
