
import Foundation
import SwiftyJSON
import CoreLocation

class APIManager: NSObject {
    
    
    private var tasksInProgress: [URL: URLSessionTask] = [:]
    
    var mainClassViewController : MainViewController = MainViewController()
    var claseCatViewController : ClaseCategoriasViewController = ClaseCategoriasViewController()
    var proximasAperturasVC : ProximasAperturasCollectionViewController = ProximasAperturasCollectionViewController()
    var favoritesVC : FavoritosCollectionViewController = FavoritosCollectionViewController ()
    
    var ciudadesVC : ForaneosCollectionViewController = ForaneosCollectionViewController ()
    var clubes : ClubesViewController = ClubesViewController ()
    var nutritionVC : NutricionCalendarViewController = NutricionCalendarViewController ()
    //var config = ConfiguracionTableViewController()
    
    var heightTextField : UITextField = UITextField()
    var weightTextField : UITextField = UITextField()
    var selectedClub : Club = Club()
    var allClubes : [Club] = [Club]()
    var allClases: [Clases] = [Clases]()
    var allClubesInfo : [[String:AnyObject]] = []
    
    var categoriasData: [[String:AnyObject]] = []
    var dictionaryP1 : [[String:AnyObject]] = []
    var dictionaryP2 : [[String:AnyObject]] = []
    var dictionaryP3 : [[String:AnyObject]] = []
    var dictionaryP4 : [[String:AnyObject]] = []
    var finalList: [String] = []
    var finalId: [Int] = []
    var totalImportes : [String] = []
    var idMovimiento : [String] = []
    var clases : [[String : AnyObject]] = []
    var claseFinal = [String]()
    var totalDescripciones : [String] = []
    var listClub : [[String:AnyObject]] = []
    var listClubP1 : [[String:AnyObject]] = []
    var listClubP2 : [[String:AnyObject]] = []
    var listClubP3 : [[String:AnyObject]] = []
    var listClubP4 : [[String:AnyObject]] = []
    var clubsInBody : [[String:AnyObject]] = []
    var listClubsInBody : [[String:AnyObject]] = []
    var listClubsInBodyFull : [[String:AnyObject]] = []
    var mail: String!
    var message: String!
    var status: Bool!
    var messageForCharges: String!

    var satusProfile: Bool!
    var satusString: String!
    var profileImage: String!
    var name: String!
    var codeMessage: Int!
    var userId: Int!
    var gender: String!
    var club: String!
    var memberNumber: Int!
    var height: String!
    var weight: String!
    var age: Int!
    var profileImageSinstance: UIImage!
    var member_type: String!
    var mainteiment: String!
    var chargesArray = [[String:AnyObject]]()
    var movimientosArray =  [[String:AnyObject]]()
    var noticiasArray = [[String:AnyObject]]()
    var noticaResumen = [String]()
    var tituloArray = [String]()
    var descripcionArray = [String]()
    var lastInbody = [Double]()
     var lastInbody2 = [Double]()
    var subtitulo = [String]()
    var imagenNoticia = [String]()
    var infoVC = InformacionViewController()
    var nombreConvenio = [String]()
    var clausulasConvenio = [String]()
    var logotipoConvenio = [String]()
    var nombrePase = [String]()
    var finVigencia = [String]()
    var productoPaseInvitado = [String]()
    var cuandoPaseInvitado = [String]()
    var puntos: NSNumber = 0
    var inbodyValues = [String]()
     var inbodyValues2 = [String]()
    var folios = [String]()
    var fechas = [String]()
    var pdfs = [String]()
    var importes = [String]()
    var pesoInbody: Double = 0.0
   var estaturaInbody: Double = 0.0
   var rccInbody:Double = 0.0
   var pgcInbody: Double = 0.0
   var imcInbody: Double = 0.0
  var  mmeInbody: Double = 0.0
   var mcgInbody:Double = 0.0
   var actInbody: Double = 0.0
   var mineralesInbody: Double = 0.0
    var proteinaInbody: Double = 0.0
   var fcrespInbody: Double!
    var nivel:  Int = 0
    var rutina: String!
     var rutas = [String]()
    var pesoInbody2 = [Double]()
    var estaturaInbody2 = [Double]()
    var rccInbody2 = [Double]()
    var pgcInbody2 = [Double]()
    var imcInbody2 = [Double]()
    var  mmeInbody2 = [Double]()
    var mcgInbody2 = [Double]()
    var actInbody2 = [Double]()
    var mineralesInbody2 = [Double]()
    var proteinaInbody2 = [Double]()
    var fcrespInbody2: Double!
    var horarios = [Horarios]()
    var mes = [String]()
   
    static let sharedInstance = APIManager()
    
    func login(authKey: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let params: [String: Any] = [:]
        
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/login_new/") else {return}
        var  request = URLRequest(url: url)
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 1
        urlconfig.timeoutIntervalForResource = 1
        let sessionOne = Foundation.URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue.main)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.httpMethod = "POST"
        request.addValue(authKey, forHTTPHeaderField: "auth-key")
        print("Este es el authKey", authKey)
        
        
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
                    let result =  try JSON(data: data)
                    
                    self.message = json["message"] as? String
                    self.status = json["status"] as! Bool
                    
