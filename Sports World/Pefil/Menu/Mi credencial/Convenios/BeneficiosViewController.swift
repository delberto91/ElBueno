//
//  BeneficiosViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/5/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class BeneficiosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var arrayOfImages = APIManager.sharedInstance.logotipoConvenio
    var arrayOfNames = APIManager.sharedInstance.nombreConvenio
    var arrayOfClausulas = APIManager.sharedInstance.clausulasConvenio
    var newArrayImages = [UIImage]()
    var imageVi = UIImageView()

    private let cell = "ConveniosTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Beneficios", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! ConveniosTableViewCell
        
        cel.labelDescription.addBottomBorderWithColor(cel.labelDescription, color: UIColor.white, width: 0.5)
        cel.labelDescription.text = arrayOfNames[indexPath.row]
        cel.imageToShow.downloadImage(downloadURL: self.arrayOfImages[indexPath.row], completion: { result in
            
        })
             return cel
            //newArrayImages.append(imageVi)

        }
         //cel.imageToShow.image = newArrayImages[indexPath.row]
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 282
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailConveniosViewController") as? DetailConveniosViewController
        vc?.descripcionClausula = arrayOfClausulas[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   

}
