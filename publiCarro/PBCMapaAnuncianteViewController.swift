
import UIKit
import MapKit
import CoreLocation
import Parse

class PBCMapaAnuncianteViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var motoristas: [PFObject] = []
    var anuncio: PFObject!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(motoristas)
        
        self.tabBarController?.tabBar.hidden = true

        let query = PFQuery(className: "MotoristaLocation")
        
        query.whereKey("motorista", containedIn: motoristas)
//        query.whereKey(<#T##key: String##String#>, containsAllObjectsInArray: <#T##[AnyObject]#>)
        query.includeKey("motorista")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if objects != nil && error == nil
            {
                print(objects?.count)
                for p in objects!
                {
                    print("\(p.objectForKey("localizacao"))\(p.objectForKey("motorista")?.objectForKey("nome"))")
                    let inicioAnuncio = self.anuncio["inicioAnuncio"] as! NSDate
                    let fimAnuncio = self.anuncio["fimAnuncio"] as! NSDate
                    
                    if NSDate.PBCDataNoPeriodo(p.createdAt!, inicio: inicioAnuncio, fim: fimAnuncio)
                    {
                        print("Está na data")
                    }
                    let coordinate = self.convertPFGeoPointToCLLocationCoordinate2D(p["localizacao"] as! PFGeoPoint)
                    
                    let circle = MKCircle(centerCoordinate: coordinate, radius: 100)
                    self.mapView.addOverlay(circle)
                }
                
                var region = MKCoordinateRegion()
                region.span.latitudeDelta = 0.05
                region.span.longitudeDelta = 0.05
                
                let centerCoordinate = self.convertPFGeoPointToCLLocationCoordinate2D(objects![0]["localizacao"] as! PFGeoPoint)
                
                self.mapView.centerCoordinate = centerCoordinate
                self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(centerCoordinate,15000, 15000), animated: true)
                
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.tabBarController?.tabBar.hidden = false
    }
    func convertPFGeoPointToCLLocationCoordinate2D(geoPoint: PFGeoPoint) -> CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        let view = MKCircleRenderer(overlay: overlay)
        
        view.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.1)
        view.fillColor = UIColor.redColor().colorWithAlphaComponent(0.4)
        
        return view
    }
    
    
}

