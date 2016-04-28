//
//  TutoViewController.swift
//  Workout watch
//
//  Created by Antoine Simon on 27/04/2016.
//  Copyright © 2016 Antoine Simon. All rights reserved.
//

import UIKit

class TutoViewController: UIViewController {

    @IBOutlet weak var ImageViewFortuto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem .setHidesBackButton(true , animated: true)
    }
    
    func handleTap(sender : UIView) {
        
        if ImageViewFortuto.image == UIImage(named: "1"){
            ImageViewFortuto.image = UIImage(named: "2")
        }
        else if ImageViewFortuto.image == UIImage(named: "2"){
            ImageViewFortuto.image = UIImage(named: "3")
        }
        else if ImageViewFortuto.image == UIImage(named: "3"){
            ImageViewFortuto.image = UIImage(named: "4")
        }
        else if ImageViewFortuto.image == UIImage(named: "4"){
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
