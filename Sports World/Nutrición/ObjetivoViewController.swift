//
//  ObjetivoViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/26/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ObjetivoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    /*@IBOutlet weak var quieroBajarDePesoButton: UIButton!
    @IBOutlet weak var quieroCompetirButton: UIButton!
    @IBOutlet weak var quieroSentirmeButton: UIButton!
    @IBOutlet weak var quieroMejorarButton: UIButton!
    @IBOutlet weak var quieroDesarrollarButton: UIButton!
    @IBOutlet weak var enviarButton: UIButton!*/
    var responseMetas : MetasResponse = MetasResponse()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activity.isHidden = true
        /*quieroBajarDePesoButton.addTopBorderWithColor(quieroBajarDePesoButton, color: UIColor.white, width: 0.5)
        quieroCompetirButton.addTopBorderWithColor(quieroCompetirButton, color: UIColor.white, width: 0.5)
        quieroSentirmeButton.addTopBorderWithColor(quieroSentirmeButton, color: UIColor.white, width: 0.5)
        quieroMejorarButton.addTopBorderWithColor(quieroMejorarButton, color: UIColor.white, width: 0.5)
        quieroDesarrollarButton.addTopBorderWithColor(quieroDesarrollarButton, color: UIColor.white, width: 0.5)
        quieroDesarrollarButton.addBottomBorderWithColor(quieroDesarrollarButton, color: UIColor.white, width: 0.5)
        

      enviarButton.layer.cornerRadius = 8*/
        self.tableView.dataSource = self
        self.tableView.delegate = self
        APIManager.sharedInstance.getMetas(onSuccess: { response in
            
            DispatchQueue.main.async {
                 
                self.responseMetas = response
                print(self.responseMetas.data.count)
                self.tableView.reloadData()
            }
        })
        
    
    }

    @IBAction func clickEnviarButton(_ sender: Any) {
         view.isHidden = true
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseMetas.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjetivoTableViewCell", for: indexPath) as! ObjetivoTableViewCell
        cell.objetivo.text = self.responseMetas.data[indexPath.row].nombre
        cell.addBottomBorderWithColor(cell, color: UIColor.white, width: 0.5)
        
        self.activity.isHidden = true
        self.activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.activity.isHidden = false
       self.activity.startAnimating()
         self.view.isUserInteractionEnabled = false
        APIManager.sharedInstance.assignMeta(meta:
        self.responseMetas.data[indexPath.row].id ,onSuccess: { response in
            
            
            
            DispatchQueue.main.async {
                APIManager.sharedInstance.nutritionVC.showDiet(response: response)
                
                self.activity.isHidden = true
                self.activity.stopAnimating()
            
                self.view.isUserInteractionEnabled = true
            }
        })
    }
}
