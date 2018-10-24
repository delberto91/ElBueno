//
//  RecetasViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/25/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class RecetasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
private let cell = "RecetasTableViewCell"
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true 
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Recetas", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

    
        APIManager.sharedInstance.getRecipies(id:0 ,onSuccess: { response in
            
            DispatchQueue.main.async {
                //self.showDiet(response: response)
                self.localRecetas = response.data
                
                self.tableView.reloadData()
                
            }
        })
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedReceta = Receta()
        
    }
    var localRecetas : [Receta] = [Receta]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  localRecetas.count
        
    }
    var selectedReceta : Receta = Receta()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! RecetasTableViewCell
        //cel.imageToShow.downloadImage(downloadURL: noticiaImagenString[indexPath.row], completion: { result in
            
       // })
        /*
 
 
         @IBOutlet weak var nombreReceta: UILabel!
         @IBOutlet weak var imagenReceta: UIImageView!
         @IBOutlet weak var descripcionReceta: UITextView!
 */
        cel.nombreReceta.text = self.localRecetas[indexPath.row].nombre
        cel.descripcionReceta.text = self.localRecetas[indexPath.row].descripcion
        cel.imagenReceta.downloadImage(downloadURL: self.localRecetas[indexPath.row].foto, completion: { result in
            
        })
        return cel
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleRecetaViewController") as? DetalleRecetaViewController*/
        
        self.selectedReceta = self.localRecetas[indexPath.row]
        //self.navigationController?.pushViewController(vc!, animated: true)
        self.performSegue(withIdentifier: "recetaToDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DetalleRecetaViewController {
            
                viewController.selectedReceta = self.selectedReceta
           
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 442.0
    }
 
}
