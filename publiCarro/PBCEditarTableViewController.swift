
import UIKit
import Parse

class PBCEditarTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var vwNome: UIView!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var imgNome: UIImageView!
    @IBOutlet weak var vwTaxista: UIView!
    @IBOutlet weak var tfTaxista: UILabel!
    @IBOutlet weak var swTaxista: UISwitch!
    @IBOutlet weak var vwCelular: UIView!
    @IBOutlet weak var imgCelular: UIImageView!
    @IBOutlet weak var tfCelular: UITextField!
    @IBOutlet weak var vwSenha: UIView!
    @IBOutlet weak var imgSenha: UIImageView!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var btSalvar: UIButton!
    
    private var motorista: PFObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        vwNome.layer.cornerRadius = 8.0
        vwTaxista.layer.cornerRadius = 8.0
        vwCelular.layer.cornerRadius = 8.0
        vwSenha.layer.cornerRadius = 8.0
        btSalvar.layer.cornerRadius = 8.0
        tfNome.delegate = self
        tfSenha.delegate = self
        tfCelular.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        vwSenha.hidden = true
    }
    
    func isValidName(email: String) -> Bool
    {
        return email.rangeOfString("[A-Za-z]+\\ [A-Za-z]+", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func isValidCellphone(email: String) -> Bool
    {
        return email.rangeOfString("\\([0-9]{2}\\)\\ 9[0-9]{4}-[0-9]{4}", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tabBarController?.tabBar.hidden = true
        PBCMotorista().motorista { (success, motorista) in
            if success && motorista != nil
            {
                self.tfNome.text = "\(motorista!["nome"])"
                self.tfCelular.text = "\(motorista!["telefone"])"
                self.swTaxista.on = motorista!["taxista"] as! Bool
                self.motorista = motorista
            }
            else
            {
                self.tfNome.text = "Nome Indisponível"
                self.tfCelular.text = "Celular Indisponível"
            }
        }
        imgNome.image = UIImage(named: "check-selected")
        imgCelular.image = UIImage(named: "check-selected")
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        tabBarController?.tabBar.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField.text?.isEmpty == false
        {
            if textField == tfNome
            {
                imgNome.image = UIImage(named: "check-selected")
            }
            else if textField == tfCelular
            {
                imgCelular.image = UIImage(named: "check-selected")
            }
            else if textField == tfSenha
            {
                imgSenha.image = UIImage(named: "check-selected")
            }
        }
        else
        {
            if textField == tfNome
            {
                imgNome.image = UIImage(named: "check-deselected")
            }
                
            else if textField == tfCelular
            {
                imgCelular.image = UIImage(named: "check-deselected")
            }
            else if textField == tfSenha
            {
                imgSenha.image = UIImage(named: "check-deselected")
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty == false
        {
            if textField == tfCelular
            {
                if textField.text?.characters.count <= 15
                {
                    if range.location == 2
                    {
                        textField.text = "("+textField.text!+") 9"
                    }
                    else if range.location == 10
                    {
                        textField.text = textField.text!+"-"
                    }
                    else if range.location == 15
                    {
                        textField.resignFirstResponder()
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    @IBAction func salvar(sender: AnyObject)
    {
        motorista["nome"] = tfNome.text
        motorista["telefone"] = tfCelular.text
        motorista["taxista"] = swTaxista.on
        motorista.saveInBackground()
        navigationController?.popToRootViewControllerAnimated(true)
    }
}