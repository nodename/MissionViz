//
//  compositeImages.swift
//  FileBrowser
//
//  Created by Alan Shaw on 2/18/20.
//

import Foundation
import UIKit

/**
 Composite two or more images on top of one another to create a single image.
 This function assume all images are same size.

 - Parameters:
 - images: An array of UIImages

 - returns: A compsite image composed of the array of images passed in
 */
func compositeImages(images: [UIImage]) -> UIImage {
    var compositeImage: UIImage!
    if images.count > 0 {
        // Get the size of the first image.  This function assumes all images are same size
        let size: CGSize = CGSize(width: images[0].size.width, height: images[0].size.height)
        UIGraphicsBeginImageContext(size)
        for image in images {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            image.draw(in: rect)
        }
        compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    return compositeImage
}
