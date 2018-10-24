//
//  NutricionCalendarTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/25/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class NutricionCalendarTableViewCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    
    @IBOutlet weak var dietaDescripcion: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       dietaDescripcion.layer.cornerRadius = 8
        dietaDescripcion.delegate = self 
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        dietaDescripcion.endEditing(true)
        
    }

}
