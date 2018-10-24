//
//  Models.swift
//  Sports World
//
//  Created by Glauco Valdes on 6/11/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import Foundation
open class Club{
    var name : String = ""
    var group : String = ""
    var clubId : Int = 0
    var distance : Double = 0.0
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var agenda : Int = 0
    var tele : String = ""
    var idEstado : Int = 0
    var address : String = ""
    var schedule : String = ""
    var clave : String = ""
    var dCount : Int = 0
    var ruta360 : String = ""
    var rutaVideo : String = ""
    var preventa : Int = 0
    var estado : String = ""
}

open class ClassSW{
    var idinstalacionactividadprogramada : Int = 0
    var club : String = ""
    var salon : String = ""
    var idsalon : Int = 0
    var clase : String = ""
    var idclase : Int = 0
    var instructor : String = ""
    var inicio : String = ""
    var fin : String = ""
    var iniciovigencia : String = ""
    var finvigencia : String = ""
    var capacidadideal : Int = 0
    var capacidadmaxima : Int = 0
    var capacidadregistrada : Int = 0
    var reservacion : Int = 0
    var confirmados : Int = 0
    var agendar : Int = 0
    var demand : Int = 0
    var inscrito : Bool = false
}
open class GenericResponse{
    var status : Bool = false
    var message : String = ""
}
open class Producto {
  var nombre: String = ""
    var fecha: String = ""
    var clubNombre: String = ""
    var costo: String = ""
    
}
open class ProductoAgregado {
    
    var producto: [Producto] = [Producto]()
}


open class DescriptionResponse{
    var status : Bool = false
    var message : String = ""
    var data : DescriptionData = DescriptionData()
}

open class DescriptionData{
    var idClass : Int = 0
    var descripcionHTML : String = ""
    var clave : String = ""
    
}

open class NotificacionResponse {
    var code : Int = 0
    var message : String = ""
    var data : Notificacion = Notificacion()
   
}
open class Notificacion {
    
    var success : Bool = false
    var id : String = ""
    }

open class ProductoCobroResponse{
    var message : String = ""
    var code : Int = 0
    var data : [ProductoCobroData] = [ProductoCobroData]()
}
open class ProductoCobroData{
    var idClass : Int = 0
    var descripcionHTML : String = ""
    var clave : String = ""
    
}

open class ClassResponse{
    var status : Bool = false
    var message : String = ""
    var data : [ClassSW] = [ClassSW]()
}
open class ClassCategoriaResponse{
    var status : Bool = false
    var message : String = ""
    var data : [ClassCategoria] = [ClassCategoria]()
}
open class ClassCategoria{
    var idinstalacionactividadprogramada : Int = 0
    var club : String = ""
    var salon : String = ""
    var idsalon : Int = 0
    var clase : String = ""
    var idclase : Int = 0
    var instructor : String = ""
    var inicio : String = ""
    var fin : String = ""
    var iniciovigencia : String = ""
    var finvigencia : String = ""
    var capacidadideal : Int = 0
    var capacidadmaxima : Int = 0
    var capacidadregistrada : Int = 0
    var reservacion : Int = 0
    var confirmados : Int = 0
    var agendar : Int = 0
    var demand : Int = 0
    var distance : Double = 0
    var latitud : Double = 0
    var longitud : Double = 0
    var inscrito : Bool = false
    
    static let timeFormatter = DateFormatter()
    
    func formattedInicio(_ string: String) -> String {
      
        ClassCategoria.timeFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale!
        ClassCategoria.timeFormatter.locale = Locale(identifier: "es_MX_POSIX")
        ClassCategoria.timeFormatter.dateFormat = "EEE"
        ClassCategoria.timeFormatter.dateFormat = "HH':'mm':'ss"
        ClassCategoria.timeFormatter.amSymbol = "AM"
        ClassCategoria.timeFormatter.pmSymbol = "PM"
        guard let date = ClassCategoria.timeFormatter.date(from: string) else {
            return string
        }
        ClassCategoria.timeFormatter.dateFormat = "hh':'mm a"
        return ClassCategoria.timeFormatter.string(from: date)
    }
    
