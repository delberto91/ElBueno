//
//  CublesTableViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 16/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class CublesTableViewController: UITableViewController {
    @IBOutlet var tabView: UITableView!
    private let cell = "ClubesTableViewCell"
    var stringArray: [String] = ["Cerca de mi", "Favoritos", "Próximas aperturas"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.rowHeight = 94

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  stringArray.count
        
    }

   

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! ClubesTableViewCell
        cel.labelView.text = stringArray[indexPath.row]
        return cel

    }
    

  
}
