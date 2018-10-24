//
//  ClaseCategoriasDetailViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/3/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ClaseCategoriasDetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
     var htmlString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
     webView.delegate = self
        
        self.webView.contentMode = UIViewContentMode.scaleAspectFit
        
     self.webView.loadHTMLString(self.htmlString, baseURL: nil)
        print("htmlStringlllllll", htmlString)
    }
 
    
}
