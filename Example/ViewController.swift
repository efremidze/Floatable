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
        switch arc4random_uniform(2) {
        case 0:
            let label = UILabel()
            label.text = "+10pts"
            label.textColor = .red
            label.font = .boldSystemFont(ofSize: 17)
            label.layer.shadowOffset = CGSize(width: 0, height: 1)
            label.layer.shadowRadius = 0.1
            label.layer.shadowOpacity = 0.1
            button.animate(customView: label)
        default:
            let imageView = UIImageView(image: UIImage(named: "heart"))
            imageView.tintColor = .red
            imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
            imageView.layer.shadowRadius = 0.1
            imageView.layer.shadowOpacity = 0.1
            button.animate(customView: imageView)
        }
    }
    
}
