//
//  ExternosAPI.swift
//  Sports World
//
//  Created by Martin Rodriguez on 10/18/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import Foundation
import SwiftyJSON

class EstadoUsuarioResponse: Codable {
    var code : Int
    var message : String
    var data : EstadoUsuarioData
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            self.code = 400
            self.message = ""
            self.data = EstadoUsuarioData()
            return
        }
        self.code = dictionary["code"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.data = EstadoUsuarioData(with: dictionary["data"] as? [String : Any])
        
    }
    
    init(){
        
        self.code = 400
        self.message = ""
        self.data = EstadoUsuarioData()
        return
    }
}

class EstadoUsuarioData : Codable{
    var tipo : Int
    var fecha : String
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            self.tipo = 0
            self.fecha = ""
            return
        }
        self.tipo = dictionary["tipo"] as? Int ?? 0
        self.fecha = dictionary["fecha"] as? String ?? ""
    }
    
    init(){
        self.tipo = 0
        self.fecha = ""
    }
}

class UsuarioInformacionResponse: Codable {
    var code : Int
    var message : String
    var data : UserData
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            self.code = 400
            self.message = ""
            self.data = UserData()
            return
        }
        self.code = dictionary["code"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.data = UserData(with: dictionary["data"] as? [String : Any])
        
    }
    
    init(){
        
        self.code = 400
        self.message = ""
        self.data = UserData()
        return
    }
}
class RegistroRequest : Codable{
    var nombre : String
    var paterno : String
    var materno : String
    var fechaNacimiento : String
    var email : String
    var telefono : String
    var password : String
    
    init(nombre : String,paterno : String,materno : String,fechaNacimiento : String,
         email : String,telefono : String,password: String){
        self.nombre = nombre
        self.paterno = paterno
        self.materno = materno
        self.fechaNacimiento  = fechaNacimiento
        self.email = email
        self.telefono = telefono
        self.password = password
    }
}

class RegistroResponse : Codable{
    var code : Int
    var message : String
    var data : RegistroResponseData
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {  self.code = 400
            self.message = ""
            self.data = RegistroResponseData()
            return
        }
        self.code = dictionary["code"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.data = RegistroResponseData(with: dictionary["data"] as? [String : Any])
    }
    init(code : Int,message : String,data : RegistroResponseData){
        self.code = code
        self.message = message
        self.data = data
    }
    init(){
        self.code = 400
        self.message = ""
        self.data = RegistroResponseData()
    }
}

class RegistroResponseData : Codable{
    var idPersona : Int
    var idProspecto : Int
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            self.idPersona = 0
            self.idProspecto = 0
            return
        }
        self.idPersona = dictionary["idPersona"] as? Int ?? 0
        self.idProspecto = dictionary["idProspecto"] as? Int ?? 0
    }
    init(idPersona : Int,idProspecto : Int){
        self.idPersona = idPersona
        self.idProspecto = idProspecto
    }
    
    init(){
        self.idPersona = 0
        self.idProspecto = 0
    }
}

class LoginResponse: Codable {
    var code : Int
    var message : String
    var data : UserData
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            self.code = 400
            self.message = ""
            self.data = UserData()
            return
        }
        self.code = dictionary["code"] as? Int ?? 0
        self.message = dictionary["message"] as? String ?? ""
        self.data = UserData(with: dictionary["data"] as? [String : Any])
        
    }
    
    init(){
    
            self.code = 400
            self.message = ""
            self.data = UserData()
            return
        }
}

class UserData: Codable {
    var user_id : Int
    var name : String
    var club : String
    var idclub : Int
    var memunic_id : Int
    var membernumber : Int
    var tallest : Double
    var weight : Double
    var age : Int
    var register_date : String
    var gender : String
    var genderId : Int
    var mail : String
    var dob : String
    var mainteiment : String
    var member_type : String
    var usuario : String
    var profile_photo : String
    var api_route : String
    var idroutine : Int
    var secret_key : String
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            
            self.user_id = 0
            self.name = ""
            self.club = ""
            self.idclub = 0
            self.memunic_id = 0
            self.membernumber = 0
            self.tallest = 0
            self.weight = 0
            self.age = 0
            self.register_date = ""
            self.gender = ""
            self.genderId = 0
            self.mail = ""
            self.dob = ""
            self.mainteiment = ""
            self.member_type = ""
            self.usuario = ""
            self.profile_photo = ""
            self.api_route = ""
            self.idroutine = 0
            self.secret_key = ""
            return
        }
        
        self.user_id = dictionary["user_id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.club = dictionary["club"] as? String ?? ""
        self.idclub = dictionary["idclub"] as? Int ?? 0
        self.memunic_id = dictionary["memunic_id"] as? Int ?? 0
        self.membernumber = dictionary["membernumber"] as? Int ?? 0
        self.tallest = dictionary["tallest"] as? Double ?? 0
        self.weight = dictionary["weight"] as? Double ?? 0
        self.age = dictionary["age"] as? Int ?? 0
        self.register_date = dictionary["register_date"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.genderId = dictionary["genderId"] as? Int ?? 0
        self.mail = dictionary["mail"] as? String ?? ""
        self.dob = dictionary["dob"] as? String ?? ""
        self.mainteiment = dictionary["mainteiment"] as? String ?? ""
        self.member_type = dictionary["member_type"] as? String ?? ""
        self.usuario = dictionary["usuario"] as? String ?? ""
        self.profile_photo = dictionary["profile_photo"] as? String ?? ""
        self.api_route = dictionary["api_route"] as? String ?? ""
        self.idroutine = dictionary["idroutine"] as? Int ?? 0
        self.secret_key = dictionary["secret_key"] as? String ?? ""
        
    }
    init() {
        
            
            self.user_id = 0
            self.name = ""
            self.club = ""
            self.idclub = 0
            self.memunic_id = 0
            self.membernumber = 0
            self.tallest = 0
            self.weight = 0
            self.age = 0
            self.register_date = ""
            self.gender = ""
            self.genderId = 0
            self.mail = ""
            self.dob = ""
            self.mainteiment = ""
            self.member_type = ""
            self.usuario = ""
            self.profile_photo = ""
            self.api_route = ""
            self.idroutine = 0
            self.secret_key = ""
            return
        }
}
class ExternosAPI: NSObject {
    static let sharedInstance = ExternosAPI()
    
