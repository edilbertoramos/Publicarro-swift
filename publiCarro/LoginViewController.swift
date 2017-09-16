
import UIKit
import Parse

class LoginViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var btLogar: UIButton!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var vwSenha: UIView!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewWillAppear(animated: Bool)
    {
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBarHidden = false
        tfEmail.delegate = self
        tfSenha.delegate = self
        btLogar.layer.cornerRadius = 8.0
        vwEmail.layer.cornerRadius = 8.0
        vwSenha.layer.cornerRadius = 8.0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        indicator.hidden = true
//        indicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4        
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == tfSenha
        {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField.text?.isEmpty == false
        {
            if textField == tfEmail
            {
                img1.image = UIImage(named: "check-selected")
            }
            else
            {
                img2.image = UIImage(named: "check-selected")
            }
        }
        else
        {
            if textField == tfEmail
            {
                img1.image = UIImage(named: "check-deselected")
            }
            else
            {
                img2.image = UIImage(named: "check-deselected")
            }
        }
    }
    
    @IBAction func logar(sender: AnyObject)
    {
        if (tfEmail.text?.isEmpty == true || tfSenha.text?.isEmpty == true)
        {
            presentViewController(PBCAlertController().alerta("Problema", mensagem: "Informe seu email e sua senha."), animated: true, completion: nil)
        }
        else
        {
            
            indicator.hidden = false
            indicator.startAnimating()
            view.userInteractionEnabled = false
            PFUser.logInWithUsernameInBackground(tfEmail.text!, password: tfSenha.text!, block: { (user, error) -> Void in
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.indicator.hidden = true
                self.view.userInteractionEnabled = true
                
                PBCUsuario().tipoUsuario({ (usuario) -> Void in
                    if usuario == PBCUsuario().motorista
                    {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else if usuario ==  PBCUsuario().anunciante
                    {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "anunciante")
                        AppDelegate().setColors(UIColor.PBCGreenColor, colorWithAplha: UIColor.PBCPinkColorWithAlpha)
                        
                        for window in UIApplication.sharedApplication().windows
                        {
                            window.tintColor = UIColor.PBCGreenColor
                        }
                        
                        self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AnuncianteTabBar") as! UITabBarController, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.presentViewController(PBCAlertController().alerta("Problema", mensagem: "Erro, tente novamente"), animated: true, completion: nil)
                    }
                })
            })
            
        }
    }
    
    @IBAction func esqueceuSenha(sender: AnyObject)
    {
        if PBCError.isConnectedToNetwork()
        {
            var email: UITextField?
            let alertView = UIAlertController(title: "Recuperação de Senha", message: "Informe seu email de acesso:", preferredStyle: .Alert)
            alertView.addTextFieldWithConfigurationHandler { (text) -> Void in
                email = text
                email?.text = self.tfEmail.text
                email!.placeholder = "email@email.com"
                email!.keyboardType = UIKeyboardType.EmailAddress
            }
            alertView.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                PFUser.requestPasswordResetForEmailInBackground((email?.text)!, block: { (sucess, error) in
                    var message: String
                    if sucess
                    {
                        message = "Verifique seu email:\n\n"+email!.text!
                    }
                    else
                    {
                        message = PBCError().codeErrorParse(error: error!)
                    }
                    let alertView = UIAlertController(title: "Recuperação de Senha", message: message, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                })
            })
            presentViewController(alertView, animated: true, completion: nil)
//            dismissKeyboard()
        }
        else
        {
            let alertView = UIAlertController(title: "Problema de Conexão", message: "Verifique sua rede de dados.", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(email: String) -> Bool
    {
        return email.rangeOfString("([A-Za-z]+|[A-Za-z][A-Za-z0-9]*)@[A-Za-z]+.[A-Za-z]+", options:.RegularExpressionSearch) != nil ? true : false
    }
    @IBAction func cadastrar(sender: AnyObject)
    {
        performSegueWithIdentifier("SegueCadastrar", sender: nil)
    }
}