//
//  ImageData.swift
//  MissionViz
//
//  Created by Alan Shaw on 2/16/20.
//  Copyright © 2020 Alan Shaw. All rights reserved.
//

import Foundation
import CoreGraphics


enum BarCode {
    case code(String)
    case unreadable
}

extension BarCode {
    public init(code: String) {
        if code == "NA" {
            self = .unreadable
        } else {
            self = .code(code)
        }
    }
}

enum ObjectType {
    case box
    case barcode(BarCode)
}

struct ObjectData: Decodable {
    var objectType: ObjectType
    var confidence: Double
    var imgSize: CGSize
    var boundingBox: CGRect
}

extension ObjectData {
    enum ParseError: Error {
        case missingBarCode(String)
        case extraBarCode(String)
    }
    
    enum CodingKeys: String, CodingKey {
        // specify keys to be found in JSON
        case className
        case confidence = "score"
        case imgSize
        case boundingBox = "rect"
        case code
    }
    
    // in an extension so that we’ll still get the default memberwise initializer
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let confidence = try values.decode(Double.self, forKey: .confidence)
        let imgSize = try values.decode(CGSize.self, forKey: .imgSize)
        let boundingBox = try values.decode(CGRect.self, forKey: .boundingBox)
        let objectType: ObjectType
        let className = try values.decode(String.self, forKey: .className)
        if let code = try? values.decodeIfPresent(String.self, forKey: .code) {
            let barCode = BarCode.init(code: code)
            if className == "barcode" {
                objectType = .barcode(barCode)
            } else {
                throw ParseError.extraBarCode("\(dump(values))")
            }
        } else {
            if className == "barcode" {
                throw ParseError.missingBarCode("\(dump(values))")
            } else {
                objectType = .box
            }
        }
        self.init(objectType: objectType, confidence: confidence, imgSize: imgSize, boundingBox: boundingBox)
    }
}
