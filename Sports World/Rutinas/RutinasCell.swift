//
//  RutinasCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 4/19/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class RutinasCell: UITableViewCell {

    //Conecta los outlets
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var repetitionsLabel: UILabel!
    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var checkButton: UIButton!
    //var parent : RutinasViewController = RutinasViewController()
     var rutinas : Rutina = Rutina()
    var entranamiento : Entrenamiento = Entrenamiento()
    
    var isSelectedCell : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activity.isHidden = true 
        self.checkButton.layer.cornerRadius = 15
        self.checkButton.layer.borderWidth = 1
        self.checkButton.layer.borderColor = UIColor.white.cgColor
        activity.isHidden = true
        if self.entranamiento.completado == true {
            self.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.backgroundColor = UIColor.black

        }
        func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return videoView
        }
     
    }

    
    var isCheckboxEnabled: ( (Bool) -> Void )?
    
    @IBAction func changeButton(_ sender: Any) {
        
        // Bool parameter is not used
            isCheckboxEnabled?(true)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
