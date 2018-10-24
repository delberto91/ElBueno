//
//  ClaseCategoriasTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/2/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

protocol OtherController : NSObjectProtocol {
    func loadNewScreen(controller: UIViewController) -> Void;
}
var descriptionHtml: String = ""

class ClaseCategoriasTableViewCell: UITableViewCell {
   
    weak var delegate: OtherController?


    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var entrenadorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        activity.isHidden = true
    }

    @IBAction func showClaseDetail(_ sender: Any) {
      self.activity.isHidden = false
       self.activity.startAnimating()
        APIManager.sharedInstance.getClassDescription(idClass: finalIdForCategorias! , onSuccess: { result in
            
            DispatchQueue.main .async {
             
                print("este es el id que se va",  finalIdForCategorias!)
               
                if result.status == true {
                  descriptionHtml =  result.data.descripcionHTML
                     var vc = ClaseCategoriasDetailViewController()
                    if((self.delegate?.responds(to: Selector(("loadNewScreen:")))) != nil)
                    {
                        
                        self.delegate?.loadNewScreen(controller: vc)
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                    }
                
                } else {
                    Alert.ShowAlert(title: "", message: result.message, titleForTheAction: "Aceptar", in: ClaseCategoriasViewController())
                }
            
            }
        }, onFailure: { error in
            
        })
    }
    }
    
    

