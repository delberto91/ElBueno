//
//  DetalleRecetaViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/25/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class DetalleRecetaViewController: UIViewController, UITextViewDelegate {
var activityViewController:UIActivityViewController?
    @IBOutlet weak var recetaImage: UIImageView!
    @IBOutlet weak var descripcionReceta: UITextView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backView: UIView!
    var recetaNombre = ""
    var recetaDescripcion = ""
    var recetaImagen = ""
    var selectedReceta : Receta = Receta()
    var  photoToShare = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isHidden = true 
        backView.layer.cornerRadius = 8
        descripcionReceta.delegate = self
       // nombreReceta.text = recetaNombre
       // descripcionReceta.text = recetaDescripcion
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 20)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: self.selectedReceta.nombre, attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
     //   recetaImage.downloadImage(downloadURL: recetaImagen, completion: { result in
            
       // })
        
         recetaNombre  = self.selectedReceta.nombre
        descripcionReceta.text = self.selectedReceta.descripcion
        recetaImage.downloadImage(downloadURL: self.selectedReceta.foto, completion: { result in
             })
        
        let url = URL(string:"http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            photoToShare = image
        }
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descripcionReceta.setContentOffset(CGPoint.zero, animated: false)
    }
    @IBAction func shareButton(_ sender: Any) {
        let viewController = UIActivityViewController(activityItems: [self.selectedReceta.descripcion, URL.init(string:  self.selectedReceta.foto)!], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(viewController, animated: true, completion: nil)
        }

}


extension DetalleRecetaViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        return URL.init(string: "https://itunes.apple.com/app/id1170886809")!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "ScreenSort for iOS: https://itunes.apple.com/app/id1170886809"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return nil
    }
}
