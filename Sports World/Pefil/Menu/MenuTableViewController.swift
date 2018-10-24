

//
//  MenuTableViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/1/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseAuth
class MenuTableViewController: UITableViewController {
    @IBOutlet weak var eventosButton: UIButton!
    @IBOutlet weak var membresiaButton: UIButton!
    @IBOutlet weak var earnitButton: UIButton!
    @IBOutlet weak var recetasButton: UIButton!
    @IBOutlet weak var inbodyButton: UIButton!
    @IBOutlet weak var tiendaButton: UIButton!
    @IBOutlet weak var cargosButtton: UIButton!
    @IBOutlet weak var facturasButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var comunidadesButton: UIButton!
    var puntos = APIManager.sharedInstance.puntos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.isHidden = true
        //facturasButton.isHidden = true
        //facturasButton.isEnabled = false
        
        //cargosButtton.isHidden = true
        //cargosButtton.isEnabled = false
        
        //tiendaButton.isHidden = true
        //tiendaButton.isEnabled = false
        
        recetasButton.isHidden = true
        //inbodyButton.isHidden = true
        
        
        //////////////////////PERSONALIZA LOS BOTONES////////////////
        eventosButton.addBottomBorderWithColor(eventosButton, color: UIColor.white, width: 0.5)
        membresiaButton.addTopBorderWithColor(membresiaButton, color: UIColor.white, width: 0.5)
        earnitButton.addTopBorderWithColor(earnitButton, color: UIColor.white, width: 0.5)
        earnitButton.addBottomBorderWithColor(earnitButton, color: UIColor.white, width: 0.5)
        tiendaButton.addBottomBorderWithColor(tiendaButton, color: UIColor.white, width: 0.5)
        //inbodyButton.addTopBorderWithColor(inbodyButton, color: UIColor.white, width: 0.5)
        //tiendaButton.addTopBorderWithColor(tiendaButton, color: UIColor.white, width: 0.5)
        inbodyButton.addBottomBorderWithColor(inbodyButton, color: UIColor.white, width: 0.5)
        //cargosButtton.addBottomBorderWithColor(cargosButtton, color: UIColor.white, width: 0.5)
        recetasButton.addBottomBorderWithColor(recetasButton, color: UIColor.white, width: 0.5)
        facturasButton.addBottomBorderWithColor(facturasButton, color: UIColor.white, width: 0.5)
        cargosButtton.addBottomBorderWithColor(cargosButtton, color: UIColor.white, width: 0.5)
        
