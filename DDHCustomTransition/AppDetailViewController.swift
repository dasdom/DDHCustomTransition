//
//  AppDetailViewController.swift
//  DDHCustomTransition
//
//  Created by dasdom on 24.02.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController, TransitionInfoProtocol {

    var appData: [String:String]?
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageName = appData?[imageKey], let name = appData?[nameKey] {
            iconImageView.image = UIImage(named: imageName)
            appNameLabel.text = name
        }
        
    }
    
    func viewsToAnimate() -> [UIView] {
        return [iconImageView, appNameLabel]
    }
    
    func copyForView(_ subView: UIView) -> UIView {
        if subView == iconImageView {
            return UIImageView(image: iconImageView.image)
        } else {
            let label = UILabel()
            label.text = appNameLabel.text
            return label
        }
    }

}
