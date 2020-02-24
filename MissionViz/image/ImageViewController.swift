//
//  ImageViewController.swift
//  
//
//  Created by Alan Shaw on 2/19/20.
//

import Foundation
import UIKit

final class ImageViewController: UIViewController {
    
    var image: UIImage? = nil
    
    override func loadView() {
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        view = imageView
    }
}