    func registrar(registroRequest : RegistroRequest, completion: @escaping (RegistroResponse) -> Void ) {
        
        let url = URL(string: "https://sandbox.sportsworld.com.mx/app/api/v1/registroExterno")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(registroRequest)
        var respuesta : RegistroResponse = RegistroResponse()
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(respuesta)
                return
            }
            
            do {
                let respuestaJson = try JSONSerialization.jsonObject(with: data)
                respuesta = RegistroResponse(with: respuestaJson as? [String : Any])
                completion(respuesta)
                print(respuesta)
            } catch let parseError {
                completion(respuesta)
                print(parseError)
            }
            }.resume()
    }
    
    func login(llave : String, completion: @escaping (LoginResponse) -> Void ) {
        
        let url = URL(string: "https://sandbox.sportsworld.com.mx/app/api/v1/login_new")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.addValue(llave, forHTTPHeaderField: "auth-key")
        
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject:  [:], options: []) else {
            return
        }
        request.httpBody = httpBody
        var respuesta : LoginResponse = LoginResponse()
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(respuesta)
                return
            }
            
            do {
                let respuestaJson = try JSONSerialization.jsonObject(with: data)
                respuesta = LoginResponse(with: respuestaJson as? [String : Any])
                completion(respuesta)
                print(respuesta)
            } catch let parseError {
                completion(respuesta)
                print(parseError)
            }
            }.resume()
    }
    
    func estado(completion: @escaping (EstadoUsuarioResponse) -> Void ) {
        
        let url = URL(string: "https://sandbox.sportsworld.com.mx/app/api/v1/estatusUsuario/\(SavedData.getTheUserId())")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject:  [:], options: []) else {
            return
        }
        request.httpBody = httpBody
        var respuesta : EstadoUsuarioResponse = EstadoUsuarioResponse()
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(respuesta)
                return
            }
            
            do {
                let respuestaJson = try JSONSerialization.jsonObject(with: data)
                respuesta = EstadoUsuarioResponse(with: respuestaJson as? [String : Any])
                completion(respuesta)
                print(respuesta)
            } catch let parseError {
                completion(respuesta)
                print(parseError)
            }
            }.resume()
    }
    
    func informacionUsuario(completion: @escaping (UsuarioInformacionResponse) -> Void ) {
        
        let url = URL(string: "https://sandbox.sportsworld.com.mx/app/api/v1/userInfo/\(SavedData.getTheUserId())")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject:  [:], options: []) else {
            return
        }
        request.httpBody = httpBody
        var respuesta : UsuarioInformacionResponse = UsuarioInformacionResponse()
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(respuesta)
                return
            }
            
            do {
                let respuestaJson = try JSONSerialization.jsonObject(with: data)
                respuesta = UsuarioInformacionResponse(with: respuestaJson as? [String : Any])
                completion(respuesta)
                print(respuesta)
            } catch let parseError {
                completion(respuesta)
                print(parseError)
            }
            }.resume()
    }
    
    func tipoDeUsuario(completion: @escaping (Int) -> Void ) {
        let valor : Int = obtenerTipoUsuario()
        
        switch valor {
        case 1,2:
            completion(valor)
            break;
        case 3,-1:
            self.estado(completion: { responseData in
                if(responseData.code == 200){
                    self.guardarTipoDeUsuario(tipo: responseData.data.tipo)
                    if(responseData.data.tipo != 3){
                        self.informacionUsuario(completion: { responseUsuarioData in
                            if(responseUsuarioData.code == 200){
                                SavedData.setTheProfilePic(profilePic: responseUsuarioData.data.profile_photo)
                                SavedData.setTheName(theName: responseUsuarioData.data.name)
                                SavedData.setTheMemberNumber(memberNumber: responseUsuarioData.data.membernumber)
                                SavedData.seTMemUnicId(memUnicId: responseUsuarioData.data.memunic_id)
                                SavedData.setTheClub(club: responseUsuarioData.data.club)
                                SavedData.setTheEmail(email: responseUsuarioData.data.mail)
                                SavedData.setMemberType(memberType: responseUsuarioData.data.member_type)
                                SavedData.setTheMantaniance(mantaniance: responseUsuarioData.data.mainteiment)
                                SavedData.setTheUserId(userId: responseUsuarioData.data.user_id)
                                APIManager.sharedInstance.userId = responseUsuarioData.data.user_id
                            }
                             completion(responseData.data.tipo)
                        })
                    }else{
                         completion(responseData.data.tipo)
                    }
                }else{
                    completion(valor)
                }
                
            })
            break
        default:
            break;
        }
        
        
    }
    
    func guardarTipoDeUsuario(tipo:Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(tipo, forKey:"tipoUsuario")
        userDefaults.synchronize()
    }
    
    func obtenerTipoUsuario() -> Int {
        let userDefaults = UserDefaults.standard
        if let tipoUsuario = userDefaults.object(forKey: "tipoUsuario") as! Int? {
            return tipoUsuario
        } else {
            return -1
        }
    }
}
