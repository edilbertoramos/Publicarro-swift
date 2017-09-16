
import UIKit
import Parse

class PBCOrcamentoAnuncianteTableViewController: UITableViewController, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private var pickerQtd = [10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100]
    private var pickerDias = ["30 dias","45 dias","60 dias"]
    
    var rowQtd = 0
    var rowDias = 0
    
    
    var pickerViewQtd =  UIPickerView()
    var pickerViewDias = UIPickerView()
    let toolBar = UIToolbar()
    
    var checkSelected = UIImage(named: "check-selected")
    
    @IBOutlet weak var vwNome: UIView!
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var vwCelular: UIView!
    @IBOutlet weak var tfCelular: UITextField!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var vwQuantidade: UIView!
    @IBOutlet weak var tfQuantidade: UITextField!
    @IBOutlet weak var btSolicitar: UIButton!
    @IBOutlet weak var tfDuracao: UITextField!
    @IBOutlet weak var vwDuracao: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        vwNome.layer.cornerRadius = 8.0
        vwCelular.layer.cornerRadius = 8.0
        vwEmail.layer.cornerRadius = 8.0
        vwQuantidade.layer.cornerRadius = 8.0
        vwDuracao.layer.cornerRadius = 8.0
        tfDuracao.delegate = self
        // Bordas
        vwNome.layer.cornerRadius = 8.0
        vwCelular.layer.cornerRadius = 8.0
        vwEmail.layer.cornerRadius = 8.0
        vwQuantidade.layer.cornerRadius = 8.0
        vwDuracao.layer.cornerRadius = 8.0
        btSolicitar.layer.cornerRadius = 8.0
        // Delegates
        tfNome.delegate = self
        tfCelular.delegate = self
        tfEmail.delegate = self
        tfQuantidade.delegate = self
        tfDuracao.delegate = self
        tfNome.delegate = self
        tfCelular.delegate = self
        tfEmail.delegate = self
        tfQuantidade.delegate = self
        tfDuracao.delegate = self
        pickerViewQtd.delegate = self
        pickerViewQtd.dataSource = self
        pickerViewDias.delegate = self
        pickerViewDias.dataSource = self
        pickerViewQtd.backgroundColor = UIColor.whiteColor()
        pickerViewDias.backgroundColor = UIColor.whiteColor()

        // ToolBar
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let okButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.Plain, target: self, action: "okPicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, okButton], animated: false)
        toolBar.userInteractionEnabled = true
        tfQuantidade.inputView = pickerViewQtd
        tfDuracao.inputView = pickerViewDias
        tfQuantidade.inputAccessoryView = toolBar
        tfDuracao.inputAccessoryView = toolBar
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        PBCUsuario().tipoUsuario({ (usuario) -> Void in
            if usuario == PBCUsuario().motorista
            {
                self.notEqualToAnunciante()
            }
            else if usuario ==  PBCUsuario().anunciante
            {
                self.equalToAnunciante()
            }
            else
            {
                self.notEqualToAnunciante()
            }
        })
    }
    
    func equalToAnunciante()
    {
        self.checkSelected = UIImage(named: "check")
        self.btSolicitar.backgroundColor = UIColor.PBCGreenColor
        toolBar.tintColor =  UIColor.PBCGreenColor
        
        tfEmail.text = PFUser.currentUser()?.email
        PBCAnunciante().anunciante { (success, anunciante) -> Void in
            if success && anunciante != nil
            {
                self.tfNome.text = "\(anunciante!["nome"])"
                self.tfCelular.text = "\(anunciante!["telefone"])"
                
                self.img1.image = self.checkSelected

                self.img2.image = self.checkSelected
            }
        }
        
        img3.image = checkSelected

        
        tfCelular.tintColor = UIColor.PBCGreenColor
        tfDuracao.tintColor = UIColor.PBCGreenColor
        tfEmail.tintColor = UIColor.PBCGreenColor
        tfNome.tintColor = UIColor.PBCGreenColor
        tfQuantidade.tintColor = UIColor.PBCGreenColor
        
    }
    
    func notEqualToAnunciante()
    {
        self.checkSelected = UIImage(named: "check-selected")
        self.btSolicitar.backgroundColor = UIColor.PBCPinkColor
        toolBar.tintColor =  UIColor.PBCGreenColor

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func dismissKeyboard() {
        
        
        view.endEditing(true)
        
        
        
    }
    
    //Picker View -> Quantidade de carros
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        
        if pickerView ==  pickerViewQtd {
            tfQuantidade.text = "\(pickerQtd[rowQtd])"
            return pickerQtd.count
            
        }
        
        if pickerView == pickerViewDias {
            tfDuracao.text = "\(pickerDias[rowDias])"
            return pickerDias.count
        }
        
        
        return 0
        
        
    }

    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if pickerView ==  pickerViewQtd {
            rowQtd = row
            tfQuantidade.text = "\(pickerQtd[row])"
            
        }
        
        if pickerView == pickerViewDias {
            
            rowDias = row
            
            tfDuracao.text =  "\(pickerDias[row])"
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var titleData = ""
        
        if pickerView ==  pickerViewQtd {
            
            titleData = "\(pickerQtd[row])"
            
        }
        
        if pickerView == pickerViewDias {
            
             titleData =  "\(pickerDias[row])"
        }
        
        
        
        return NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "BloggerSans", size: 15.0)!,NSForegroundColorAttributeName:UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)])
        
        
    
    }
    
    // essa função remove a pickerView e a toolbar quando o usuario escolhe a opcao desejada
    
    func okPicker() {
        
        
        pickerViewQtd.removeFromSuperview()
        pickerViewDias.removeFromSuperview()
        toolBar.removeFromSuperview()
        tfQuantidade.resignFirstResponder()
        tfDuracao.resignFirstResponder()

        
    }
    
    
    
    //esconder pickerView quando o usuario clicar em qualquer parte da dela
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        pickerViewDias.hidden = true
        pickerViewQtd.hidden = true
        
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 6
        
        
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
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField.text?.isEmpty == false
        {
            if textField == tfNome
            {
                img1.image = checkSelected
            }
            else if textField == tfCelular
            {
                img2.image = checkSelected
            }
            else if textField == tfEmail
            {
                img3.image = checkSelected
            }
        }
        else
        {
            if textField == tfNome
            {
                img1.image = UIImage(named: "check-deselected")
            }
            else if textField == tfCelular
            {
                img2.image = UIImage(named: "check-deselected")
            }
            else if textField == tfEmail
            {
                img3.image = UIImage(named: "check-deselected")
            }
        }
    }
    
    @IBAction func solicitar(sender: AnyObject)
    {
        if (tfEmail.text?.isEmpty == true || tfNome.text?.isEmpty == true || tfCelular.text?.isEmpty == true)
        {
            presentViewController(PBCAlertController().alerta("Problema", mensagem: "Preencha todos os campos."), animated: true, completion: nil)
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
            else if isValidEmail(tfEmail.text!) == false
            {
                presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Email inválido."), animated: true, completion: nil)
            }
            else
            {
                let orcamento = PFObject(className: "Orcamento")
                
                PBCAnunciante().anunciante({ (success, anunciante) -> Void in
                    if success && anunciante != nil
                    {
                        orcamento["anunciante"] = anunciante
                        self.salvaOrcamento(orcamento)
                    }
                    else
                    {
                        self.salvaOrcamento(orcamento)
                    }
                })
            }
        }
    }
    
    func salvaOrcamento(orcamento:PFObject)
    {
        orcamento["nome"] = tfNome.text
        orcamento["telefone"] = tfCelular.text
        orcamento["email"] = tfEmail.text
        orcamento["carros"] = Int(tfQuantidade.text!)
        orcamento["meses"] = Int(tfDuracao.text!.substringToIndex(tfDuracao.text!.startIndex.advancedBy(2)))
        
        orcamento.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success
            {
                self.presentViewController(PBCAlertController().alerta("Orçamento Solicitado", mensagem: "Aguarde nosso contato!"), animated: true, completion: nil)
                self.tfNome.text = ""
                self.tfCelular.text = ""
                self.tfEmail.text = ""
                self.tfQuantidade.text = "10"
                self.tfDuracao.text = "30 dias"
                self.img1.image = UIImage(named: "check-deselected")
                self.img2.image = UIImage(named: "check-deselected")
                self.img3.image = UIImage(named: "check-deselected")
            }
            else
            {
                self.presentViewController(PBCAlertController().alerta("Problema", mensagem: "Ocorreu um problema com o envio do orçamento."), animated: true, completion: nil)
            }
        })

    }
    
    func isValidName(nome: String) -> Bool
    {
        return nome.rangeOfString("[A-Za-z]+", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func isValidEmail(email: String) -> Bool
    {
        return email.rangeOfString("([A-Za-z]+|[A-Za-z][A-Za-z0-9]*)@[A-Za-z]+.[A-Za-z]+", options:.RegularExpressionSearch) != nil ? true : false
    }
    
    func isValidCellphone(cellphone: String) -> Bool
    {
        return cellphone.rangeOfString("\\([0-9]{2}\\)\\ 9[0-9]{4}-[0-9]{4}", options:.RegularExpressionSearch) != nil ? true : false
    }
}