    func dateInicio(_ string: String) -> Date {
        // inicio = "21:00:00"
        // We only need the time, that's why we are disregarding the year, month and year
        //        ClassCategoria.timeFormatter.dateFormat = "hh':'mm a"
        ClassCategoria.timeFormatter.dateFormat = "HH':'mm':'ss"
        guard let date = ClassCategoria.timeFormatter.date(from: string) else {
            return Date()
        }
        return date
    }
    
}
open class ClubResponse{
    var status : Bool = false
    var message : String = ""
    var data : ClubData = ClubData()
}
open class AsignMetaResponse{
    var code : Int = 0
    var message : String = ""
    var data : [DietDateData] =  [DietDateData]()
}

open class AsignInbodyResponse{
    var code : Int = 0
    var message : String = ""
    
}

open class MetasResponse{
    var code : Int = 0
    var message : String = ""
    var data : [MetaData] = [MetaData]()
}
open class DietDateData{
    var usuario : Int = 0
    var dia : Date = Date()
    var cableMeta : Int = 0
    var nombreMeta : String = ""
    var cableDieta : Int = 0
    var nombreDieta : String = ""
}
open class MetaData{
    var id : Int = 0
    var nombre : String = ""
}

open class ComidaResponse{
    var code : Int = 0
    var message : String = ""
    var data : [Comida] = [Comida]()
}
open class Comida{
    var tipo : String = ""
    var descripcion : String = ""
    var horario : String = ""
}
open class RecetaResponse{
    var code : Int = 0
    var message : String = ""
    var data : [Receta] = [Receta]()
}

open class Receta{
    var id : Int = 0
    var nombre : String = ""
    var descripcion : String = ""
    var foto : String = ""
}
open class LastInbodyResponse {
    var status = ""
    var message = ""
    var data : [Double] = [Double]()
}
open class LastInbody{
    var peso: Double = 0.0
    var estatura :  Double = 0.0
    var RCC :  Double = 0.0
    var PGC :  Double = 0.0
    var IMC :  Double = 0.0
    var MME : Double = 0.0
    var MCG :  Double = 0.0
    var ACT :  Double = 0.0
    var minerales :  Double = 0.0
    var proteina :  Double = 0.0
    var fcresp :  Double = 0.0
}

open class ClubData{
    var latitud : Double = 0
    var agendar : Int = 0
    var favorito : Bool = false
    var direccion : String = ""
    var horario : String = ""
    var idun : Int = 0
    var imagenes_club : [String] = [String]()
    var ruta360 : String = ""
    var nombre : String = ""
    var rutavideo : String = ""
    var preventa : Int = 0
    var telefono : String = ""
    var longitud : Double = 0
}
open class FacturaResponse{
    var code : Int = 0
    var message : String = ""
    var data : [Factura] = [Factura]()
}
open class Factura{
    var folio : String = ""
    var importe : String = ""
    var fecha : String = ""
    var pdf : String = ""
}

open class EntrenamientosResponse {
    var code: Int = 0
    var message: String = ""
    var data: [Entrenamiento] = [Entrenamiento]()
}

open class RutinasResponse {
    var code: Int = 0
    var message: String = ""
    var fechaInicio: Date = Date()
    var fechaFin: Date = Date()
}
open class Entrenamiento {
    var clave: String = ""
    var orden: Int = 0
    var nombre: String = ""
    var video: String = ""
    var series: Int = 0
    var repeticiones: Int = 0
    var descanso: Int = 0
    var completado: Bool = false
    var fechaStr: String = ""
    
    
    public init(clave: String = "", orden: Int = 0, nombre: String = "", video: String = "", series: Int = 0, repeticiones: Int = 0, descanso: Int = 0, completado: Bool = false, fechaStr: String = "") {
        self.clave = clave
        self.orden = orden
        self.nombre = nombre
        self.video = video
        self.series = series
        self.repeticiones = repeticiones
        self.descanso = descanso
        self.completado = completado
        self.fechaStr = fechaStr
    }
}
open class RutinaResponse {
    var code: Int = 0
    var message: String = ""
    var data: [Rutina] = [Rutina]()
}

