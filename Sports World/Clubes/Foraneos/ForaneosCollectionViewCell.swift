//
//  ForaneosCollectionViewCell.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 17/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ForaneosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func clickLikeButton(_ sender: Any) {
        
      APIManager.sharedInstance.clubes.showActivity()
        
        let localClub : Club = APIManager.sharedInstance.ciudadesVC.arrayLocalClubes.filter({$0.clubId == self.tag}).last!//[sender.tag]
        if(APIManager.sharedInstance.allClubes.filter({$0.group.uppercased() == "FAVORITOS"}).filter({$0.clubId == localClub.clubId}).count > 0){
            let params = [
                "user_id": "\(SavedData.getTheUserId())",
                "club_id": "\(localClub.clubId)",
                "status": "0"
                ] as [String : String]
            APIManager.sharedInstance.changeFavorite(params: params , onSuccess: { result in
                

                
                if(result.status){
                    DispatchQueue.main.async{
                        APIManager.sharedInstance.clubes.updateAllValues()
                     }
                   APIManager.sharedInstance.clubes.hideActivity()
                }
           
                
            }, onFailure: { error in
               
            })
            
        }else{
            let params = [
                "user_id": "\(SavedData.getTheUserId())",
                "club_id": "\(localClub.clubId)",
                "status": "1"
            ]
            APIManager.sharedInstance.changeFavorite(params: params , onSuccess: { result in
                
          
                if(result.status){
                    
                    DispatchQueue.main.async{
                        APIManager.sharedInstance.clubes.updateAllValues()
                     
                        
                    }
                  APIManager.sharedInstance.clubes.hideActivity()
                }
             
                
            }, onFailure: { error in
               
            })
          
        }
        
        
    }
}
