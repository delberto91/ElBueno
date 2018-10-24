//
//  CategoriasViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/1/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class CategoriasViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CategoriasTableViewCellDelegate {
    func idClaseSelcted() {
        print("")
    }
    
    private let cell = "CategoriasTableViewCell"
    
    var clasesCategoria : [ClaseCategorias] = [ClaseCategorias]()
    var clasesToSearch = [[String:AnyObject]]()
    var sortedArray : [String:[String]] = [:]
    var filteredCandies = [[String:AnyObject]]()
    var clasesF : [Clases] = [Clases]()
    var clasesFull : [Clases] = [Clases]()
    var idClase = [Int]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoClaseCategorias" {
            if let collectionCell: CategoriasCollectionViewCell = sender as? CategoriasCollectionViewCell {
                
                
                if let collectionView: UICollectionView = collectionCell.superview as? UICollectionView {
                    
                    if let destination = segue.destination as? ClaseCategoriasViewController {
                       
                    }
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedArray.count
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.sortedArray = [String: [String]]()
        for dictionary in APIManager.sharedInstance.categoriasData {
            if let key = dictionary["categoria"]{
                let clasesF = dictionary["clases"] as! [[String:AnyObject]]
                self.clasesToSearch = clasesF
                self.filteredCandies = clasesF
                for clases in clasesF {
                    
                    if let clase = clases["clase"] {
                        if((clase as! String).uppercased().contains(searchText.uppercased()) || searchText == ""){
                        let idClase = clases["idClase"]
                        self.idClase.append(idClase as! Int)
                        if self.sortedArray[key as! String ] != nil {
                            self.sortedArray[key as! String ]?.append(clase as! String )
                            
                        }else{
                            self.sortedArray[key as! String ] = [clase] as? [String]
                            print("self.sortedArray", self.sortedArray)
                        }
                        }else if self.sortedArray[key as! String ] == nil {
                            //self.sortedArray[key as! String ] =  [String]()
                            
                        }
                    }
                }
            }
        }
        
        tabView.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! CategoriasTableViewCell
        let key = Array(self.sortedArray.keys)[indexPath.row]
        
        cel.loadCollectionView(array: sortedArray[key]!)
        
        
        cel.loadCollectionViewForId(array: self.clasesFull)
        
        
        cel.categoriaLabel.text = key
        return cel 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 111.0 + 20
        return 80
    }
    
    @IBOutlet weak var tabView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = NSLocalizedString("Buscar", comment: "")
        searchBar.setTextColor(color: .white)
        //            searchBar.layer.borderWidth = 0
        //            searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
        searchBar.setTextFieldColor(color: UIColor.init(white: 1.0, alpha: 0.3))
        searchBar.setPlaceholderTextColor(color: .white)
        searchBar.setSearchImageColor(color: .white)
        searchBar.setTextFieldClearButtonColor(color: .white)
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Clases", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_perfil"), style: .done, target: self, action: #selector(CategoriasViewController.clickMenuButton))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 20
        //searchBar.searchBarStyle = .default
       
        self.searchBar.delegate = self

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        searchBar.resignFirstResponder()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterContentForSearchText(searchText)
       
        
    }
    @objc  func clickMenuButton() {
        DispatchQueue.main.async {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabView.delegate = self
       
        APIManager.sharedInstance.categoriasData = []
        self.sortedArray = [String: [String]]()
        
        
        self.tabView.reloadData()
        APIManager.sharedInstance.getCategoriaClases(onSuccess: {response in
            DispatchQueue.main.async {
                
                if response.status == true  {
                    self.clasesCategoria = response.data
                    self.clasesFull = response.clases
                    
                    
                    for dictionary in APIManager.sharedInstance.categoriasData {
                        if let key = dictionary["categoria"]{
                            let clasesF = dictionary["clases"] as! [[String:AnyObject]]
                            self.clasesToSearch = clasesF
                            self.filteredCandies = clasesF
                            for clases in clasesF {
                                if let clase = clases["clase"] {
                                    let idClase = clases["idClase"]
                                    self.idClase.append(idClase as! Int)
                                    
                                    print("idputasclases",  self.idClase)
                                    if self.sortedArray[key as! String ] != nil {
                                        self.sortedArray[key as! String ]?.append(clase as! String )
                                        
                                    }else{
                                        self.sortedArray[key as! String ] = [clase] as? [String]
                                    print("self.sortedArray", self.sortedArray)
                                    }
                                }
                            }
                        }
                    }
 
                    self.tabView.reloadData()
                } else if response.status == false {
                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                }
            }
            
        })
    }
    @IBAction func backButton(_ sender: Any) {
           let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

