//
//  ViewController.swift
//  Example
//
//  Created by Mew on 2018/4/23.
//  Copyright © 2018年 Littocats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    let label = UILabel()
    label.text = "Example"
    label.textColor = UIColor.black
    label.backgroundColor = UIColor.purple
    self.view.addSubview(label)

    label.pet.top == self.view.pet.top + 128
    label.pet.left == self.view.pet.left + 13
    label.pet.right <= self.view.pet.right - 13
    label.pet.height == self.view.pet.height * 0.5
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

