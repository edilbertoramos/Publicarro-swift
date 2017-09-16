
import UIKit
import Parse

class CadastroTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var btCadastrar: UIButton!
    @IBOutlet weak var vwNome: UIView!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var vwCelular: UIView!
    @IBOutlet weak var tfCelular: UITextField!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var vwSenha: UIView!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var vwCPF: UIView!
    @IBOutlet weak var tfCPF: UITextField!
    @IBOutlet weak var img5: UIImageView!

    override func viewWillAppear(animated: Bool)
    {
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btCadastrar.layer.cornerRadius = 8.0
        vwNome.layer.cornerRadius = 8.0
        vwEmail.layer.cornerRadius = 8.0
        vwCelular.layer.cornerRadius = 8.0
        vwSenha.layer.cornerRadius = 8.0
        vwCPF.layer.cornerRadius = 8.0
        tfNome.delegate = self
        tfEmail.delegate = self
        tfCelular.delegate = self
        tfSenha.delegate = self
        tfCPF.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField.text?.isEmpty == false
        {
            if textField == tfNome
            {
                img1.image = UIImage(named: "check-selected")
            }
            else if textField == tfEmail
            {
                img2.image = UIImage(named: "check-selected")
            }
            else if textField == tfCelular
            {
                img3.image = UIImage(named: "check-selected")
            }
            else if textField == tfSenha
            {
                img4.image = UIImage(named: "check-selected")
            }
            else if textField == tfCPF
            {
                img5.image = UIImage(named: "check-selected")
            }
        }
        else
        {
            if textField == tfNome
            {
                img1.image = UIImage(named: "check-deselected")
            }
            else if textField == tfEmail
            {
                img2.image = UIImage(named: "check-deselected")
            }
            else if textField == tfCelular
            {
                img3.image = UIImage(named: "check-deselected")
            }
            else if textField == tfSenha
            {
                img4.image = UIImage(named: "check-deselected")
            }
            else if textField == tfCPF
            {
                img5.image = UIImage(named: "check-deselected")
            }
        }
    }
    
    func isValidName(email: String) -> Bool
    {
        return email.rangeOfString("[A-Za-z]+\\ [A-Za-z]+", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func isValidEmail(email: String) -> Bool
    {
        return email.rangeOfString("([A-Za-z]+|[A-Za-z][A-Za-z0-9]*)@[A-Za-z]+.[A-Za-z]+", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func isValidCellphone(email: String) -> Bool
    {
        return email.rangeOfString("\\([0-9]{2}\\)\\ 9[0-9]{4}-[0-9]{4}", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func isValidCPF(email: String) -> Bool
    {
        return email.rangeOfString("[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    @IBAction func cadastrar(sender: AnyObject)
    {
        if (tfEmail.text?.isEmpty == true || tfNome.text?.isEmpty == true || tfSenha.text?.isEmpty == true || tfCelular.text?.isEmpty == true || tfCPF.text?.isEmpty == true)
        {
            presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Preencha todos os campos."), animated: true, completion: nil)
        }
        else
        {
            if isValidName(tfNome.text!) == false
            {
                presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Nome inválido."), animated: true, completion: nil)
            }
            else if isValidCellphone(tfCelular.text!) == false
            {
                presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Celular inválido."), animated: true, completion: nil)
            }
            else if isValidCPF(tfCPF.text!) == false
            {
                presentViewController(PBCAlertController().alerta("Aviso", mensagem: "CPF inválido."), animated: true, completion: nil)
            }
            else if isValidEmail(tfEmail.text!) == false
            {
                presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Email inválido."), animated: true, completion: nil)
            }
            else
            {
                let DadosMotorista = PBCDadosCadastroMotorista()
                DadosMotorista.nome = tfNome.text
                DadosMotorista.email = tfEmail.text
                DadosMotorista.celular = tfCelular.text
                DadosMotorista.senha = tfSenha.text!
                DadosMotorista.cpf = tfCPF.text
                self.performSegueWithIdentifier("SegueTerminarCadastro", sender:DadosMotorista)
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == tfSenha
        {
            textField.text = ""
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
            else if textField == tfCPF
            {
                if textField.text?.characters.count <= 14
                {
                    if range.location == 3
                    {
                        textField.text = textField.text!+"."
                    }
                    else if range.location == 7
                    {
                        textField.text = textField.text!+"."
                    }
                    else if range.location == 11
                    {
                        textField.text = textField.text!+"-"
                    }
                    else if range.location == 14
                    {
                        textField.resignFirstResponder()
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "SegueTerminarCadastro"
        {
            let destination = segue.destinationViewController as? PBCTerminarCadastroTableViewController
            destination?.dadosMotorista = sender as! PBCDadosCadastroMotorista
        }
    }
}