open class CompletadoResponse {
    var code: Int = 0
    var message: String = ""
    var completado: Bool = false
}
open class Rutina {
    var clave: String = ""
    var orden: Int = 0
    var nombre: String = ""
    var video: String = ""
    var series: Int = 0
    var repeticiones: Int = 0
    var descanso: Int = 45
    var completado: Bool = false
}
open class Horarios {
    var hora:[String]
    var fecha:String
    init(hora:[String], fecha:String) {
        self.hora = hora
        self.fecha = fecha
    }
    
}

open class DatosResponse {
    var code : Int = 0
    var message : String =  ""
    var data : [Datos] = [Datos]()
}
open class Datos {
    var idPersona: Int = 0
    var nivel : Int = 0
    var rutina : String = ""
    
}

open class MenuActividadResponse {
    var code : Int = 0
    var message : String =  ""
    var data : [MenuActividad] = [MenuActividad]()
}
open class MenuActividad {
    var idPersona: Int = 0
    var nivel : Int = 0
    var rutina : String = ""
    
}

open class PasesResponse {
    
    var data : [Pases] = [Pases]()
}
open class Pases {
    
    var producto : String =  ""
    var cuando : String = ""
    
}
open class PasesPorAsignarResponse {
    var message : String = ""
    var data : [PasesPorAsignar] = [PasesPorAsignar]()
}
open class PasesPorAsignar {
    var nombre : String = ""
    var finVigencia : String = ""
}

open class RutinaCasaResponse {
    var code : Int = 0
    var message : String =  ""
    var data : [RutinasCasa] = [RutinasCasa]()
}

open class RutinasCasa {
    var usuario: String = ""
    var nombreEntrenamiento: String = ""
    var claveEntrenamiento: Int = 0
    var calificacion: Int = 0
    var fechaReproduccion: String = ""
    var foto: String = ""
    var videoDistribucion: String = ""
    var categoria: String = ""
    var favorito: Int = 0
    var numeroReproduccion: Int = 0
    var descripEntre: String = ""
    var coach : Coach = Coach()
    
    init(usuario: String = "", nombreEntrenamiento: String = "", claveEntrenamiento: Int = 0, calificacion: Int = 0, fechaReproduccion: String = "", foto: String = "", videoDistribucion: String = "", categoria: String = "", numeroReproduccion: Int = 0, coach : Coach = Coach(),favorito: Int = 0,descripEntre : String = "") {
        self.usuario = usuario
        self.nombreEntrenamiento = nombreEntrenamiento
        self.claveEntrenamiento = claveEntrenamiento
        self.calificacion = calificacion
        self.fechaReproduccion = fechaReproduccion
        self.foto = foto
        self.videoDistribucion = videoDistribucion
        self.categoria = categoria
        self.numeroReproduccion = numeroReproduccion
        self.coach  = coach
        self.favorito = favorito
        self.descripEntre = descripEntre
    }
    
}

open class Coach {
    var nombre: String = ""
    var apellidos: String = ""
    var descripcion: String = ""
    var foto: String = ""
    
    init(nombre: String = "", apellidos: String = "", descripcion: String = "", foto: String = "") {
        self.nombre = nombre
        self.apellidos = apellidos
        self.descripcion = descripcion
        self.foto = foto
    }
    
}
open class ClaseCategoriasResponse {
    var status : Bool = false
    var message : String =  ""
    var data : [ClaseCategorias] = [ClaseCategorias]()
    var clases :[Clases] = [Clases]()
}
open class ClaseCategorias {
    var categoria: String = ""
    
