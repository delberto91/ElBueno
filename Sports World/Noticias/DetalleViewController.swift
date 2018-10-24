//
//  DetalleViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 3/15/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
class DetalleViewController: UIViewController, UITextViewDelegate {

    //@IBOutlet weak var tituloNoticiaLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var subtituloLabel: UILabel!
    @IBOutlet weak var descripcionNoticia: UITextView!
    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var backView: UIView!
    
  
    
   var tituloFinal = ""
   var subtituloFinal = ""
   var descripcionNoti = ""
    var imagenNoticia = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        descripcionNoticia.delegate = self 
        roundedView.layer.cornerRadius = 8
       // tituloNoticiaLabel.text = tituloFinal
        descripcionNoticia.text = descripcionNoti
        subtituloLabel.text = subtituloFinal
        imageToShow.downloadImage(downloadURL: imagenNoticia, completion: { result in
            
        })
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 18)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string:tituloFinal, attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        backView.layer.cornerRadius = 10
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descripcionNoticia.setContentOffset(CGPoint.zero, animated: false)
    }
    @IBAction func shareContent(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems: [descripcionNoticia.text, URL.init(string:  imagenNoticia)!], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(viewController, animated: true, completion: nil)
    }
    
}
