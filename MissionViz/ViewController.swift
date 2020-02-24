//
//  ViewController.swift
//  MissionViz
//
//  Created by Alan Shaw on 2/17/20.
//  Copyright © 2020 Alan Shaw. All rights reserved.
//

import UIKit
import FileBrowser

class ViewController: UIViewController {
    private var overlays = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeOverlays()
    }
    
    private func makeOverlays() {
        let url = Bundle.main.resourceURL!
        let path = Bundle.main.resourcePath!
        let items = try! FileManager.default.contentsOfDirectory(atPath: path)
        let imageFiles = items.filter { $0.hasPrefix("img") }
        let jsonFiles = imageFiles.filter { $0.hasSuffix("json") }
        for jsonFile in jsonFiles {
            do {
                let overlay = try createOverlay(url.appendingPathComponent(jsonFile))
                overlays[stripFileExtension(jsonFile)] = overlay
            } catch {
                print("Error decoding JSON File: \(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showFileBrowser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FileBrowser
    
    func showFileBrowser() {
        let url = Bundle.main.resourceURL!
        let fileBrowser = FileBrowser(initialPath: url,
                                      allowEditing: false,
                                      showCancelButton: true)
        fileBrowser.filter = { $0.hasPrefix("img") && $0.hasSuffix("jpg") }
        fileBrowser.previewFile = { fbFile in
            let imgViewController = ImageViewController()
            guard let image = UIImage.init(named: fbFile.displayName,
                                           in: Bundle.main,
                                           compatibleWith: nil),
                let overlay = self.overlays[stripFileExtension(fbFile.displayName)]
                else { return imgViewController }
            imgViewController.image = compositeImages(images: [image, overlay])
            return imgViewController
        }
        present(fileBrowser, animated: true, completion: nil)
    }
}

