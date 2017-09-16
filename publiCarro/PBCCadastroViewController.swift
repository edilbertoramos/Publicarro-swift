
import UIKit

class PBCCadastroViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cadastrar(sender: AnyObject)
    {
        PBCMotorista().signUp(email: emailTextField.text!, password: passwordTextField.text!, cidade: "", celular: "") { (success, result) -> Void in
            if success
            {
                PBCMotorista().logIn(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (success, result) -> Void in
                    if success
                    {

                        self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("PBCTabBar"))!, animated: true, completion: nil)
                    }
                    else
                    {
                        self.presentViewController(PBCAlertController().problema(result), animated: true, completion: nil)
                    }
                }
            }
            else
            {
                self.presentViewController(PBCAlertController().problema(result), animated: true, completion: nil)
            }
        }
    }
}