    var id: Int = 0
    
}
open class Clases {
    var clase : String = ""
    var idClase : Int = 0
}
open class EventosResponse {
    var code : Int = 0
    var message : String = ""
    var data : [Eventos] = [Eventos]()
}

open class Eventos {
    var id: Int = 0
    var nombre : String = ""
    var ubicacion : String = ""
    var descripcion : String = ""
    var imagen : String = ""
    var fecha : String = ""
    var ruta: String = "" 
    var galeria : [GaleriaEventos] = [GaleriaEventos]()
}
open class DetalleEventos {
    var ruta : String =  ""
    
}
open class GaleriaEventos {
    var idFoto : Int = 0
    var ruta : String =  ""
}

open class EncuestasPendientes {
    var status : Bool = false
    var message : String = ""
    var data : [DatosEncuesta] = [DatosEncuesta]()
}

open class DatosEncuesta {
    var instructor : String = ""
    var idinstalacionactividadprogramada : Int = 0
    var clase:String = ""
}

open class EvaluacionesEncuestas{
    
    var status:Bool = false
    var message:String = ""
    var data:[CategoriaEvaluacion] = [CategoriaEvaluacion]()
}

open class CategoriaEvaluacion{
    var categoria:String = ""
    var orden:Int = 0
    var idsatisfaccionpregunta:Int = 0
    var tipo:String = ""
    var claveencuesta:String = ""
    var activo:Int = 0
    var pregunta:String = ""
    var idsatisfaccionpreguntaevaluacion:Int = 0
}
open class PagoResponse {
    var code : Int = 0
    var message : String = ""
    var data : [Pago] = [Pago]()
}
open class Pago {
    
}
open class AllClubsInBody{
    var code : Int = 0
    var message : String = ""
    var data : [ClubInBody] = [ClubInBody]()
}
open class ClubInBody{
    var name: String = ""
    var idUn: Int = 0
    var clave: String = ""
    var domicilio:String = ""
    var seleccionaUnclub: String = "Selecciona un club"
}

open class Respuesta{
    var code:Int = 0
    var message:String = ""
}

open class ReservaInBodyRespuesta{
    var code:Int = 0
    var message:String = ""
    var data:[ReservaInBody]  = [ReservaInBody]()
}

open class ReservaInBody{
    var idUn:Int = 0
    var idAgenda:Int = 0
    var idPersona: Int = 0
    var horario:String = ""
    var fechaSolicitud:String = ""
    var fechaConfirmacion: String = ""
}

open class TiendaResponse{
    var code:Int = 0
    var message:String = ""
    var data:[Tienda]  = [Tienda]()
}
open class Tienda{
    var idProducto:Int = 0
    var nombre:String = ""
    var importe: Int = 0
    var idTipoCliente:Int = 0
    var tipoProducto: String = ""
    var descripcion: String = ""
}
open class DietaPersonalizadaResponse{
    var code:Int = 0
    var message:String = ""
    var data:[DietaPersonalizada]  = [DietaPersonalizada]()
}
open class DietaPersonalizada{
    
    var id:Int = 0
    var titulo:String = ""
    var contenido: String = ""
  
    
}

// MARK: menu/readMenu response

public struct ReadMenu: Codable, Mutable {
    var code: Int
    var message: String
    var data: DataClass
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
    
    public init(code: Int, message: String, data: DataClass) {
        self.code = code
        self.message = message
        self.data = data
    }
}

public struct DataClass: Codable, Mutable {
    var fuerzas: [Fuerza]
    var cardios: [Cardio]
    var clases: [Clase]
    var optativas: [Clase]
    
    enum CodingKeys: String, CodingKey {
        case fuerzas = "Fuerza"
        case cardios = "Cardio"
        case clases = "Clases"
        case optativas = "Optativas"
    }
    
    public init(fuerzas: [Fuerza], cardios: [Cardio], clases: [Clase], optativas: [Clase]) {
        self.fuerzas = fuerzas
        self.cardios = cardios
        self.clases = clases
        self.optativas = optativas
    }
}

