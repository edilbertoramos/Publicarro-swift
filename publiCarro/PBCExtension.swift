//
//  PBCExtension.swift
//  publiCarro
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 04/01/16.
//  Copyright © 2016 tambatech. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
extension String
{
    
    static func PBCConvertFromNSDateToString(date:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd 'de' MMMM"
        return dateFormatter.stringFromDate(date)
    }
    static func PBCConvertToStringNumber(date:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
}

extension UIColor
{
    static var PBCPinkColor: UIColor{ return UIColor(colorLiteralRed: 0.957, green:0, blue:0.518, alpha:1.0)}
    static var PBCPinkColorWithAlpha: UIColor{ return UIColor(colorLiteralRed: 0.957, green:0, blue:0.518, alpha:0.4)}
    static var PBCGrayColor: UIColor{ return UIColor(colorLiteralRed: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)}
    static var PBCGreenColor: UIColor{ return UIColor(colorLiteralRed:0.169, green:0.725, blue:0.659, alpha:1)}

}

extension NSDate
{
    // Comparando datas
    static func PBCMenorIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970}
    
    static func PBCMaiorIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970}
    
    static func PBCMaior(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970}
    
    static func PBCMenor(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970}
    
    static func PBCIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970}
    
    static func PBCDataNoPeriodo(data: NSDate, inicio: NSDate, fim:NSDate) -> Bool
    {return NSDate.PBCMaiorIgual(data, rhs: inicio) && NSDate.PBCMenorIgual(data, rhs: fim)}

}

extension CLLocationCoordinate2D
{
    static func PBCConvertPFGeoPointToCLLocationCoordinate2D(geoPoint: PFGeoPoint) -> CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}