//
//  NoticiasTViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/14/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
class NoticiasTViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    //var noticiasArray = APIManager.sharedInstance.noticaResumen
    var tituloNoticias = APIManager.sharedInstance.tituloArray.removeDuplicates()
    var descripcionNoticias = APIManager.sharedInstance.descripcionArray.removeDuplicates()
    var subtitulo  = APIManager.sharedInstance.subtitulo.removeDuplicates()
    var noticiaImagenString = APIManager.sharedInstance.imagenNoticia.removeDuplicates()
    var noticiaImagen: [UIImage?] = []
    private let cell = "NoticiasTableViewCell"
    

    @IBOutlet weak var tabView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        activity.isHidden = true 
        self.tabView.delegate = self
        self.tabView.dataSource = self
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Noticias", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_perfil"), style: .done, target: self, action: #selector(NoticiasTViewController.clickMenuButton))
        
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
       /* let images = noticiaImagenString.compactMap{ link->UIImage? in
            guard let url = URL(string: link) else {return nil}
            guard let imageData = try? Data(contentsOf: url) else {return nil}
            var finalImage = UIImage(data: imageData)
            noticiaImagen.append(finalImage!)
            
            return UIImage(data: imageData)
    }*/
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTheNews()

    }

    func getTheNews(){
        
        APIManager.sharedInstance.getNews(onSuccess: { json in
            if(json == JSON.null) {
                Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
            } else {
            DispatchQueue.main.async {
                self.activity.isHidden = false
                self.activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                if APIManager.sharedInstance.status == true {
                    self.tabView.reloadData()
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                    print("Success Request GetCharges")
                } else {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                
            }
            }
            
        }, onFailure: { error in
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tituloNoticias.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! NoticiasTableViewCell
        
      
        cel.tituloLabel.text = tituloNoticias[indexPath.row]
        cel.subtituloLabel.text = subtitulo[indexPath.row]
        cel.imageToShow.downloadImage(downloadURL: noticiaImagenString[indexPath.row], completion: { result in
            
        })
        //cel.imageToShow.image = noticiaImagen[indexPath.row]
        
        cel.backView.layer.cornerRadius = 10
        
        return cel
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController") as? DetalleViewController
       
        vc?.tituloFinal = tituloNoticias[indexPath.row]
        
        vc?.subtituloFinal = subtitulo[indexPath.row]
        vc?.descripcionNoti = descripcionNoticias[indexPath.row]
        vc?.imagenNoticia = noticiaImagenString[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
 @objc  func clickMenuButton() {
        DispatchQueue.main.async {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 311.0
    }
}
