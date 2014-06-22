//
//  ViewController.swift
//  001
//
//  Created by songjiayang on 6/22/14.
//  Copyright (c) 2014 swift 101. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var textField : UITextField
    @IBOutlet var welcomeLabel : UILabel
    @IBAction func onGoEvent(sender : AnyObject) {
      var name:String = textField.text
      welcomeLabel.text = "Hello \(name), Welcome to Swift!"
    }
    override func viewDidLoad() {
      super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }


}

