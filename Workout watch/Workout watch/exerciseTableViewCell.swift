//
//  exerciseTableViewCell.swift
//  Workout watch
//
//  Created by Antoine Simon on 31/03/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit

class exerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var numberRep: UILabel!
    @IBOutlet weak var stepperRep: UIStepper!

    @IBOutlet weak var LabelSec: UILabel!
    @IBOutlet weak var SliderSec: UISlider!
    
    @IBAction func clicStepperRep(_ sender: AnyObject) {
        numberRep.text = String(Int(stepperRep.value))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func slide(_ sender: Any) {
        self.LabelSec.text = String(Int(self.SliderSec.value))
    }
}
