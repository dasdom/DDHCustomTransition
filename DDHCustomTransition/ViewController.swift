//
//  ViewController.swift
//  DDHCustomTransition
//
//  Created by dasdom on 21.02.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TransitionInfoProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func viewsToAnimate() -> [UIView] {
        return [imageView, label]
    }
    
    func copyForView(_ subView: UIView) -> UIView {
        if subView == imageView {
            let imageViewCopy = UIImageView(image: imageView.image)
            imageViewCopy.contentMode = imageView.contentMode
            imageViewCopy.clipsToBounds = true
            return imageViewCopy
        } else if subView == label {
            let labelCopy = UILabel()
            labelCopy.text = label.text
            labelCopy.font = label.font
            labelCopy.backgroundColor = view.backgroundColor
            return labelCopy
        }
        return UIView()
    }
}

