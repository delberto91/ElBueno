//
//  ClubesViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 12/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class ClubesViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
    class MyAnnotation: MKPointAnnotation {
        var identifier: Int!
    }
    //MARK:- OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var clubesView: UIView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var arrowButton2: UIButton!
    @IBOutlet weak var arrowCercaDeMi: UIImageView!
    @IBOutlet weak var arrowProximasAperturas: UIImageView!
    @IBOutlet weak var arrowFavoritos: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    let locationManager = CLLocationManager()
    
    var stringArray: [String] = ["No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar", "No hay información para mostrar"]
      var stringArray2: [String] = ["No hay información para mostrar", "No hay información para mostrar"]
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        
        self.activity.color = UIColor(red: 233/255, green: 37/255, blue: 48/255, alpha: 1.0)
        
        self.view.addSubview(self.activity)
        self.activity.isHidden = true
        
        APIManager.sharedInstance.clubes = self
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 20
        searchBar.searchBarStyle = .default
        searchBar.backgroundColor = UIColor.darkGray
        //MARK: - BOTONES
        
        for club in APIManager.sharedInstance.allClubes{
            //self.compleateAppfters.append(appfter)
            let location = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(club.latitude),
                longitude: CLLocationDegrees(club.longitude)
            )
            let newAnnotation : MyAnnotation = MyAnnotation()
            newAnnotation.coordinate = location
            newAnnotation.identifier = club.clubId
            
            
            self.mapView.addAnnotation(newAnnotation)
            
         
            
        }
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled()
        {
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.notDetermined
            {
                //locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }else if status == CLAuthorizationStatus.authorizedWhenInUse
            {
                self.mapView.showsUserLocation = true
                
                //locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                //locationManager.startUpdatingLocation()
            }
        } else {
            
            print("locationServices disenabled")
        }
        
        self.mapView.delegate = self
        
        self.mapView.mapType = MKMapType.standard
        
        self.searchBar.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
     
    }
   
    func showActivity(){
         DispatchQueue.main.async{
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        }

    }
    
    func hideActivity(){
         DispatchQueue.main.async{
        self.activity.isHidden = true
        self.activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
        }
        
    }
    
    func updateMapLocation(){
        //let span = MKCoordinateSpanMake(0.014, 0.014)
        if(APIManager.sharedInstance.ciudadesVC.arrayLocalClubes.count > 0){
            let tempClub = APIManager.sharedInstance.ciudadesVC.arrayLocalClubes.first
            let locationCenter : CLLocationCoordinate2D  = CLLocationCoordinate2D(latitude: (tempClub?.latitude)!, longitude: (tempClub?.longitude)!)
        //let region = MKCoordinateRegion(center: locationCenter, span: span)
            let region = MKCoordinateRegion(center: locationCenter, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status
        {
        case .authorizedWhenInUse:
            self.mapView.showsUserLocation = true
            // locationManager.delegate = self
            /*locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.startUpdatingLocation()*/
            break
            
        default:
            break
            // User denied access, handle as appropriate
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            APIManager.sharedInstance.ciudadesVC.update(value: searchBar.text!)
            APIManager.sharedInstance.favoritesVC.update(value: searchBar.text!)
            APIManager.sharedInstance.proximasAperturasVC.update(value: searchBar.text!)
        })
        self.updateMapLocation()
    }
    @IBAction func backButton(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        APIManager.sharedInstance.ciudadesVC.update(value: searchText)
        APIManager.sharedInstance.favoritesVC.update(value: searchText)
        APIManager.sharedInstance.proximasAperturasVC.update(value: searchText)
        self.updateMapLocation()
    }
    func updateAllValues(){
         DispatchQueue.main.async{
            APIManager.sharedInstance.ciudadesVC.update(value: self.searchBar.text!)
        APIManager.sharedInstance.favoritesVC.update(value: self.searchBar.text!)
        //APIManager.sharedInstance.proximasAperturasVC.update(value: self.searchBar.text!)
        }
    }
    func mapView(_ ProfileMapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseId = "ProfilePinView"
        
        var pinView = ProfileMapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)}
        pinView!.canShowCallout = false
        pinView!.image = UIImage(named: "pin_ubicaciones")
        let customPointAnnotation  = annotation as! MyAnnotation
        
        pinView!.tag = customPointAnnotation.identifier
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.handleTapAnnotation(gestureRecognizer:)))
        pinView!.addGestureRecognizer(tapGestureRecognizer)
        return pinView
        
    }
    
    @objc func handleTapAnnotation(gestureRecognizer: UIGestureRecognizer) {
        print("touc")
        
        //let customPointAnnotation : MyAnnotation = self.annotationsArray[(gestureRecognizer.view?.tag)!]
        
        let club = APIManager.sharedInstance.allClubes.first(where: {$0.clubId == (gestureRecognizer.view?.tag)!})
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openMaps(query:"\(club!.latitude),\(club!.longitude)")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openGoogleMaps(query:"\(club!.latitude),\(club!.longitude)")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openWaze(query:"\(club!.latitude),\(club!.longitude)")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //-
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        //self.mapView.setRegion(region, animated: true)
        
        /*for club in APIManager.sharedInstance.allClubes{
            //self.compleateAppfters.append(appfter)
            let location = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(club.latitude),
                longitude: CLLocationDegrees(club.longitude)
            )
            let newAnnotation : MKPointAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = location
            
            
            self.mapView.addAnnotation(newAnnotation)
            
            
            
        }*/
        
        
    }
    var lastCoordiate : CLLocationCoordinate2D!
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let anno : MyAnnotation = view as? MyAnnotation{
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Maps", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.openMaps(query:"")
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.openGoogleMaps(query:"")
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.openWaze(query:"")
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
        }
       
    }
    
    func openGoogleMaps(query : String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //First check Google Mpas installed on User's phone or not.
            UIApplication.shared.open(URL(string:
                "http://maps.google.com/?daddr=" + query)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(URL(string:"https://www.google.com/maps?daddr=" + query)!, options: [:], completionHandler: nil)
        }
    }
    
    
    func openWaze(query : String) {
        if (UIApplication.shared.canOpenURL(URL(string:"waze://")!)) {  //First check Waze Mpas installed on User's phone or not.
            UIApplication.shared.open(URL(string:
                "http://waze.com/ul?ll="+query+"&navigate=yes")!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(URL(string:
                "http://waze.com/ul?ll="+query+"&navigate=yes")!, options: [:], completionHandler: nil)
        }
    }
    
    func openMaps(query : String) {
        //First check Waze Mpas installed on User's phone or not.
        UIApplication.shared.open(URL(string:"http://maps.apple.com/?daddr=" + query)!, options: [:], completionHandler: nil)
            
       
    }
    //MARK:- BOTONES.
   
    @IBAction func pellizcoButton(_ sender: Any) {
        let center = CLLocationCoordinate2D(latitude: SavedData.getTheLatitude(), longitude: SavedData.getTheLongitude())
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
    }
    

    
   
    
}
