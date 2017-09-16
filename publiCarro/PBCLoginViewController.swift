
import UIKit
import Parse
import MediaPlayer
import AVKit

class ViewController: UIViewController
{
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    var player: AVPlayer!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let playerLayer: AVPlayerLayer
        let v  : UIView
        
        player = AVPlayer(URL: NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")!)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      
        v  = UIView(frame: self.view.frame)
        v.layer.addSublayer(playerLayer)
        
        self.view.insertSubview(v, atIndex: 0)
 
        player.play()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loopVideo" , name: AVPlayerItemDidPlayToEndTimeNotification, object: player)
    }
    
    func loopVideo() {
        player.play()
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logar(sender: AnyObject)
    {
        PBCMotorista().logIn(email: loginTextField.text!, password: senhaTextField.text!) { (success, result) -> Void in
            if success
            {
                print("login")
            self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("PBCTabBar"))!, animated: true, completion: nil)
            }
            else
            {
                self.presentViewController(PBCAlertController().problema(result), animated: true, completion: nil)
            }
        }
    }
}

