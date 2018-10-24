//
//  FavoritosCollectionViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 17/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
private let cell = "FavoritosCollectionViewCell"

class FavoritosCollectionViewController: UICollectionViewController {
    @IBOutlet var colleView: UICollectionView!
    
    var stringArray: [String] = ["No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar"]
    var arrayLocalClubes : [Club] = [Club]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.favoritesVC = self
        self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Favoritos"})
        
      
        colleView.reloadData()
        
    }
    func update(value: String){
        DispatchQueue.main.async{
            self.arrayLocalClubes = [Club]()
            self.collectionView?.reloadData()
        
       
        if(value == ""){
            self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Favoritos"})
        }else{
            self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Favoritos"}).filter({$0.name.uppercased().contains(value.uppercased())})
        }
        self.collectionView?.reloadData()
        }
        
     /*   DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            let indexPath : IndexPath = IndexPath(row: 0, section: 0)
            
            self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })*/
        
    } 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayLocalClubes.count
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath)
        if let theLabel = cel.viewWithTag(100) as? UILabel {
            theLabel.text = self.arrayLocalClubes[indexPath.row].name
            print(self.arrayLocalClubes[indexPath.row].name)
            
           
        }
        
        cel.tag = self.arrayLocalClubes[indexPath.row].clubId
        
            //heart_red
            /*if let theButton = cel.viewWithTag(200) as? UIButton {
                theButton.removeTarget(nil, action: nil, for: .allEvents)
                theButton.setImage(UIImage(named:"heart_red"), for: .normal)
                theButton.tag = self.arrayLocalClubes[indexPath.row].clubId
                theButton.setTitle("\(self.arrayLocalClubes[indexPath.row].clubId)", for: .normal)
                print("\(self.arrayLocalClubes[indexPath.row].clubId)")
                theButton.addTarget(self, action: #selector(self.myviewTapped(_:)), for: .touchUpInside)
            }*/
        
        
        return cel
    }
    
    @objc func myviewTapped(_ sender: UIButton) {
        DispatchQueue.main.async{
            APIManager.sharedInstance.clubes.showActivity()
            print(sender.tag)
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
