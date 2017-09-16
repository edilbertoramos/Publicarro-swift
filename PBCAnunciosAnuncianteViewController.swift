
import UIKit
import Parse

class PBCAnunciosAnuncianteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
 {

    @IBOutlet weak var tableView: UITableView!

    //array de anúncios
    var anuncios : [PFObject] = []
    var anunciante : PFObject?

    //auxilares de animação na table view
    private var lastContentOffset: CGFloat = 0
    private var directionAnimation: CGFloat = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.tableView.hidden = true
        self.tabBarController?.tabBar.hidden = false
        if PFUser.currentUser() != nil
        {
            PBCAnunciante().historico({ (success, objects, anunciante) -> Void in
                if success
                {
                    self.anuncios = objects
                    self.anunciante = anunciante
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                }
                else
                {
                    print("erro anuncios")
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return anuncios.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellAnunciosAnunciante") as! PBCAnunciosAnuncianteTableViewCell
        
        let object = anuncios[indexPath.row]
        
        
        anunciante!.objectForKey("image")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                    if error == nil && imageData != nil
                    {
                        cell
                        .btBusiness.setImage(UIImage(data:imageData!), forState:.Normal)
//                        cell.btBusiness.setBackgroundImage(UIImage(data:imageData!), forState:.Normal)
                        cell.btBusiness.backgroundColor = UIColor.whiteColor()
                    }
                    else
                    {
                }
            }
    
        
        //image
        //        cell.activityIndicator.startAnimating()
        object.objectForKey("imagem")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil && imageData != nil
            {
                //                cell.activityIndicator.stopAnimating()
                //                cell.activityIndicator.hidesWhenStopped = true
                cell.imageViewAdvert.image = UIImage(data:imageData!)
            }
        }
        
        //attributes
        cell.nameBusiness.text = object["nome"] as? String
        let data = String.PBCConvertFromNSDateToString(object["inicioAdesivamento"] as! NSDate)
        cell.dateAvailable.text = "Disponível até: " + data.substringToIndex(data.startIndex.advancedBy(6))+data.substringFromIndex(data.startIndex.advancedBy(6)).capitalizedString
        cell.timeAdivertise.text = "Prazo da campanha: " + String(object["meses"].intValue*30) + " dias"
        //actions
        cell.btVisualizar.addTarget(self, action: "visualizarAction:", forControlEvents: .TouchUpInside)
        cell.imageViewAdvert.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        cell.imageViewAdvert.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    //botão visualizar imagem do anúncio
    func imageTapped(sender: UITapGestureRecognizer)
    {
        let indexPath = indexPah(sender.view!)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PBCAnunciosAnuncianteTableViewCell
        
        print(cell.nameBusiness.text)
        print("Cliked in image")
        PBCImageViewController.imageSelected = cell.imageViewAdvert.image
//        
//        let controller = storyboard!.instantiateViewControllerWithIdentifier("ImageAnuncioView")
//        addChildViewController(controller)
//        UIView.transitionWithView(view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.view.addSubview(controller.view)}, completion: nil)
    }
    
    
    //botão visualizar
    func visualizarAction(sender: AnyObject)
    {
        print("Cliked in visualizar")

        let indexPath = indexPah(sender)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PBCAnunciosAnuncianteTableViewCell
        
        let tupla = [anuncios[indexPath.row], cell.imageViewAdvert.image!]
        
        performSegueWithIdentifier("SegueDetalhesAnunciosAnunciante", sender: tupla)
        
    }
    
    
    func indexPah(sender: AnyObject) -> NSIndexPath
    {
        let position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        return self.tableView.indexPathForRowAtPoint(position)!
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SegueDetalhesAnunciosAnunciante"
        {
            let destination = segue.destinationViewController as? PBCDetalhesAnunciosAnuncianteTableViewController
            
            destination?.anuncio = sender?.objectAtIndex(0) as! PFObject
            destination?.imageSegue = sender?.objectAtIndex(1) as! UIImage            
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        //1. Setup the CATransform3D structure
        var rotation:CATransform3D
        
        rotation = CATransform3DMakeRotation( 50*directionAnimation , 0.5, 0.7, 0.4);
        rotation.m34 = 5*directionAnimation/(600);
        
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        //!!!FIX for issue #1 Cell position wrong------------
        if(cell.layer.position.x != 0){
            cell.layer.position = CGPointMake(0, cell.layer.position.y);
        }
        
        //4. Define the final state (After the animation) and commit the animation
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.6)
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        UIView.commitAnimations()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        if self.lastContentOffset > scrollView.contentOffset.y
        {
            directionAnimation = 1
        }
        else
        {
            directionAnimation = -1
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
}