                    print("Este es el status", self.status)
                    if self.status == false {
                        print("Valio madres")
                    }else {
                        if let  data = json ["data"] as? Dictionary<String,AnyObject> {
                        for element in data {
                            var profilePic = data["profile_photo"] as? String
                            SavedData.setTheProfilePic(profilePic: profilePic!)
                            let name = data["name"] as! String
                            SavedData.setTheName(theName: name)
                            self.name = name
                            if let memberNumber =  data["membernumber"] as?  Int {
                                SavedData.setTheMemberNumber(memberNumber: memberNumber )
                            }
                            
                            self.userId = data["user_id"] as! Int
                            self.gender = data["gender"] as? String
                            var club = data ["club"] as? String
                            var memUnicId = data["memunic_id"] as! Int
                            SavedData.seTMemUnicId(memUnicId: memUnicId)
                            self.club = club
                            SavedData.setTheClub(club: club!)
                            var mail = data ["mail"] as? String
                            SavedData.setTheEmail(email: mail!)
                            self.height = data ["tallest"] as? String
                            print("Aqui estÃ¡ el tallest", self.height)
                            self.weight = data ["weight"] as? String
                            
                            
                           
                            self.age = data["age"] as! Int
                            var memberType = data ["member_type"] as? String
                            self.member_type = memberType
                            SavedData.setMemberType(memberType: memberType!)
                            var mainteiment = data ["mainteiment"] as? String
                            self.mainteiment = mainteiment
                            SavedData.setTheMantaniance(mantaniance: mainteiment!)
                            //self.memberNumber = data ["membernumber"] as! Int
                            
                            SavedData.setTheUserId(userId: self.userId)
                            }
                        }
                        
                    }
                    print(json )
                    
                  
                    onSuccess(result)
                    
                    
                    
                } catch {
                    print(error)
                    print("OcurriÃ³ un error")
                    onSuccess(JSON.null)
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                //onFailure(error!)
                print("Todo mal")
            } else{
                onSuccess(JSON.null)
                
            }
        })
        task.resume()
        
    }
    func register(email: String, tipo: String, club: String, membresia: String, id: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let params : [String:Any] = ["email": email,
                                     "tipo" : tipo,
                                     "club" : club,
                                     "membresia" : membresia,
                                     "id" : id]
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/app/api/v1/usuario/registro")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    let code = json["code"] as! Int
                    print("Este es el cÃ³digo", code )
                    
                    self.codeMessage = code
                    self.message = mensaje as! String
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
                    
                    
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                 onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
//////////////////////////////////OBTEN LOS MOVIMIENTOS DEL USUARIO/////////////////////////////////////////
    
    func getPendingCharges(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/movimientos/pendientes/\(SavedData.getTheUserId())") else {return}
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
                    let result = try JSON(data: data)
                    var status = json["status"] as! Bool
                    var message = json["message"] as? String
                    self.messageForCharges = message
                    self.status = status
                    let dataReceived = json["data"] as! Dictionary<String,AnyObject>
                    
                    for element in dataReceived {
                        let movimientos = dataReceived["movimientos"]
                        self.movimientosArray = movimientos as! [[String : AnyObject]]
                    }
                    for element in self.movimientosArray {
                        let importeTotal = element["importetotal"]
                        let descripcion = element["descripcion"]
                        let idMovimiento = element["idmovimiento"] as! Int
                        let idMovimientoToString = String(idMovimiento)
                        self.idMovimiento.append(idMovimientoToString as! String)
                        
                        
                        self.totalImportes.append(importeTotal as! String)
                        self.totalDescripciones.append(descripcion as! String)
                        print("Aqui estÃ¡ el importeTotal", self.totalImportes)
                    }
                    onSuccess(result)
                    print("Todo ok")
                    
                    
                } catch {
                     onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
               onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }

    
    func getClubesForRegister(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        self.allClubes = [Club]()
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/club_list/\(SavedData.getTheLatitude())/\(SavedData.getTheLongitude())/\(SavedData.getTheUserId())/") else {return}
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
                    let result = try JSON(data: data)
                    if  let dataReceived = json["data"] {

                        self.allClubesInfo = dataReceived as! [[String : AnyObject]]
                        print("Aqui está la data", self.allClubesInfo)
                    
                  
                   
                
                    
                    for allClubesP1 in self.allClubesInfo {
                        if  let clubReceived = allClubesP1["p1"] {
                        self.dictionaryP1 = clubReceived as! [[String : AnyObject]]
                        }
                        
                    }
                    
                    for clubList1 in self.dictionaryP1 {
                        if  let list1 = clubList1["list_club"] {
                        self.listClubP1 = list1 as! [[String : AnyObject]]
                        }
                    }
                    
                    for clubNameP1 in self.listClubP1 {
                   
                        
                        let tempClub : Club = Club()
                        if (clubNameP1["latitud"] as? Double) != nil
                        {
                            tempClub.latitude = clubNameP1["latitud"] as! Double
                        }
                        
                        if (clubNameP1["distance"] as? Double) != nil
                        {
                            tempClub.distance = clubNameP1["distance"] as! Double
                        }
                        
                        if (clubNameP1["agendar"] as? Int) != nil
                        {
                            tempClub.agenda = clubNameP1["agendar"] as! Int
                        }
                        
                        if (clubNameP1["idestado"] as? Int) != nil
                        {
                            tempClub.idEstado = clubNameP1["idestado"] as! Int
                        }
                        
                        if (clubNameP1["direccion"] as? String) != nil
                        {
                            tempClub.address = clubNameP1["direccion"] as! String
                        }
                        
                        
                        if (clubNameP1["horario"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP1["horario"] as! String
                        }
                        
                        if (clubNameP1["idun"] as? Int) != nil
                        {
                            tempClub.clubId = clubNameP1["idun"] as! Int
                        }
                        
                        if (clubNameP1["clave"] as? String) != nil
                        {
                            tempClub.clave = clubNameP1["clave"] as! String
                        }
                        
                        
                        if (clubNameP1["dcount"] as? Int) != nil
                        {
                            tempClub.dCount = clubNameP1["dcount"] as! Int
                        }
                        
                        if (clubNameP1["ruta360"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP1["ruta360"] as! String
                        }
                        
                        if (clubNameP1["nombre"] as? String) != nil
                        {
                            tempClub.name = clubNameP1["nombre"] as! String
                        }
                        
                        if (clubNameP1["rutavideo"] as? String) != nil
                        {
                            tempClub.rutaVideo = clubNameP1["rutavideo"] as! String
                        }
                        
                        if (clubNameP1["preventa"] as? Int) != nil
                        {
                            tempClub.preventa = clubNameP1["preventa"] as! Int
                        }
                        
                        if (clubNameP1["estado"] as? String) != nil
                        {
                            tempClub.estado = clubNameP1["estado"] as! String
                        }
                        
                        if (clubNameP1["longitud"] as? Double) != nil
                        {
                            tempClub.longitude = clubNameP1["longitud"] as! Double
                        }
                        
                        let coordinate₀ = CLLocation(latitude: tempClub.latitude, longitude: tempClub.longitude)
                        let coordinate₁ = CLLocation(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
                        
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        tempClub.distance = distanceInMeters
                        tempClub.group = "Favoritos"
                        self.allClubes.append(tempClub)
                        
                        
                    }
                    
                    for allClubesP2 in self.allClubesInfo {
                        let clubReceived = allClubesP2["p2"]
                        self.dictionaryP2 = clubReceived as! [[String : AnyObject]]
                        
                    }
                    
                    for clubList2 in self.dictionaryP2 {
                        let list2 = clubList2["list_club"]
                        self.listClubP2 = list2 as! [[String : AnyObject]]
                    }
                    
                    for clubNameP2 in self.listClubP2 {
                        let nameP2 = clubNameP2["nombre"]
                        //print("Clubes de la p2", nameP2 ?? "")
                        self.finalList.append(nameP2 as! String)
                        
                        let tempClub : Club = Club()
                        if (clubNameP2["latitud"] as? Double) != nil
                        {
                            tempClub.latitude = clubNameP2["latitud"] as! Double
                        }
                        
                        if (clubNameP2["distance"] as? Double) != nil
                        {
                            tempClub.distance = clubNameP2["distance"] as! Double
                        }
                        
                        if (clubNameP2["agendar"] as? Int) != nil
                        {
                            tempClub.agenda = clubNameP2["agendar"] as! Int
                        }
                        
                        if (clubNameP2["idestado"] as? Int) != nil
                        {
                            tempClub.idEstado = clubNameP2["idestado"] as! Int
                        }
                        
                        if (clubNameP2["direccion"] as? String) != nil
                        {
                            tempClub.address = clubNameP2["direccion"] as! String
                        }
                        
                        
                        if (clubNameP2["horario"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP2["horario"] as! String
                        }
                        
                        if (clubNameP2["idun"] as? Int) != nil
                        {
                            tempClub.clubId = clubNameP2["idun"] as! Int
                        }
                        
                        if (clubNameP2["clave"] as? String) != nil
                        {
                            tempClub.clave = clubNameP2["clave"] as! String
                        }
                        
                        
                        if (clubNameP2["dcount"] as? Int) != nil
                        {
                            tempClub.dCount = clubNameP2["dcount"] as! Int
                        }
                        
                        if (clubNameP2["ruta360"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP2["ruta360"] as! String
                        }
                        
                        if (clubNameP2["nombre"] as? String) != nil
                        {
                            tempClub.name = clubNameP2["nombre"] as! String
                        }
                        
                        if (clubNameP2["rutavideo"] as? String) != nil
                        {
                            tempClub.rutaVideo = clubNameP2["rutavideo"] as! String
                        }
                        
                        if (clubNameP2["preventa"] as? Int) != nil
                        {
                            tempClub.preventa = clubNameP2["preventa"] as! Int
                        }
                        
                        if (clubNameP2["estado"] as? String) != nil
                        {
                            tempClub.estado = clubNameP2["estado"] as! String
                        }
                        
                        if (clubNameP2["longitud"] as? Double) != nil
                        {
                            tempClub.longitude = clubNameP2["longitud"] as! Double
                        }
                        
                        let coordinate₀ = CLLocation(latitude: tempClub.latitude, longitude: tempClub.longitude)
                        let coordinate₁ = CLLocation(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
                        
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        tempClub.distance = distanceInMeters
                        tempClub.group = "Próximas Aperturas"
                        self.allClubes.append(tempClub)
                        
                        
                    }
                    
                    for id2 in self.listClubP2 {
                        let id2 = id2["idun"]
                        //print("id clubes de la p2", id2 ?? 0)
                        self.finalId.append(id2 as! Int)
                    }
                    
                    //////////////////////////////////OBTEN LOS CLUBES DEL DICCIONARIO P3////////////////////////////////
                    
                    for allClubesP3 in self.allClubesInfo {
                        let clubReceived = allClubesP3["p3"]
                        self.dictionaryP3 = clubReceived as! [[String : AnyObject]]
                        
                    }
                    
                    for clubList3 in self.dictionaryP3 {
                        let list3 = clubList3["list_club"]
                        self.listClubP3 = list3 as! [[String : AnyObject]]
                    }
                    
                    for clubNameP3 in self.listClubP3 {
                        let nameP3 = clubNameP3["nombre"]
                        //print("Clubes de la p3", nameP3 ?? "")
                        self.finalList.append(nameP3 as! String)
                        
                        let tempClub : Club = Club()
                        if (clubNameP3["latitud"] as? Double) != nil
                        {
                            tempClub.latitude = clubNameP3["latitud"] as! Double
                        }
                        
                        if (clubNameP3["distance"] as? Double) != nil
                        {
                            tempClub.distance = clubNameP3["distance"] as! Double
                        }
                        
                        if (clubNameP3["agendar"] as? Int) != nil
                        {
                            tempClub.agenda = clubNameP3["agendar"] as! Int
                        }
                        
                        if (clubNameP3["idestado"] as? Int) != nil
                        {
                            tempClub.idEstado = clubNameP3["idestado"] as! Int
                        }
                        
                        if (clubNameP3["direccion"] as? String) != nil
                        {
                            tempClub.address = clubNameP3["direccion"] as! String
                        }
                        
                        
                        if (clubNameP3["horario"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP3["horario"] as! String
                        }
                        
                        if (clubNameP3["idun"] as? Int) != nil
                        {
                            tempClub.clubId = clubNameP3["idun"] as! Int
                        }
                        
                        if (clubNameP3["clave"] as? String) != nil
                        {
                            tempClub.clave = clubNameP3["clave"] as! String
                        }
                        
                        
                        if (clubNameP3["dcount"] as? Int) != nil
                        {
                            tempClub.dCount = clubNameP3["dcount"] as! Int
                        }
                        
                        if (clubNameP3["ruta360"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP3["ruta360"] as! String
                        }
                        
                        if (clubNameP3["nombre"] as? String) != nil
                        {
                            tempClub.name = clubNameP3["nombre"] as! String
                        }
                        
                        if (clubNameP3["rutavideo"] as? String) != nil
                        {
                            tempClub.rutaVideo = clubNameP3["rutavideo"] as! String
                        }
                        
                        if (clubNameP3["preventa"] as? Int) != nil
                        {
                            tempClub.preventa = clubNameP3["preventa"] as! Int
                        }
                        
                        if (clubNameP3["estado"] as? String) != nil
                        {
                            tempClub.estado = clubNameP3["estado"] as! String
                        }
                        
                        if (clubNameP3["longitud"] as? Double) != nil
                        {
                            tempClub.longitude = clubNameP3["longitud"] as! Double
                        }
                        
                        let coordinate₀ = CLLocation(latitude: tempClub.latitude, longitude: tempClub.longitude)
                        let coordinate₁ = CLLocation(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
                        
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        tempClub.distance = distanceInMeters
                        tempClub.group = "Cerca de mi"
                        self.allClubes.append(tempClub)
                    }
                    
                    for id3 in self.listClubP3{
                        let id3 = id3["idun"]
                        //print("id clubes de la p3", id3 ?? 0)
                        self.finalId.append(id3 as! Int)
                    }
                    
                    /////7///////////////////////////////OBTEN LOS CLUBES DEL DICCIONARIO P4///////////////////////////////
                    
                    for allClubesP4 in self.allClubesInfo {
                        let clubReceived = allClubesP4["p4"]
                        self.dictionaryP4 = clubReceived as! [[String : AnyObject]]
                        
                    }
                    
                    for clubList4 in self.dictionaryP4 {
                        let list4 = clubList4["list_club"]
                        self.listClubP4 = list4 as! [[String : AnyObject]]
                    }
                    
                    for clubNameP4 in self.listClubP4 {
                        let nameP4 = clubNameP4["nombre"]
                        self.finalList.append(nameP4 as! String)
                        
                        let tempClub : Club = Club()
                        if (clubNameP4["latitud"] as? Double) != nil
                        {
                            tempClub.latitude = clubNameP4["latitud"] as! Double
                        }
                        
                        if (clubNameP4["distance"] as? Double) != nil
                        {
                            tempClub.distance = clubNameP4["distance"] as! Double
                        }
                        
                        if (clubNameP4["agendar"] as? Int) != nil
                        {
                            tempClub.agenda = clubNameP4["agendar"] as! Int
                        }
                        
                        if (clubNameP4["idestado"] as? Int) != nil
                        {
                            tempClub.idEstado = clubNameP4["idestado"] as! Int
                        }
                        
                        if (clubNameP4["direccion"] as? String) != nil
                        {
                            tempClub.address = clubNameP4["direccion"] as! String
                        }
                        
                        
                        if (clubNameP4["horario"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP4["horario"] as! String
                        }
                        
                        if (clubNameP4["idun"] as? Int) != nil
                        {
                            tempClub.clubId = clubNameP4["idun"] as! Int
                        }
                        
                        if (clubNameP4["clave"] as? String) != nil
                        {
                            tempClub.clave = clubNameP4["clave"] as! String
                        }
                        
                        
                        if (clubNameP4["dcount"] as? Int) != nil
                        {
                            tempClub.dCount = clubNameP4["dcount"] as! Int
                        }
                        
                        if (clubNameP4["ruta360"] as? String) != nil
                        {
                            tempClub.schedule = clubNameP4["ruta360"] as! String
                        }
                        
                        if (clubNameP4["nombre"] as? String) != nil
                        {
                            tempClub.name = clubNameP4["nombre"] as! String
                        }
                        
                        if (clubNameP4["rutavideo"] as? String) != nil
                        {
                            tempClub.rutaVideo = clubNameP4["rutavideo"] as! String
                        }
                        
                        if (clubNameP4["preventa"] as? Int) != nil
                        {
                            tempClub.preventa = clubNameP4["preventa"] as! Int
                        }
                        
                        if (clubNameP4["estado"] as? String) != nil
                        {
                            tempClub.estado = clubNameP4["estado"] as! String
                        }
                        
                        if (clubNameP4["longitud"] as? Double) != nil
                        {
                            tempClub.longitude = clubNameP4["longitud"] as! Double
                        }
                        
                        let coordinate₀ = CLLocation(latitude: tempClub.latitude, longitude: tempClub.longitude)
                        let coordinate₁ = CLLocation(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
                        
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        tempClub.distance = distanceInMeters
                        tempClub.group = "Cerca de mi"
                        self.allClubes.append(tempClub)
                    }
                    
                    
                    for id4 in self.listClubP3{
                        let id4 = id4["idun"]
                        //print("id clubes de la p4", id4 ?? 0)
                        self.finalId.append(id4 as! Int)
                    }
                    
                    print("Lista ids",self.finalId.removeDuplicates())
                    print("Lista clubes",self.finalList.removeDuplicates())
                    //self.allClubes = self.allClubes.removingDuplicates(byKey: {$0.name})
                    
                    var tempList = [Club]()
                    for temp in self.allClubes{
                        
                        if(tempList.filter({$0.clubId == temp.clubId && $0.group == temp.group}).count == 0){
                            tempList.append(temp)
                        }
                    }
                    
                    self.allClubes = tempList.sorted(by: { $0.distance < $1.distance });
                    onSuccess(result)
                    print("Todo ok")
                    }
                    
                } catch {
                    onSuccess(JSON.null)
                    print("Ocurrió un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
    
    func reorderLocation()->Bool{
        var tempList = [Club]()
        for temp in self.allClubes{
            
            if(tempList.filter({$0.clubId == temp.clubId && $0.group == temp.group}).count == 0){
                let coordinate₀ = CLLocation(latitude: temp.latitude, longitude: temp.longitude)
                let coordinate₁ = CLLocation(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                temp.distance = distanceInMeters
                tempList.append(temp)
            }
        }
        
        self.allClubes = tempList.sorted(by: { $0.distance < $1.distance });
        return true
    }
    func getClasessByClub(date:Date,idClub:Int, onSuccess: @escaping(ClassResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let calendar = Calendar.current
        var returnResponse : ClassResponse = ClassResponse()
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        let result = formatter.string(from: date)
        
        guard let url = URL(string: "https://prepago.sportsworld.com.mx/api/v1/app/class/list/reservation/\(idClub)/\(result)/\(SavedData.getTheUserId())/") else {return}
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
                    let dataReceived = json["data"]
                    print(dataReceived ?? "")
                    var tempArrayClasses : [ClassSW] = [ClassSW]()
                    for clubData in dataReceived as! [[String : AnyObject]]{
                        let tempClass : ClassSW = ClassSW()
                        if (clubData["idinstalacionactividadprogramada"] as? Int) != nil
                        {
                            tempClass.idinstalacionactividadprogramada = clubData["idinstalacionactividadprogramada"] as! Int
                        }
                        
                        if (clubData["club"] as? String) != nil
                        {
                            tempClass.club = clubData["club"] as! String
                        }
                        
                        if (clubData["salon"] as? String) != nil
                        {
                            tempClass.salon = clubData["salon"] as! String
                        }
                        
                        if (clubData["idsalon"] as? Int) != nil
                        {
                            tempClass.idsalon = clubData["idsalon"] as! Int
                        }
                        
                        if (clubData["clase"] as? String) != nil
                        {
                            tempClass.clase = clubData["clase"] as! String
                        }
                        
                        if (clubData["idclase"] as? Int) != nil
                        {
                            tempClass.idclase = clubData["idclase"] as! Int
                        }
                        
                        if (clubData["instructor"] as? String) != nil
                        {
                            tempClass.instructor = clubData["instructor"] as! String
                        }
                        
                        if (clubData["inicio"] as? String) != nil
                        {
                            tempClass.inicio = clubData["inicio"] as! String
                        }
                        
                        if (clubData["fin"] as? String) != nil
                        {
                            tempClass.fin = clubData["fin"] as! String
                        }
                        
                        if (clubData["iniciovigencia"] as? String) != nil
                        {
                            tempClass.iniciovigencia = clubData["iniciovigencia"] as! String
                        }
                        
                        if (clubData["finvigencia"] as? String) != nil
                        {
                            tempClass.finvigencia = clubData["finvigencia"] as! String
                        }
                        
                        if (clubData["capacidadideal"] as? Int) != nil
                        {
                            tempClass.capacidadideal = clubData["capacidadideal"] as! Int
                        }
                        
                        if (clubData["capacidadmaxima"] as? Int) != nil
                        {
                            tempClass.capacidadmaxima = clubData["capacidadmaxima"] as! Int
                        }
                        
                        if (clubData["capacidadregistrada"] as? Int) != nil
                        {
                            tempClass.capacidadregistrada = clubData["capacidadregistrada"] as! Int
                        }
                        
                        if (clubData["reservacion"] as? Int) != nil
                        {
                            tempClass.reservacion = clubData["reservacion"] as! Int
                        }
                        
                        if (clubData["confirmados"] as? Int) != nil
                        {
                            tempClass.confirmados = clubData["confirmados"] as! Int
                        }
                        
                        if (clubData["agendar"] as? Int) != nil
                        {
                            tempClass.agendar = clubData["agendar"] as! Int
                        }
                        
                        if (clubData["demand"] as? Int) != nil
                        {
                            tempClass.demand = clubData["demand"] as! Int
                        }
                        
                        if (clubData["inscrito"] as? Bool) != nil
                        {
                            tempClass.inscrito = clubData["inscrito"] as! Bool
                        }
                        
                        tempArrayClasses.append(tempClass)
                    }
                    
                    returnResponse.status = true
                    returnResponse.data = tempArrayClasses
                    onSuccess(returnResponse)
                    
                     self.codeMessage = 0
                } catch {
                    print(error)
                    returnResponse.status = false
                    print("Ocurrió un error")
                   
                    onSuccess(returnResponse)
                }
            
                
                
            }
            
            /*if(error != nil){
                returnResponse.status = false
                 onSuccess(returnResponse)
                print("Todo mal")
            } else{
                returnResponse.status = false
                 onSuccess(returnResponse)
            }*/
        })
        task.resume()
    }
    
    func makeReservation(params : [String:Any], onSuccess: @escaping(GenericResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        

        guard let url = URL(string: "https://prepago.sportsworld.com.mx/api/v1/app/class/reservation")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let j = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    let result : GenericResponse = GenericResponse()
                    if (j["message"] as? String) != nil
                    {
                        result.message = j["message"] as! String
                    }
                    
                    if (j["status"] as? Bool) != nil
                    {
                        result.status = j["status"] as! Bool
                    }
                    
                    onSuccess(result)
                    
                    
                } catch {
                    print(error)
                    print("Ocurrió un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    func getClassDescription(idClass : Int, onSuccess: @escaping(DescriptionResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/descipcion_clase/\(idClass)/")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(SavedData.getSecretKey(), forHTTPHeaderField: "secret-key")
        /*
         guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/news") else {return}
         var  request = URLRequest(url: url)
         request.httpMethod = "GET"
         let session = URLSession.shared
         let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in*/
        
        
        
        let session = URLSession.shared
        //request.httpBody = httpBody
        
        //let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let j = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    let result : DescriptionResponse = DescriptionResponse()
                    if (j["message"] as? String) != nil
                    {
                        result.message = j["message"] as! String
                    }
                    
                    if (j["status"] as? Bool) != nil
                    {
                        result.status = j["status"] as! Bool
                        if(result.status){
                            let dataReceived = j["data"] as! [Dictionary<String,AnyObject>]
                            if(dataReceived.count > 0){
                                if (dataReceived[0]["descripcionHTML"] as? String) != nil
                                {
                                    result.data.descripcionHTML = dataReceived[0]["descripcionHTML"] as! String
                                    print("result.data.descripcionHTM", result.data.descripcionHTML)
                                }
                            }
                        }
                    }
                    
                    
                    
                    onSuccess(result)
                    
                    
                } catch {
                    print(error)
                    print("Ocurrió un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    func cancelReservation(params : [String:String], onSuccess: @escaping(GenericResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/class/cancelar_reservacion/")
            else {return}
        
        
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.encodeParameters(parameters:params)
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
        /*var  request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.addValue(SavedData.getSecretKey(), forHTTPHeaderField: "secret-key")
         
         guard  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
         return
         }
         request.httpBody = httpBody
         
         let session = URLSession.shared*/
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let j = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    //let result = try JSON(data: data)
                    let result : GenericResponse = GenericResponse()
                    if (j["message"] as? String) != nil
                    {
                        result.message = j["message"] as! String
                    }
                    
                    if (j["status"] as? Bool) != nil
                    {
                        result.status = j["status"] as! Bool
                    }
                    
                    onSuccess(result)
                    
                    
                } catch {
                    print(error)
                    print("Ocurrió un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    
    func changeFavorite(params : [String:String], onSuccess: @escaping(GenericResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/club/favorite/set/")
            else {return}
        
        
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.encodeParameters(parameters:params)
        request.addValue(SavedData.getSecretKey(), forHTTPHeaderField: "secret-key")
        
        /*var  request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.addValue(SavedData.getSecretKey(), forHTTPHeaderField: "secret-key")
         
         guard  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
         return
         }
         request.httpBody = httpBody
         
         let session = URLSession.shared*/
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let j = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    //let result = try JSON(data: data)
                    let result : GenericResponse = GenericResponse()
                    if (j["message"] as? String) != nil
                    {
                        result.message = j["message"] as! String
                    }
                    
                    if (j["status"] as? Bool) != nil
                    {
                        result.status = j["status"] as! Bool
                        if(result.status){
                            APIManager.sharedInstance.getClubesForRegister(onSuccess: { json in
                                
                                
                                onSuccess(result)
                                
                            }, onFailure: { error in
                                onSuccess(result)
                            })
                                
                        }
                    }
                    
                    
                    
                    
                } catch {
                    print(error)
                    print("Ocurrió un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    func getClubDetail(onSuccess: @escaping(ClubResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        guard let url = URL(string:"https://app.sportsworld.com.mx/api/v2/club/details/\( APIManager.sharedInstance.selectedClub.clubId)/0/")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue(SavedData.getSecretKey(), forHTTPHeaderField: "secret-key")
        /*
 guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/news") else {return}
 var  request = URLRequest(url: url)
 request.httpMethod = "GET"
 let session = URLSession.shared
 let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in*/
        
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let j = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    //let result = try JSON(data: data)
                    let result : ClubResponse = ClubResponse()
                    if (j["message"] as? String) != nil
                    {
                        result.message = j["message"] as! String
                    }
                    
                    if (j["status"] as? Bool) != nil
                    {
                        result.status = j["status"] as! Bool
                    }
                    let dataReceived = j["data"] as! Dictionary<String,AnyObject>
                    
                    if (dataReceived["latitud"] as? Double) != nil
                    {
                        result.data.latitud = dataReceived["latitud"] as! Double
                    }
                    
                    if (dataReceived["longitud"] as? Double) != nil
                    {
                        result.data.longitud = dataReceived["longitud"] as! Double
                    }
                    
                    if (dataReceived["agendar"] as? Int) != nil
                    {
                        result.data.agendar = dataReceived["agendar"] as! Int
                    }
                    
                    if (dataReceived["favorito"] as? Bool) != nil
                    {
                        result.data.favorito = dataReceived["favorito"] as! Bool
                    }
                    
                    if (dataReceived["direccion"] as? String) != nil
                    {
                        result.data.direccion = dataReceived["direccion"] as! String
                    }
                    
                    if (dataReceived["horario"] as? String) != nil
                    {
                        result.data.horario = dataReceived["horario"] as! String
                    }
                    
                    if (dataReceived["idun"] as? Int) != nil
                    {
                        result.data.idun = dataReceived["idun"] as! Int
                    }
                    
                    if (dataReceived["imagenes_club"] as? [String]) != nil
                    {
                        result.data.imagenes_club = dataReceived["imagenes_club"] as! [String]
                    }
                    
                    if (dataReceived["ruta360"] as? String) != nil
                    {
                        result.data.ruta360 = dataReceived["ruta360"] as! String
                    }
                    
                    if (dataReceived["nombre"] as? String) != nil
                    {
                        result.data.nombre = dataReceived["nombre"] as! String
                    }
                    
                    if (dataReceived["rutavideo"] as? String) != nil
                    {
                        result.data.rutavideo = dataReceived["rutavideo"] as! String
                    }
                    
                    if (dataReceived["preventa"] as? Int) != nil
                    {
                        result.data.preventa = dataReceived["preventa"] as! Int
                    }
                    
                    if (dataReceived["telefono"] as? String) != nil
                    {
                        result.data.telefono = dataReceived["telefono"] as! String
                    }
                    
                    onSuccess(result)
                    
                    
                } catch {
                    print(error)
                    print("Ocurrió un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
/////////////////////////////CONEKTA REQUEST///////////////////////////////
    func conekta(token_id: String, person_id: Int, name: String,
                 unit_price:Int, quantity: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let params : [String:Any] = ["token_id": token_id,
                                     "person_id" : person_id,
                                     "line_items" : ["name" : name,
                                                     "unit_price": unit_price,
                                                     "quantity": quantity]
                                     ]
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/api/v1/app/conekta")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    let code = json["code"]
                    
                    print("Este es el mensaje de conekta", mensaje ?? "")
                    self.message = mensaje as! String
                    self.codeMessage = code as! Int
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
                    
                    
                } catch {
                    print(error)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    //////////////////////////////OBTEN PUNTOS EARN IT//////////////////////////////////////////////////
    func earnIt(userId: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let params : [String:Any] = ["id": userId]
        guard let url = URL(string: "http://manticore.4p.com.mx/manticore/beneficiarioRewards/puntos")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("5p0r75w0rlD09632", forHTTPHeaderField: "tokenCliente")
        
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
                    let success = json["success"]
                    if  let dataTemp = json["data"] as?  [String:AnyObject] {
                    self.status = success as! Bool
                        if  let puntos = dataTemp["puntos"] as? NSNumber {
                             self.puntos = puntos
                        }
                   

                    }
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
                    
                } catch {
                    print(error)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onFailure(error!)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
///////////////////////////////////CONFIGURACIÃ“N////////////////////////////////////////////
   
    func profileUpdate(height: Double, weight: Double, age: Int, img:String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let params : [String:Any] = ["height": height,
                                     "weight": weight,
                                     "age": age,
                                     "user_id": SavedData.getTheUserId(),
                                     "dob": "1983-05-03",
                                     "memunic_id": 0,
                                     "img": img]
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/profile/update/v2/")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let success = json["status"]
                    let mensaje = json["message"]
                    self.satusProfile = success as! Bool
                    self.message = mensaje as! String
                    if let  dataUpdate = json["data"] as? [String:Any]{
                    print("Este es el data update", dataUpdate)

                    if let profilePic = dataUpdate["profile_photo"] {
                    var profPic = profilePic as! String
                        self.profileImage = profPic
                        
                        SavedData.setTheProfilePic(profilePic: profPic)
                        
                    }
                 
                    if let name = dataUpdate["name"] {
                        var nombre = name as! String
                        SavedData.setTheName(theName: nombre)
                    }
                    if let mainteiment = dataUpdate["mainteiment"] {
                        var maint = mainteiment as! String
                        //SavedData.setTheName(theName: maint)
                        SavedData.setTheMantaniance(mantaniance: maint)
                    }
                    if let mail = dataUpdate["mail"] {
                        var correo = mail as! String
                        //SavedData.setTheE(theName: correo)
                        SavedData.setTheEmail(email: correo)
                    }
                        if let club = dataUpdate["club"] {
                            var club = club as! String
                            //SavedData.setTheE(theName: correo)
                            SavedData.setTheClub(club: club)
                        }
                        
                    }
                    

                    print("Todo ok")
                    
                    print(json )
                   onSuccess(JSON.null)
                } catch {
                    print(error)
                    print("OcurriÃ³ un error")
                }
            }
            if(error != nil){
                   onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
///////////////////////////RECUPERAR CONTRASEÃ‘A////////////////////////////
    
    func recoverPassword(email:String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let params : [String:Any] = ["email": email]
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/app/api/v1/usuario/pass/recuperar")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"] as? String
                    let code = json ["code"]
                    self.codeMessage = code as! Int
                    self.message = mensaje
                    
                    print("Todo ok")
                    print(json )
                    onSuccess(result)
                    
                } catch {
                    print(error)
                    onSuccess(JSON.null)
                }
            }
            if(error != nil){
                onFailure(error!)
                onSuccess(JSON.null)
            } else{
                
            }
        })
        task.resume()
    }
    
//////////////////////////////CONSULTA LAS NOTICIAS///////////////////////
    func getNews(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/noticias/api/v1/noticias") else {return}
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
                    let result = try JSON(data: data)
                    var status = json["code"] as! Int
                    self.codeMessage = status
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                    
                  
                    for element in dataReceived{
                       // let resumen = element["resumen"]
                        let titulo = element["titulo"]
                        let descripcion = element["descripcion"]
                        let subtitulo = element["subtitulo"]
                        let imagenNoticia = element["imagen"]
                        self.imagenNoticia.append(imagenNoticia as! String)
                        self.subtitulo.append(subtitulo as! String)
                        self.descripcionArray.append(descripcion as! String)
                        self.tituloArray.append(titulo as! String)
                        //self.noticaResumen.append(resumen as! String)
                    }
                    }
                    onSuccess(result)
                    print("Todo ok")
                    
                    
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)

                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }

    func getMetas(onSuccess: @escaping(MetasResponse) -> Void) {
        let metaResponse : MetasResponse = MetasResponse()
        metaResponse.code = 500
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/nutricion/api/v1/metas") else {return}
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
                    _ = try JSON(data: data)
                    metaResponse.code = json["code"] as! Int
                    metaResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        
                        for element in dataReceived{
                            let tempData : MetaData = MetaData()
                        
                            tempData.id = element["id"] as! Int
                            tempData.nombre = element["nombre"] as! String
                            metaResponse.data.append(tempData)
                        
                        }
                    }
                    onSuccess(metaResponse)
                    print("Todo ok")
                    
                    
                } catch {
                    print(metaResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(metaResponse)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
/////////////////////////////////////////CONSULTA HISTORIAL INBODY//////////////////////////////////////////////////
    func getLastInbody(onSuccess: @escaping(JSON)-> Void) {
        APIManager.sharedInstance.lastInbody = []
        APIManager.sharedInstance.inbodyValues = []
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/piso/api/v1/lastInBody/\(SavedData.getTheUserId())") else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
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
                    let result = try JSON(data: data)
                    var status = json["status"] as! String
                    var  mensaje = json["message"] as! String
                    self.satusString = status
                    self.message = mensaje
                    if  let dataReceived = json["data"]as? [[String: Any]] {
                    
                        
                        
                    for element in dataReceived {
                       let dataReceived = Array(element.keys)
                          self.inbodyValues = dataReceived// for Dictionary
                        if let index = self.inbodyValues.index(of:"fechaEliminacion") {
                            self.inbodyValues.remove(at: index)
                        }
                        if let indexTwo = self.inbodyValues.index(of: "fecha"){
                             self.inbodyValues.remove(at: indexTwo)
                        }
                        
                       
                        print("Camara no me agüito", self.inbodyValues)
                        let peso = element ["peso"] as! String
                        SavedData.setTheWeight(weight: Double(peso)!)
                        self.pesoInbody = Double(peso)!
                        let estatura = element["estatura"] as! String
                        SavedData.setTheHeight(height: Double(estatura)!)
                        self.estaturaInbody = Double(estatura)!
                        let rcc = element ["RCC"] as! String
                        self.rccInbody = Double(rcc)!
                        let pgc = element ["PGC"] as! String
                        self.pgcInbody = Double(pgc)!
                        let imc = element ["IMC"] as! String
                        self.imcInbody = Double(imc)!
                        let mme = element ["MME"] as! String
                        self.mmeInbody = Double(mme)!
                        let mcg = element ["MCG"] as! String
                        self.mcgInbody = Double(mcg)!
                        let act = element ["ACT"] as! String
                        self.actInbody = Double(act)!
                        let minerales = element ["minerales"] as! String
                        self.mineralesInbody = Double(minerales)!
                        let proteina = element ["proteina"] as! String
                        self.proteinaInbody = Double(proteina)!
                        let fcresp = element ["fcresp"] as! String
                        self.fcrespInbody = Double(fcresp)!
                     
                        self.lastInbody.append(Double(peso)!)
                        self.lastInbody.append(Double(estatura)!)
                        self.lastInbody.append(Double(rcc)!)
                         self.lastInbody.append(Double(pgc)!)
                         self.lastInbody.append(Double(imc)!)
                         self.lastInbody.append(Double(mme)!)
                         self.lastInbody.append(Double(mcg)!)
                         self.lastInbody.append(Double(act)!)
                         self.lastInbody.append(Double(minerales)!)
                         self.lastInbody.append(Double(proteina)!)
                         self.lastInbody.append(Double(fcresp)!)
                       
                        print("Esste es el array de last inbody", self.lastInbody)
                        }
                    
                    }
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)

    
                }
            }
            if(error != nil){
                
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
/////////////////////////////////SEND PASES DE INVITADO///////////////////////////////////
    
        func enviarPasesInvitado(to: String, nameto: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
            let params : [String:Any] = ["idPersona": SavedData.getTheUserId(),
                                         "to": to,
                                         "nameto": nameto,
                                         "subject": "Pase de Invitado"]
            
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/app/api/v1/pases/mailPaseInvitado")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    let code = json["code"] as! Int
                    self.codeMessage = code
                    self.message = mensaje as! String
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
        
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                 onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    func getDiet(meta: Int,onSuccess: @escaping(AsignMetaResponse) -> Void) {
        
        let asignResponse : AsignMetaResponse = AsignMetaResponse()
        asignResponse.code = 500
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let result = formatter.string(from: Date())
       
     

        
       guard let url = URL(string: "https://cloud.sportsworld.com.mx/nutricion/api/v1/mostrarDietasUsuario/\( SavedData.getTheUserId())/\(result)") else {return}

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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    
                    
                    let result = try JSON(data: data)
                    asignResponse.code = json["code"] as! Int
                    asignResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        
                        for element in dataReceived{
                            let tempData : DietDateData = DietDateData()
                            
                            tempData.usuario = element["usuario"] as! Int
                            tempData.cableMeta = element["cableMeta"] as! Int
                            tempData.cableDieta = element["cableDieta"] as! Int
                            
                            tempData.dia =  dateFormatter.date(from:  element["dia"] as! String)!
                            tempData.nombreMeta = element["nombreMeta"] as! String
                            tempData.nombreDieta = element["nombreDieta"] as! String
                            asignResponse.data.append(tempData)
                            
                        }
                    }
                    
                    print(json )
                    onSuccess(asignResponse)
                    
                } catch {
                    print(asignResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(asignResponse)
                print("Todo mal")
            } else{
                onSuccess(asignResponse)
            }
        })
        task.resume()
    }
    
    func getDietById(id: Int,onSuccess: @escaping(ComidaResponse) -> Void) {
        
        let comidaResponse : ComidaResponse = ComidaResponse()
        comidaResponse.code = 500
        
        
        
        
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/nutricion/api/v1/dieta/\(id)") else {return}
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    
                    
                    let result = try JSON(data: data)
                    comidaResponse.code = json["code"] as! Int
                    comidaResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        
                        for element in dataReceived{
                            let tempData : Comida = Comida()
                            
                            tempData.descripcion = element["descripcion"] as! String
                            tempData.horario = element["horario"] as! String
                            tempData.tipo = element["tipo"] as! String
                            
                            
                            comidaResponse.data.append(tempData)
                            
                        }
                    }
                    
                    print(json )
                    onSuccess(comidaResponse)
                    
                } catch {
                    print(comidaResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(comidaResponse)
                print("Todo mal")
            } else{
                onSuccess(comidaResponse)
            }
        })
        task.resume()
    }
    
    func getRecipies(id: Int,onSuccess: @escaping(RecetaResponse) -> Void) {
        
        let recetaResponse : RecetaResponse = RecetaResponse()
        recetaResponse.code = 500
        
        
       
      
        
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/nutricion/api/v1/recetas") else {return}
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    
                    
                    let result = try JSON(data: data)
                    recetaResponse.code = json["code"] as! Int
                    recetaResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        
                        for element in dataReceived{
                            let tempData : Receta = Receta()
                            
                            tempData.id = element["id"] as! Int
                            tempData.nombre = element["nombre"] as! String
                            tempData.descripcion = element["descripcion"] as! String
                            tempData.descripcion = element["descripcion"] as! String
                            tempData.foto = element["foto"] as! String
                            
                            
                            recetaResponse.data.append(tempData)
                            
                        }
                    }
                    
                    print(json )
                    onSuccess(recetaResponse)
                    
                } catch {
                    print(recetaResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(recetaResponse)
                print("Todo mal")
            } else{
                onSuccess(recetaResponse)
            }
        })
        task.resume()
    }
    func assignMeta(meta: Int,onSuccess: @escaping(AsignMetaResponse) -> Void) {
        
        var asignResponse : AsignMetaResponse = AsignMetaResponse()
        //asignResponse.code = 500
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let result = formatter.string(from: Date())
        let params : [String:Any] = ["usuario": SavedData.getTheUserId(),
                                     "dia": result,
                                     "meta_id": meta]
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/nutricion/api/v1/crearUsuarioDietas")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    
                    
                    let result = try JSON(data: data)
                    asignResponse.code = json["code"] as! Int
                    asignResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        
                        for element in dataReceived{
                            let tempData : DietDateData = DietDateData()
                            
                            tempData.usuario = element["usuario"] as! Int
                            tempData.cableMeta = element["cableMeta"] as! Int
                            tempData.cableDieta = element["cableDieta"] as! Int
                            
                            tempData.dia =  dateFormatter.date(from:  element["dia"] as! String)!
                            tempData.nombreMeta = element["nombreMeta"] as! String
                            tempData.nombreDieta = element["nombreDieta"] as! String
                            asignResponse.data.append(tempData)
                            
                        }
                    }
                    
                    print(json )
                    onSuccess(asignResponse)
                    
                } catch {
                    print(asignResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(asignResponse)
                print("Todo mal")
            } else{
                onSuccess(asignResponse)
            }
        })
        task.resume()
    }
//////////////////////////// GET CONVENIOS//////////////////////////////////////////
    
    func getConvenios(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Bool) -> Void) {
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/beneficios/api/v1/readBeneficio/") else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
        var  request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as!  Dictionary<String,AnyObject>
                    print(json)
                    let result = try JSON(data: data)
                    
                    let beneficios = json["beneficios"] as! [[String:AnyObject]]
                    print("Beneficios aqui estan", beneficios)
                    for element in beneficios {
                        let beneficioName = element["nombre"] as! String
                        let clausulasBeneficio = element["clausulas"] as! String
                        let logotipo = element["logotipo"] as! String
                        self.clausulasConvenio.append(clausulasBeneficio)
                        self.logotipoConvenio.append(logotipo)
                        self.nombreConvenio.append(beneficioName)
                    }
                 
                    
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)

                    print("OcurriÃ³ un error")
                }
            }
            if(error != nil){
              onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
    
    public func getSecretKey()->String {
        
        
        
        if(SavedData.getSecretKey() != "" && SavedData.getTokenDay() ==  Date().string(format: "yyyy-MM-dd")){
            return SavedData.getSecretKey()
        }
        
        do{
            
            let str = try String(contentsOf: URL(string:"https://cloud.sportsworld.com.mx/api/key")!)
            SavedData.setSecretKey(secretKey: str)
            SavedData.setTokenDay(tokenDay: Date().string(format: "yyyy-MM-dd"))
            
            return str
        }catch{
         return ""
        }
    }

///////////////////////////////////CONECTA PASES POR MEMBRESIA////////////////////////////////
    func getPasesDeInvitado(onSuccess: @escaping(PasesResponse) -> Void) {
        
           let pasesResponse : PasesResponse = PasesResponse()
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/app/api/v1/pases/readPasesPorMembresia/\(SavedData.getMemUnicId())") /*cambiar el id de usuario de SavedData*/else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
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
                    let result = try JSON(data: data)
                  
                   /* let nombre = element["nombre"] as! String
                    let finVigencia = element["finVigencia"] as! String
                    self.finVigencia.append(finVigencia)
                    self.nombrePase.append(nombre)*/
                 
                     if let asignados = json["asignados"] as? [[String:AnyObject]] {
                        
                            for element in asignados{
                                let pasesData : Pases = Pases()
                                
                                pasesData.producto = element["producto"] as! String
                                pasesData.cuando = element["cuando"] as! String
            
                                pasesResponse.data.append(pasesData)
                            }
                }
                    onSuccess(pasesResponse)
                } catch {
                    onSuccess(pasesResponse)
                }
            }
            if(error != nil){
                onSuccess(pasesResponse)
            } else{
            }
        })
        task.resume()
    }
    
    
    func getPasesDeInvitadoPorAsignar(onSuccess: @escaping(PasesPorAsignarResponse) -> Void) {
        
        let pasesResponsePorAsignarResponse : PasesPorAsignarResponse = PasesPorAsignarResponse()
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/app/api/v1/pases/readPasesPorMembresia/\(SavedData.getMemUnicId()))") /*cambiar el id de usuario de SavedData*/else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
        
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
                    let result = try JSON(data: data)
                    
                    /* let nombre = element["nombre"] as! String
                     let finVigencia = element["finVigencia"] as! String
                     self.finVigencia.append(finVigencia)
                     self.nombrePase.append(nombre)*/
                     pasesResponsePorAsignarResponse.message = json["message"] as! String
                    if let pases = json ["pases"] as? [[String:AnyObject]] {
                        
                        for element in pases {
                            let pasesDataPorAsignar: PasesPorAsignar = PasesPorAsignar()
                            pasesDataPorAsignar.nombre = element["nombre"] as! String
                            pasesDataPorAsignar.finVigencia = element["finVigencia"] as! String
                            
                            pasesResponsePorAsignarResponse.data.append(pasesDataPorAsignar)
                        }
                    }
               
                    onSuccess(pasesResponsePorAsignarResponse)
                } catch {
                    onSuccess(pasesResponsePorAsignarResponse)
                }
            }
            if(error != nil){
                onSuccess(pasesResponsePorAsignarResponse)
            } else{
            }
        })
        task.resume()
    }
    
