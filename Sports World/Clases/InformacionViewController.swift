//
//  InformacionViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 15/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class InformacionViewController: UIViewController, ZCarouselDelegate, UIScrollViewDelegate {
    
     var images: ZCarousel?
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var adressImage: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var phoneImage: UIImageView!
    
    
    
    func ZCarouselShowingIndex(scrollview: ZCarousel, index: Int) {
        
    }
   
    
    var loadViewController: ((_ index: Int) -> Void)?
    
    @IBAction func loadSegment(_ sender: Any) {
        
        if loadViewController != nil {
            loadViewController!(0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        images = ZCarousel(frame: CGRect( x: self.view.frame.size.width/5,
                                          y: 0,
                                          width: (self.view.frame.size.width/5)*3,
                                          height: 150))
        images?.ZCdelegate = self
        //images?.backgroundColor = UIColor.cyan
        
        self.view.addSubview(images!)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformacionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.handleTapAddress(gestureRecognizer:)))
        self.address.addGestureRecognizer(tapGestureRecognizer)
        
        
        let tapGestureRecognizerImage = UITapGestureRecognizer(target:self, action:#selector(self.handleTapAddress(gestureRecognizer:)))
        self.adressImage.addGestureRecognizer(tapGestureRecognizerImage)
        
        self.address.isUserInteractionEnabled = true
        
        self.adressImage.isUserInteractionEnabled = true
        
        let tapGestureRecognizerPhone = UITapGestureRecognizer(target:self, action:#selector(self.handleTapPhone(gestureRecognizer:)))
        self.phone.addGestureRecognizer(tapGestureRecognizerPhone)
        
        
        let tapGestureRecognizerPhoneImage = UITapGestureRecognizer(target:self, action:#selector(self.handleTapPhone(gestureRecognizer:)))
        self.phoneImage.addGestureRecognizer(tapGestureRecognizerPhoneImage)
        
        self.phone.isUserInteractionEnabled = true
        
        self.phoneImage.isUserInteractionEnabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        APIManager.sharedInstance.getClubDetail( onSuccess: { result in
            
            DispatchQueue.main .async {
                if(result.status == true){
                    //self.images?.addImages(imagesToUSe: result.data.imagenes_club)
                    self.address.text = result.data.direccion
                    self.phone.text = result.data.telefono
                    
                    
                }else{
                    
                }
                
            }
        }, onFailure: { error in
            
        })
        })
        
        APIManager.sharedInstance.infoVC = self
    }
    
    func updateValues(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.images?.images.removeAll()
            for v in (self.images?.subviews)!{
                v.removeFromSuperview()
            }
           // self.images?.removeFromSuperview()
            /*self.images = ZCarousel(frame: CGRect( x: self.view.frame.size.width/5,
                                              y: 0,
                                              width: (self.view.frame.size.width/5)*3,
                                              height: 150))*/
            //self.images?.ZCdelegate = self
            //self.images?.backgroundColor = UIColor.cyan
            
            //self.view.addSubview(self.images!)
            self.address.text = ""
            self.phone.text = ""
            APIManager.sharedInstance.getClubDetail( onSuccess: { result in
                
                DispatchQueue.main .async {
                    if(result.status == true){
                        self.images?.addImages(imagesToUSe:  result.data.imagenes_club)
                        self.address.text = result.data.direccion
                        self.phone.text = result.data.telefono
                        
                        
                    }else{
                        
                    }
                    
                }
            }, onFailure: { error in
                
            })
        })
        
    }
    @objc func handleTapPhone(gestureRecognizer: UIGestureRecognizer) {
        print("touc")
        
        //let customPointAnnotation : MyAnnotation = self.annotationsArray[(gestureRecognizer.view?.tag)!]
        
        let club = APIManager.sharedInstance.selectedClub
        
        guard let number = URL(string: "tel://" + (self.phone.text?.digits)!) else { return }
        UIApplication.shared.open(number)
       
        
    }
    @objc func handleTapAddress(gestureRecognizer: UIGestureRecognizer) {
        print("touc")
        
        //let customPointAnnotation : MyAnnotation = self.annotationsArray[(gestureRecognizer.view?.tag)!]
        
        let club = APIManager.sharedInstance.selectedClub
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openMaps(query:"\(club.latitude),\(club.longitude)")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openGoogleMaps(query:"\(club.latitude),\(club.longitude)")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openWaze(query:"\(club.latitude),\(club.longitude)")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func openGoogleMaps(query : String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //First check Google Mpas installed on User's phone or not.
            UIApplication.shared.open(URL(string:
                "http://maps.google.com/?daddr=" + query)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(URL(string:"https://www.google.com/maps?daddr=" + query)!, options: [:], completionHandler: nil)
        }
    }
    
    
    func openWaze(query : String) {
        if (UIApplication.shared.canOpenURL(URL(string:"waze://")!)) {  //First check Waze Mpas installed on User's phone or not.
            UIApplication.shared.open(URL(string:
                "http://waze.com/ul?ll="+query+"&navigate=yes")!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(URL(string:
                "http://waze.com/ul?ll="+query+"&navigate=yes")!, options: [:], completionHandler: nil)
        }
    }
    
    func openMaps(query : String) {
        //First check Waze Mpas installed on User's phone or not.
        UIApplication.shared.open(URL(string:"http://maps.apple.com/?daddr=" + query)!, options: [:], completionHandler: nil)
        
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

 
    
}
