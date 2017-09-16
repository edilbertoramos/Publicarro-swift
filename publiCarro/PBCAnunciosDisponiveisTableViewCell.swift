
import UIKit

class PBCAnunciosDisponiveisTableViewCell:UITableViewCell
{

    @IBOutlet weak var btVisualizar: UIButton!
    
    @IBOutlet weak var timeAdvertise: UILabel!
    
    @IBOutlet weak var dateAvailable: UILabel!
    
    @IBOutlet weak var nameBusiness: UILabel!
    
    @IBOutlet weak var imageBusiness: UIButton!
    
    @IBOutlet weak var imageAdvert: UIImageView!
    
    
    @IBOutlet weak var detailsView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        imageAdvert.layer.masksToBounds = true
        imageBusiness.layer.masksToBounds = true
        detailsView.layer.masksToBounds = true
        imageAdvert.layer.cornerRadius = 8
        imageBusiness.layer.cornerRadius = imageBusiness.frame.size.width/2
        detailsView.layer.cornerRadius = 8
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    

}