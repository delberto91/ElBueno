//
//  ChatsCell.swift
//  AppfterSwift
//
//  Created by Glauco Valdes on 3/4/18.
//  Copyright © 2018 Glauco Valdes. All rights reserved.
//

import UIKit

class ChatsCell: UITableViewCell {

    @IBOutlet weak var ChatImage: UIImageView!
    @IBOutlet weak var PreviewMessage: UILabel!
    @IBOutlet weak var ChatTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var DateMessage: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
