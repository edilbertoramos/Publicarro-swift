
import UIKit
import Parse

class PBCAnunciosDisponiveisTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
    
{
    
    @IBOutlet weak var tableView: UITableView!
    
    //array de anúncios
    var anuncios : [PFObject] = []

    //auxilares de animação na table view
    private var lastContentOffset: CGFloat = 0
    private var directionAnimation: CGFloat = -1

    var isPresenting: Bool!
    var point: CGPoint!
    let animationDuration = 0.6
    
    override func viewDidLoad()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("presenteVoucher:"), name: "test", object: nil)
        super.viewDidLoad()
    }
    
    func presenteVoucher(notification: NSNotification)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
            self.tabBarController?.selectedIndex = 1
        })
    }

    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewWillAppear(animated: Bool)
    {
        self.tableView.hidden = true
        self.tabBarController?.tabBar.hidden = false
        if PFUser.currentUser() != nil
        {
            PBCMotorista().anuncios({ (success, objects) -> Void in
                if success
                {
                    self.anuncios = objects
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                    print("anuncios")
                }
                else
                {
                    print("erro anuncios")
                }
            })
        }
        else
        {
            let query = PFQuery(className: "Anuncio")
            query.whereKey("emAberto", equalTo: true)
            query.findObjectsInBackgroundWithBlock({ (anuncios, error) -> Void in
                if error == nil && anuncios != nil
                {
                    self.tableView.hidden = false
                    self.anuncios = anuncios!
                    self.tableView.reloadData()
                }
                else
                {
                    
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("anunciosTableViewCell") as! PBCAnunciosDisponiveisTableViewCell
        let object = anuncios[indexPath.row]
        
        
        //query
        let queryAnuncianteAnuncio = PFQuery(className: "AnuncianteAnuncio")
        queryAnuncianteAnuncio.whereKey("anuncio", equalTo: object)
        queryAnuncianteAnuncio.includeKey("anunciante")
        queryAnuncianteAnuncio.getFirstObjectInBackgroundWithBlock({ (anuncianteAnuncio, error) -> Void in
            if anuncianteAnuncio != nil
            {
                anuncianteAnuncio!["anunciante"].objectForKey("image")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
                    if error == nil && imageData != nil
                    {
                        cell.imageBusiness.setImage(UIImage(data:imageData!), forState:.Normal)
                        cell.imageBusiness.backgroundColor = UIColor.clearColor()
                    }
                }

            }
            else
            {
            }
        })
        
        //image
//        cell.activityIndicator.startAnimating()
        object.objectForKey("imagem")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil && imageData != nil
            {
//                cell.activityIndicator.stopAnimating()
//                cell.activityIndicator.hidesWhenStopped = true
                cell.imageAdvert.image = UIImage(data:imageData!)
            }
        }
        
        //attributes
        cell.nameBusiness.text = object["nome"] as? String
        let data = String.PBCConvertFromNSDateToString(object["inicioAdesivamento"] as! NSDate)
        cell.dateAvailable.text = "Disponível até: " + data.substringToIndex(data.startIndex.advancedBy(6))+data.substringFromIndex(data.startIndex.advancedBy(6)).capitalizedString
        cell.timeAdvertise.text = "Prazo da campanha: " + String(object["meses"].intValue*30) + " dias"
        //actions
        cell.btVisualizar.addTarget(self, action: "visualizarAction:", forControlEvents: .TouchUpInside)
        cell.imageAdvert.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        cell.imageAdvert.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    
    //botão visualizar
    func visualizarAction(sender: AnyObject)
    {
        let indexPath = indexPah(sender)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PBCAnunciosDisponiveisTableViewCell
        
        let tupla = [anuncios[indexPath.row], cell.imageAdvert.image!]

        performSegueWithIdentifier("segueDetalhesAnuncios", sender: tupla)

        
    }
    
    
    func indexPah(sender: AnyObject) -> NSIndexPath
    {
        let position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        return self.tableView.indexPathForRowAtPoint(position)!
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "segueDetalhesAnuncios"
        {
            let destination = segue.destinationViewController as? PBCDetalhesAnuncioTableViewController
            destination?.anuncio = sender?.objectAtIndex(0) as! PFObject
            destination?.imageSegue = sender?.objectAtIndex(1) as! UIImage
            destination?.previousSegueIndentifier = "participar"
            
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
        if(cell.layer.position.x != 0)
        {
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
 
    func scrollViewDidScroll(scrollView: UIScrollView) {
       
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
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = false;
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView();
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        toViewController!.view.frame = fromViewController!.view.frame
        if(self.isPresenting == true) {
            toViewController!.view.alpha = 0;
            toViewController!.view.transform = CGAffineTransformMakeScale(0, 0);
            
            
            
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.9, options: .TransitionNone, animations: { () -> Void in
                toViewController!.view.alpha = 1;
                toViewController!.view.transform = CGAffineTransformMakeScale(1, 1);
                containerView!.addSubview(toViewController!.view)
                }, completion: { (completed) -> Void in
                    transitionContext.completeTransition(completed)
            })
            
        } else {
            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.9, options: .TransitionNone, animations: { () -> Void in
                fromViewController!.view.alpha = 0;
                fromViewController!.view.transform = CGAffineTransformMakeScale(0.001, 0.0001);
                }, completion: { (completed) -> Void in
                    fromViewController?.view.removeFromSuperview()
                    transitionContext.completeTransition(completed)
                    
                    
            })
        }
    }
    
    //botão visualizar imagem do anúncio
    func imageTapped(sender: UITapGestureRecognizer)
    {
        let indexPath = indexPah(sender.view!)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PBCAnunciosDisponiveisTableViewCell
        
        print(cell.nameBusiness.text)
        print("Cliked in image")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let dvc : PBCImageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewImageAnuncio") as! PBCImageViewController
        
        
        PBCImageViewController.imageSelected = cell.imageAdvert.image
        
        dvc.transitioningDelegate = self
        dvc.modalPresentationStyle = UIModalPresentationStyle.Custom
        let currRect = self.tableView.rectForRowAtIndexPath(indexPath)
        
        self.point = CGPointMake(currRect.midX, currRect.midY)
        self.presentViewController(dvc, animated: true, completion: nil)
        
    }
}