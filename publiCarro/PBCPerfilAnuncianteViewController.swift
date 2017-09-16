
import UIKit
import Parse

class PBCPerfilAnuncianteViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var lbEmail: UILabel!

    @IBOutlet weak var btSair: UIButton!
    @IBOutlet weak var btImagemPerfil: UIButton!
    
    @IBOutlet weak var viewBalao: UIView!
    
    let picker = UIImagePickerController()
    var imagePerfil = UIImage(named: "camera")
    
    var anunciante:PFObject?

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker.delegate = self
        
        btImagemPerfil.setImage(imagePerfil, forState: .Normal)
        
        btImagemPerfil.layer.cornerRadius = btImagemPerfil.frame.size.width/2
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if PFUser.currentUser() != nil
        {
            PBCAnunciante().anunciante({ (success, anunciante) -> Void in
                if success && anunciante != nil
                {
                    self.anunciante = anunciante
                    if anunciante!.objectForKey("image") != nil
                    {
                        if anunciante!.objectForKey("image")!.name.containsString("image.png")
                        {
                            anunciante!.objectForKey("image")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                                if error == nil && imageData != nil
                                {
                                    self.btImagemPerfil.setImage(UIImage(data:imageData!), forState: .Normal)
                                }
                            }
                        }
                    }
                    self.lbNome.text = "\(anunciante!["nome"])"
                }
                else
                {
                    self.lbNome.text = "Nome Indisponível"
                }
            })
            
            lbEmail.text = PFUser.currentUser()?.email
            
            viewBalao.hidden = false
            btSair.hidden = false
        }
        else
        {
            btSair.hidden = true
            viewBalao.hidden = true
        }
    }

    
    
    @IBAction func actionConfiguracoes(sender: AnyObject)
    {
        alertaEmDesenvolvimento()
    }
    
    
    @IBAction func actionContato(sender: AnyObject)
    {
        alertaEmDesenvolvimento()
    }
    
    
    @IBAction func actionTermosDeUso(sender: AnyObject)
    {
        alertaEmDesenvolvimento()
    }
    
    
    @IBAction func actionDesenvolvedores(sender: AnyObject)
    {
        performSegueWithIdentifier("SegueDesenvolvedoresAnunciante", sender: nil)
    }
    

    @IBAction func sair(sender: AnyObject)
    {
        let alertView = UIAlertController(title: "Sair", message: "Tem deseja que deja sair?", preferredStyle: .Alert)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        let sair = UIAlertAction(title: "Sair", style: .Default) { (action) -> Void in
            PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "anunciante")
                    AppDelegate().setColors(UIColor.PBCPinkColor, colorWithAplha: UIColor.PBCPinkColorWithAlpha)
                    for window in UIApplication.sharedApplication().windows
                    {
                        window.tintColor = UIColor.PBCPinkColor
                    }
                    self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("MotoristaTabBar") as! UITabBarController, animated: true, completion: nil)
                }
            })
        }
        
        alertView.addAction(cancelar)
        alertView.addAction(sair)
        
        presentViewController(alertView, animated: true, completion: nil)

    }


    @IBAction func actionImagemPerfil(sender: AnyObject)
    {
        //Cria um alerta do estilo Action Sheet
        let actionSheetCamera = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Opção de tirar foto
        let camera = UIAlertAction(title: "Tirar foto", style: .Default, handler: { (camera) -> Void in
            self.shootPhoto()
        })
        
        //Opção de selecionar foto
        let library = UIAlertAction(title: "Escolher foto", style: .Default, handler: { (camera) -> Void in
            self.photoFromLibrary()
        })
        
        //Opção de cancelar
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (cancel) -> Void in
//            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        if btImagemPerfil.imageView?.image != imagePerfil
        {
            //Opção de mostrar foto
            let removePhoto = UIAlertAction(title: "Apagar foto", style: .Destructive, handler: { (camera) -> Void in
                
                let imageFile = PFFile(name:"notImage", data:UIImageJPEGRepresentation(UIImage(named: "logo-empresa.png")!, 0.5)!)
                self.anunciante!["image"] = imageFile
                
                self.anunciante?.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success && error == nil
                    {
                        //Seta a imagem no botão.
                        self.btImagemPerfil.setImage(self.imagePerfil, forState: .Normal)
                    }
                })
                
            })
            actionSheetCamera.addAction(removePhoto)
        }
        
        //Adiciona opções ao Action Sheet
        actionSheetCamera.addAction(camera)
        actionSheetCamera.addAction(library)
        actionSheetCamera.addAction(cancel)
        
        self.presentViewController(actionSheetCamera, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func actionEditarPerfil(sender: AnyObject)
    {
    }
    
    //Acessa a câmera do iPhone
    func shootPhoto()
    {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker,
                animated: true,
                completion: nil)
        }
    }
    
    //Acessa a biblioteca de fotos do iPhone
    func photoFromLibrary()
    {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true,
            completion: nil)//4
    }
    
    //Recebe a imagem fotografada ou selecionada
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // Recebe a imagem da câmera
        let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        anunciante!["image"] = imageFile
        anunciante?.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success && error == nil
            {
                //Seta a imagem no botão.
                self.btImagemPerfil.setImage(image, forState: .Normal)
                //Remove ação da câmera
                
            }
            else
            {
                print("123")
            }
        })
        self.dismissViewControllerAnimated(true, completion: nil) //5
        
        
    }
    
    //Esconde a câmera
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.view.frame.size.height + 10
    }

    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y < 0
        {
            tableView.backgroundColor = UIColor.yellowColor()
        }
        else
        {
            tableView.backgroundColor = UIColor.PBCGrayColor
        }
    }
    func alertaEmDesenvolvimento()
    {
        self.presentViewController(PBCAlertController().alerta("Aviso", mensagem: "Esta funcionalidade ainda está em desenvolvimento"), animated: true, completion: nil)
    }

}
