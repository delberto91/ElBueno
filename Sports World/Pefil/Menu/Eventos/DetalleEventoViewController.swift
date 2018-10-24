//
//  DetalleEventoViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
class DetalleEventoViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
   
    var scrollView = UIScrollView()
    
    var pageControl : UIPageControl = UIPageControl(frame:CGRect(x: UIScreen.main.bounds.midX-100, y: 300, width: 200, height: 60))
    
    var yPosition:CGFloat = 0
    var scrollViewContentSize:CGFloat = 0
    
  
     @IBOutlet weak var tituloEventoLabel: UILabel!
    @IBOutlet weak var descripcionEventoLabel: UITextView!
    
    var detailEvent = Eventos()
    override func viewDidLoad() {
        
        super.viewDidLoad()
          
      
        
      
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
        
            case 2436:
               /*ES IPHONE X*/
                if isProximos == true {
                    scrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 300))
                    scrollView.delegate = self
                    self.view.addSubview(scrollView)
                    configurePageControl()
                    var frame = CGRect.zero
                    frame.origin.x = self.scrollView.frame.size.width * CGFloat(0)
                    frame.origin.y = 0
                    frame.size = self.scrollView.frame.size
                    self.scrollView.isPagingEnabled = true
                    
                    
                    
                    let myImageView: UIImageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX-100, y: 400, width: 200, height: 300))
                    
                    myImageView.downloadImageSync(downloadURL: self.detailEvent.imagen, completion: { result in
                        
                    })
                    myImageView.contentMode = UIViewContentMode.scaleAspectFit
                    myImageView.frame = frame
                    
                    
                    scrollView.addSubview(myImageView)
                }
                for  i in stride(from: 0, to: self.detailEvent.galeria.count, by: 1) {
                    var frame = CGRect.zero
                    frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
                    frame.origin.y = 0
                    frame.size = self.scrollView.frame.size
                    self.scrollView.isPagingEnabled = true
                    
                    
                    
                    
                    let myImageView: UIImageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX-100, y: 400, width: 200, height: 300))
                    myImageView.downloadImageSync(downloadURL: self.detailEvent.galeria[i].ruta, completion: { result in
                        
                    })
                    myImageView.contentMode = UIViewContentMode.scaleAspectFit
                    myImageView.frame = frame
                    
                    scrollView.addSubview(myImageView)
                }
                
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(self.detailEvent.galeria.count), height: self.scrollView.frame.size.height)
                pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
                
                tituloEventoLabel.text! = self.detailEvent.nombre
                descripcionEventoLabel.text! = self.detailEvent.descripcion
                
     //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            default:
                if isProximos == true {
                    scrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 300))
                    scrollView.delegate = self
                    self.view.addSubview(scrollView)
                    configurePageControl()
                    var frame = CGRect.zero
                    frame.origin.x = self.scrollView.frame.size.width * CGFloat(0)
                    frame.origin.y = 0
                    frame.size = self.scrollView.frame.size
                    self.scrollView.isPagingEnabled = true
                    
                    
                    
                    let myImageView: UIImageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX-100, y: UIScreen.main.bounds.midY-100, width: 200, height: 200))
                    myImageView.downloadImageSync(downloadURL: self.detailEvent.imagen, completion: { result in
                        
                    })
                    myImageView.clipsToBounds = true
                    myImageView.contentMode = UIViewContentMode.scaleAspectFill
                    myImageView.frame = frame
                    myImageView.autoresizesSubviews = false
                   // myImageView.backgroundColor = UIColor.red
                    scrollView.addSubview(myImageView)
                }
                for  i in stride(from: 0, to: self.detailEvent.galeria.count, by: 1) {
                    var frame = CGRect.zero
                    frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
                    frame.origin.y = 0
                    frame.size = self.scrollView.frame.size
                    self.scrollView.isPagingEnabled = true
                    
                    
                    
                    
                    let myImageView: UIImageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX-100, y: UIScreen.main.bounds.midY-100, width: 200, height: 200))
                    myImageView.downloadImageSync(downloadURL: self.detailEvent.galeria[i].ruta, completion: { result in
                        
                    })
                   // myImageView.backgroundColor = UIColor.red
                    myImageView.clipsToBounds = true
                    myImageView.contentMode = UIViewContentMode.scaleAspectFill
                    myImageView.frame = frame
                    myImageView.autoresizesSubviews = false
                    scrollView.addSubview(myImageView)
                }
                
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(self.detailEvent.galeria.count), height: self.scrollView.frame.size.height)
                pageControl.addTarget(self, action: Selector(("changePage:")), for: UIControlEvents.valueChanged)
                
                tituloEventoLabel.text! = self.detailEvent.nombre
                descripcionEventoLabel.text! = self.detailEvent.descripcion
                
                //idEventoDetalle = detailEvent.
                //print("idEventoDetalle", idEventoDetalle!)
            }
        }
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = self.detailEvent.galeria.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descripcionEventoLabel.setContentOffset(CGPoint.zero, animated: false)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
}
