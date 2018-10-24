//
//  CargosPendietesTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 5/16/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
class CustomButton: UIButton {
    var indexPath: NSIndexPath!
}

class CargosPendietesTableViewCell: UITableViewCell {

    @IBOutlet weak var selectButton: CustomButton! {
        didSet {
            selectButton.addTarget(self, action: #selector(self.selectButtonWasPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var backgrdndView: UIView!
    @IBOutlet weak var amountCharge: UILabel!
    @IBOutlet weak var descriptionCharge: UILabel!
    @IBOutlet weak var titleCharge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgrdndView.layer.cornerRadius = 10
    }

    var selectButtonWasPressed: ( (Bool) -> Void )?
    
    @objc
    private func selectButtonWasPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectButtonWasPressed?(sender.isSelected)
        isCellTouched = true
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

    
   
   
}