public struct Cardio: Codable, Mutable {
    var clave: String
    var equipo: String
    var imagen: String
    var tiempo: Int
    var intensidad: Int
    var completado: Bool
    
    enum CodingKeys: String, CodingKey {
        case clave = "clave"
        case equipo = "equipo"
        case imagen = "imagen"
        case tiempo = "tiempo"
        case intensidad = "intensidad"
        case completado = "completado"
    }
    
    public init(clave: String, equipo: String, imagen: String, tiempo: Int, intensidad: Int, completado: Bool) {
        self.clave = clave
        self.equipo = equipo
        self.imagen = imagen
        self.tiempo = tiempo
        self.intensidad = intensidad
        self.completado = completado
    }
}

public struct Clase: Codable, Mutable {
    var clave: String
    var nombre: String
    var imagen: String
    var completado: Bool
    
    enum CodingKeys: String, CodingKey {
        case clave = "clave"
        case nombre = "nombre"
        case imagen = "imagen"
        case completado = "completado"
    }
    
    public init(clave: String, nombre: String, imagen: String, completado: Bool) {
        self.clave = clave
        self.nombre = nombre
        self.imagen = imagen
        self.completado = completado
    }
}

public struct Fuerza: Codable, Mutable {
    var clave: String
    var orden: Int
    var nombre: String
    var video: String
    var imagen: String
    var series: Int
    var repeticiones: Int
    var descanso: Int
    var completado: Bool
    
    enum CodingKeys: String, CodingKey {
        case clave = "clave"
        case orden = "orden"
        case nombre = "nombre"
        case video = "video"
        case imagen = "imagen"
        case series = "series"
        case repeticiones = "repeticiones"
        case descanso = "descanso"
        case completado = "completado"
    }
    
