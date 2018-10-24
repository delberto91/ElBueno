//
//  DetalleFacturaViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 7/6/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class DetalleFacturaViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var descripcionFactura = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.barTintColor = .gray
       // navigationController?.navigationBar.tintColor = .gray
     // self.automaticallyAdjustsScrollViewInsets = false
        
         let url = URL (string: descripcionFactura)
         let requestObj = URLRequest(url: url!)
         webView.loadRequest(requestObj)

        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Detalle Factura", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        }
    
 @objc  func savePdf() {
  
        
    //The URL to Save
    let yourURL = NSURL(string: descripcionFactura)
    //Create a URL request
    let urlRequest = NSURLRequest(url: yourURL! as URL)
    //get the data
   
    do {
    let  theData = try  NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: nil)
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
        
        docURL = docURL?.appendingPathComponent("sportsWorldFactura") as NSURL?
        
        try theData.write(to: docURL! as URL)
        //theData.writeToURL(docURL!, atomically: true)
    } catch {
        
    }
    //Get the local docs directory and append your local filename.
    
    
    }
   
}
