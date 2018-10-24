//
//  ClasesTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 4/30/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ClasesTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func getDescription(_ sender: Any) {
        APIManager.sharedInstance.getClassDescription(idClass: self.tag , onSuccess: { result in
            
            DispatchQueue.main .async {
                
                
                if(result.status == true){
                    APIManager.sharedInstance.mainClassViewController.selectedTag = self.tag
                    APIManager.sharedInstance.mainClassViewController.htmlString = result.data.descripcionHTML
                    APIManager.sharedInstance.mainClassViewController.performSegue(withIdentifier: "showWebView", sender: nil)
                    /*let webViewController = SVModalWebViewController(address: "http://google.com")
                    webViewController.
                    APIManager.sharedInstance.presentViewController(webVC, animated: true, completion: nil)*/
                }else{
                    Alert.ShowAlert(title: "Reservación", message: result.message, titleForTheAction: "Aceptar", in: APIManager.sharedInstance.mainClassViewController)
                }
                
                
            }
        }, onFailure: { error in
            
        })
    }
    
}
