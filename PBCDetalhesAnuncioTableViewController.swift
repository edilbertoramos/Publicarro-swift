
import UIKit
import Parse

class PBCDetalhesAnuncioTableViewController: UITableViewController
{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lbStartAdvert: UILabel!
    @IBOutlet weak var lbEndAdvert: UILabel!
    @IBOutlet weak var lbTimeAdvert: UILabel!
    @IBOutlet weak var lbSpaceAvaliableAdvert: UILabel!
    
    @IBOutlet weak var btAceitarTermosUso: UIButton!
    @IBOutlet weak var btAdesivar: UIButton!
    
    var queryMotorista = PFQuery(className: "Motorista")
    var anuncio: PFObject!
    var imageSegue: UIImage!
    var previousSegueIndentifier:String = ""
    
    var aceitarTermos = false
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        
        btAdesivar.layer.masksToBounds = true
        btAdesivar.layer.cornerRadius = 5
        
        btAceitarTermosUso.layer.masksToBounds = true
        btAceitarTermosUso.layer.cornerRadius = 6
        btAceitarTermosUso.layer.borderWidth = 2
        btAceitarTermosUso.layer.borderColor = UIColor.PBCPinkColor.CGColor
        btAceitarTermosUso.backgroundColor = UIColor.whiteColor()
        print(previousSegueIndentifier)
        
        image.image = imageSegue
        lbStartAdvert.text = String.PBCConvertToStringNumber(anuncio["inicioAnuncio"] as! NSDate)
        lbEndAdvert.text = String.PBCConvertToStringNumber(anuncio["fimAdesivamento"] as! NSDate)
        lbSpaceAvaliableAdvert.text = anuncio["vagas"].stringValue
        lbTimeAdvert.text = String("\((anuncio["meses"] as!Int)*30) dias")

        let label = UILabel(frame: CGRectMake(0, 0, 32, 32))
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "BloggerSans-Medium", size: 20)
        label.textColor = UIColor.PBCPinkColor
        label.text = anuncio["nome"] as? String
        navigationItem.titleView = label
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.tabBarController?.tabBar.hidden = true

        if let user  = PFUser.currentUser()
        {
            queryMotorista.whereKey("user", equalTo: user)
            
            if  previousSegueIndentifier == "participar"
            {
                btAdesivar.setTitle("Quero adesivar meu carro!", forState: .Normal)
            } else
            {
                btAdesivar.setTitle("Cancelar Participação!", forState: .Normal)
            }
        }
        else
        {
            btAdesivar.setTitle("Quero adesivar meu carro!", forState: .Normal)
        }
        
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    @IBAction func adesivarAction(sender: AnyObject)
    {
        performSelector(Selector(previousSegueIndentifier))
    }
    
    @IBAction func aceitarTermosDaCampanha(sender: AnyObject)
    {
        if !aceitarTermos
        {
        btAceitarTermosUso.setImage(UIImage(named: "check-selected.png"), forState: .Normal)
            aceitarTermos = true
        }
        else
        {
            btAceitarTermosUso.setImage(nil, forState: .Normal)
            aceitarTermos = false
        }
    }

    func participar()
    {
        print("Participar")
        if PFUser.currentUser() != nil
        {
            if aceitarTermos
            {
            queryMotorista.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
                if motorista != nil
                {
                    PBCMotorista().participarCampanha(self.anuncio, motorista: motorista!) { (success, result) -> Void in
                        
                        if success
                        {
                            print(result)
                            let alertVieww = UIAlertController(title: "Sucesso!", message: result, preferredStyle: .Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in

                                NSNotificationCenter.defaultCenter().postNotificationName("test", object: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                            alertVieww.addAction(okAction)
                            
                            self.presentViewController(alertVieww, animated: true, completion: nil)
                        }
                        else
                        {
                            self.presentViewController(self.alerta("Aviso", mensagem: result), animated: true, completion: nil)
                        }
                    }
                } 
            }
            }
            else
            {
                self.presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Você precisa aceitar os Termos"), animated: true, completion: nil)
            }
        }
        else
        {
            print("Você precisa fazer login")
            btAceitarTermosUso.setImage(nil, forState: .Normal)
            aceitarTermos = false
            performSegueWithIdentifier("SegueAnuncioLogin", sender: nil)
        }
    }
    func cancelar()
    {
        print("Cancelar")
        queryMotorista.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
            if motorista != nil
            {
                PBCMotorista().cancelarCampanha(self.anuncio, motorista: motorista!) { (success, result) -> Void in
                    
                    if success
                    {
                        print(result)
                    }
                    else
                    {
                        print(result)
                    }
                    
                }
            }
        }
    }
    
    func alerta(titulo: String, mensagem: String) -> UIAlertController
    {
    
        let alertView = UIAlertController(title: titulo, message: mensagem, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            self.btAceitarTermosUso.setImage(nil, forState: .Normal)
            self.aceitarTermos = false
        }
        alertView.addAction(okAction)
        return alertView
    }
}
