//
//  ViewController.swift
//  TableStyleNetflix
//
//  Created by VicktorManuel on 7/30/18.
//  Copyright © 2018 VicktorManuel. All rights reserved.
//

import UIKit

class RutinasCasaViewController: UIViewController,MoviesTableViewCellDelegate,UISearchBarDelegate {
    func videoSelect(video: RutinasCasa) {
        
        self.rutinaSelecionado = video
        performSegue(withIdentifier: "segueVideoDescription", sender: nil)
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterContentForSearchText(searchText)
        
        
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
       
        self.sortedArray = [RutinasCasa]()
        for item in self.videoRoutines{
            if(item.nombreEntrenamiento.uppercased().contains(searchText.uppercased()) || searchText == ""){
                self.sortedArray.append(item)
            }
        }
        self.videoCategories = Array(Set( self.sortedArray.map { $0.categoria}))
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVideoDescription"{
            // let changeName = segue.destination as! DescripcionViewController
            //changeName.videoImagen = videoSeleccionado?.urlImagen
            //changeName.videoUrl = videoSeleccionado?.urlVideo
            let vc : RoutineDetailViewController = segue.destination as! RoutineDetailViewController
            vc.videoRoutine = self.rutinaSelecionado!
        }
    }
    @IBOutlet weak var tableView: UITableView!
    //Colleccion de videos
    var collecciones:[VideoCollection]! = []
    var videoCategories : [String] = [String]()
    var videoRoutines : [RutinasCasa] = [RutinasCasa]()
    var sortedArray : [RutinasCasa] = [RutinasCasa]()
    //Video seleccionado
    var rutinaSelecionado:RutinasCasa?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_perfil"), style: .done, target: self, action: #selector(RutinasCasaViewController.goTonAnotherViewController))
        
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.view.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Workout", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RutinasCasaViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MoviesTableViewCell
        cell.delegate = self
        
        cell.titleCell.text = self.videoCategories[indexPath.row]
        cell.videoRoutines = self.sortedArray.filter({$0.categoria == self.videoCategories[indexPath.row]})
        cell.moviesCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.sharedInstance.getRutinasCasa(onSuccess: {response in
            DispatchQueue.main.async {
               

                self.videoCategories = Array(Set( response.data.map { $0.categoria}))
                self.sortedArray = response.data
                self.videoRoutines = response.data
                //self.nivelLabel.text = String(APIManager.sharedInstance.nivel)
                //self.programaLabel.text = APIManager.sharedInstance.rutina
                // /} else {
                
                //}
                self.tableView.reloadData()
                self.searchBar.text = ""
                
                
            }
            
        })
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    @objc func goTonAnotherViewController() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
}

