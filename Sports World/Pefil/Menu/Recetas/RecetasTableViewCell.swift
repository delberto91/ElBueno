//
//  RecetasTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/25/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class RecetasTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var nombreReceta: UILabel!
    @IBOutlet weak var imagenReceta: UIImageView!
    @IBOutlet weak var descripcionReceta: UITextView!
    
    @IBOutlet weak var bckgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
      
        bckgView.layer.cornerRadius = 8
        descripcionReceta.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        descripcionReceta.endEditing(true)
        
    }
    

}
