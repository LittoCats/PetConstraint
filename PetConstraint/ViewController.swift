//
//  ViewController.swift
//  PetConstraint
//
//  Created by 程巍巍 on 6/26/15.
//  Copyright © 2015 Littocats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let button = UIButton(type: .System)
        button.setTitle("TEST", forState: .Normal)
        self.view.addSubview(button)
        
        button.backgroundColor = UIColor.purpleColor()
        
        button.CenterX*2-100==self.view.CenterX*1.5-44
        button.CenterY==self.view.CenterY*0.5+100
        
        button.Width==100
        button.Height==66.5
    }
}

