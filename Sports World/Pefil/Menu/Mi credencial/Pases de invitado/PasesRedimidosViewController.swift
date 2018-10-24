//
//  PasesRedimidosViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class PasesRedimidosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arrayOfProducto = APIManager.sharedInstance.productoPaseInvitado
    var arrayCuando = APIManager.sharedInstance.cuandoPaseInvitado
    var pasesRedimidos : [Pases] = [Pases]()
    var arrayOfVigencias = ["12/12/2012","12/12/2012","12/12/2012"]
    
    @IBOutlet weak var tabView: UITableView!
    private let cell = "PasesRedimidosTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
      
      tabView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getPasesInvitado()
    }
    
    func getPasesInvitado() {
        APIManager.sharedInstance.getPasesDeInvitado(onSuccess: { response in
            DispatchQueue.main.async {
                self.pasesRedimidos = response.data
                self.tabView.reloadData()
            }
            
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pasesRedimidos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! PasesRedimidosTableViewCell
        cel.tituloPase.text = pasesRedimidos[indexPath.row].producto
        cel.vigenciaPase.text = pasesRedimidos[indexPath.row].cuando
        return cel
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
