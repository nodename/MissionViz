//
//  ImageData.swift
//  MissionViz
//
//  Created by Alan Shaw on 2/16/20.
//  Copyright © 2020 Alan Shaw. All rights reserved.
//

import Foundation
import CoreGraphics


enum BarCode: Decodable {
    case code(String)
    case unreadable
}

extension BarCode {
    enum CodingKeys: String, CodingKey {
        case code
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let code = try values.decode(String.self, forKey: .code)
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

struct ImageData: Decodable {
    var objectType: ObjectType
    var confidence: Double
    var imgSize: CGSize
    var boundingBox: CGRect
}

extension ImageData {
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
        if let code = try? values.decodeIfPresent(BarCode.self, forKey: .code) {
            if className == "barcode" {
                objectType = .barcode(code)
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
