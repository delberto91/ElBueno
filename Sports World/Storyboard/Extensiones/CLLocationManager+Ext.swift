//
//  CLLocationManager+Ext.swift
//  Sports World
//
//  Created by Mario Canto on 8/15/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//
import CoreLocation

final class LocationReporter {
    static let shared = LocationReporter()
    
    var userLocation: Future<CLLocation> {
        let promise = Promise<CLLocation>()
                
        LocationManager.shared.didUpdateLocation = { location in
            promise.resolve(with: location)
        }
        LocationManager.shared.requestOneTimeLocation()
        
        return promise
    }
    
    init() {}
}

extension LocationReporter {
    
    enum Result<T> {
        case value(T)
        case failure(Error)
    }
    
    class Future<T> {
        fileprivate var result: Result<T>? {
            didSet { result.map(report) }
        }
        private lazy var callbacks = [(Result<T>) -> Void]()
        
        func observe(with callback: @escaping (Result<T>) -> Void) {
            callbacks.append(callback)
            result.map(callback)
        }
        
        private func report(result: Result<T>) {
            for callback in callbacks {
                callback(result)
            }
        }
    }
    
    class Promise<T>: Future<T> {
        init(value: T? = nil) {
            super.init()
            result = value.map(Result.value)
        }
        
        func resolve(with value: T) {
            result = .value(value)
        }
        
        func reject(with error: Error) {
            result = .failure(error)
        }
    }
}

private final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private lazy var locationManager: CLLocationManager = {
        $0.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        $0.delegate = $1
        $0.requestWhenInUseAuthorization()
        return $0
    }(CLLocationManager(), self)
    
    var didUpdateLocation: ( (CLLocation) -> Void )? {
        didSet {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    var didChangeAuthorization: ( (CLAuthorizationStatus) -> Void )?
    var didAuthorizeTrackUserLocation: ( (CLAuthorizationStatus) -> Void )?
    
    
    var _location: CLLocation? {
        didSet {
            guard let location = _location else {
                return
            }
            didUpdateLocation?(location)
        }
    }
    
    var location: CLLocation? {
        get {
            return _location
        }
        set {
            _location = newValue
        }
    }
    
    
    
    
//    private override init() {
//        super.init()
//    }
}

// MARK: Public API

extension LocationManager {
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestOneTimeLocation() {        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
}

// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            didUpdateLocation?(location)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorization?(status)
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            didAuthorizeTrackUserLocation?(status)
        default:
            break
        }
    }
}



