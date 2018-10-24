//
//  CategoriasTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/1/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
var ffff: Int!
var finalIdForCategorias: Int!

var tituloClase: String = ""
protocol CategoriasTableViewCellDelegate {
  func idClaseSelcted()
    
}
class CategoriasTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var clasesCategoria : [ClaseCategorias] = [ClaseCategorias]()
    var array = [String]()
     var idClase = [Int]()
    var clase = [String]()
    var claseAll: [Clases] = [Clases]()
    var delegate: CategoriasTableViewCellDelegate! = nil
    var selectedIndex = 0
    @IBOutlet weak var categoriaLabel: UILabel!
    
    private let cell = "CategoriasCollectionViewCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  array.count
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath) as! CategoriasCollectionViewCell
//        cel.claseLabel.layer.cornerRadius = 15.0
        cel.claseLabel.layer.cornerRadius = cel.frame.height / 2 - 8
        cel.claseLabel.layer.borderWidth = 1.0
        cel.claseLabel.layer.borderColor = UIColor.red.cgColor
        cel.claseLabel.text = self.array[indexPath.row]
        
        return cel 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath) as! CategoriasCollectionViewCell
        
          //cel.idClase = self.idClase[indexPath.row]
          cel.claseLabel.text = self.array[indexPath.row]
        
           print("Clase seleccionada",   cel.claseLabel.text!)
        
        ffff = self.claseAll.first(where: {$0.clase == self.array[indexPath.row]})?.idClase
        tituloClase = cel.claseLabel.text!
        finalIdForCategorias = ffff!
        
        
        
    }
    
    

    @IBOutlet weak var colleView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colleView.dataSource = self
        colleView.delegate = self
        
    }

    
    func loadCollectionView(array:[String]) {
        self.array = array
        self.colleView.reloadData()
    }
    
    func loadCollectionViewForId(array:[Clases]) {
        self.claseAll = array
        self.colleView.reloadData()
    }


}

extension CategoriasTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.array[indexPath.row]
        let insets = (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing
        
        let width = item.width(withConstrainedHeight: collectionView.bounds.height, font: UIFont(name: "LarkeNeue-Regular", size: 26)!)
        
        return CGSize(width: fmax(width, 74), height: collectionView.bounds.height)
    }
}


