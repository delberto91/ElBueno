//
//  RegistroExternosTableViewController.swift
//  Sports World
//
//  Created by Martin Rodriguez on 10/18/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

var nombreRegistroExterno: String = ""
var paternoRegistroExterno: String = ""
var maternoRegistroExterno: String = ""
var nacimientoRegistroExterno: String = ""
var correoRegistroExterno: String = ""
var telefonoExterno: String = ""
var contraseñaExterno : String = ""
class RegistroExternosTableViewController: UITableViewController {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var paterno: UITextField!
    @IBOutlet weak var materno: UITextField!
    @IBOutlet weak var nacimiento: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var contraseña: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        configuraVista(vista: nombre)
        configuraVista(vista: paterno)
        configuraVista(vista: materno)
        configuraVista(vista: nacimiento)
        configuraVista(vista: correo)
        configuraVista(vista: telefono)
        configuraVista(vista: contraseña)
        nombreRegistroExterno = "parangaricutirimicuaro"
        
    }
    
    func configuraVista(vista : UITextField){
        
        let borde = CALayer()
        borde.backgroundColor = UIColor.red.cgColor
        borde.frame = CGRect(x: 5, y: vista.frame.size.height - 2.0, width: vista.frame.size.width - 10.0, height: 2.0)
        vista.layer.addSublayer(borde)
        vista.backgroundColor = UIColor.lightGray.withAlphaComponent(1/3)
        vista.layer.cornerRadius = 8
        
    }

    var valorInicialFecha = ""
    @IBAction func nacimientoInicio(_ sender: UITextField) {
        self.valorInicialFecha = sender.text ?? ""
        
        let fechaPickerView = UIDatePicker()
        fechaPickerView.datePickerMode = .date
        sender.inputView = fechaPickerView
        fechaPickerView.addTarget(self, action: #selector(cambiarFechaPicker(sender:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
        toolBar.sizeToFit()
        
        let aceptarBoton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(aceptarClick))
        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelarBoton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelarClick))
        toolBar.setItems([aceptarBoton, espacio, cancelarBoton], animated: false)
        toolBar.isUserInteractionEnabled = true
        sender.inputAccessoryView = toolBar
        
        aceptarBoton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.darkGray],
                                          for: .normal)
        
        cancelarBoton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.darkGray],
                                            for: .normal)
    }
    
    @objc func aceptarClick() {
        
        nacimiento?.resignFirstResponder()
    }
    
    @objc func cancelarClick() {
        nacimiento?.text = valorInicialFecha
        nacimiento?.resignFirstResponder()
    }
    @objc func cambiarFechaPicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        nacimiento.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nacimientoRegistroExterno = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func nombreCambia(_ sender: Any) {
        nombreRegistroExterno = (sender as? UITextField)?.text ?? ""
    }
    @IBAction func paternoCambia(_ sender: Any) {
        paternoRegistroExterno = (sender as? UITextField)?.text ?? ""
    }
    @IBAction func maternoCambia(_ sender: Any) {
        maternoRegistroExterno = (sender as? UITextField)?.text ?? ""
    }
    @IBAction func nacimientoCambia(_ sender: Any) {
        //nacimientoRegistroExterno = (sender as? UITextField)?.text ?? ""
    }
    @IBAction func correoCambia(_ sender: Any) {
        correoRegistroExterno = (sender as? UITextField)?.text ?? ""
    }
    @IBAction func telefonoCambia(_ sender: Any) {
        telefonoExterno = (sender as? UITextField)?.text ?? ""
    }
    @IBAction func contraseñaCambia(_ sender: Any) {
        contraseñaExterno = (sender as? UITextField)?.text ?? ""
    }
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
