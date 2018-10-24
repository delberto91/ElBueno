//
//  AlertaExternosViewController.swift
//  Sports World
//
//  Created by Martin Rodriguez on 10/20/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class AlertaExternosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    @IBAction func cerrar(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func comprar(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "RegistoExternos", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RegistroExternos") as! RegistroExternosViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