//////////////////////////////////////////LISTADO DE FACTURAS/////////////////////////////
    func getListadoFacturas(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Bool) -> Void) {
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/app/api/v1/listadoDeFacturas/\(SavedData.getTheUserId())") else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
        var  request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as!  Dictionary<String,AnyObject>
                    print(json)
                    let result = try JSON(data: data)
                    self.message = json["message"] as! String
                    self.codeMessage = json["code"] as! Int
                    
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        for element in dataReceived {
                    let folio = element ["folio"] as! String
                    let importe = element["importe"] as! String
                    let fecha = element["fecha"] as! String
                    let pdf = element["pdf"] as! String
                    self.folios.append(folio)
                    self.importes.append(importe)
                    self.fechas.append(fecha)
                    self.pdfs.append(pdf)
                        }
                    }
                    
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)
                    
                    print("OcurriÃ³ un error")
                }
            }
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
        
    }
    
    func getAvancesInbody(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/piso/api/v1/lastInBody/\(SavedData.getTheUserId())") else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
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
                    let result = try JSON(data: data)
                    var status = json["status"] as! String
                    var  mensaje = json["message"] as! String
                    self.satusString = status
                    self.message = mensaje
                    if  let dataReceived = json["data"]as? [[String: Any]] {
                        
                        
                        
                        for element in dataReceived {
                            let dataReceived = Array(element.keys)
                            self.inbodyValues = dataReceived// for Dictionary
                            if let index = self.inbodyValues.index(of:"fechaEliminacion") {
                                self.inbodyValues.remove(at: index)
                            }
                            if let indexTwo = self.inbodyValues.index(of: "fecha"){
                                self.inbodyValues.remove(at: indexTwo)
                            }
                            
                            
                            print("Camara no me agüito", self.inbodyValues)
                            let peso = element ["peso"] as! String
                            let estatura = element["estatura"] as! String
                            let rcc = element ["RCC"] as! String
                            let pgc = element ["PGC"] as! String
                            let imc = element ["IMC"] as! String
                            let mme = element ["MME"] as! String
                            let mcg = element ["MCG"] as! String
                            let act = element ["ACT"] as! String
                            let minerales = element ["minerales"] as! String
                            let proteina = element ["proteina"] as! String
                            let fcresp = element ["fcresp"] as! String
                          
                            
                            self.lastInbody.append(Double(peso)!)
                            self.lastInbody.append(Double(estatura)!)
                            self.lastInbody.append(Double(rcc)!)
                            self.lastInbody.append(Double(pgc)!)
                            self.lastInbody.append(Double(imc)!)
                            self.lastInbody.append(Double(mme)!)
                            self.lastInbody.append(Double(mcg)!)
                            self.lastInbody.append(Double(act)!)
                            self.lastInbody.append(Double(minerales)!)
                            self.lastInbody.append(Double(proteina)!)
                            self.lastInbody.append(Double(fcresp)!)
                            
                            print("Esste es el array de last inbody", self.lastInbody)
                        }
                        
                    }
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)
                    
                    
                }
            }
            if(error != nil){
                
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
    
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    func getReadMenu(date: String, completion: @escaping (Result<ReadMenu>) -> Void ) {
        

        guard let url = URL(string: "http://cloud.sportsworld.com.mx/piso/api/v1/menu/readMenu/\(SavedData.getTheUserId())/\(date)") else {return}
//
        
        
        if let inProgressTask = tasksInProgress[url] {
            inProgressTask.cancel()
        }
        
        let task = URLSession.shared.readMenuTask(with: url) { readMenu, _, error in
            DispatchQueue.main.async {
                if let readMenu = readMenu {
                    completion(Result.success(readMenu))
                    
                } else {
                    guard let error = error else {
                        let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: "unable to load menu"])
                        completion(Result.failure(error))
                        return
                    }
                    if error.localizedDescription != "cancelled" {
                        completion(Result.failure(error))
                    }                    
                }
            }            
        }
        tasksInProgress[url] = task
        task.resume()
        
    }
    
    func getEntrenamientos(date: String ,onSuccess: @escaping(EntrenamientosResponse) -> Void) {
      
        
        

        let entrenamientoResponse : EntrenamientosResponse = EntrenamientosResponse()
        
        
        entrenamientoResponse.data = []
        
        

        guard let url = URL(string: "http://cloud.sportsworld.com.mx/piso/api/v1/menu/readMenu/\(SavedData.getTheUserId())/\(date)") else {return}
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    
                    
                    let result = try JSON(data: data)
                    entrenamientoResponse.code = json["code"] as! Int
                    entrenamientoResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        
                        for element in dataReceived{
                            let entrenamientoData : Entrenamiento = Entrenamiento()
                            
                            entrenamientoData.clave = element["clave"] as! String
                            entrenamientoData.orden = element["orden"] as! Int
                            entrenamientoData.nombre = element["nombre"] as! String
                            entrenamientoData.video = element["video"] as! String
                            entrenamientoData.series = element["series"] as! Int
                            entrenamientoData.repeticiones = element["repeticiones"] as! Int
                            entrenamientoData.descanso = element["descanso"] as! Int
                            entrenamientoData.completado = element["completado"] as! Bool
                            entrenamientoData.fechaStr = date
                            
                            entrenamientoResponse.data.append(entrenamientoData)
                            
                        }
                    }
                    
                    print(json )
                    onSuccess(entrenamientoResponse)
                    
                } catch {
                    print(entrenamientoResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(entrenamientoResponse)
                print("Todo mal")
            } else{
                onSuccess(entrenamientoResponse)
            }
        })
        task.resume()
    }
    
    func registraEjercicio(entramiento: Entrenamiento, onSuccess: @escaping(CompletadoResponse) -> Void) {
        
        let completadoResponse : CompletadoResponse = CompletadoResponse()
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/piso/api/v1/menu/ejercicioCompletado/\(entramiento.clave)/\(entramiento.fechaStr)") else {return}
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
                    

                    
                    let result = try JSON(data: data)
                    completadoResponse.code = json["code"] as! Int
                    completadoResponse.message = json["message"] as! String
                    if(completadoResponse.code == 200){
                        if let  data = json ["data"] as? [String:AnyObject]{
                            completadoResponse.completado = data["completado"] as! Bool
                            
                        }
                    }
                    
                    
                    
                    print(json )
                    onSuccess(completadoResponse)
                    
                } catch {
                    print(completadoResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(completadoResponse)
                print("Todo mal")
            } else{
                onSuccess(completadoResponse)
            }
        })
        task.resume()
    }
    
    func getReservacionesInBody(clubId:Int,onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Bool) -> Void){
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/wellness/api/v1/readHDxDia/\(clubId)") else {return}
        var request =  URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        self.horarios = [Horarios]()
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                //print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as!  Dictionary<String,AnyObject>
                    
                    let result = try JSON(data: data)
                    self.message = json["message"] as! String
                    self.codeMessage = json["code"] as! Int
                    if let dataReceived = json["data"] as? [[String:AnyObject]]{
                        
                        for element in dataReceived {
                            print(element.keys)
                            for elemento in element{
                                print(elemento.value)
                                self.horarios.append(Horarios(hora: elemento.value as! [String], fecha: elemento.key))
                            }
                        }
                    }
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)
                    
                    print("OcurriÃ³ un error")
                }
            }
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
    
    /*func hacerReservacion(horario:String,fechaSolicitud:String,idClub:Int, onsuccess:@escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let params : [String:Any] = ["idPersona": SavedData.getTheUserId(),
                                     "idUn": idClub,
                                     "horario": horario,
                                     "fechaSolicitud": fechaSolicitud
        ]
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/wellness/api/v1/createReservaInbody")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
        })
        
    }*/
    
    
    func hacerReservacion(horario:String,fechaSolicitud:String,idClub:Int,onSuccess: @escaping(AsignInbodyResponse) -> Void) {
        
        var asingInbodyResponse : AsignInbodyResponse = AsignInbodyResponse()
        //asingInbodyResponse.code = 500
        //asingInbodyResponse.message = "Ocurrio un error"
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd" 
    let params : [String:Any] = ["idPersona": String(SavedData.getTheUserId()),
    "idUn": String(idClub),
    "fechaSolicitud": fechaSolicitud
    ]

        guard let url = URL(string: "http://cloud.sportsworld.com.mx/wellness/api/v1/createReservaInbody")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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

                    asingInbodyResponse.code = json["code"] as! Int
                    asingInbodyResponse.message = json["message"] as! String
                    
                    
                    print(json )
                    onSuccess(asingInbodyResponse)
                    
                } catch {
                    print(asingInbodyResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(asingInbodyResponse)
                print("Todo mal")
            } else{
                onSuccess(asingInbodyResponse)
            }
        })
        task.resume()
    }





    
    func getHistorialInbody(onSuccess: @escaping(JSON)-> Void) {
        self.pesoInbody2 = [Double]()
        self.estaturaInbody2 = [Double]()
        self.rccInbody2 = [Double]()
        
        self.pgcInbody2 = [Double]()
        self.imcInbody2 = [Double]()
        self.mmeInbody2 = [Double]()
       
        self.mcgInbody2 = [Double]()
       
        self.actInbody2 = [Double]()
      
        self.mineralesInbody2 = [Double]()
     
        self.proteinaInbody2 = [Double]()
       
       
        
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/piso/api/v1/inBody/\(SavedData.getTheUserId())") else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
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
                    let result = try JSON(data: data)
                    var status = json["code"] as! Int
                    var  mensaje = json["message"] as! String
                    self.codeMessage = status
                    self.message = mensaje
                    if  let dataReceived = json["data"]as? [[String: Any]] {
                        
                        
                        for element in dataReceived {
                            let mes = element["mes"] as! String
                            self.mes.append(mes)
                            print("Aqui estan los meses", self.mes)
                            let dataReceived = Array(element.keys)
                            self.inbodyValues2 = dataReceived// for Dictionary
                            if let index = self.inbodyValues2.index(of:"fechaEliminacion") {
                                self.inbodyValues2.remove(at: index)
                            }
                            if let indexTwo = self.inbodyValues2.index(of: "fecha"){
                                self.inbodyValues2.remove(at: indexTwo)
                            }
                            if let indexThree = self.inbodyValues2.index(of: "mes"){
                                self.inbodyValues2.remove(at: indexThree)
                            }
                           
                            print("Camara no me agüito 2", self.inbodyValues2)
                            let peso = element ["peso"] as! String
                            self.pesoInbody2.append(Double(peso)!)
                            print("Aqui estan los pesos", self.pesoInbody2)
                            let estatura = element["estatura"] as! String
                            self.estaturaInbody2.append(Double(estatura)!)
                            let rcc = element ["RCC"] as! String
                            self.rccInbody2.append(Double(rcc)!)
                            let pgc = element ["PGC"] as! String
                            self.pgcInbody2.append(Double(pgc)!)
                            let imc = element ["IMC"] as! String
                            self.imcInbody2.append(Double(imc)!)
                            let mme = element ["MME"] as! String
                            self.mmeInbody2.append(Double(mme)!)
                            let mcg = element ["MCG"] as! String
                            self.mcgInbody2.append(Double(mcg)!)
                            let act = element ["ACT"] as! String
                            self.actInbody2.append(Double(act)!)
                            let minerales = element ["minerales"] as! String
                            self.mineralesInbody2.append(Double(minerales)!)
                            let proteina = element ["proteina"] as! String
                            self.proteinaInbody2.append(Double(proteina)!)
                            let fcresp = element ["fcresp"] as! String
                            self.fcrespInbody2 = Double(fcresp)
                            
                            self.lastInbody2.append(Double(peso)!)
                            self.lastInbody2.append(Double(estatura)!)
                            self.lastInbody2.append(Double(rcc)!)
                            self.lastInbody2.append(Double(pgc)!)
                            self.lastInbody2.append(Double(imc)!)
                            self.lastInbody2.append(Double(mme)!)
                            self.lastInbody2.append(Double(mcg)!)
                            self.lastInbody2.append(Double(act)!)
                            self.lastInbody2.append(Double(minerales)!)
                            self.lastInbody2.append(Double(proteina)!)
                            self.lastInbody2.append(Double(fcresp)!)
                            
                            print("Esste es el array de last inbody2", self.lastInbody2)
                        }
                        
                    }
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)
                    
                    
                }
            }
            if(error != nil){
                
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
    func getCalendarRoutines(onSuccess: @escaping(RutinasResponse) -> Void) {
        
        let rutinasResponse : RutinasResponse = RutinasResponse()
        
        
        
       
        
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/piso/api/v1/rutina/rutinasCalendario/\( SavedData.getTheUserId())") else {return}
        
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
                    
                    
                    
                    rutinasResponse.code = json["code"] as! Int
                    rutinasResponse.message = json["message"] as! String
                    if(rutinasResponse.code == 200){
                        if let  data = json ["data"] as? [String:AnyObject]{
                            rutinasResponse.fechaFin =  dateFormatter.date(from: data["fecha_fin"] as! String)!
                            rutinasResponse.fechaInicio = dateFormatter.date(from: data["fecha_inicio"] as! String)!
                        }
                    }
                    
                    print(json )
                    onSuccess(rutinasResponse)
                    
                } catch {
                    print(rutinasResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(rutinasResponse)
                print("Todo mal")
            } else{
                onSuccess(rutinasResponse)
            }
        })
        task.resume()
    }
    
    func getMenuActividad(onSuccess: @escaping(MenuActividadResponse) -> Void) {
        
        let menuActividadResponse : MenuActividadResponse = MenuActividadResponse()
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/piso/api/v1/menu/readMenuActividad/\(SavedData.getTheUserId())") else {return}
        
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
                    
                    menuActividadResponse.code = json["code"] as! Int
                    menuActividadResponse.message = json["message"] as! String
                    
                    // print(" menuActividadResponse.message",  menuActividadResponse.message)
                    let result = try JSON(data: data)
                    if let dataReceived = json["data"] as? Dictionary<String,AnyObject>{
                        
                        if let nivel =  dataReceived["nivel"] as? Int {
                            self.nivel = nivel
                            
                        }
                        if let rutina  = dataReceived["rutina"] as? String {
                            self.rutina = rutina 
                        }
                        
                    }
                    
                    print(json )
                    onSuccess(menuActividadResponse)
                    
                } catch {
                    print(menuActividadResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(menuActividadResponse)
                print("Todo mal")
            } else{
                onSuccess(menuActividadResponse)
            }
        })
        task.resume()
    }
    
    
    enum MarkingType {
        case fuerza
        case cardio
        case clase
        case optativa
        
        var basePath: String {
            return "https://cloud.sportsworld.com.mx"
        }
        
        var path: String {
            switch self {
            case .fuerza:
                return "\(basePath)/piso/api/v1/menu/ejercicioCompletado/"
            case .cardio:
                return "\(basePath)/piso/api/v1/menu/cardioCompletado/"
            case .clase:
                return "\(basePath)/piso/api/v1/menu/claseCompletado/"
            case .optativa:
                return "\(basePath)/piso/api/v1/menu/optativaCompletado/"
            }
        }
        
    }
    
    func markRoutine(type: MarkingType,claveEntrenamiento: String, date: String, completion: @escaping (Result<MarkRoutineResponse>) -> Void) {
        guard let url = URL(string: "\(type.path)\(claveEntrenamiento)/\(date)") else {return}
        
        if let inProgressTask = tasksInProgress[url] {
            inProgressTask.cancel()
        }
        let task = URLSession.shared.markRoutine(with: url) { response, _, error in
            DispatchQueue.main.async {
                if let response = response {
                    completion(Result.success(response))
                } else {
                    guard let error = error else {
                        let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: "unable to load menu"])
                        completion(Result.failure(error))
                        return
                    }
                    completion(Result.failure(error))
                }
            }
        }
        tasksInProgress[url] = task
        task.resume()
    }
    
    func getRoutinesAtHome(completion: @escaping (Result<EntrenamientosUsuario>) -> Void ) {
        
        
        guard let url = URL(string: "http://sandbox.sportsworld.com.mx/entrenamientos/api/v2/entrenamientosusuario/\(SavedData.getTheUserId())") else {return}
    
        
        
        if let inProgressTask = tasksInProgress[url] {
            inProgressTask.cancel()
        }
        
        let task = URLSession.shared.entrenamientosUsuarioTask(with: url) { routines, _, error in
            DispatchQueue.main.async {
                if let routines = routines {
                    completion(Result.success(routines))
                } else {
                    guard let error = error else {
                        let error = NSError(domain: String(describing: self), code: 1, userInfo: [NSLocalizedDescriptionKey: "unable to load menu"])
                        completion(Result.failure(error))
                        return
                    }
                    completion(Result.failure(error))
                }
            }
        }
        tasksInProgress[url] = task
        task.resume()
        
    }
    
    

    func getRutinasCasa(onSuccess: @escaping(RutinaCasaResponse) -> Void) {
        
        
        let rutinaCasaResponse : RutinaCasaResponse = RutinaCasaResponse()
        
        
        
        
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/entrenamientos/api/v1/entrenamientosusuario/\(SavedData.getTheUserId())") else {return}
        
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
                    
                    let result = try JSON(data: data)
                    rutinaCasaResponse.code = json["code"] as! Int
                    rutinaCasaResponse.message = json["message"] as! String
                    if let dataReceived = json["data"] as? [[String:AnyObject]] {
                        
                        for element in dataReceived {
                            let rutinaCasaData : RutinasCasa = RutinasCasa()
                            rutinaCasaData.calificacion = element["calificacion"] as! Int
                            rutinaCasaData.usuario = element["usuario"] as! String
                            rutinaCasaData.nombreEntrenamiento = element["nombreEntrenamiento"] as! String
                            rutinaCasaData.claveEntrenamiento = element["claveEntrenamiento"] as! Int
                            rutinaCasaData.fechaReproduccion = element["fechaReproduccion"] as! String
                            rutinaCasaData.foto = element["foto"] as! String
                            rutinaCasaData.numeroReproduccion = element["numeroReproduccion"] as! Int
                            rutinaCasaData.descripEntre = element["descripcionEntrenamiento"] as! String
                            print("descripcionEntrenamiento", rutinaCasaData.descripEntre )
                            
                            rutinaCasaData.videoDistribucion = element["videoDistribucion"] as! String
                            rutinaCasaData.categoria = element["categoria"] as! String
                            rutinaCasaData.coach.nombre = element["coach"]!["nombre"] as! String
                            rutinaCasaData.coach.apellidos = element["coach"]!["apellidos"] as! String
                            rutinaCasaData.coach.descripcion = element["coach"]!["descripcion"] as! String
                            rutinaCasaData.coach.foto = element["coach"]!["foto"] as! String
                            print("Todas las categorias", rutinaCasaData.categoria)
                            rutinaCasaResponse.data.append(rutinaCasaData)
                            
                            let grouped = rutinaCasaResponse.data.group(by: { $0.categoria })
                            
                            print("grouped", grouped)
                            
                            
                        }
                }
        
                    print(json )
                    onSuccess(rutinaCasaResponse)
                    
                } catch {
                    print(rutinaCasaResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(rutinaCasaResponse)
                print("Todo mal")
            } else{
                onSuccess(rutinaCasaResponse)
            }
        })
        task.resume()
    }


