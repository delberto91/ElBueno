//
//  SegurosViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/5/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class SegurosViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var myTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Coberturas", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

         myTextField.delegate = self

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTextField.setContentOffset(CGPoint.zero, animated: false)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboard()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
}
