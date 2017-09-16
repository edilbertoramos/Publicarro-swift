
import UIKit

class PBCAlertController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func alerta(titulo: String, mensagem: String) -> UIAlertController
    {
        let alertView = UIAlertController(title: titulo, message: mensagem, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        return alertView
    }
}