//
//  MyComunityDescriptionViewController.swift
//  Sports World
//
//  Created by Glauco Valdes on 10/21/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

@objc class MyComunityDescriptionViewController: UIViewController {

     public var selectedGroupId : String = ""
    public var descripcion : String = ""
    public var usersQty : String = ""
    public var name : String = ""
    public func setup (_selectedGroupId : String,_descripcion : String,_usersQty : String,_name : String){
        self.selectedGroupId = _selectedGroupId
        self.descripcion = _descripcion
        self.usersQty = _usersQty
        self.name = _name
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*self.groupName.text = self.name as String
        self.descriptionText.text = self.descripcion as String
        self.count.text = self.usersQty as String*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBAction func openChat(_ sender: Any) {
    }
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goAviso(_ sender: Any) {
    }
}