        comunidadesButton.addBottomBorderWithColor(comunidadesButton, color: UIColor.white, width: 0.5)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    //////////////////CONECTA LAS ACCIONES DE LOS BOTONES//////////////////
    @IBAction func clickFacturasButton(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            self.getHistorialFacturas()
        }
    }
    
    @IBAction func clickComunidadesButton(_ sender: Any) {
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.configureChat()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
    }
    func chatSignUp(){
        Auth.auth().createUser(withEmail:"\(SavedData.getTheUserId())" + "@chatswnormal.com", password:"\(SavedData.getTheUserId())") { (result, error) in
            if let _eror = error {
                //something bad happning
                print(_eror.localizedDescription )
            }else{
                //user registered successfully
                print(result)
                self.configureChat()
            }
        }
    }
    func configureChat(){
        ChatAuth.auth(withEmail: "\(SavedData.getTheUserId())" + "@chatswnormal.com", password:"\(SavedData.getTheUserId())", completion: { (user, error) -> Void in
            if(error != nil){
                
                self.chatSignUp()
            }else{
                let chatm : ChatManager = ChatManager.getInstance()
                
                let imageSufix = SavedData.getTheProfilePic()
                user?.firstname = "normal"//SavedData.getTheName()
                user?.lastname = ""
                
                user?.imageurl = imageSufix
                chatm.start(with: user)
                /*
                 UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                 ChatConversationsVC *chatNC = [sb instantiateViewControllerWithIdentifier:@"MessagesController2"];
                 return chatNC;
 */
                
                ChatManager.getInstance().createContact(for: user, withCompletionBlock: {(error) -> Void in
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessagesController2") as! ChatConversationsVC
                    //let conversationsVC : UINavigationController = ChatUIManager.getInstance().getConversationsViewController()
                    self.navigationController!.pushViewController(newViewController, animated: true)
                    //self.present(conversationsVC, animated: false, completion: nil)
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                })
                
            }
        })
    }
    @IBAction func clickMembresiaButton(_ sender: Any) {
        
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        ExternosAPI.sharedInstance.tipoDeUsuario(completion: { tipo in
            
            DispatchQueue.main.async {
                switch tipo {
                case 1,2:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MembresiaViewController") as! MembresiaViewController
                    self.navigationController!.pushViewController(VC1, animated: true)
                    break;
                case 3:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Externos", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertaExternosA") as! AlertaExternosViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                    break;
                default:
                    break;
                }
            }
            
        })
    }
    @IBAction func clickEarnitButton(_ sender: Any) {
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        ExternosAPI.sharedInstance.tipoDeUsuario(completion: { tipo in
            
            DispatchQueue.main.async {
                switch tipo {
                case 1,2:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if Reachability.isConnectedToNetwork() {
                        self.earnIt()
                    } else {
                        Alert.ShowAlert(title: "", message: "No cuentas con internet, verifica tu conexión o intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                    }
                    break;
                case 3:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Externos", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertaExternosA") as! AlertaExternosViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                    break;
                default:
                    break;
                }
            }
            
        })
    }
    @IBAction func clickInbodyButton(_ sender: Any) {
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        ExternosAPI.sharedInstance.tipoDeUsuario(completion: { tipo in
            
            DispatchQueue.main.async {
                switch tipo {
                case 1,2:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if Reachability.isConnectedToNetwork() {
                        self.getLastInbody()
                    }
                    break;
                case 3:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Externos", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertaExternosA") as! AlertaExternosViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                    break;
                default:
                    break;
                }
            }
            
        })
        
    }
    
    @IBAction func clickRecetasButton(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "RecetasViewController") as! RecetasViewController
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }
    
    @IBAction func clickTiendaButton(_ sender: Any) {
        
    }
    @IBAction func clickCargosButton(_ sender: Any) {
        self.getThePendingCharges()
    }
    
    
    //////////////////LLAMA A LOS CARGOS/////////////
    
    func getLastInbody(){
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.getHistorialInbody()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            
            
            APIManager.sharedInstance.getLastInbody(onSuccess: { json in
                DispatchQueue.main.async {
                    if (json == JSON.null) {
                        Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "ACEPTAR", in: self)
                    } else {
                        if APIManager.sharedInstance.satusString == "ok" {
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            
                            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "RutinasViewController") as! RutinasViewController
                            self.navigationController!.pushViewController(VC1, animated: true)
                        } else {
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            
                            self.view.isUserInteractionEnabled = true
                            // Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "ACEPTAR", in: self)
                            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "RutinasViewController") as! RutinasViewController
                            self.navigationController!.pushViewController(VC1, animated: true)
                        }
                    }
                }
                
            })
        })
        
    }
    
    
    func getHistorialInbody(){
        //APIManager.sharedInstance.lastInbody2 = []
        //APIManager.sharedInstance.mes = []
        
        APIManager.sharedInstance.pesoInbody2 = []
        APIManager.sharedInstance.estaturaInbody2 = []
        APIManager.sharedInstance.mineralesInbody2 = []
        APIManager.sharedInstance.actInbody2 = []
        APIManager.sharedInstance.mcgInbody2 = []
        APIManager.sharedInstance.imcInbody2 = []
        APIManager.sharedInstance.mmeInbody2 = []
        APIManager.sharedInstance.actInbody2 = []
        APIManager.sharedInstance.rccInbody2 = []
        APIManager.sharedInstance.pgcInbody2 = []
        APIManager.sharedInstance.mes = []
        
        APIManager.sharedInstance.getHistorialInbody(onSuccess: { json in
            DispatchQueue.main.async {
                if (json == JSON.null) {
                    Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "ACEPTAR", in: self)
                } else {
                    if APIManager.sharedInstance.codeMessage == 200 {
                        
                    } else {
                        
                 
                    }
                }
            }
            
        })
        
        
    }
    func getThePendingCharges(){
        self.view.isUserInteractionEnabled = false
        activity.startAnimating()
        activity.isHidden = false
        APIManager.sharedInstance.totalImportes = []
        APIManager.sharedInstance.totalDescripciones = []
        APIManager.sharedInstance.getPendingCharges(onSuccess: { json in
            DispatchQueue.main.async {
                
                if APIManager.sharedInstance.status == true {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "CargosPendietesViewController") as! CargosPendietesViewController
                    self.navigationController!.pushViewController(VC1, animated: true)
                } else {
                    if (json == JSON.null) {
                        Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "ACEPTAR", in: self)
                    }
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "ACEPTAR", in: self)
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                }
                
            }
            
            
        }, onFailure: { error in
            self.activity.isHidden = true
            self.activity.stopAnimating()
        })
        
    }
    
    ////////////////LLAMA A REQUEST////////////////////////////////////
    
    func getHistorialFacturas() {
        APIManager.sharedInstance.pdfs = []
        APIManager.sharedInstance.folios = []
        APIManager.sharedInstance.importes = []
        APIManager.sharedInstance.fechas = []
        
        
        self.view.isUserInteractionEnabled = false
        activity.startAnimating()
        activity.isHidden = false
        APIManager.sharedInstance.getListadoFacturas(onSuccess: { json in
            DispatchQueue.main.async {
                
                if APIManager.sharedInstance.codeMessage == 200 {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "FacturasViewController") as! FacturasViewController
                    self.navigationController!.pushViewController(VC1, animated: true)
                } else {
                    if (json == JSON.null) {
                        Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "ACEPTAR", in: self)
                    }
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "ACEPTAR", in: self)
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                
            }
            
            
        }, onFailure: { error in
            self.activity.isHidden = true
            self.activity.stopAnimating()
        })
        
    }
    func earnIt() {
        activity.isHidden = false
        activity.startAnimating()
        view.isUserInteractionEnabled = false
        APIManager.sharedInstance.earnIt(userId: SavedData.getTheUserId(), onSuccess: { json in
            
            DispatchQueue.main .async {
                
                if APIManager.sharedInstance.status == true {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: "Puntos: \(APIManager.sharedInstance.puntos ?? 0)", titleForTheAction: "Aceptar", in: self)
                } else if APIManager.sharedInstance.status == false  {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: "El usuario no existe.", titleForTheAction: "Aceptar", in: self)
                } else {
                    if (json == JSON.null) {
                        Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "ACEPTAR", in: self)
                    }
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: "Puntos: \(APIManager.sharedInstance.puntos ?? 0)", titleForTheAction: "Aceptar", in: self)
                }
            }
        }, onFailure: { error in
            self.activity.isHidden = true
            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "Aceptar", in: self)
        })
    }
    
    @IBAction func clickEventosButton(_ sender: Any) {
        
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "EventosMainViewController") as! EventosMainViewController
        self.navigationController!.pushViewController(VC1, animated: true)
        
        
    }
    
    
}
