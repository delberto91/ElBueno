//
//  NoticiasTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/14/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class NoticiasTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var subtituloLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
       // imageToShow.image = UIImage(named: "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
