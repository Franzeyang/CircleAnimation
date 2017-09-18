//
//  ViewController.swift
//  CircleAnimation
//
//  Created by franze on 2017/9/17.
//  Copyright © 2017年 franze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cirle = Circle(frame: CGRect(x: 150, y: 200, width: 30, height: 30))
        cirle.initialize(color: .red)
        view.addSubview(cirle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

