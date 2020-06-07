//
//  ViewController.swift
//  iOS-Triangles
//
//  Created by Glenn Cole on 6/6/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var triangleView: TriangleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleReveal(_ sender: UIButton) {
        
        triangleView.toggleReveal()
        triangleView.setNeedsDisplay()
    }
    
    override func viewWillTransition( to size: CGSize,
                                      with coordinator: UIViewControllerTransitionCoordinator) {
        
        // if they rotate the display, redraw the view
        triangleView.setNeedsDisplay()
    }
}

