//
//  AreasCollectionViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 30/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

private let cell = "AreasCollectionViewCell"

class AreasCollectionViewController: UICollectionViewController {

    var arrayOfImages: [UIImage] = [#imageLiteral(resourceName: "areas_ring"),#imageLiteral(resourceName: "area_"),#imageLiteral(resourceName: "area_squash"),#imageLiteral(resourceName: "area_canchas"),#imageLiteral(resourceName: "area_salones"),#imageLiteral(resourceName: "area_grupales"),#imageLiteral(resourceName: "areas_alberca"),#imageLiteral(resourceName: "area_funcional"),#imageLiteral(resourceName: "area_areadebox"),#imageLiteral(resourceName: "area_pesolibre"),#imageLiteral(resourceName: "area_vestidores"),#imageLiteral(resourceName: "area_areadeninos"),#imageLiteral(resourceName: "areas_vapor_sauna"),#imageLiteral(resourceName: "area_areacadiovascular")]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayOfImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
          let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath) as! AreasCollectionViewCell
        cel.imageToShow.image = arrayOfImages[indexPath.row]
        return cel
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
