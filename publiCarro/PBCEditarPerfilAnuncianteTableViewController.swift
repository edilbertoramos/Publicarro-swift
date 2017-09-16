
import UIKit
import Parse

class PBCEditarPerfilAnuncianteTableViewController: UITableViewController, UITextFieldDelegate
{

    @IBOutlet weak var vwNome: UIView!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var imgNome: UIImageView!
    @IBOutlet weak var vwCelular: UIView!
    @IBOutlet weak var tfCelular: UITextField!
    @IBOutlet weak var imgCelular: UIImageView!
    @IBOutlet weak var vwSenha: UIView!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var imgSenha: UIImageView!
    @IBOutlet weak var salvar: UIButton!
    
    private var anunciante: PFObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        vwNome.layer.cornerRadius = 8.0
        vwCelular.layer.cornerRadius = 8.0
        vwSenha.layer.cornerRadius = 8.0
        salvar.layer.cornerRadius = 8.0
        tfNome.delegate = self
        tfCelular.delegate = self
        tfSenha.delegate = self
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
        PBCAnunciante().anunciante { (success, anunciante) in
            if success && anunciante != nil
            {
                self.tfNome.text = "\(anunciante!["nome"])"
                self.tfCelular.text = "\(anunciante!["telefone"])"
                self.anunciante = anunciante
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
    
    @IBAction func salvar(sender: AnyObject)
    {
        anunciante["nome"] = tfNome.text
        anunciante["telefone"] = tfCelular.text
        anunciante.saveInBackground()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func dismissKeyboard() {
    
        view.endEditing(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
}
