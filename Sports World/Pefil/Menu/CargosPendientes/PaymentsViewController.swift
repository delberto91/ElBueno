//
//  PaymentsViewController.swift
//  SW_etapa_IV
//
//  Created by Mario Canto on 8/1/18.
//  Copyright © 2018 Aldo Gutierrez Montoya. All rights reserved.
//

import UIKit
final class PaymentsViewController: UIViewController {
    var mes : String! = ""
    var año: String! = ""
    var cvv: String! = ""
    var cardHolderName: String! = ""
    var numeroTarjeta: String! = ""
    var pago : [Pago] = [Pago] ()
    private let maxNumberOfCharacters = 16
    private let maxMonth = 2
    private let maxYear = 2
    private let maxCVV = 3
    var productoData: [ProductoCobroData] = [ProductoCobroData]()
    var isProducto = false
    
    private lazy var yearPickerDataSource: YearPickerDataSourceAndDelegate = {
        return $0
    }(YearPickerDataSourceAndDelegate())
    
    private lazy var yearPickerView: UIPickerView = {
        $0.showsSelectionIndicator = true
        $0.dataSource = $1
        $0.delegate = $1
        return $0
    }(UIPickerView(), yearPickerDataSource)
    
    private lazy var monthPickerDataSource: MonthPickerDataSourceAndDelegate = {
        return $0
    }(MonthPickerDataSourceAndDelegate())
    
    private lazy var monthPickerView: UIPickerView = {
        $0.showsSelectionIndicator = true
        $0.dataSource = $1
        $0.delegate = $1
      return $0
    }(UIPickerView(), monthPickerDataSource)
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    //@IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var creditCardName: UITextField!
    @IBOutlet weak var creditCardExpireMonth: UITextField! {
        didSet {
            activity.isHidden = true
            creditCardExpireMonth.inputView = monthPickerView
            creditCardExpireMonth.delegate = self
            monthPickerDataSource.didSelectMonth = { [weak self] monthInt, monthUI, monthName in
                self?.creditCardExpireMonth.text = monthUI
            }
            addToolBarInTextField(creditCardExpireMonth)
        }
    }
    @IBOutlet weak var creditCardExpireYear: UITextField! {
        didSet {
        //Aqui has lo del de pintar los botones del picker .
            creditCardExpireYear.inputView = yearPickerView
            creditCardExpireYear.delegate = self
            yearPickerDataSource.didSelectYear = { [weak self] yearUI in
                self?.creditCardExpireYear.text = yearUI.description
            }
            addToolBarInTextField(creditCardExpireYear)
        }
    }
    @IBOutlet weak var creditCardNumber: UITextField! {
        didSet {
            creditCardNumber.delegate = self
        }
    }
    @IBOutlet weak var creditCardCCV: UITextField! {
        didSet {
            creditCardCCV.delegate = self
        }
    }
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var pagarButton: UIButton!
    
  //  @IBAction func segmentedValueDidChange(_ sender: SegmentedControl) {
   // }
    func conekta() {
        if self.creditCardName.text! == "" || self.creditCardCCV.text! == "" || self.creditCardNumber.text! == "" || self.creditCardExpireYear.text! == "" || self.creditCardExpireMonth.text! == "" {
            
            Alert.ShowAlert(title: "", message: "Debes completar todos los campos para continuar.", titleForTheAction: "Aceptar", in: self)
        } else if self.creditCardNumber.text!.count < 16 || self.creditCardCCV.text!.count < 3{
            Alert.ShowAlert(title: "", message: "Por favor verifica que los dígitos de los campos estén completos.", titleForTheAction: "Aceptar", in: self)
        } else {
            let conekta = Conekta()
            
            conekta.delegate = self
            
            conekta.publicKey = "key_fr9VAocpABR3nyYxHW9bhag"
            
            
            conekta.collectDevice()
            
            let card = conekta.card()
            
            card?.setNumber(numeroTarjeta!, name: cardHolderName!, cvc: cvv!, expMonth: mes!, expYear: año!)
            
            let token = conekta.token()
            
            token?.card = card
            
            token?.create(success: { (data) -> Void in
                if let dataConverted = data as? Dictionary<String,AnyObject> {
                    print("pinche data", dataConverted)
                    if  let token = dataConverted["id"] as? String {
                    print("pinche token", token)
                        
                        
                    SavedData.settokenConekta(tokenConekta: token)
                        
                        if self.isProducto == true {
                            self.makeThePayMentForProduct()
                            self.isProducto = false
                        } else {
                            self.makePayment()
                        }
                    
                    }
                   // Alert.ShowAlert(title: "", message: "Verifica los datos ", titleForTheAction: "Aceptar", in: self)
                }
            }, andError: { (error) -> Void in
                print(error ?? "")
            })
        }
    
            
    }
    
