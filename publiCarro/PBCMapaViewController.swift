
import UIKit
import MapKit
import CoreLocation

class PBCMapaViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var enderecoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tfEndereco: UILabel!
    @IBOutlet weak var btPronto: UIButton!
    var locationManager : CLLocationManager!
    var locationUser : CLLocationCoordinate2D?
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btPronto.layer.cornerRadius = 8.0
        enderecoView.layer.cornerRadius = 8.0
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCode(location)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        locationUser = userLocation.location?.coordinate
        print("teste")
        print(locationUser)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.first!
        mapView.centerCoordinate = location.coordinate
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500), animated: true)
        PBCTerminarCadastroTableViewController.motoristaLocation = location
        geoCode(location)
    }
    
    func geoCode(location: CLLocation!)
    {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(data,error) -> Void in
            let loc = (data?.last)!
//            self.textAdd(loc)
                       PBCTerminarCadastroTableViewController.detalhesLocation = loc as CLPlacemark
            let addressDict: [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address = addrList.joinWithSeparator(", ")
            
            print("\n\nEndereço: \(address)")
            
            self.tfEndereco.text = address
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    func textAdd(loc:CLPlacemark)
    {
        if let text = loc.thoroughfare
        {
            tfEndereco.text = text
        }
        else
        {
            if isValidName(loc.name!)
            {
                tfEndereco.text = loc.name
            }
            else
            {
                tfEndereco.text = loc.subLocality
            }
        }
    }
    
    func isValidName(text: String) -> Bool
    {
        return text.rangeOfString("([A-Za-z])", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    @IBAction func pronto(sender: AnyObject)
    {
        print("pronto")
        PBCTerminarCadastroTableViewController.mapLocation = tfEndereco.text
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func currentLocation(sender: AnyObject)
    {
        locationManager.startUpdatingLocation()
    }
}