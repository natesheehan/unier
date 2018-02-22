//
//  onboardingViewController.swift
//  unier
//
//  Created by Nathanael Sheehan on 08/02/2018.
//  Copyright © 2018 Nathanael Sheehan. All rights reserved.
//

import Foundation
import UIKit
class onboardingViewController: UIViewController{
    
    @IBOutlet weak var courseTextBox1: UITextField!
    @IBOutlet weak var courseTextBox2: UITextField!
    @IBOutlet weak var courseTextBox3: UITextField!
    @IBOutlet weak var courseTextBox4: UITextField!
   
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var distance: UILabel!
    
    @IBAction func distanceSlider(_ sender: Any) {
        let currentValue = Int(slider.value)
        distance.text = "\(currentValue) Km"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "UNIER.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let viewController = segue.destination as! ViewController
        
        // set a variable in the second view controller with the String to pass
        viewController.receivedString = nameLabel.text!
    }
}

