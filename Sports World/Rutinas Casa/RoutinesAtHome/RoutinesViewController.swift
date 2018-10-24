//
//  RoutinesViewController.swift
//  SW_etapa_IV
//
//  Created by Mario Canto on 7/27/18.
//  Copyright © 2018 Aldo Gutierrez Montoya. All rights reserved.
//

import UIKit
import AVKit
final class RoutinesViewController: UIViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    func clearAllFilesFromTempDirectory(){
        
        
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
        
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            //            searchBar.barTintColor = UIColor.clear
            searchBar.placeholder = NSLocalizedString("Buscar", comment: "")
            searchBar.setTextColor(color: .white)
            //            searchBar.layer.borderWidth = 0
            //            searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
            searchBar.setTextFieldColor(color: UIColor.init(white: 1.0, alpha: 0.3))
            searchBar.setPlaceholderTextColor(color: .white)
            searchBar.setSearchImageColor(color: .white)
            searchBar.setTextFieldClearButtonColor(color: .white)
            searchBar.barTintColor = UIColor.clear
            searchBar.backgroundColor = UIColor.clear
            searchBar.isTranslucent = true
            searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
            //view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            tableView.tableFooterView = view
            tableView.estimatedRowHeight = 160
            
            let bgView = UIView()
            bgView.backgroundColor = UIColor.clear
            tableView.backgroundView = bgView
        }
    }
    var storedOffsets = [Int: CGFloat]()
    var tableCellscells : [StandardRoutineCell]  = [StandardRoutineCell]()
    var routines: [[Routine]] = [] {
        didSet {
            tableCellscells = [StandardRoutineCell]()
            tableView.reloadData()
        }
    }
    var originalRoutines: [[Routine]] = [] {
        didSet {
            
        }
    }
}

extension RoutinesViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.activity.isHidden = true
        self.clearAllFilesFromTempDirectory()
        self.refreshData()
    }
    
    @objc private func refreshRoutines(_ note: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshData()
        }
    }
    
    private func refreshData() {
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.originalRoutines = []
        self.routines = []
        self.tableView.reloadData()
        APIManager.sharedInstance.getRoutinesAtHome { result in
            func priority(sort: [String], source: String) -> Int {
                guard let index = sort.index(of: source) else {
                    return sort.count
                }
                return Int(index)
            }
            switch result {
            case let .success(trainings):
                let rawTrainings = uniq(source: trainings.data.map({ $0.categoria }))
                    .map({ $0 })
               
                self.routines = trainings.data
                    .grouped(by: { lhs, rhs in lhs.categoria == rhs.categoria })
                    .filter({ $0.first != nil })
                    .sorted(by: { lhs, rhs in
                        
                        return priority(sort: rawTrainings, source: lhs.first!.categoria) < priority(sort: rawTrainings, source: rhs.first!.categoria)
                       
                    })
                self.originalRoutines = self.routines
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true 
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearAllFilesFromTempDirectory()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshRoutines(_:)),
                                               name: NSNotification.Name("com.sportsworld.update.routines"),
                                               object: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_perfil"), style: .done, target: self, action: #selector(RoutinesViewController.clickMenuButton))
        tableView.reloadData()
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Workout", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        //refreshData()
    }
    
    @objc  func clickMenuButton() {
        DispatchQueue.main.async {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RoutinesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        routines = originalRoutines
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        routines = []b
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            routines = originalRoutines
            return
        }
        let filtered = originalRoutines
            .map({ $0.filter({ $0.nombreEntrenamiento.range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive]) != nil }) })
        routines = filtered
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension RoutinesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return routines.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines[section].count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let routines = self.routines[indexPath.section]
        
        
        if indexPath.section == 0 {
            let cell: LargeRoutineCell = tableView.dequeueReusableCell(at: indexPath)
            cell.routines = routines
            cell.didSelectCellAtIndexPath = { [weak self] ip, routine in
                //                self?.performSegue(withIdentifier: RoutineDetailViewController.reuseId, sender: self)
                if routines[indexPath.row].isLive == false {
                  
                    let vc : RoutineDetailViewController = UIStoryboard(name: "Main", bundle: nil)
                        .instantiateViewController(withIdentifier: "RoutineDetailViewController") as! RoutineDetailViewController
                    vc.videoRoutine = routine.mapToRutinasCasa()
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let videoURL = URL(string: routines[indexPath.row].videoDistribucion)
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self?.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }

                }
               
            }
            return cell
        } else {
            var cell: StandardRoutineCell = tableView.dequeueReusableCell(withIdentifier: "StandardRoutineCell") as! StandardRoutineCell
            if(indexPath.section - 1 >= tableCellscells.count){
                cell.routines = routines
                cell.didSelectCellAtIndexPath = { [weak self] ip, routine in
                    if routines[indexPath.row].isLive == false {
                      
                        let vc : RoutineDetailViewController = UIStoryboard(name: "Main", bundle: nil)
                            .instantiateViewController(withIdentifier: "RoutineDetailViewController") as! RoutineDetailViewController
                        vc.videoRoutine = routine.mapToRutinasCasa()
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                      let videoURL = URL(string: routines[indexPath.row].videoDistribucion)
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self?.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                }
                tableCellscells.append(cell)
            }else{
                
                cell = tableCellscells[indexPath.section - 1]
                cell.routines = routines
                cell.didSelectCellAtIndexPath = { [weak self] ip, routine in
                    if routines[indexPath.row].isLive == false {
                         print("es falso 3")
                        let vc : RoutineDetailViewController = UIStoryboard(name: "Main", bundle: nil)
                            .instantiateViewController(withIdentifier: "RoutineDetailViewController") as! RoutineDetailViewController
                        vc.videoRoutine = routine.mapToRutinasCasa()
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let videoURL = URL(string: routines[indexPath.row].videoDistribucion)
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self?.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                }
            }
            
            
            return cell
        }
    }
    
    
    
}

