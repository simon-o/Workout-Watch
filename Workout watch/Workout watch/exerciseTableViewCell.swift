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
    @IBOutlet weak var clickStepperRep: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
