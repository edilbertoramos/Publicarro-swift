////
////  LocationManagerBackground.swift
////  LocationTest
////
////  Created by Angel Ignatov on 10/27/15.
////  Copyright © 2015 Aggressione. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//import UIKit
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    
//    var anotherLocationManager: CLLocationManager!
//    
//    class var IS_IOS_OR_LATER: Bool {
//        
//        let Device = UIDevice.currentDevice()
//        let iosVersion = NSString(string: Device.systemVersion).doubleValue
//        return iosVersion >= 8
//    }
//    
//    class var sharedManager : LocationManager {
//        struct Static {
//            static let instance : LocationManager = LocationManager()
//        }
//        return Static.instance
//    }
//    
//    private override init(){
//        super.init()
//        
//    }
//    
//    func startMonitoringLocation() {
//        if (anotherLocationManager != nil) {
//            anotherLocationManager.stopMonitoringSignificantLocationChanges()
//        }
//        
//        self.anotherLocationManager = CLLocationManager()
//        anotherLocationManager.delegate = self
//        anotherLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        anotherLocationManager.activityType = CLActivityType.OtherNavigation
//        
//        if (LocationManager.IS_IOS_OR_LATER) {
//            anotherLocationManager.requestAlwaysAuthorization()
//        }
//        anotherLocationManager.startMonitoringSignificantLocationChanges()
//    }
//    
//    func restartMonitoringLocation() {
//        anotherLocationManager.stopMonitoringSignificantLocationChanges()
//        
//        if (LocationManager.IS_IOS_OR_LATER) {
//            anotherLocationManager.requestAlwaysAuthorization()
//        }
//        
//        anotherLocationManager.startMonitoringSignificantLocationChanges()
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let arrayOfLocation = locations as NSArray
//        let location = arrayOfLocation.lastObject as! CLLocation
//        let coordLatLon = location.coordinate
//        
//        let latitude: Double  = coordLatLon.latitude
//        //let longitude: Double = coordLatLon.longitude
//        print(latitude)
//
//        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
//            if (error != nil){
//                print("reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            else if (placemarks?.count > 0){
//                let locationDetail = placemarks!.last! as CLPlacemark
//                print(locationDetail)
//            }
//            else{
//                print("geocoder problem")
//            }
//        }
//    }
//    
//    func acessoAutorizado() -> Bool{
//        if (CLLocationManager.authorizationStatus() ==  CLAuthorizationStatus.AuthorizedAlways)
//        {
//            return true
//        }
//        else{
//            return false
//        }
//
//    }
//    
//    
//}