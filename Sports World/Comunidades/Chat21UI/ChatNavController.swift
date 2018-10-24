//
//  ChatNavController.swift
//  AppfterSwift
//
//  Created by Glauco Valdes on 9/20/18.
//  Copyright © 2018 Glauco Valdes. All rights reserved.
//

import UIKit

class ChatNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        self.navigationBar.barTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        // Do any additional setup after loading the view.
        
        let backGroudColor : UIColor = UIColor.clear
        
        //self.tabBarController?.tabBar.backgroundColor = backGroudColor
        //self.tabBarController?.tabBar.tintColor = backGroudColor
        self.navigationBar.backgroundColor = backGroudColor
        self.navigationBar.barTintColor = backGroudColor
        
       // self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
