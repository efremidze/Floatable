//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 1/10/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit
import Floatable

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(_ button: UIButton) {
        button.animate(UIImage(named: "heart"), direction: .top)
    }
    
}
