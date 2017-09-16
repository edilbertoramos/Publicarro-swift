
import UIKit
import Parse

class PBCTerminarCadastroTableViewController: UITableViewController, UITextFieldDelegate
{
    // LOCATIONS
    let locationManager = CLLocationManager()
    static var motoristaLocation = CLLocation()
    static var detalhesLocation = CLPlacemark?()


    @IBOutlet weak var btTerminar: UIButton!

    @IBOutlet weak var vwTaxista: UIView!
    @IBOutlet weak var switchTaxista: UISwitch!
    
    @IBOutlet weak var vwRenavam: UIView!
    @IBOutlet weak var tfRenavam: UITextField!
    
    @IBOutlet weak var vwLcalizar: UIView!
    @IBOutlet weak var tfLocalizar: UITextField!
    @IBOutlet weak var btLocalizar: UIButton!

    @IBOutlet weak var vwCEP: UIView!
    @IBOutlet weak var tfCEP: UITextField!

    @IBOutlet weak var vwNumero: UIView!
    @IBOutlet weak var tfNumero: UITextField!

    var dadosMotorista:PBCDadosCadastroMotorista!
    static var mapLocation: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btTerminar.layer.cornerRadius = 8.0
        vwCEP.layer.cornerRadius = 8.0
        vwLcalizar.layer.cornerRadius = 8.0
        vwNumero.layer.cornerRadius = 8.0
        vwRenavam.layer.cornerRadius = 8.0
        vwTaxista.layer.cornerRadius = 8.0
        tfCEP.delegate = self
        tfLocalizar.delegate = self
        tfNumero.delegate = self
        tfRenavam.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tfLocalizar.text = PBCTerminarCadastroTableViewController.mapLocation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    @IBAction func close(sender: AnyObject)
    {
        tabBarController?.tabBar.hidden = false
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func isValidRenavam(email: String) -> Bool
    {
        return email.rangeOfString("[0-9]{9}", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty == false
        {
            if textField == tfRenavam && range.location == 9
            {
                textField.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    @IBAction func terminar(sender: AnyObject)
    {
        if isValidRenavam(tfRenavam.text!) == false
        {
            presentViewController(PBCAlertController().alerta("Problema", mensagem: "RENAVAM inválido"), animated: true, completion: nil)
        }
        else
        {
            dadosMotorista.taxista = switchTaxista.on
            dadosMotorista.renavam = tfRenavam.text
            dadosMotorista.coordenada = PBCTerminarCadastroTableViewController.motoristaLocation.coordinate
            dadosMotorista.cep = tfCEP.text
            dadosMotorista.numero = tfNumero.text
            PBCMotorista().signUp(dadosMotorista) { (success, result, motorista) -> Void in
                if success
                {
                    print(motorista, result)
                    AppDelegate.motorista = motorista
                    self.presentAnuncios()
                }
                else
                {
                    self.presentViewController(PBCAlertController().alerta("Problema", mensagem: result), animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                if placemark?.areasOfInterest?.count > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    
    @IBAction func localizacao(sender: AnyObject)
    {
        performSegueWithIdentifier("SegueLocalizacaoMtorista", sender: nil)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func presentAnuncios()
    {
    
        self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("MotoristaTabBar"))!, animated: true, completion: nil)
    }
    
    static func printLocationMotorista(placemark:CLPlacemark)
    {
        print("\n")
        print(placemark.location?.coordinate.latitude)
        print(placemark.location?.coordinate.longitude)
        print(placemark.country)
        print(placemark.administrativeArea)
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.subLocality)
        print(placemark.thoroughfare)
        
    }
}