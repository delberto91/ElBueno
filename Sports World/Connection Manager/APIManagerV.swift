//
//  APIManagerV.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/9/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManagerV: NSObject {
    var webContent: String = ""
     static let sharedInstance = APIManagerV()
    
    func getProductosTienda(clubId: String, onSuccess: @escaping(TiendaResponse) -> Void) {
        
        let tiendaResponse : TiendaResponse = TiendaResponse()
        
        guard let url = URL(string: "http://sandbox.sportsworld.com.mx/especiales/api/v1/consultaProductosCRM2/\(clubId)/\(SavedData.getTheUserId())") else {return}
        var  request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    print(json)
                   
                    tiendaResponse.message = json["message"] as! String
                    tiendaResponse.code = json["code"] as! Int
                    
                    if let data = json ["data"] as? [[String:AnyObject]] {
                        for element in data {
                            let tiendaData: Tienda = Tienda()
                            tiendaData.nombre = element["nombre"] as! String
                            tiendaData.idProducto = element["idProducto"] as! Int
                            tiendaData.importe = element["importe"] as! Int
                            tiendaData.idTipoCliente = element["idTipoCliente"] as! Int
                            tiendaData.tipoProducto = element["TipoProducto"] as! String
                            tiendaData.descripcion = element["descripcion"] as! String
                            tiendaResponse.data.append(tiendaData)
                        }
                   
                        
                        
                        
                    }
                    
                    
                  
                    
                    onSuccess(tiendaResponse)
                } catch {
                    onSuccess(tiendaResponse)
                }
            }
            if(error != nil){
                onSuccess(tiendaResponse)
            } else{
            }
        })
        task.resume()
    }
    
    func getDietaPersonalizada(onSuccess: @escaping(DietaPersonalizadaResponse) -> Void) {
        
        let dietaPersonalizadaResponse : DietaPersonalizadaResponse = DietaPersonalizadaResponse()
        
        guard let url = URL(string: "http://sandbox.sportsworld.com.mx/nutricion/api/v1/personaPlanNutricional/\(SavedData.getTheUserId())") else {return}
        var  request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    print(json)
                    
                    dietaPersonalizadaResponse.message = json["message"] as! String
                    dietaPersonalizadaResponse.code = json["code"] as! Int
                    
                    if let dataReceived = json ["data"] as? [[String:AnyObject]] {
                        for element in dataReceived {
                            let dietaPersonalizada: DietaPersonalizada = DietaPersonalizada()
                            self.webContent = element["contenido"] as! String
                          //  dietaPersonalizada.titulo = element["titulo"] as! String
                          //  print("Aquo estña el titulo",dietaPersonalizada.titulo)
                            dietaPersonalizada.contenido = element["contenido"] as! String
      print("Aqui esta el contenido.",dietaPersonalizada.contenido)
                             dietaPersonalizadaResponse.data.append(dietaPersonalizada)
                          
                        }
                        
                      
                        
                    }
                    
                    
                    onSuccess(dietaPersonalizadaResponse)
                } catch {
                    onSuccess(dietaPersonalizadaResponse)
                }
            }
            if(error != nil){
                onSuccess(dietaPersonalizadaResponse)
            } else{
            }
        })
        task.resume()
    }

    func makePaymentForProducto(onSuccess: @escaping(ProductoCobroResponse) ->  Void) {
        
         let productoCobroResponse : ProductoCobroResponse = ProductoCobroResponse()
        let params : [String:Any] = [ "idPersona": 1070137,
                                      "idProducto": 79,
                                      "idEsquemaPago": 4,
                                      "idUn": 16,
                                      "cantidad": 2,
                                      "token_id": "tok_test_visa_4242"]
        
        guard let url = URL(string: "http://sandbox.sportsworld.com.mx/especiales/api/v1/compraProductoCKT2")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    let result = try JSON(data: data)
                    productoCobroResponse.message = json["message"] as! String
                    productoCobroResponse.code = json["code"] as! Int
                    
                    print(json )
                    onSuccess(productoCobroResponse)
                    
                    
                } catch {
                  onSuccess(productoCobroResponse)
                    print("OcurriÃ³ un error")
                }
                if(error != nil){
                    onSuccess(productoCobroResponse)
                } else{
                }
            }
            
         
        })
        task.resume()
    }
    
    func notificacionAlta(tipoDispositivo: Int, type: Int, onSuccess: @escaping(NotificacionResponse) ->  Void) {
        
        let notificacionResponse : NotificacionResponse = NotificacionResponse()
        let params : [String:Any] = ["idUsuario" : SavedData.getTheUserId(),
                                       "idOneSignal" : "756e7da6-3830-42b7-8339-217144bba8ec",
                                       "tipoDispositivo" : tipoDispositivo,
                                       "type" : type]
        
        guard let url = URL(string: "http://sandbox.sportsworld.com.mx/app/api/v1/userDevice")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    let result = try JSON(data: data)
                    notificacionResponse.message = json["message"] as! String
                    notificacionResponse.code = json["code"] as! Int
                    
                    print(json )
                    onSuccess(notificacionResponse)
                    
                    
                } catch {
                    onSuccess(notificacionResponse)
                    print("OcurriÃ³ un error")
                }
                if(error != nil){
                    onSuccess(notificacionResponse)
                } else{
                }
            }
            
            
        })
        task.resume()
    }
}