    public init(clave: String, orden: Int, nombre: String, video: String, imagen: String, series: Int, repeticiones: Int, descanso: Int, completado: Bool) {
        self.clave = clave
        self.orden = orden
        self.nombre = nombre
        self.video = video
        self.imagen = imagen
        self.series = series
        self.repeticiones = repeticiones
        self.descanso = descanso
        self.completado = completado
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

public extension URLSession {
    
    public func getSecretKey()->String {
        if(SavedData.getSecretKey() != "" && SavedData.getTokenDay() ==  Date().string(format: "yyyy-MM-dd")){
            return SavedData.getSecretKey()
        }
        do{
            
            let str = try String(contentsOf: URL(string:"https://cloud.sportsworld.com.mx/api/key")!)
            SavedData.setSecretKey(secretKey: str)
            SavedData.setTokenDay(tokenDay: Date().string(format: "yyyy-MM-dd"))
            return str
        } catch {
            return ""
        }
    }
    
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
        return self.dataTask(with: request) { data, response, error in
            print("url: \(response?.url) request: \(request) Data: \(data), response: \(response), error: \(error)")
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            do {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                    case 200...299:
                        let codable = try newJSONDecoder().decode(T.self, from: data)
                        completionHandler(codable, response, nil)
                    default:
                        let codable = try newJSONDecoder().decode(EmptyResponse.self, from: data)
                        let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: codable.message])
                        completionHandler(nil, response, error)
                    }
                } else {
                    let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: "try again later"])
                    completionHandler(nil, response, error)
                }
            } catch {
                completionHandler(nil, response, error)
            }
            
        }
    }
    
    /*
     fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
     return self.dataTask(with: url) { data, response, error in
     guard let data = data, error == nil else {
     completionHandler(nil, response, error)
     return
     }
     do {
     if let statusCode = (response as? HTTPURLResponse)?.statusCode {
     switch statusCode {
     case 200...299:
     let codable = try newJSONDecoder().decode(T.self, from: data)
     completionHandler(codable, response, nil)
     default:
     let codable = try newJSONDecoder().decode(EmptyResponse.self, from: data)
     let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: codable.message])
     completionHandler(nil, response, error)
     }
     } else {
     let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: "try again later"])
     completionHandler(nil, response, error)
     }
     } catch {
     completionHandler(nil, response, error)
     }
     
     
     }
     }
     */
    
    func markRoutine(with url: URL, completionHandler: @escaping (MarkRoutineResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
    
    func readMenuTask(with url: URL, completionHandler: @escaping (ReadMenu?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
    
    func entrenamientosUsuarioTask(with url: URL, completionHandler: @escaping (EntrenamientosUsuario?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


import Foundation

public struct MarkRoutineResponse: Codable {
    let code: Int
    let message: String
    let data: MarkDataClass
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
}

public struct MarkDataClass: Codable {
    let completado: Bool
    
    enum CodingKeys: String, CodingKey {
        case completado = "completado"
    }
}

struct EmptyResponse: Codable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
}

public struct EntrenamientosUsuario: Codable {
    public let code: Int
    public let message: String
    public let data: [Routine]
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
    
    public init(code: Int, message: String, data: [Routine]) {
        self.code = code
        self.message = message
        self.data = data
    }
}

public struct Routine: Codable, Comparable {
    public let usuario: String
    public let nombreEntrenamiento: String
    public let nombreVimeoEntrenamiento: String
    public let claveEntrenamiento: Int
    public let calificacion: String
    public let numeroReproduccion: Int
    public let fechaReproduccion: String
    public let foto: String
    public let video: String
    public let videoIframe: String
    public let videoDistribucion: String
    public let categoria: String
    public let isLive: Bool
    public let descripEntre: String
    public let favorito: Int
    public let coach: Trainer
    
    enum CodingKeys: String, CodingKey {
        case usuario = "usuario"
        case nombreEntrenamiento = "nombreEntrenamiento"
        case nombreVimeoEntrenamiento = "nombreVimeoEntrenamiento"
        case claveEntrenamiento = "claveEntrenamiento"
        case calificacion = "calificacion"
        case numeroReproduccion = "numeroReproduccion"
        case fechaReproduccion = "fechaReproduccion"
        case foto = "foto"
        case video = "video"
        case videoIframe = "videoIframe"
        case videoDistribucion = "videoDistribucion"
        case categoria = "categoria"
        case descripEntre = "descripcionEntrenamiento"
        case coach = "coach"
        case favorito = "favorito"
        case isLive = "isLive"
    }
    
    public init(usuario: String, nombreEntrenamiento: String, nombreVimeoEntrenamiento: String, claveEntrenamiento: Int, calificacion: String, numeroReproduccion: Int, fechaReproduccion: String, foto: String, video: String, videoIframe: String, videoDistribucion: String, categoria: String, descripEntre: String, coach: Trainer,favorito : Int, isLive: Bool) {
        self.usuario = usuario
        self.nombreEntrenamiento = nombreEntrenamiento
        self.nombreVimeoEntrenamiento = nombreVimeoEntrenamiento
        self.claveEntrenamiento = claveEntrenamiento
        self.calificacion = calificacion
        self.numeroReproduccion = numeroReproduccion
        self.fechaReproduccion = fechaReproduccion
        self.foto = foto
        self.video = video
        self.videoIframe = videoIframe
        self.videoDistribucion = videoDistribucion
        self.categoria = categoria
        self.isLive = isLive
        self.coach = coach
        self.favorito = favorito
        self.descripEntre = descripEntre
    }
    
    public static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.usuario == rhs.usuario
            && lhs.nombreEntrenamiento == rhs.nombreEntrenamiento
            && lhs.nombreVimeoEntrenamiento == rhs.nombreVimeoEntrenamiento
            && lhs.claveEntrenamiento == rhs.claveEntrenamiento
            && lhs.calificacion == rhs.calificacion
            && lhs.numeroReproduccion == rhs.numeroReproduccion
            && lhs.categoria == rhs.categoria && lhs.descripEntre == rhs.descripEntre
    }
    
    public static func < (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.categoria < rhs.categoria
    }
    
    func mapToRutinasCasa() -> RutinasCasa {
        return RutinasCasa(usuario: usuario,
                           nombreEntrenamiento: nombreEntrenamiento,
                           claveEntrenamiento: claveEntrenamiento,
                           calificacion: Int(calificacion) ?? 0,
                           fechaReproduccion: fechaReproduccion,
                           foto: foto,
                           videoDistribucion: videoDistribucion,
                           categoria: categoria,
                           numeroReproduccion: numeroReproduccion,
                           coach: coach.mapToCoach(),favorito: favorito,descripEntre:descripEntre)
    }
}

extension Routine {
    /*
     case usuario = "usuario"
     case nombreEntrenamiento = "nombreEntrenamiento"
     case nombreVimeoEntrenamiento = "nombreVimeoEntrenamiento"
     case claveEntrenamiento = "claveEntrenamiento"
     case calificacion = "calificacion"
     case numeroReproduccion = "numeroReproduccion"
     case fechaReproduccion = "fechaReproduccion"
     case foto = "foto"
     case video = "video"
     case videoIframe = "videoIframe"
     case videoDistribucion = "videoDistribucion"
     case categoria = "categoria"
     case descripcionEntrenamiento = "descripcionEntrenamiento"
     case coach = "coach"
     */
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        usuario = try container.decode(String.self, forKey: .usuario)
        nombreEntrenamiento = try container.decode(String.self, forKey: .nombreEntrenamiento)
        nombreVimeoEntrenamiento = try container.decode(String.self, forKey: .nombreVimeoEntrenamiento)
        claveEntrenamiento = try container.decode(Int.self, forKey: .claveEntrenamiento)
        
        
        
        if let calificacionString = try? container.decode(String.self, forKey: .calificacion) {
            calificacion = calificacionString
        } else if let calificacionInt = try? container.decode(Int.self, forKey: .calificacion) {
            calificacion = calificacionInt.description
        } else {
            throw DecodingError.dataCorruptedError(forKey: .calificacion,
                                                   in: container,
                                                   debugDescription: "calificacion is not an int neither string.")
        }
        
        numeroReproduccion = try container.decode(Int.self, forKey: .numeroReproduccion)
        fechaReproduccion = try container.decode(String.self, forKey: .fechaReproduccion)
        foto = try container.decode(String.self, forKey: .foto)
        video = try container.decode(String.self, forKey: .video)
        videoIframe = try container.decode(String.self, forKey: .videoIframe)
        videoDistribucion = try container.decode(String.self, forKey: .videoDistribucion)
        categoria = try container.decode(String.self, forKey: .categoria)
        
        favorito = try container.decode(Int.self, forKey: .favorito)
        
        coach = try container.decode(Trainer.self, forKey: .coach)
        descripEntre = try container.decode(String.self, forKey: .descripEntre)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        
    }
}

public struct Trainer: Codable {
    public let id: Int
    public let nombre: String
    public let apellidos: String
    public let descripcion: String
    public let foto: String
    public let calificacion: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nombre = "nombre"
        case apellidos = "apellidos"
        case descripcion = "descripcion"
        case foto = "foto"
        case calificacion = "calificacion"
    }
    
    public init(id: Int, nombre: String, apellidos: String, descripcion: String, foto: String, calificacion: Int) {
        self.id = id
        self.nombre = nombre
        self.apellidos = apellidos
        self.descripcion = descripcion
        self.foto = foto
        self.calificacion = calificacion
    }
    
    func mapToCoach() -> Coach {
        return Coach(nombre: nombre, apellidos: apellidos, descripcion: descripcion, foto: foto)
    }
}




public protocol Mutable {}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) -> ()) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) throws -> ()) rethrows -> Self {
        var newSelf = self
        try transform(&newSelf)
        return newSelf
    }
}
