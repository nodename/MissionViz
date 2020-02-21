//
//  readJSONFile.swift
//  MissionViz
//
//  Created by Alan Shaw on 2/16/20.
//  Copyright © 2020 Alan Shaw. All rights reserved.
//

import Foundation
import UIKit

/*
let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
let image = renderer.image { context in
    // draw your image into your view
    context.cgContext.draw(UIImage(named: "myImage")!.cgImage!, in: view.frame)
    // draw even more...
    context.cgContext.setFillColor(UIColor.red.cgColor)
    context.cgContext.setStrokeColor(UIColor.black.cgColor)
    context.cgContext.setLineWidth(10)
    context.cgContext.addRect(view.frame)
    context.cgContext.drawPath(using: .fillStroke)
}
 */

fileprivate
func makeOverlayRect(_ object: ObjectData) -> CGRect {
    let w = object.imgSize.width
    let x = object.boundingBox.origin.x * w
    let width = object.boundingBox.size.width * w
    
    let h = object.imgSize.height
    let y = object.boundingBox.origin.y * h
    let height = object.boundingBox.size.height * h
    return CGRect(x: x, y: y, width: width, height: height)
}

fileprivate
func draw(object: ObjectData, in cgContext: CGContext) {
    let rect = makeOverlayRect(object)
    
    switch  object.objectType {
    case .box:
        //cgContext.setStrokeColor(UIColor.magenta.cgColor)
        //cgContext.stroke(rect, width: 2)
        UIColor.magenta.setStroke()
        cgContext.stroke(rect)
    case .barcode(let barCode):
        cgContext.setStrokeColor(UIColor.yellow.cgColor)
        cgContext.stroke(rect, width: 2)
        /*
        switch barCode {
        case .unreadable:
            print("unreadable")
        case .code(let code):
            print(code)
        }
 */
    }
}

fileprivate
func createOverlay(_ objects: [ObjectData]) -> UIImage {
    let size = objects[0].imgSize
    let renderer = UIGraphicsImageRenderer(size: size)
    let overlay = renderer.image { context in
        for object in objects {
            draw(object: object, in: context.cgContext)
        }
    }
    return overlay
}

func createOverlay(_ fileURL: URL) throws -> UIImage {
    let data = try Data(contentsOf: fileURL)
    let objects: [ObjectData] = try JSONDecoder().decode([ObjectData].self, from: data)
    return createOverlay(objects)
}
