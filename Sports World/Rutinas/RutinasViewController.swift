//
//  RutinasViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 3/12/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import PlayerKit
import AVKit
import MediaPlayer
var claveFinal: String!
class RutinasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mesLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citaSegue"{
            let vc = segue.destination as! CitaAgendadaViewController
            /*self.fecha = i.fechaSolicitud
             self.hora = i.horario
             self.idClub = i.idUn*/
            vc.fecha = self.fecha
            vc.horario = self.hora
            vc.idUNTemp = self.idClub
            vc.idAgenda = self.idAgenda
        }
    }
    enum DisplayObjectType {
        case fuerza(Fuerza)
        case cardio(Cardio)
        case clase(Clase)
        case optativa(Clase)
    }
    
    enum DisplaySectionType {
        case fuerza
        case cardio
        case clase
        case optativa
        
        var name: String {
            switch self {
            case .fuerza:
                return NSLocalizedString("Fuerza", comment: "")
            case .cardio:
                return NSLocalizedString("Cardio", comment: "")
            case .clase:
                return NSLocalizedString("Clase", comment: "")
            case .optativa:
                return NSLocalizedString("Optativa", comment: "")
            }
        }
        
        var staticText: String {
            switch self {
            case .fuerza:
                return ""
            case .cardio:
                return ""
            case .clase:
                return NSLocalizedString("(elige una)", comment: "")
            case .optativa:
                return NSLocalizedString("(elige una)", comment: "")
            }
        }
    }
    
    var horas:[String] = [String]()
    var mensajeAlerta: String = ""
    var fecha:String!
    var hora:String!
    var idClub:Int!
    var idAgenda:Int = 0
    struct SectionType {
        let type: DisplaySectionType
        var items: [DisplayObjectType]
    }
    
    private var sections:  [SectionType] = [] {
        didSet {
            tabView.reloadData()
        }
    }
    
    private var items: [DisplayObjectType] = [] {
        didSet {
            tabView.reloadData()
        }
    }
    
    private var selectedRows: [IndexPath] = []
    
    var days = [Int]()
    var daysDateFormat = [Date]()
    var currentSelected = Date()
    let formatter = DateFormatter()
    var currentSegment: Int!
    private let cell = "RutinasCell"
    var thereIsCellTapped = false
    var selectedRowIndex = -1
    var comesFromEmptyValues = false
    private let collectionCell = "RutinasCollectionViewCell"
    
    
    //MARK:- CONECTA LOS OUTLETS
    
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var series: UILabel!
    @IBOutlet weak var repeticiones: UILabel!
    @IBOutlet weak var descanso: UILabel!
    @IBOutlet weak var descansoFreccCardiaca: UILabel!
    @IBOutlet weak var seriesTiempo: UILabel!
    
    @IBOutlet weak var diaDeDescansoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inbodyContainer: UIView!
    @IBOutlet weak var avancesContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tabView: UITableView! {
        didSet {
            tabView.register(RutinasHeader.self, forHeaderFooterViewReuseIdentifier: RutinasHeader.reuseId)
        }
    }
    @IBOutlet weak var instructionsView: UIView!
    var nameOfDays: [String] = ["LUN", "MAR", "MIE", "JUE", "VIE", "SAB","DOM"]
    var entrenamiento : [Entrenamiento] = [Entrenamiento]()
    var celdasVideo : [RutinasCell] = [RutinasCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gotoReservaInbodyFromBeginning()
        self.diaDeDescansoLabel.isHidden = false
        Tools.clearAllFilesFromTempDirectory()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if self.tabView.visibleCells.isEmpty {
            self.tabView.isHidden = true
            self.diaDeDescansoLabel.text! = "Día de recuperación"
        } else {
            self.tabView.isHidden = false
            self.diaDeDescansoLabel.isHidden = true
        }
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back_button"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        celdasVideo.removeDuplicates()
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_agendar"), style: .done, target: self, action: #selector(RutinasViewController.gotoReservaInbody))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        formatter.dateFormat = "dd"
        let result = formatter.string(from: currentSelected)
        print("date", result)
        tabView.delegate = self
        tabView.dataSource = self
        
        segmentedControl.selectedSegmentIndex = 1
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Wellness test",attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        avancesContainer.isHidden = true
        inbodyContainer.isHidden = true
        //Customiza la navigatonBar
        
        
        //CONFIGURA LAS VISTAS.
        instructionsView.layer.borderColor = UIColor.gray.cgColor
        instructionsView.layer.borderWidth = 0.5
        //self.tabView.rowHeight = 100
        
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        self.repeticiones.text = ""
        self.descanso.text = ""
        self.series.text = ""
        
        
        
        self.getCalendarRoutines()
        
        agendarCita.layer.masksToBounds = true
        agendarCita.layer.cornerRadius = 15
    }
    
    @objc func back(){
        /*let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
         self.navigationController!.pushViewController(VC1, animated: true)*/
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getCalendarRoutines() {
        self.gotoReservaInbodyFromBeginning()
        APIManager.sharedInstance.getCalendarRoutines( onSuccess: { response in
            
            DispatchQueue.main.async {
                if(response.code == 200){
                    let cal = Calendar.current
                    var date = cal.startOfDay(for: Date())
                    
                    
                    
                    if self.tabView.visibleCells.isEmpty {
                        
                        self.tabView.isHidden = true
                        self.diaDeDescansoLabel.isHidden = false
                        self.diaDeDescansoLabel.text = "Día de recuperación"
                    } else {
                        self.tabView.isHidden = false
                        self.diaDeDescansoLabel.isHidden = true
                    }
                    
                    
                    self.currentSelected = date
                    var move = 0
                    let currentCalendar = NSCalendar.current
                    let timeUnitDay = NSCalendar.Unit.day
                    let daysBetween = currentCalendar.dateComponents([.day], from: cal.date(byAdding: .day, value: 0, to: response.fechaInicio)!, to: response.fechaFin).day!
                    
                    self.daysDateFormat = [Date]()
                    self.days = [Int]()
                    date = cal.date(byAdding: .day, value: 0, to: response.fechaInicio)!
                    for i in 0 ... daysBetween {
                        let day = cal.component(.day, from: date)
                        self.days.append(day)
                        self.daysDateFormat.append(date)
                        if(self.currentSelected == date){
                            move = i
                        }
                        date = cal.date(byAdding: .day, value: +1, to: date)!
                        
                    }
                    self.colleView.reloadData()
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    //                        let indexPath : IndexPath = IndexPath(row: move, section: 0)
                    //
                    //                        self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    //                    })
                    
                    self.tabView.reloadData()
                    self.updateCalendar()
                    
                    
                    
                    let currentDate = self.currentSelected
                    guard
                        let day = Calendar.current.dateComponents([.day], from: currentDate).day,
                        let indexOf = self.days.index(of: day)
                        else {
                            return
                    }
                    let indexPath = IndexPath(item: Int(indexOf), section: 0)
                    self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    let tempCellSelect: RutinasCollectionViewCell? = self.colleView.cellForItem(at: indexPath) as? RutinasCollectionViewCell
                    //tempCellSelect.dayNumberLabel.textColor = UIColor.red
                    tempCellSelect?.dayNumberLabel.layer.borderWidth = 2.0
                    tempCellSelect?.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
                    tempCellSelect?.dayNumberLabel.layer.cornerRadius = tempCellSelect?.dayNumberLabel.bounds.width ?? 0 / 2
                }else{
                    self.diaDeDescansoLabel.isHidden = true
                    self.mensajeAlerta = response.message
                    
                }
            }
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tools.clearAllFilesFromTempDirectory()
        self.gotoReservaInbodyFromBeginning()
        self.descansoFreccCardiaca.text = "Descanso"
        self.seriesTiempo.text = "Series"
        self.diaDeDescansoLabel.isHidden = true
        
        
        
        let editButton   = UIBarButtonItem.init(image: UIImage(named: "icon_agendar"), style: .done, target: self, action: #selector(RutinasViewController.gotoReservaInbody))
        
        self.navigationItem.rightBarButtonItem = editButton
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        if self.tabView.visibleCells.isEmpty {
            // self.tabView.isHidden = true
            self.diaDeDescansoLabel.isHidden = false
            self.diaDeDescansoLabel.text! = "Día de recuperación"
        } else {
            self.tabView.isHidden = false
            self.diaDeDescansoLabel.isHidden = true
        }
        return sections[section].items.count
    }
    
    lazy var df: DateFormatter = {
        $0.dateFormat = "yyyy-MM-dd"
        return $0
    }(DateFormatter())
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RutinasCell = self.tabView.dequeueReusableCell(withIdentifier: self.cell) as! RutinasCell
        if self.tabView.visibleCells.isEmpty {
            
            // self.tabView.isHidden = true
            self.diaDeDescansoLabel.isHidden = false
            self.diaDeDescansoLabel.text! = "Día de recuperación"
        } else {
            self.tabView.isHidden = false
            
        }
        
        cell.isCheckboxEnabled = { isSelected in
            cell.activity.isHidden = false
            cell.activity.startAnimating()
            switch self.sections[indexPath.section].items[indexPath.row] {
            case .fuerza(let fuerza):
                APIManager.sharedInstance.markRoutine(type: APIManager.MarkingType.fuerza,claveEntrenamiento: fuerza.clave, date: self.df.string(from: self.currentSelected)) { result in
                    switch result {
                    case .success(let response):
                        let updated = fuerza.mutate(transform: { $0.completado = response.data.completado })
                        self.sections[indexPath.section].items[indexPath.row] = DisplayObjectType.fuerza(updated)
                        if response.data.completado {
                            cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        } else {
                            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        }
                        self.selectedRows = self.selectedRows.filter({ $0 != indexPath })
                    case .failure(let error):
                        print(error)
                        cell.activity.isHidden = true
                        cell.activity.stopAnimating()
                    }
                }
            case .cardio(let cardio):
                cell.activity.isHidden = true
                cell.activity.stopAnimating()
                APIManager.sharedInstance.markRoutine(type: APIManager.MarkingType.cardio,claveEntrenamiento: cardio.clave, date: self.df.string(from: self.currentSelected)) { result in
                    switch result {
                    case .success(let response):
                        let updated = cardio.mutate(transform: { $0.completado = response.data.completado })
                        self.sections[indexPath.section].items[indexPath.row] = DisplayObjectType.cardio(updated)
                        if response.data.completado {
                            cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        } else {
                            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        }
                    case .failure(let error):
                        print(error)
                        cell.activity.isHidden = true
                        cell.activity.stopAnimating()
                    }
                }
            case .clase(let clase):
                cell.activity.isHidden = true
                cell.activity.stopAnimating()
                APIManager.sharedInstance.markRoutine(type: APIManager.MarkingType.clase,claveEntrenamiento: clase.clave, date: self.df.string(from: self.currentSelected)) { result in
                    switch result {
                    case .success(let response):
                        let updated = clase.mutate(transform: { $0.completado = response.data.completado })
                        self.sections[indexPath.section].items[indexPath.row] = DisplayObjectType.clase(updated)
                        if response.data.completado {
                            cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        } else {
                            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        }
                    case .failure(let error):
                        print(error)
                        cell.activity.isHidden = true
                        cell.activity.stopAnimating()
                    }
                }
            case .optativa(let clase):
                cell.activity.isHidden = true
                cell.activity.stopAnimating()
                APIManager.sharedInstance.markRoutine(type: APIManager.MarkingType.optativa,claveEntrenamiento: clase.clave, date: self.df.string(from: self.currentSelected)) { result in
                    switch result {
                    case .success(let response):
                        let updated = clase.mutate(transform: { $0.completado = response.data.completado })
                        self.sections[indexPath.section].items[indexPath.row] = DisplayObjectType.optativa(updated)
                        if response.data.completado {
                            cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        } else {
                            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                            cell.activity.isHidden = true
                            cell.activity.stopAnimating()
                        }
                    case .failure(let error):
                        print(error)
                        cell.activity.isHidden = true
                        cell.activity.stopAnimating()
                    }
                }
            }
            
        }
        switch sections[indexPath.section].items[indexPath.row] {
        case let .fuerza(fuerza):
            cell.exerciseName.text = fuerza.nombre.capitalized
            cell.imageToShow.image = nil
            cell.imageToShow.downloadImageSync(downloadURL: fuerza.imagen, completion: { result in
                
            })
            
            cell.repetitionsLabel.text = fuerza.repeticiones.description + " " + NSLocalizedString("repeticiones", comment: "")
            //            let video = fuerza.video
            //                .replacingOccurrences(of: "640", with: "\(Int(self.view.bounds.width * 3))")
            //                .replacingOccurrences(of: "360", with: "\(Int(600))")
            
            cell.videoView.loadHTMLString("", baseURL: nil)
            //            cell.videoView.stopLoading()
            
            //            if let videoURL = fuerza.video.detectedURL, let url = URL(string: videoURL) {
            //                let request = URLRequest(url: url)
            //                cell.videoView.allowsInlineMediaPlayback = true
            //                cell.videoView.loadRequest(request)
            //            }
            
            print("esto es el video",fuerza.video)
            cell.videoView.scrollView.isScrollEnabled = true
            cell.videoView.scrollView.bounces = false
            cell.videoView.allowsInlineMediaPlayback = true
            cell.videoView.mediaPlaybackRequiresUserAction = true
            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            cell.checkButton.setImage(nil, for: .normal)
            let entrenamiento = Entrenamiento(clave: fuerza.clave,
                                              orden: fuerza.orden,
                                              nombre: fuerza.nombre,
                                              video: fuerza.video,
                                              series: fuerza.series,
                                              repeticiones: Int(fuerza.repeticiones),
                                              descanso: Int(fuerza.descanso),
                                              completado: fuerza.completado,
                                              fechaStr: df.string(from: self.currentSelected))
            cell.entranamiento = entrenamiento
            if fuerza.completado {
                
                cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                
                cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            }
        case let .cardio(cardio):
            cell.imageToShow.image = nil
            cell.imageToShow.downloadImageSync(downloadURL: cardio.imagen, completion: { result in
                
            })
            cell.exerciseName.text = cardio.equipo.capitalized
            cell.repetitionsLabel.text = cardio.tiempo.description + " " + NSLocalizedString("minutos", comment: "")
            cell.videoView.scrollView.isScrollEnabled = true
            cell.videoView.scrollView.bounces = false
            cell.videoView.allowsInlineMediaPlayback = false
            cell.videoView.mediaPlaybackRequiresUserAction = true
            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            cell.checkButton.setImage(nil, for: .normal)
            let entrenamiento = Entrenamiento(clave: cardio.clave,
                                              orden: 0,
                                              nombre: cardio.equipo,
                                              video: "",
                                              series: 0,
                                              repeticiones: 0,
                                              descanso: 0,
                                              completado: cardio.completado,
                                              fechaStr: df.string(from: self.currentSelected))
            cell.entranamiento = entrenamiento
            if cardio.completado {
                
                cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
                
            }
        case let .clase(clase):
            cell.imageToShow.image = nil
            cell.imageToShow.downloadImageSync(downloadURL: clase.imagen, completion: { result in
                
            })
            cell.exerciseName.text = clase.nombre.capitalized
            cell.repetitionsLabel.text = ""
            cell.videoView.scrollView.isScrollEnabled = true
            cell.videoView.scrollView.bounces = false
            cell.videoView.allowsInlineMediaPlayback = false
            cell.videoView.mediaPlaybackRequiresUserAction = true
            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            cell.checkButton.setImage(nil, for: .normal)
            let entrenamiento = Entrenamiento(clave: clase.clave,
                                              orden: 0,
                                              nombre: clase.nombre,
                                              video: "",
                                              series: 0,
                                              repeticiones: 0,
                                              descanso: 0,
                                              completado:clase.completado,
                                              fechaStr: df.string(from: self.currentSelected))
            cell.entranamiento = entrenamiento
            if clase.completado {
                
                cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                
                cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            }
        case let .optativa(optativa):
            cell.imageToShow.image = nil
            cell.imageToShow.downloadImageSync(downloadURL: optativa.imagen, completion: { result in
                
            })
            cell.exerciseName.text = optativa.nombre.capitalized
            cell.repetitionsLabel.text = ""
            cell.videoView.scrollView.isScrollEnabled = true
            cell.videoView.scrollView.bounces = false
            cell.videoView.allowsInlineMediaPlayback = false
            cell.videoView.mediaPlaybackRequiresUserAction = true
            cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            cell.checkButton.setImage(nil, for: .normal)
            let entrenamiento = Entrenamiento(clave: optativa.clave,
                                              orden: 0,
                                              nombre: optativa.nombre,
                                              video: "",
                                              series: 0,
                                              repeticiones: 0,
                                              descanso: 0,
                                              completado: optativa.completado,
                                              fechaStr: df.string(from: self.currentSelected))
            cell.entranamiento = entrenamiento
            if optativa.completado {
                
                cell.checkButton.setImage(UIImage(named: "check_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                
                cell.checkButton.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            }
        }
        
        return cell
        
        //        return self.celdasVideo[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return selectedRows.contains(indexPath) ? 305 : 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedRows.contains(indexPath) {
            selectedRows = selectedRows.filter({ $0 != indexPath })
            tableView.beginUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endUpdates()
            
            if case let .fuerza(_) = sections[indexPath.section].items[indexPath.row] {
                guard let cell: RutinasCell = tableView.cellForRow(at: indexPath) as? RutinasCell else { return }
                //                cell.videoView.reload()
                cell.videoView.loadHTMLString("", baseURL: nil)
            }
            return
        } else {
            if case let .fuerza(_) = sections[indexPath.section].items[indexPath.row] {
                selectedRows.append(indexPath)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            
        }
        
        
        guard let cell: RutinasCell = tableView.cellForRow(at: indexPath) as? RutinasCell else { return }
        switch sections[indexPath.section].items[indexPath.row] {
        case let .fuerza(fuerza):
            let video = fuerza.video
                .replacingOccurrences(of: "640", with: "\(Int(self.view.bounds.width * 3))")
                .replacingOccurrences(of: "360", with: "\(Int(600))")
            
            //            cell.videoView.loadHTMLString(video, baseURL: nil)
            
            if let videoURL = fuerza.video.detectedURL, let url = URL(string: videoURL) {
                let request = URLRequest(url: url)
                cell.videoView.allowsInlineMediaPlayback = true
                cell.videoView.loadRequest(request)
                //                cell.videoView.loadHTMLString(video, baseURL: nil)
            }
            
            self.descansoFreccCardiaca.text = "Descanso"
            self.seriesTiempo.text = "Series"
            self.repeticiones.text = fuerza.repeticiones.description
            self.descanso.text = fuerza.descanso.description
            self.series.text = fuerza.series.description
            tableView.beginUpdates()
            tableView.endUpdates()
            self.series.text = fuerza.series.description
            self.repeticiones.text = fuerza.repeticiones.description
            self.descanso.text = fuerza.descanso.description + "\""
            
        case let .cardio(cardio):
            tableView.deselectRow(at: indexPath, animated: true)
            self.descansoFreccCardiaca.text = "Frec Cardiáca"
            self.seriesTiempo.text = "Tiempo"
            
            self.series.text = cardio.tiempo.description
            self.repeticiones.text = ""
            self.descanso.text = cardio.intensidad.description
        case .clase:
            tableView.deselectRow(at: indexPath, animated: true)
            
            self.series.text = ""
            self.repeticiones.text = ""
            self.descanso.text = ""
        case .optativa:
            tableView.deselectRow(at: indexPath, animated: true)
            self.series.text = ""
            self.repeticiones.text = ""
            self.descanso.text = ""
        }
        
    }
    
    
    @IBAction func adasd(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }
    class RutinasHeader: UITableViewHeaderFooterView {
        
        lazy var titleLabel: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "LarkeNeue-Regular", size: 22)
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return label
        }()
        
        lazy var subtitleLabel: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "LarkeNeue-Regular", size: 12)
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return label
        }()
        
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            self.layout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func layout() {
            let leftView = UIView(frame: CGRect.zero)
            leftView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.01176470588, blue: 0.03529411765, alpha: 1)
            leftView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(leftView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(subtitleLabel)
            contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            NSLayoutConstraint.activate([
                leftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                leftView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
                leftView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 0),
                leftView.widthAnchor.constraint(equalToConstant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 8),
                titleLabel.centerYAnchor.constraint(equalTo: leftView.layoutMarginsGuide.centerYAnchor, constant: 0),
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
                subtitleLabel.centerYAnchor.constraint(equalTo: leftView.layoutMarginsGuide.centerYAnchor, constant: 0),
                ])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: RutinasHeader = tableView.dequeueReusableHeaderFooterView(at: section)
        header.titleLabel.text = sections[section].type.name
        
        header.subtitleLabel.text = sections[section].type.staticText
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        switch sections[indexPath.section].items[indexPath.row] {
        case let .fuerza(fuerza):
            if let cell: RutinasCell = tableView.cellForRow(at: indexPath) as? RutinasCell {
                cell.videoView.reload()
            }
        default:
            break
        }
        
        
        selectedRows = selectedRows.filter({ $0 != indexPath })
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.gotoReservaInbodyFromBeginning()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tabView.visibleCells.isEmpty {
            self.tabView.isHidden = true
            self.diaDeDescansoLabel.isHidden = false
            self.diaDeDescansoLabel.text! = "Día de recuperación"
        } else {
            self.tabView.isHidden = false
            self.diaDeDescansoLabel.isHidden = true
            
        }
        
        
        return  self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cal = Calendar.current
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath as IndexPath) as! RutinasCollectionViewCell
        if self.tabView.visibleCells.isEmpty {
            self.tabView.isHidden = true
            self.diaDeDescansoLabel.isHidden = false
            self.diaDeDescansoLabel.text! = "Día de recuperación"
            
        } else {
            self.tabView.isHidden = false
            self.diaDeDescansoLabel.isHidden = true
            
        }
        
        cel.dayNumberLabel.text = String(days[indexPath.row])
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale!
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.dateFormat = "EEE"
        
        cel.dayLabel.text =  dateFormatter.string(from: cal.date(byAdding: .day, value:0, to: self.daysDateFormat[indexPath.row])!)
        
        
        let currentDate = self.currentSelected
        var finalMonth =  currentDate.getMonthName()
        mesLabel.text = finalMonth
        if
            let day = Calendar.current.dateComponents([.day], from: currentDate).day,
            let indexOf = self.days.index(of: day) {
            let selectedIndexPath = IndexPath(item: Int(indexOf), section: 0)
            if selectedIndexPath == indexPath {
                cel.dayNumberLabel.layer.borderWidth = 2.0
                cel.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
                cel.dayNumberLabel.layer.cornerRadius = cel.dayNumberLabel.bounds.width / 2
                if self.tabView.visibleCells.isEmpty {
                    self.tabView.isHidden = true
                    self.diaDeDescansoLabel.isHidden = false
                    self.diaDeDescansoLabel.text! = "Día de recuperación"
                } else {
                    self.tabView.isHidden = false
                    self.diaDeDescansoLabel.isHidden = true
                    
                }
                
            } else {
                cel.dayNumberLabel.layer.borderWidth = 0.0
                cel.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
                cel.dayNumberLabel.layer.cornerRadius = 0
            }
        } else {
            cel.dayNumberLabel.layer.borderWidth = 0.0
            cel.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            cel.dayNumberLabel.layer.cornerRadius = 0
        }
        
        
        
        //        if(self.currentSelected.compare(self.daysDateFormat[indexPath.row]) == ComparisonResult.orderedSame ){
        //
        //            cel.dayNumberLabel.layer.borderWidth = 2.0
        //            cel.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
        //            cel.dayNumberLabel.layer.cornerRadius = cel.dayNumberLabel.bounds.width / 2
        //
        //        }else{
        //            //cel.dayNumberLabel.textColor = UIColor.white
        //
        //            cel.dayNumberLabel.layer.borderWidth = 0.0
        //            cel.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
        //            cel.dayNumberLabel.layer.cornerRadius = 0
        //        }
        return cel
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelected = self.daysDateFormat[indexPath.row];
        var finalMonth =  self.currentSelected.getMonthName()
        mesLabel.text = finalMonth
        for i in 0...(self.colleView.visibleCells.count - 1){
            let tempCell : RutinasCollectionViewCell = self.colleView.visibleCells[i] as! RutinasCollectionViewCell
            //tempCell.dayNumberLabel.textColor = UIColor.white
            
            tempCell.dayNumberLabel.layer.borderWidth = 0.0
            tempCell.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            tempCell.dayNumberLabel.layer.cornerRadius = 0
            
        }
        let tempCellSelect : RutinasCollectionViewCell = self.colleView.cellForItem(at: indexPath) as! RutinasCollectionViewCell
        //tempCellSelect.dayNumberLabel.textColor = UIColor.red
        tempCellSelect.dayNumberLabel.layer.borderWidth = 2.0
        tempCellSelect.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
        tempCellSelect.dayNumberLabel.layer.cornerRadius = tempCellSelect.dayNumberLabel.bounds.width / 2
        self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        
        self.updateCalendar()
        
        
    }
    func updateCalendar(){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        selectedRows = []
        APIManager.sharedInstance.getReadMenu(date: dateFormatter.string(from: self.currentSelected)) { result in
            
            
            
            
            switch result {
                
                
            case let .success(response):
                
                let fuerzas = response.data.fuerzas.map({ DisplayObjectType.fuerza($0) })
                let cardios = response.data.cardios.map({ DisplayObjectType.cardio($0) })
                let clases = response.data.clases.map({ DisplayObjectType.clase($0) })
                let optativas = response.data.optativas.map({ DisplayObjectType.optativa($0)
                    
                    
                })
                
                self.sections = [
                    SectionType(type: .fuerza, items: fuerzas),
                    SectionType(type: .cardio, items: cardios),
                    SectionType(type: .clase, items: clases),
                    SectionType(type: .optativa, items: optativas)
                    
                    ].filter({ !$0.items.isEmpty })
                
                if self.tabView.visibleCells.isEmpty {
                    self.tabView.isHidden = true
                    self.diaDeDescansoLabel.isHidden = false
                    self.diaDeDescansoLabel.text! = "Día de recuperación"
                    
                } else {
                    
                    self.tabView.isHidden = false
                    self.diaDeDescansoLabel.isHidden = true
                }
                
                if !SavedData.getInBody(){
                    // self.viewAgendarCita.isHidden = false
                    SavedData.setInBody(isInBody: true)
                }else{
                    self.viewAgendarCita.isHidden = true
                    
                }
                
                
                
            case .failure(_):
                print("falló")
            }
        }
        
        
        
    }
    
    
    /////////////////////ACCIONES DE LOS BOTONES///////////////////////
    @IBAction func clickSegmented(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            avancesContainer.isHidden = true
            inbodyContainer.isHidden = false
            tabView.isHidden = true
            diaDeDescansoLabel.isHidden = true
            mesLabel.isHidden = true
            let titleLabel = UILabel()
            titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.numberOfLines = 1
            let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
            //attributes for the second part of the string
            
            //initializing the attributed string and appending the two parts together
            let attrString = NSMutableAttributedString(string: "Wellness test", attributes: firstAttr)
            //setting the attributed string as an attributed text
            titleLabel.attributedText = attrString
            
            //finding the bounds of the attributed text and resizing the label accordingly
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
            titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
            
            //setting the label as the title view of the navigation bar
            navigationItem.titleView = titleLabel
            instructionsView.isHidden = true
            colleView.isHidden = true
            currentSegment = sender.selectedSegmentIndex
            
        } else if sender.selectedSegmentIndex == 1 {
            mesLabel.isHidden = false
            
            avancesContainer.isHidden = true
            inbodyContainer.isHidden = true
            tabView.isHidden = true
            let titleLabel = UILabel()
            titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.numberOfLines = 1
            let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
            //attributes for the second part of the string
            
            //initializing the attributed string and appending the two parts together
            let attrString = NSMutableAttributedString(string: "Wellnes test", attributes: firstAttr)
            //setting the attributed string as an attributed text
            titleLabel.attributedText = attrString
            
            //finding the bounds of the attributed text and resizing the label accordingly
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
            titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
            
            //setting the label as the title view of the navigation bar
            navigationItem.titleView = titleLabel
            tabView.isHidden = false
            instructionsView.isHidden = false
            colleView.isHidden = false
            currentSegment = sender.selectedSegmentIndex
        } else if sender.selectedSegmentIndex == 2 {
            mesLabel.isHidden = true
            diaDeDescansoLabel.isHidden = true
            segmentedControl.isHidden = false
            colleView.isHidden = true
            avancesContainer.isHidden = false
            tabView.isHidden = true
            let titleLabel = UILabel()
            titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.numberOfLines = 1
            let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
            //attributes for the second part of the string
            
            //initializing the attributed string and appending the two parts together
            let attrString = NSMutableAttributedString(string: "Wellness test", attributes: firstAttr)
            //setting the attributed string as an attributed text
            titleLabel.attributedText = attrString
            
            //finding the bounds of the attributed text and resizing the label accordingly
            let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
            titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
            
            //setting the label as the title view of the navigation bar
            navigationItem.titleView = titleLabel
            inbodyContainer.isHidden = true
            tabView.isHidden = true
            instructionsView.isHidden = true
            currentSegment = sender.selectedSegmentIndex
            
            
        }
    }
    
    @IBOutlet weak var viewAgendarCita: UIView!
    @IBOutlet weak var agendarCita: UIButton!
    @IBAction func agendarCitaAction(_ sender: Any) {
        viewAgendarCita.isHidden = true
        
    }
    
    @objc func gotoReservaInbody()  {
        /*let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "CalendarioInBodyViewController")
         self.navigationController!.pushViewController(VC1, animated: true)*/
        APIManager.sharedInstance.getReservasInBody(onSuccess: {
            reservas in
            DispatchQueue.main.async {
                if reservas.code == 200{
                    if reservas.data.count > 0{
                        for i in reservas.data{
                            self.fecha = i.fechaSolicitud
                            self.hora = i.horario
                            self.idClub = i.idUn
                            self.idAgenda = i.idAgenda
                        }
                        
                        
                        
                        
                        
                        self.performSegue(withIdentifier: "citaSegue", sender: nil)
                        
                        
                        
                    }else{
                        self.performSegue(withIdentifier: "reservarBody", sender: nil)
                    }
                    
                    
                }
                
            }
        })
        
        
    }
    
    @objc func gotoReservaInbodyFromBeginning()  {
        
        //self.getCalendarRoutines()
        APIManager.sharedInstance.getReservasInBody(onSuccess: {
            reservas in
            DispatchQueue.main.async {
                
                if reservas.code == 200 {
                    
                    
                    if reservas.data.count == 0 && codeForInbody == 500 {
                        self.viewAgendarCita.isHidden = false
                        self.comesFromEmptyValues = true
                        
                        //Si hay reservas y hay rutina esconde la vista
                    } else if reservas.data.count > 0  && codeForInbody == 200 {
                        self.viewAgendarCita.isHidden = true
                        
                        
                        // Si no hay rutina y hay reserva esconde la vista
                        
                    } else if codeForInbody == 500 && reservas.data.count > 0 {
                        
                        if self.comesFromEmptyValues == true {
                            self.viewAgendarCita.isHidden = true
                        } else {
                            self.viewAgendarCita.isHidden = true
                            if self.viewAgendarCita.isHidden == true {
                                Alert.ShowAlert(title: "", message: "Acércate a tu entrenador para que genere tu rutina", titleForTheAction: "Aceptar", in: self)
                            }
                        }
                        
                        
                        
                    }  else if reservas.data.count > 0 {
                        self.viewAgendarCita.isHidden = true
                    }
                }
                
                
            }
        })
        
        
    }
    
}

extension String {
    
    var detectedURL: String? {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: utf16.count))
        
        
        let urls = matches.map({ result -> String? in
            guard let range = Range(result.range, in: self) else {
                return nil
            }
            return String(self[range])
        })
        
        return urls.compactMap({ $0 }).first?.components(separatedBy: " ").first?.replacingOccurrences(of: "'", with: "")
    }
    
}
