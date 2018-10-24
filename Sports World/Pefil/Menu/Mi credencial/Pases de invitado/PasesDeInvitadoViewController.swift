//
//  PasesDeInvitadoViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit


class PasesDeInvitadoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    private let cell = "PasesDeInvitadoTableViewCell"

    var pases : [PasesPorAsignar] = [PasesPorAsignar]()

    var arrayOfVigencias = APIManager.sharedInstance.finVigencia
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Pases de invitado", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        containerView.isHidden = true 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPasesInvitadoPorAsignar()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! PasesDeInvitadoTableViewCell
        cel.numberOfPass.text = self.pases[indexPath.row].nombre
        cel.vigencia.text! = self.pases[indexPath.row].finVigencia
        
        return cel 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "EnviaPaseViewController") as? EnviaPaseViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            containerView.isHidden = true
           tabView.isHidden = false
        } else if sender.selectedSegmentIndex == 1 {
            containerView.isHidden = false
            tabView.isHidden = true 
        }
    }
    func getPasesInvitadoPorAsignar() {
        APIManager.sharedInstance.getPasesDeInvitadoPorAsignar(onSuccess: { response in
            DispatchQueue.main.async {
                if response.data.count == 0 {
                    
                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                    
                } else {
                    self.pases = response.data
                    self.tabView.reloadData()
                }
                
            }
            
        })
        
    }
    
}
