
import UIKit
import Parse

class PBCDetalhesAnunciosAnuncianteTableViewController: UITableViewController
{
    var anuncio: PFObject!
    var motoristas: [PFObject] = []
    var imageSegue: UIImage!
        
    @IBOutlet weak var imageViewAdvert: UIImageView!
    
    @IBOutlet weak var lbDuracao: UILabel!
    @IBOutlet weak var lbLancamento: UILabel!
    @IBOutlet weak var lbAderencia: UILabel!
    @IBOutlet weak var lbCarros: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lbLancamento.text = String.PBCConvertToStringNumber(anuncio["inicioAnuncio"] as! NSDate)
        lbAderencia.text = String.PBCConvertToStringNumber(anuncio["fimAdesivamento"] as! NSDate)
        lbCarros.text = anuncio["carros"].stringValue
        lbDuracao.text = String("\((anuncio["meses"] as!Int)*30) dias")
        
        self.navigationItem.title = ("\(anuncio["nome"])")

        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        imageViewAdvert.image = imageSegue
        PBCAnunciante().motoristas(anuncio, feedback: { (success, motoristas) -> Void in
            
            if success
            {
                self.motoristas = motoristas
            }
            else
            {
                print("erro motoristas")
            }
        })

    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "SegueRastreamentoAnuncio"
        {
            let destination = segue.destinationViewController as? PBCMapaAnuncianteViewController
            destination?.motoristas = motoristas
            destination?.anuncio = anuncio
        }
        
        if segue.identifier == "SegueShowMotoristasInAnuncio"
        {
            let destination = segue.destinationViewController as? PBCShowMotoristasInAnuncioTableViewController
            destination?.motoristas = motoristas
        }
        
    }

}
