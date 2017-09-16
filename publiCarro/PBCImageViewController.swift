
import UIKit

class PBCImageViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    
    static var imageSelected:UIImage?
    override func viewWillDisappear(animated: Bool)
    {
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imageView.image = PBCImageViewController.imageSelected
        
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.imageView.addGestureRecognizer(panGestureRecognizer)
        
        //Swipe
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downtSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        upSwipe.direction = .Up
        downtSwipe.direction = .Down
        
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downtSwipe)
        
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer)
    {
        UIView.transitionWithView(view, duration: 1.0, options: UIViewAnimationOptions.ShowHideTransitionViews, animations: {self.dismissViewControllerAnimated(true , completion: nil)}, completion: nil)
    }

    func handlePan(sender: UIPanGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Ended){
            print("diss")
            self.dismissViewControllerAnimated(true , completion: nil);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func voltar(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        
        
    }
  }