extension RoutinesViewController: UITableViewDelegate {
    
    
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = RoutinesHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        view.titleLabel.text = routines[section].first?.categoria.capitalized
        view.subtitleLabel.text = nil
        return view
        //        let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        //        container.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        let header = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        //        header.translatesAutoresizingMaskIntoConstraints = false
        //        header.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        header.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        header.font = UIFont(name: "LarkeNeueBold-Bold", size: 17)!
        //        header.text = routines[section].first?.categoria.capitalized
        //        container.addSubview(header)
        //        NSLayoutConstraint.activate([
        //            header.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor, constant: 8),
        //            header.centerYAnchor.constraint(equalTo: container.layoutMarginsGuide.centerYAnchor, constant: 0)
        //            ])
        //        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return routines[section].count > 0 ? 34 : 0
    }
    
    
    
}


final class StandardRoutineCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: RoutineTitleImageCell.reuseId, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: RoutineTitleImageCell.reuseId)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var RoutineTitleImageCellcells : [RoutineTitleImageCell]  = [RoutineTitleImageCell]()
    var routines: [Routine] = [] {
        didSet {
            /*for routine in routines{
             let cell: RoutineTitleImageCell = collectionView.deques
             
             //cell.pictureView.downloadedFrom(url: URL(string: routine.foto)!, contentMode: .scaleAspectFill)
             
             cell.pictureView.image = nil
             
             cell.pictureView.downloadImage(downloadURL: routine.foto, completion: { result in
             
             })
             
             cell.pictureView.contentMode = .scaleAspectFill
             cell.titleLabel.text = routine.nombreEntrenamiento
             cell.titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 17)!
             cells.append(cell)
             }*/
            //cells = [RoutineTitleImageCell]()
            collectionView.reloadData()
        }
    }
    
    
    
    var didSelectCellAtIndexPath: ( (IndexPath, Routine) -> Void )?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let routine = routines[indexPath.row]
        let cell: RoutineTitleImageCell = collectionView.dequeueReusableCell(at: indexPath)
        
        //cell.pictureView.downloadedFrom(url: URL(string: routine.foto)!, contentMode: .scaleAspectFill)
        
        cell.isFirstLoad = false
        cell.pictureView.image = nil
        
        cell.pictureView.downloadImageSync(downloadURL: routine.foto, completion: { result in
            
        })
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                cell.pictureView.contentMode = .scaleAspectFill
            case 1334:
                 print("iPhone 6/6S/7/8")
                cell.pictureView.contentMode = .scaleAspectFill
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                 cell.pictureView.contentMode = .scaleAspectFill
            case 2436:
                print("iPhone X")
                  cell.pictureView.contentMode = .scaleAspectFill
            default:
                print("unknown")
            }
        }
        //cell.pictureView.contentMode = .scaleAspectFill
        cell.titleLabel.text = ""
        cell.titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 17)!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.70) / 1.95), height: size.height)
            case 1334:
                print("iPhone 6/6S/7/8")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.70) / 1.95), height: size.height)
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.73) / 1.95), height: size.height)
            case 2436:
                print("iPhone X")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.85) / 1.95), height: size.height)
            default:
                print("unknown")
            }
        }
        let size = collectionView.frame.size
        return CGSize(width: ((size.width * 0.85) / 1.95), height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCellAtIndexPath?(indexPath, routines[indexPath.row])
    }
}

final class LargeRoutineCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!  {
        didSet {
            let nib = UINib(nibName: RoutineImageCell.reuseId, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: RoutineImageCell.reuseId)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var routines: [Routine] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var didSelectCellAtIndexPath: ( (IndexPath, Routine) -> Void )?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let routine = routines[indexPath.row]
        let cell: RoutineImageCell = collectionView.dequeueReusableCell(at: indexPath)
        
        
        cell.pictureView.downloadImageSync(downloadURL: routine.foto, completion: { result in
            
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.95) / 1.70), height: size.height)
            case 1334:
                print("iPhone 6/6S/7/8")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.95) / 1.70), height: size.height)
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                let size = collectionView.frame.size
                return CGSize(width: ((size.width * 0.95) / 1.80), height: size.height)
            case 2436:
                print("iPhone X")
                let size = collectionView.frame.size
                return CGSize(width: size.width * 0.85, height: size.height)
            default:
                print("unknown")
            }
        }
        let size = collectionView.frame.size
        return CGSize(width: size.width * 0.85, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     didSelectCellAtIndexPath?(indexPath, routines[indexPath.row])
    }
}

final class RoutineImageCell: UICollectionViewCell {
    @IBOutlet weak var pictureView: UIImageView!
    
    
}



final class RoutineTitleImageCell: UICollectionViewCell {
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var isFirstLoad : Bool = true
    
    
    
}



extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}



extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}


class RoutinesHeaderView: UITableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "LarkeNeue-Regular", size: 17)
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
        contentView.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.black
        NSLayoutConstraint.activate([
            leftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            leftView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            leftView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            leftView.widthAnchor.constraint(equalToConstant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: leftView.layoutMarginsGuide.centerYAnchor, constant: 0),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            subtitleLabel.centerYAnchor.constraint(equalTo: leftView.layoutMarginsGuide.centerYAnchor, constant: 0),
            ])
    }
}