func getCategoriaClases(onSuccess: @escaping(ClaseCategoriasResponse) -> Void) {
    
    let claseCategoriasResponse : ClaseCategoriasResponse = ClaseCategoriasResponse()
    
    guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/categorization") else {return}
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
                let result = try JSON(data: data)
                let dataReceived = json["data"]
                claseCategoriasResponse.status = json["status"] as! Bool
                claseCategoriasResponse.message = json["message"] as! String
                if  let categoriasDataReceived = dataReceived as? [[String : AnyObject]] {
               self.categoriasData = categoriasDataReceived
                  
                for categorias in self.categoriasData {
                     let claseCategoriasData : ClaseCategorias = ClaseCategorias()
                     let clases = categorias["clases"] as! [[String : AnyObject]]
                     self.clases = clases
                    
                    for element in self.clases {
                        let claseData : Clases = Clases()
                        claseData.clase = element["clase"] as! String
                        claseData.idClase = element["idClase"] as! Int
                        //claseCategoriasResponse.clases.append(claseData)
                        
                        claseCategoriasResponse.clases.append(claseData)
                        
                    }
                    
                      claseCategoriasData.categoria = categorias["categoria"] as! String
                    
                      claseCategoriasResponse.data.append(claseCategoriasData)
                    
                }
                    
        }
                onSuccess(claseCategoriasResponse)
                print("Todo ok")
                
                
            } catch {
                onSuccess(claseCategoriasResponse)
                print("Ocurrió un error")
            }
        }
        
        if(error != nil){
            onSuccess(claseCategoriasResponse)
            print("Todo mal")
        } else{
        }
    })
    task.resume()
}

    func getClasessByCategoria(date:Date,idClase:Int, onSuccess: @escaping(ClassCategoriaResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let calendar = Calendar.current
        var returnResponse : ClassCategoriaResponse = ClassCategoriaResponse()
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        
        let result = formatter.string(from: date)
        
        guard let url = URL(string: "https://prepago.sportsworld.com.mx/api/v1/app/class/list/schedule/\(idClase)/\(result)/\(SavedData.getTheUserId())/") else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,AnyObject>
                    let dataReceived = json["data"]
                    print(dataReceived ?? "")
                    var tempArrayClasses : [ClassCategoria] = [ClassCategoria]()
                    
                    for clubData in dataReceived as! [[String : AnyObject]]{
                        let tempClass : ClassCategoria = ClassCategoria()
                        if (clubData["idinstalacionactividadprogramada"] as? Int) != nil
                        {
                            tempClass.idinstalacionactividadprogramada = clubData["idinstalacionactividadprogramada"] as! Int
                        }
                        
                        if (clubData["club"] as? String) != nil
                        {
                            tempClass.club = clubData["club"] as! String
                        }
                        
                        if (clubData["salon"] as? String) != nil
                        {
                            tempClass.salon = clubData["salon"] as! String
                        }
                        
                        if (clubData["idsalon"] as? Int) != nil
                        {
                            tempClass.idsalon = clubData["idsalon"] as! Int
                        }
                        
                        if (clubData["clase"] as? String) != nil
                        {
                            tempClass.clase = clubData["clase"] as! String
                        }
                        
                        if (clubData["idclase"] as? Int) != nil
                        {
                            tempClass.idclase = clubData["idclase"] as! Int
                        }
                        
                        if (clubData["instructor"] as? String) != nil
                        {
                            tempClass.instructor = clubData["instructor"] as! String
                        }
                        
                        if (clubData["inicio"] as? String) != nil
                        {
                            tempClass.inicio = clubData["inicio"] as! String
//                            tempClass.inicio = tempClass.formattedInicio(clubData["inicio"] as! String)
                        }
                        
                        if (clubData["fin"] as? String) != nil
                        {
                            tempClass.fin = clubData["fin"] as! String
                        }
                        
                        if (clubData["iniciovigencia"] as? String) != nil
                        {
                            tempClass.iniciovigencia = clubData["iniciovigencia"] as! String
                        }
                        
                        if (clubData["finvigencia"] as? String) != nil
                        {
                            tempClass.finvigencia = clubData["finvigencia"] as! String
                        }
                        
                        if (clubData["capacidadideal"] as? Int) != nil
                        {
                            tempClass.capacidadideal = clubData["capacidadideal"] as! Int
                        }
                        
                        if (clubData["capacidadmaxima"] as? Int) != nil
                        {
                            tempClass.capacidadmaxima = clubData["capacidadmaxima"] as! Int
                        }
                        
                        if (clubData["capacidadregistrada"] as? Int) != nil
                        {
                            tempClass.capacidadregistrada = clubData["capacidadregistrada"] as! Int
                        }
                        
                        if (clubData["reservacion"] as? Int) != nil
                        {
                            tempClass.reservacion = clubData["reservacion"] as! Int
                        }
                        
                        if (clubData["confirmados"] as? Int) != nil
                        {
                            tempClass.confirmados = clubData["confirmados"] as! Int
                        }
                        
                        if (clubData["agendar"] as? Int) != nil
                        {
                            tempClass.agendar = clubData["agendar"] as! Int
                        }
                        
                        if (clubData["demand"] as? Int) != nil
                        {
                            tempClass.demand = clubData["demand"] as! Int
                        }
                        
                        if (clubData["inscrito"] as? Bool) != nil
                        {
                            tempClass.inscrito = clubData["inscrito"] as! Bool
                        }
                        
                        if (clubData["latitud"] as? Double) != nil
                        {
                            tempClass.latitud = clubData["latitud"] as! Double
                        }
                        
                        if (clubData["longitud"] as? Double) != nil
                        {
                            tempClass.longitud = clubData["longitud"] as! Double
                        }
                        let coordinate₀ = CLLocation(latitude: tempClass.latitud, longitude: tempClass.longitud)
                        let coordinate₁ = CLLocation(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
                        
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        tempClass.distance = distanceInMeters
                        tempArrayClasses.append(tempClass)
                    }
                    
                    returnResponse.status = true
                    returnResponse.data = tempArrayClasses
                    onSuccess(returnResponse)
                    
                    self.codeMessage = 0
                } catch {
                    print(error)
                    returnResponse.status = false
                    print("Ocurrió un error")
                    
                    onSuccess(returnResponse)
                }
                
                
                
            }
            
            /*if(error != nil){
             returnResponse.status = false
             onSuccess(returnResponse)
             print("Todo mal")
             } else{
             returnResponse.status = false
             onSuccess(returnResponse)
             }*/
        })
        task.resume()
    }
    func getEventos(onSuccess: @escaping(EventosResponse) -> Void) {
        
        let eventosResponse : EventosResponse = EventosResponse()
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/eventos/api/v1/eventos") else {return}
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
                    let result = try JSON(data: data)
                    eventosResponse.message = json["message"] as! String
                    eventosResponse.code = json["code"] as! Int
                    if let data = json ["data"] as? [[String:AnyObject]] {
                        for element in data {
                            let eventosData: Eventos = Eventos()
                            eventosData.id = element["id"] as! Int
                            eventosData.nombre = element["nombre"] as! String
                            eventosData.ubicacion = element["ubicacion"] as! String
                            print("eventosData.ubicacion = element", eventosData.ubicacion)
                            eventosData.descripcion = element["descripcion"] as! String
                            eventosData.imagen = element["imagen"] as! String
                            eventosData.fecha = element["fecha"] as! String
                             eventosResponse.data.append(eventosData)
                            if  let galeria = element ["galeria"] as? [[String:AnyObject]]  {
                                for element in galeria {
                                    var galeriaEventos:  GaleriaEventos = GaleriaEventos()
                                    galeriaEventos.ruta = element["ruta"] as! String
                                   eventosData.galeria.append(galeriaEventos)
                               //   eventosResponse.data.append(eventosData)
                                   
                                }
                               
                            }
                            
                         
                        }
                       
                    }
                    
                    onSuccess(eventosResponse)
                } catch {
                    onSuccess(eventosResponse)
                }
            }
            if(error != nil){
                onSuccess(eventosResponse)
            } else{
            }
        })
        task.resume()
    }
    
    func finishedVideo(id: String, entrenamiento: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let params : [String:Any] = ["usuario": SavedData.getTheUserId(),
                                     "entrenamiento" : entrenamiento,
                                     ]
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/entrenamientos/api/v1/guardarNumeroReproducciones")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    let code = json["code"] as! Int
                    print("Este es el cÃ³digo", code )
                    
                    self.codeMessage = code
                    self.message = mensaje as! String
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    func calificacionVideo(entrenamiento: Int,calificacion:Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
       
        let params : [String:Any] = ["usuario": SavedData.getTheUserId(),
                                     "entrenamiento" : entrenamiento,
                                     "calificacion": calificacion
                                     ]
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/entrenamientos/api/v1/guardarCalificacionEntrenamiento")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    let code = json["code"] as! Int
                    print("Este es el cÃ³digo", code )
                    
                    self.codeMessage = code
                    self.message = mensaje as! String
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }

    func makePayment(token_id: String, idMovimiento: String, onSuccess: @escaping(PagoResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        let pagoResponse : PagoResponse = PagoResponse()
print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SERVICIO PARA HACER EL PAGO CON CONECTA>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        let params : [String:Any] = ["token_id": token_id,
                                     "idMovimiento" : idMovimiento]
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/especiales/api/v1/cargoPorCKT")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    pagoResponse.message = json["message"] as! String
                    pagoResponse.code = json["code"] as! Int
                    
                    print(json )
                    onSuccess(pagoResponse)
                    
                    
                } catch {
                    onSuccess(pagoResponse)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(pagoResponse)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    func getEventoDetalle(idEventoDetalle:Int, onSuccess: @escaping(JSON)-> Void) {
        
        self.rutas = []
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/eventos/api/v1/eventos/\(idEventoDetalle)") else {return}
        ////++++++Se hardcodea el idPersona para que regrese la info hay que cambiarlo
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
                    let result = try JSON(data: data)
                    var status = json["code"] as! Int
                    var  mensaje = json["message"] as! String
                    self.codeMessage = status
                    self.message = mensaje
                    if  let dataReceived = json["data"]as? [String: Any] {
                        let galeria = dataReceived["galeria"] as! [[String:AnyObject]]
                        
                        for element in galeria{
                            let ruta  = element["ruta"] as! String
                            self.rutas.append(ruta)
                        }
                        
                    }
                    onSuccess(result)
                    print("Todo ok")
                } catch {
                    onSuccess(JSON.null)
                    
                    
                }
            }
            if(error != nil){
                
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
            }
        })
        task.resume()
    }
    
    func getEncuestasPendientes(onSuccess: @escaping(EncuestasPendientes) -> Void) {
        
        let encuestasPendientes : EncuestasPendientes = EncuestasPendientes()
        //1070137
        //guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/encuestas_pendientes/1070137/") else {return}
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/encuestas_pendientes/\(String(SavedData.getTheUserId()))/") else {return}
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
                    let result = try JSON(data: data)
                    encuestasPendientes.message = json["message"] as! String
                    encuestasPendientes.status = json["status"] as! Bool
                    if let data = json["data"] as? [[String:AnyObject]] {
                        for element in data {
                            let datosEncuesta:DatosEncuesta = DatosEncuesta()
                            datosEncuesta.clase = element["clase"] as! String
                            datosEncuesta.instructor = element["instructor"] as! String
                            print(datosEncuesta.instructor)
                            print(element["instructor"] as! String)
                            datosEncuesta.idinstalacionactividadprogramada = element["idinstalacionactividadprogramada"] as! Int
                            encuestasPendientes.data.append(datosEncuesta)
                        }
                        
                    }
                    
                    onSuccess(encuestasPendientes)
                } catch {
                    onSuccess(encuestasPendientes)
                }
            }
            if(error != nil){
                onSuccess(encuestasPendientes)
            } else{
            }
        })
        task.resume()
    }
    
    
    func getEvaluacionClases(onSuccess: @escaping(EvaluacionesEncuestas) -> Void) {
        
        let evaluacionesEncuestas : EvaluacionesEncuestas = EvaluacionesEncuestas()
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/evaluacion_clase/CG/") else {return}
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
                    let result = try JSON(data: data)
                    evaluacionesEncuestas.message = json["message"] as! String
                    evaluacionesEncuestas.status = json["status"] as! Bool
                    if let data = json ["data"] as? [[String:AnyObject]] {
                        for element in data {
                            let categoriaEvaluacion:CategoriaEvaluacion = CategoriaEvaluacion()
                            categoriaEvaluacion.categoria = element["categoria"] as! String
                            categoriaEvaluacion.orden = element["orden"] as! Int
                            categoriaEvaluacion.idsatisfaccionpregunta = element["idsatisfaccionpregunta"] as! Int
                            categoriaEvaluacion.tipo = element["tipo"] as! String
                            categoriaEvaluacion.claveencuesta = element["claveencuesta"] as! String
                            categoriaEvaluacion.activo = element["activo"] as! Int
                            categoriaEvaluacion.pregunta = element["pregunta"] as! String
                            categoriaEvaluacion.idsatisfaccionpreguntaevaluacion = element["idsatisfaccionpreguntaevaluacion"] as! Int
                            evaluacionesEncuestas.data.append(categoriaEvaluacion)
                        }
                        
                    }
                    
                    onSuccess(evaluacionesEncuestas)
                } catch {
                    onSuccess(evaluacionesEncuestas)
                }
            }
            if(error != nil){
                onSuccess(evaluacionesEncuestas)
            } else{
            }
        })
        task.resume()
    }
    
    
    /*
     https://app.sportsworld.com.mx/api/v1/app/class/reservation
     */
    
    
    func calificacionEncuesta(idInstalacionActividadProgramada: String,idSatisfaccionPregunta:String,calificacion:String,comentario:String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let params : [String:String] = ["claveencuesta": "CG",
                                     "idinstalacionactividadprogramada" : idInstalacionActividadProgramada,
                                     "idsatisfaccionpreguntaevaluacion": calificacion,
                                     "idsatisfaccionpregunta":idSatisfaccionPregunta,
                                     "calificacion":calificacion,
                                     "idpersona":String(SavedData.getTheUserId()),
                                     "comentario":comentario
            
        //Cambiar el parámetro cacharlo.
        ]
        print(SavedData.getTheUserId())
        guard let url = URL(string: "https://app.sportsworld.com.mx/api/v2/guarda_encuestagf/")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        guard  let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        request.httpBody = httpBody
        request.encodeParameters(parameters:params)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let response = response {
                print("Response",response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,AnyObject>
                    
                    
                    let result = try JSON(data: data)
                    let mensaje = json["message"]
                    //let code = json["code"] as! Int
                    //print("Este es el cÃ³digo", code )
                    
                    //self.codeMessage = code
                    self.message = mensaje as! String
                    print(self.message)
                    
                    print(json )
                    onSuccess(result)
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    
    func getClubsInBody(onSuccess: @escaping(AllClubsInBody) -> Void) {
        
        let allClubsInBody : AllClubsInBody = AllClubsInBody()
      
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/wellness/api/v1/consultaClubes") else {return}
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
                    let result = try JSON(data: data)
                    allClubsInBody.message = json["message"] as! String
                    allClubsInBody.code = json["code"] as! Int
                    let data = json ["data"] as! Dictionary<String,AnyObject>
                   
                    
                    if let dataReceived = data["clubes"] as? [[String:AnyObject]]{
                        for data in dataReceived{
                            let dataClubInBody: ClubInBody = ClubInBody()
                            print(data["nombre"] as! String)
                            dataClubInBody.clave = data["clave"] as! String
                            dataClubInBody.name = data["nombre"] as! String
                            dataClubInBody.idUn = data["idUn"] as! Int
                            dataClubInBody.domicilio = data["domicilio"] as! String
                            
                            allClubsInBody.data.append(dataClubInBody)
                            
                        }
                    }
                    
                    onSuccess(allClubsInBody)
                } catch {
                    onSuccess(allClubsInBody)
                }
            }
            if(error != nil){
                onSuccess(allClubsInBody)
            } else{
            }
        })
        task.resume()
    }
    
  
    //idAgenda
    func cancelReservaInBody(idAgenda:String,onSuccess: @escaping(JSON) -> Void,onFailure: @escaping(Error) -> Void) {
        
        let params : [String:Any] = ["idAgenda": idAgenda]
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/wellness/api/v1/deleteReservaInbody")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    let code = json["code"] as! Int
                    print("Este es el cÃ³digo", code )
                    
                    self.codeMessage = code
                    self.message = mensaje as! String
                    print("Todo ok")
                    
                    print(json )
                    onSuccess(result)
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
}

    func getReservasInBody(onSuccess: @escaping(ReservaInBodyRespuesta) -> Void) {
        
        let reservaInBodyRespuesta : ReservaInBodyRespuesta = ReservaInBodyRespuesta()
        
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/wellness/api/v1/readReservaInbody/\(SavedData.getTheUserId())") else {return}
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
                    let result = try JSON(data: data)
                    reservaInBodyRespuesta.message = json["message"] as! String
                    reservaInBodyRespuesta.code = json["code"] as! Int
                    let data = json ["data"] as! Dictionary<String,AnyObject>
                    
                    
                    if let dataReceived = data["reservas"] as? [[String:AnyObject]]{
                        for data in dataReceived{
                            let reservaInBody: ReservaInBody = ReservaInBody()
                            
                            reservaInBody.fechaConfirmacion = data["fechaConfirmacion"] as! String
                            reservaInBody.fechaSolicitud = data["fechaSolicitud"] as! String
                            reservaInBody.horario = data["horario"] as! String
                            reservaInBody.idAgenda = data["idAgenda"] as! Int
                            reservaInBody.idPersona = data["idPersona"] as! Int
                            reservaInBody.idUn = data["idUn"] as! Int
                           
                            
                            reservaInBodyRespuesta.data.append(reservaInBody)
                            
                        }
                    }
                    
                    onSuccess(reservaInBodyRespuesta)
                } catch {
                    onSuccess(reservaInBodyRespuesta)
                }
            }
            if(error != nil){
                onSuccess(reservaInBodyRespuesta)
            } else{
            }
        })
        task.resume()
    }
    
    
    func evaluacionEncuestaVideo(claveEntrenamiento: Int,respuestas:String,onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let params : [String:Any] = ["idPersona": SavedData.getTheUserId(),
                                     "claveEntrenamiento" : claveEntrenamiento,
                                     "respuestas": respuestas
        ]
        print(SavedData.getTheUserId())
        guard let url = URL(string: "https://cloud.sportsworld.com.mx/entrenamientos/api/v1/evaluacion")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    //let code = json["code"] as! Int
                    //print("Este es el cÃ³digo", code )
                    
                    //self.codeMessage = code
                    self.message = mensaje as! String
                 
                    print(self.message)
                    
                    print(json )
                    onSuccess(result)
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    
    
    func guardarFavoritosEntrenamientos(claveEntrenamiento: Int,onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        
        let params : [String:Any] = ["usuario": SavedData.getTheUserId(),
                                     "entrenamiento" : claveEntrenamiento
        ]
        print(SavedData.getTheUserId())
        guard let url = URL(string: "http://cloud.sportsworld.com.mx/entrenamientos/api/v1/guardarFavoritosEntrenamientos")
            else {return}
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(getSecretKey(), forHTTPHeaderField: "secret-key")
        
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
                    let mensaje = json["message"]
                    //let code = json["code"] as! Int
                    //print("Este es el cÃ³digo", code )
                    
                    //self.codeMessage = code
                    self.message = mensaje as! String
                    
                    print(self.message)
                    
                    print(json )
                    onSuccess(result)
                } catch {
                    onSuccess(JSON.null)
                    print("OcurriÃ³ un error")
                }
            }
            
            if(error != nil){
                onSuccess(JSON.null)
                print("Todo mal")
            } else{
                
            }
        })
        task.resume()
    }
    
    
    
}



