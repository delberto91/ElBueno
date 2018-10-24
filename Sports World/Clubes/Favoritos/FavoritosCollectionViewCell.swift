//
//  FavoritosCollectionViewCell.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 17/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit


class FavoritosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var comoSeaButton: UIButton!
    
    @IBAction func t(_ sender: Any) {
        DispatchQueue.main.async{
            APIManager.sharedInstance.clubes.showActivity()
            print(self.tag)
            let localClub : Club = APIManager.sharedInstance.favoritesVC.arrayLocalClubes.filter({$0.clubId == self.tag}).last!//[sender.tag]
            if(APIManager.sharedInstance.allClubes.filter({$0.group.uppercased() == "FAVORITOS"}).filter({$0.clubId == localClub.clubId}).count > 0){
                let params = [
                    "user_id": "\(SavedData.getTheUserId())",
                    "club_id": "\(localClub.clubId)",
                    "status": "0"
                    ] as [String : String]
                APIManager.sharedInstance.changeFavorite(params: params , onSuccess: { result in
                    
                    
                    
                    if(result.status){
                        DispatchQueue.main.async{
                            
                        }
                        APIManager.sharedInstance.clubes.updateAllValues()
                        APIManager.sharedInstance.clubes.hideActivity()
                    }
                    
                }, onFailure: { error in
                    APIManager.sharedInstance.clubes.hideActivity()
                })
            }
            
        }
    }
}
