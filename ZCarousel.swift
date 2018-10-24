//
//  Carrousel.swift
//  ZCScrollMenu
//
//  Created by Ricardo Zertuche on 2/8/15.
//  Copyright (c) 2015 Ricardo Zertuche. All rights reserved.
//

import UIKit

@objc protocol ZCarouselDelegate {
    func ZCarouselShowingIndex(scrollview:ZCarousel, index: Int)
}

class ZCarousel: UIScrollView, UIScrollViewDelegate {
    
    var ZCButtons:[UIButton] = []
    var ZCImages:[UIImageView] = []
    private var buttons:[UIButton] = []
    var images:[UIImageView] = []
    private var page: CGFloat!
    private var isImage: Bool!
    private var originalArrayCount: Int!
    
    var ZCdelegate: ZCarouselDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initalizeScrollViewProperties()
    }
    
    init() {
        super.init(frame: CGRect .zero)
        self.initalizeScrollViewProperties()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initalizeScrollViewProperties()
    }
    
    func initalizeScrollViewProperties(){
        super.isPagingEnabled = true
        super.contentSize = CGSize(width: 0, height: self.frame.height)
        super.clipsToBounds = false
        super.delegate = self
        super.showsHorizontalScrollIndicator = false
        isImage = false
    }
    func clear(){
        
    }
    func addButtons(titles: [String]){
        originalArrayCount = titles.count
        //1
        var buttonFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.height)
        //a
        var finalButtons = titles
        //b
        let firstItem       = titles[0]
        let secondItem      = titles[1]
        let almostLastItem  = titles[titles.count-2]
        let lastItem        = titles.last
        //c
        finalButtons.insert(almostLastItem, at: 0)
        finalButtons.insert(lastItem!, at: 1)
        finalButtons.append(firstItem)
        finalButtons.append(secondItem)
        
        //2
        for i in 0..<finalButtons.count {
            //3
            //println("\(i) - \(finalButtons[i])")
            if i != 0 {
                buttonFrame = CGRect(x: buttonFrame.origin.x+buttonFrame.width, y: self.frame.height/2-self.frame.height/2, width: self.frame.size.width, height: self.frame.height)
            }
            //4
            let button = UIButton(frame: buttonFrame)
            button.setTitle(finalButtons[i], for: UIControlState .normal)
            button.setTitleColor(UIColor.black, for: UIControlState .normal)
            //6
            self.addSubview(button)
            self.contentSize.width = super.contentSize.width+button.frame.width
            
            buttons.append(button)
        }
        
        let middleButton = buttons[(buttons.count/2)]
        self.scrollRectToVisible(middleButton.frame, animated: false)
    }
    
    func addImages(imagesToUSe: [String]){
        originalArrayCount = imagesToUSe.count
        //1
        var imageViewFrame = CGRect(x: 10, y: 0, width: self.frame.size.width-20, height: self.frame.height)
        //a
        var finalImageViews = imagesToUSe
        //b
        /*let firstItem       = imagesToUSe[0]
        let secondItem      = imagesToUSe[1]
        let almostLastItem  = imagesToUSe[imagesToUSe.count-2]
        let lastItem  = imagesToUSe.last
        //c
        finalImageViews.insert(almostLastItem, at: 0)
        finalImageViews.insert(lastItem!, at: 1)
        finalImageViews.append(firstItem)
        finalImageViews.append(secondItem)*/
        
        //2
        for i in 0..<finalImageViews.count {
            //let image = UIImage(named: finalImageViews[i])
            
            //3
            //println("\(i) - \(finalButtons[i])")
            if i != 0 {
                imageViewFrame = CGRect(x: (self.frame.width * CGFloat(i)) + 10, y: (self.frame.height/2-self.frame.height/2)+12.5, width: self.frame.size.width - 20, height: self.frame.height - 25)
            }
            //4
            let imageView = UIImageView(frame: imageViewFrame)
            //imageView.image = image
            imageView.downloadImage(downloadURL: finalImageViews[i], completion: { result in
                
            })
            //6
            self.addSubview(imageView)
            self.contentSize.width = super.contentSize.width+imageView.frame.width
            
            images.append(imageView)
        }
        page  = 0
        isImage = true
        if(self.images.count > 0){
            let middleImage = images[Int(page)]
            middleImage.frame = CGRect(x: middleImage.frame.origin.x, y: 0, width: middleImage.bounds.width, height: self.frame.height)
            self.scrollRectToVisible(middleImage.frame, animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1
        
        /*if(Int(page) != Int(scrollView.contentOffset.x / scrollView.frame.width)){
        page = scrollView.contentOffset.x / scrollView.frame.width
        print(Int(page))
        //2
        var objectsCount: CGFloat!
        var objects = [AnyObject]()
        if isImage==true {
            objectsCount = CGFloat(images.count)
            objects = images
        }
        else {
            objectsCount = CGFloat(buttons.count)
            objects = buttons
        }
        //3
            
            for image in images{
                image.frame = CGRect(x: image.frame.origin.x, y: 12.5, width: image.bounds.width, height: self.frame.height - 25)
            }
        
            
            if(Int(page) >= 0 && Int(page) < originalArrayCount ){
                let scrollToObject: UIImageView = images[Int(page)]
                scrollToObject.frame = CGRect(x: scrollToObject.frame.origin.x, y: 0, width: scrollToObject.bounds.width, height: self.frame.height)
                self.scrollRectToVisible(scrollToObject.frame, animated: false)
            }else if( Int(page) > (originalArrayCount - 1) ){
                let scrollToObject: UIImageView = images[Int(originalArrayCount - 1)]
                scrollToObject.frame = CGRect(x: scrollToObject.frame.origin.x, y: 0, width: scrollToObject.bounds.width, height: self.frame.height)
                self.scrollRectToVisible(scrollToObject.frame, animated: false)
            }
        
        
        }*/
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //1
        
        if(Int(page) != Int(scrollView.contentOffset.x / scrollView.frame.width)){
            page = scrollView.contentOffset.x / scrollView.frame.width
            print(Int(page))
            //2
            var objectsCount: CGFloat!
            var objects = [AnyObject]()
            if isImage==true {
                objectsCount = CGFloat(images.count)
                objects = images
            }
            else {
                objectsCount = CGFloat(buttons.count)
                objects = buttons
            }
            //3
            
            for image in images{
                image.frame = CGRect(x: image.frame.origin.x, y: 12.5, width: image.bounds.width, height: self.frame.height - 25)
            }
            
            
            if(Int(page) >= 0 && Int(page) < originalArrayCount ){
                let scrollToObject: UIImageView = images[Int(page)]
                scrollToObject.frame = CGRect(x: scrollToObject.frame.origin.x, y: 0, width: scrollToObject.bounds.width, height: self.frame.height)
                self.scrollRectToVisible(scrollToObject.frame, animated: false)
            }else if( Int(page) > (originalArrayCount - 1) ){
                let scrollToObject: UIImageView = images[Int(originalArrayCount - 1)]
                scrollToObject.frame = CGRect(x: scrollToObject.frame.origin.x, y: 0, width: scrollToObject.bounds.width, height: self.frame.height)
                self.scrollRectToVisible(scrollToObject.frame, animated: false)
            }
            
            
        }
        
    }
}

