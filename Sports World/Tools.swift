//
//  Tools.swift
//  Sports World
//
//  Created by Glauco Valdes on 6/11/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import Foundation

extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
    }
}

public func removeTimeStamp(fromDate: Date) -> Date {
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
        fatalError("Failed to strip time from Date object")
    }
    return date
}

extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale!
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.dateFormat = "MMMM"
      
       
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
    var buffer = [T]()
    var added = Set<T>()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}
open class Tools{
    static func clearAllFilesFromTempDirectory(){
        
        
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
        
    }
    static func getHash()->String{
        
        let date = Date()
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        
        let timestamp : Double = makeDate(year: year, month: month, day: day, hr: 0, min: 0, sec: 0  ).timeIntervalSince1970
        
        
        return String(String(format: timestamp == floor(timestamp) ? "%.0f" : "%.1f", timestamp) + "#sportsworldMX$")
    }
    static    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        // calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }
    
}
public enum UIButtonBorderSide {
    case top, bottom, left, right
}

extension UIActivityIndicatorView {
    
    public func showActivity(viewController: UIViewController) {
        self.isHidden = false
        self.startAnimating()
        viewController.view.isUserInteractionEnabled = false
    
}
    public func hideActivity(viewController: UIViewController) {
        self.isHidden = true
        self.stopAnimating()
        viewController.view.isUserInteractionEnabled = true 
        
    }
    
}

extension UIView {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - 2.0, width: self.frame.size.width, height: 2.0)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension UIImageView {
    
    public func downloadImage(downloadURL : String, completion: @escaping (Bool?) -> ()) {
        
        
        if (self.image == nil){
            self.image = UIImage(named: "profileDefault")
        }
        //let imageSufix =  "profile-" + userAppfterId
        //self.image = UIImage(named: "profileDefault")
        if(downloadURL != ""){
            URLSession.shared.dataTask(with: URL(string: downloadURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, completionHandler: { (data, response, error) -> Void in
                guard
                    let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                    let data = data , error == nil,
                    let imageLocal = UIImage(data: data)
                    else {
                        
                        
                        /*let fbUrl = "https://graph.facebook.com/" + fbId + "/picture?type=large"
                         
                         URLSession.shared.dataTask(with: URL(string: fbUrl)!, completionHandler: { (data, response, error) -> Void in
                         guard
                         let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                         let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                         let data = data , error == nil,
                         let imageLocal = UIImage(data: data)
                         else { completion(true)
                         return }
                         DispatchQueue.main.async { () -> Void in
                         self.image = imageLocal
                         completion(true)
                         }
                         }).resume()*/
                        
                        completion(true)
                        return
                }
                
                
                DispatchQueue.main.async { () -> Void in
                    
                    self.image =  imageLocal
                    completion(true)
                    
                    
                    
                    
                }
            }).resume()
        }else{
            completion(true)
        }
        
    }
    public func downloadImageSync(downloadURL : String, completion: @escaping (Bool?) -> ()) {
        
        
        if (self.image == nil){
            self.image = UIImage(named: "profileDefault")
        }
        //let imageSufix =  "profile-" + userAppfterId
        //self.image = UIImage(named: "profileDefault")
        let fullNameArr : [String] = downloadURL.components(separatedBy: "/")
        let imageSufix =  fullNameArr.count > 1 ? fullNameArr[fullNameArr.count - 1] : nil
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("rutina-\(imageSufix)")
        if FileManager.default.fileExists(atPath: filePath.path) {
            
            self.image = UIImage(contentsOfFile: filePath.path)
            
        }else{
            if(downloadURL != ""){
                URLSession.shared.dataTask(with: URL(string: downloadURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, completionHandler: { (data, response, error) -> Void in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                        let data = data , error == nil,
                        let imageLocal = UIImage(data: data)
                        else {
                            
                            
                            /*let fbUrl = "https://graph.facebook.com/" + fbId + "/picture?type=large"
                             
                             URLSession.shared.dataTask(with: URL(string: fbUrl)!, completionHandler: { (data, response, error) -> Void in
                             guard
                             let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                             let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                             let data = data , error == nil,
                             let imageLocal = UIImage(data: data)
                             else { completion(true)
                             return }
                             DispatchQueue.main.async { () -> Void in
                             self.image = imageLocal
                             completion(true)
                             }
                             }).resume()*/
                            
                            completion(true)
                            return
                    }
                    
                    
                    DispatchQueue.main.async { () -> Void in
                        
                        do {
                            try data.write(to:filePath)
                            
                        } catch {
                            print(error.localizedDescription)
                            
                        }
                        self.image =  imageLocal
                        completion(true)
                        
                        
                        
                        
                    }
                }).resume()
            }else{
                completion(true)
            }
        }
    }
}
extension URLRequest {
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func encodeParameters(parameters: [String : String]) {
        httpMethod = "POST"
        
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
}

extension Collection where Iterator.Element == Any {
    /*var doubleArrayFromStrings: [Double] {
     return compactMap{ Double($0 as? String ?? "") }
     }*/
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
private var keyboardHandlerKey: Void?
private var associatedTextFieldKey: Void?

extension UIViewController {
    
    //Calibra movimiento con una notificación en Keyboard de scroll para teclado dependiendo dispositivo
    func moveTextFieldForKeyBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            //let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -150 // Move view 150 points upward
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    var keyboardHandler: ( (String) -> Void )? {
        get {
            return objc_getAssociatedObject(self, &keyboardHandlerKey) as? ( (String) -> Void )
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &keyboardHandlerKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var associatedTextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &associatedTextFieldKey) as? UITextField
        }
        
        set {
            objc_setAssociatedObject(self,
                                     &associatedTextFieldKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func addToolBarInTextField(_ textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = #colorLiteral(red: 0.9019607843, green: 0.1607843137, blue: 0.2156862745, alpha: 1)
        toolBar.barTintColor = #colorLiteral(red: 0.9521105886, green: 0.956189096, blue: 0.9692507386, alpha: 1)
        
        let button = UIButton(type: .system)
        button.setTitleColor(#colorLiteral(red: 0.9019607843, green: 0.1607843137, blue: 0.2156862745, alpha: 1), for: .normal)
        button.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(UIViewController.donePressed), for: .touchUpInside)
        
        let doneButton = UIBarButtonItem(customView: button)
        button.sizeToFit()
        //        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        //        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(){
        view.endEditing(true)
    }
    @objc func cancelPressed(){
        view.endEditing(true) // or do something
    }
}

