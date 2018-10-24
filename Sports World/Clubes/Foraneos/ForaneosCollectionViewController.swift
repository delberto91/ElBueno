//
//  ForaneosCollectionViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 17/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

private let cell = "ForaneosCollectionViewCell"

class ForaneosCollectionViewController: UICollectionViewController {
    
    var stringArray: [String] = ["No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar"]
    var arrayLocalClubes : [Club] = [Club]()
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.ciudadesVC = self
        self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Cerca de mi"})
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayLocalClubes.count
        
    }
    func update(value: String){
        DispatchQueue.main.async{
            self.arrayLocalClubes = [Club]()
             self.collectionView?.reloadData()
        if(value == ""){
            self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Cerca de mi"})
        }else{
            self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Cerca de mi"}).filter({$0.name.uppercased().contains(value.uppercased())})
        }
        self.collectionView?.reloadData()
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel : ForaneosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath) as! ForaneosCollectionViewCell
        if let theLabel = cel.viewWithTag(100) as? UILabel {
            theLabel.text = self.arrayLocalClubes[indexPath.row].name
        }
        
        if(APIManager.sharedInstance.allClubes.filter({$0.group.uppercased() == "FAVORITOS"}).filter({$0.clubId == self.arrayLocalClubes[indexPath.row].clubId}).count > 0){
            //heart_red
            /*if let theButton = cel.viewWithTag(200) as? UIButton {
                theButton.setImage(UIImage(named:"heart_red"), for: .normal)
                theButton.tag = arrayLocalClubes[indexPath.row].clubId
                theButton.addTarget(self, action: #selector(self.myviewTapped(_:)), for: .touchUpInside)
            }*/
            cel.likeButton.setImage(UIImage(named:"heart_red"), for: .normal)
        }else{
            /*if let theButton = cel.viewWithTag(200) as? UIButton {
                theButton.setImage(UIImage(named:"heart_image"), for: .normal)
                theButton.tag = arrayLocalClubes[indexPath.row].clubId
                theButton.addTarget(self, action: #selector(self.myviewTapped(_:)), for: .touchUpInside)
            }*/
            cel.likeButton.setImage(UIImage(named:"heart_image"), for: .normal)
        }
        cel.tag = self.arrayLocalClubes[indexPath.row].clubId
        
        return cel
    }

    @objc func myviewTapped(_ sender: UIButton) {
         DispatchQueue.main.async{
       APIManager.sharedInstance.clubes.showActivity()
        
        let localClub : Club = self.arrayLocalClubes.filter({$0.clubId == sender.tag}).last!//[sender.tag]
        if(APIManager.sharedInstance.allClubes.filter({$0.group.uppercased() == "FAVORITOS"}).filter({$0.clubId == localClub.clubId}).count > 0){
            let params = [
                "user_id": "\(SavedData.getTheUserId())",
                "club_id": "\(localClub.clubId)",
                "status": "0"
                ] as [String : String]
            APIManager.sharedInstance.changeFavorite(params: params , onSuccess: { result in
                
               
                    
                    if(result.status){
                        DispatchQueue.main.async{
                              
                            sender.setImage(UIImage(named:"heart_image"), for: .normal)
                        }
                        APIManager.sharedInstance.clubes.updateAllValues()
                            APIManager.sharedInstance.clubes.hideActivity()
                    }
                
            }, onFailure: { error in
                APIManager.sharedInstance.clubes.hideActivity()
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
                            sender.setImage(UIImage(named:"heart_red"), for: .normal)
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
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        APIManager.sharedInstance.selectedClub = self.arrayLocalClubes[indexPath.row]
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
