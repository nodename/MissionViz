//
//  stripFileExtension.swift
//  
//
//  Created by Alan Shaw on 2/19/20.
//

import Foundation

func stripFileExtension(_ filename: String) -> String {
    var components = filename.components(separatedBy: ".")
    guard components.count > 1 else { return filename }
    components.removeLast()
    return components.joined(separator: ".")
}
