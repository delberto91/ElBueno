//
//  ProximasAperturasCollectionViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 17/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

private let cell = "ProximasAperturasCollectionViewCell"

class ProximasAperturasCollectionViewController: UICollectionViewController {
    
    var stringArray: [String] = ["No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar"]
    var arrayLocalClubes : [Club] = [Club]()
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.proximasAperturasVC = self
        arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Próximas Aperturas"})
    }

    func update(value: String){
        DispatchQueue.main.async{
            self.arrayLocalClubes = [Club]()
            self.collectionView?.reloadData()
        if(value == ""){
            self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Próximas Aperturas"})
        }else{
            self.arrayLocalClubes = APIManager.sharedInstance.allClubes.filter({$0.group == "Próximas Aperturas"}).filter({$0.name.uppercased().contains(value.uppercased())})
        }
        self.collectionView?.reloadData()
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayLocalClubes.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath)
        if let theLabel = cel.viewWithTag(100) as? UILabel {
            theLabel.text = arrayLocalClubes[indexPath.row].name
        }
        return cel
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        APIManager.sharedInstance.selectedClub = arrayLocalClubes[indexPath.row]
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

