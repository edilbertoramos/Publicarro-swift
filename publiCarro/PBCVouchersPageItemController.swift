
import UIKit
import CoreLocation
import MapKit
import Parse

class PBCVouchersPageItemController: UIViewController
{

    @IBOutlet weak var viewVouchers: UIView!
    @IBOutlet weak var lbTipoVouchers: UILabel!
    @IBOutlet weak var viewStatusDisponivel: UIView!
    @IBOutlet weak var lbResgateRealizado: UILabel!
    @IBOutlet weak var lbDataFim: UILabel!
    @IBOutlet weak var btLocal: UIButton!

    @IBOutlet weak var lbTextResgate: UILabel!
    @IBOutlet weak var lbDisponivel: UILabel!
    @IBOutlet weak var imageViewTipo
    : UIImageView!
    
    var localizacao:CLLocationCoordinate2D?
    var itemIndex: Int!
    var tipo: String!
    var endereco: String!
    var dataInicio: NSDate!
    var dataFim: NSDate!
    var resgatado: Bool = true
    var dateResgate: NSDate!
    
    private var resgateAnimationFeito = false
    
    var id = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()

        viewVouchers.userInteractionEnabled = true
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downtSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))

        upSwipe.direction = .Up
        downtSwipe.direction = .Down
        
        viewVouchers.addGestureRecognizer(downtSwipe)
        viewVouchers.addGestureRecognizer(upSwipe)

        viewStatusDisponivel.layer.cornerRadius = 10
        viewVouchers.layer.cornerRadius = 10
        
        lbTipoVouchers.text = tipo.capitalizedString
        lbDataFim.text = String.PBCConvertToStringNumber(dataFim)

        if let end = endereco
        {
            btLocal.setTitle("  \(end)", forState: .Normal)
        }
        
        if let date = dateResgate
        {
            lbResgateRealizado.text = lbResgateRealizado.text! + String.PBCConvertToStringNumber(date)
        }
        else
        {
            lbResgateRealizado.text = "\(lbResgateRealizado.text!) Data indisponível"
        }
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        if sender.direction == .Down
        {
            isEmpityView(viewStatusDisponivel)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.id)
        }
        else
        {
            viewStatusDisponivel.hidden = false
            lbResgateRealizado.hidden = true
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: self.id)
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        resgateAnimationFeito = false
    }
    
    override func viewWillAppear(animated: Bool)
    {
            if let resgateFeito:Bool = NSUserDefaults.standardUserDefaults().boolForKey(id)
            {
                if resgateFeito
                {
                    print("remove WillAppear")
                    viewStatusDisponivel.hidden = true
                    lbResgateRealizado.hidden = false
                }
                else
                {
                    viewStatusDisponivel.hidden = false
                    lbResgateRealizado.hidden = true
                }
            }
    }
    
    
    override func viewDidAppear(animated: Bool)
    {

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
//                self.status()
//        })

    }
    
    func status()
    {
        if resgatado
        {
            if let resgateFeito:Bool = NSUserDefaults.standardUserDefaults().boolForKey(id)
            {
                if !resgateFeito
                {
                    isEmpityView(viewStatusDisponivel)
                }
            }
        }
        else
        {
            lbResgateRealizado.hidden = true
            viewStatusDisponivel.hidden = false
        }
    }
    
    func isEmpityView(viewTest:UIView)
    {
        
        if viewTest.hidden != true
        {
            resgateVoucherAnimation(viewTest)
        }
    }
    


    @IBAction func localizar(sender: AnyObject)
    {
        if let coordinate = localizacao
        {
            goToMap(coordinate, name: tipo.capitalizedString + ", " + endereco, endereco: endereco)
        }
    }
    
    func goToMap(coordinate:CLLocationCoordinate2D, name:String, endereco:String)
    {
        let placemark : MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary:nil)
        
        let mapItem:MKMapItem = MKMapItem(placemark: placemark)
        mapItem.phoneNumber = "90909090909090"
        mapItem.name = "\(name)"

        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving
            , forKey: MKLaunchOptionsDirectionsModeKey)
        
        let currentLocationMapItem:MKMapItem = MKMapItem.mapItemForCurrentLocation()
        MKMapItem.openMapsWithItems([currentLocationMapItem, mapItem], launchOptions: launchOptions as? [String : AnyObject])

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func resgateVoucherAnimation(viewAnimation:UIView) {
        let smallFrame = CGRectInset(viewAnimation.frame,0,0)
        let finalFrame = CGRectOffset(viewAnimation.frame, 1, 500)
        
     
        UIView.animateKeyframesWithDuration(2.0, delay: 0.2, options: .CalculationModePaced, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5) {
                viewAnimation.frame = smallFrame
            }

            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.2) {
                viewAnimation.frame = finalFrame
            }
            self.resgateAnimationFeito = true

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.2*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                if self.resgateAnimationFeito
                {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.id)
                    viewAnimation.hidden = true
                    self.lbResgateRealizado.hidden = false
                    print("remove end animation")

                    print("1.0-\(self.tipo) - salvou")
                }
                else
                {
                    self.viewStatusDisponivel.hidden = false
                    self.lbResgateRealizado.hidden = true
                    print("1.0-\(self.tipo) - não salvou")

                }
            })
            }) { (success) -> Void in
               
        }
    }
}