    @IBAction func didTapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    func makePayment() {
  
            self.activity.isHidden = false
            self.activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            APIManager.sharedInstance.makePayment(token_id: SavedData.gettokenConekta(), idMovimiento: idMovimientoFinal, onSuccess: { json in
                
                DispatchQueue.main .async {
                    
                    if json.code == 200 {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        Alert.ShowAlert(title: "ACEPTAR", message: json.message, titleForTheAction: "ACEPTAR", in: self)
                    } else {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        Alert.ShowAlert(title: "ACEPTAR", message: json.message, titleForTheAction: "ACEPTAR", in: self)
                    }
                    
                }
            }, onFailure: { error in
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                Alert.ShowAlert(title: "ACEPTAR", message: "Hubo un error intenta mas tarde", titleForTheAction: "ACEPTAR", in: self)
            })
        }
        
    
    
    @IBAction func acceptWasPressed(_ sender: Any) {
        //conekta()
      self.makeThePayMentForProduct()
}
    
    @IBAction func backWasPressed(_ sender: Any) {
    }
    
    //Has el pago del producto.
    func makeThePayMentForProduct() {

            activity.showActivity(viewController: self)
            APIManagerV.sharedInstance.makePaymentForProducto(onSuccess:  { response in
                
                DispatchQueue.main.async {
                    
                    self.productoData = response.data
                    if response.code == 200 {
                        Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                        self.activity.hideActivity(viewController: self)
                        
                    } else {
                        
                        self.activity.hideActivity(viewController: self)
                        Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                    }
                }
                
            })
        }
    
}

extension PaymentsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagarButton.layer.cornerRadius = 8.0
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Pago", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

    }
    
}

extension PaymentsViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == creditCardExpireMonth {
            monthPickerView.delegate = nil
        }
        
        if textField == creditCardExpireYear {
            yearPickerView.delegate = nil
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == creditCardExpireMonth {
            monthPickerView.delegate = monthPickerDataSource
        }
        
        if textField == creditCardExpireYear {
            yearPickerView.delegate = yearPickerDataSource
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == creditCardExpireMonth {
            textField.text = monthPickerDataSource.selectedItem.uiFormatted
            mes = textField.text!
            print(" mes", mes!)
            return
        }
        
        if textField == creditCardExpireYear {
            textField.text = yearPickerDataSource.selectedYear.description
            año = textField.text!
             print(" año", año!)
            return
        }
        if textField == creditCardName {
            cardHolderName! = textField.text!
            print(" cardHolderName!!", cardHolderName!)
            return
        }
        if textField == creditCardNumber {
            numeroTarjeta! = textField.text!
            print(" numeroTarjeta!", numeroTarjeta!)
            return
        }
        
        if textField == creditCardCCV {
            cvv! = textField.text!
            print(" cvv!", cvv!)
            return

        }
    }
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == creditCardNumber {
            guard string.compactMap({ Int(String($0)) }).count == string.count else {
                
              
                return false
            }
            
            let text = textField.text!
          
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 4, withSeparator: " ")
            } else {
                let formatted = String(text + string)
                    .filter({ $0 != " " })
                    .prefix(maxNumberOfCharacters)
                textField.text = String(formatted).chunkFormatted(withChunkSize: 4, withSeparator: " ")
               
               
            }
            
            return false
        }
        
        
        if textField == creditCardCCV {
            guard string.compactMap({ Int(String($0)) }).count == string.count else {
                return false
            }
            
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 3, withSeparator: " ")
            } else {
                let formatted = String(text + string)
                    .filter({ $0 != " " })
                    .prefix(maxCVV)
                textField.text = String(formatted).chunkFormatted(withChunkSize: 3, withSeparator: " ")
            }
            
            return false
        }
        
        return true
        
    }
}

final class YearPickerDataSourceAndDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    private let years: [Int] = (2018...(2018 + 10)).map({ $0 })
    
    var didSelectYear: ( (Int) -> Void )?
    var selectedYear: Int = 2018 {
        didSet {
            didSelectYear?(selectedYear)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYear = years[row]
        }
        
    }
    
}

final class MonthPickerDataSourceAndDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "MMMM"
        return $0
    }(DateFormatter())
    private let months: [(Int, String)] = (1...12).compactMap({
        var components = DateComponents()
        components.year = 2018
        components.month = $0
        components.day = 1
        guard let date = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: components) else {
            return nil
        }
        return ($0, MonthPickerDataSourceAndDelegate.dateFormatter.string(from: date))
    })
    
    var didSelectMonth: ( (Int, String,  String) -> Void )?
    lazy var selectedItem: (index: Int, uiFormatted: String,  monthName: String) = {
        return ($0[0].0, String(format: "%02d", $0[0].0), $0[0].1)
    }(months)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row].1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = (months[row].0, String(format: "%02d", months[row].0), months[row].1)
        didSelectMonth?(months[row].0, String(format: "%02d", months[row].0), months[row].1)
    }
    
}

extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
                        withSeparator separator: Character = "-") -> String {
        
        return
            self
            .filter { $0 != separator }
            .chunk(n: chunkSize)
            .map{ String($0) }
            .joined(separator: String(separator))
    }
}


