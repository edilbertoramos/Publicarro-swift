//
//  PBCAnunciosAnuncianteTableViewCell.swift
//  publiCarro
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 13/01/16.
//  Copyright © 2016 tambatech. All rights reserved.
//

import UIKit

class PBCAnunciosAnuncianteTableViewCell: UITableViewCell
{

    
    @IBOutlet weak var imageViewAdvert: UIImageView!
    
    @IBOutlet weak var btBusiness: UIButton!
    
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var nameBusiness: UILabel!
    
    @IBOutlet weak var dateAvailable: UILabel!
    
    @IBOutlet weak var timeAdivertise: UILabel!
    
    @IBOutlet weak var btVisualizar: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        imageViewAdvert.layer.masksToBounds = true
        btBusiness.layer.masksToBounds = true
        detailsView.layer.masksToBounds = true
        imageViewAdvert.layer.cornerRadius = 8
        btBusiness.layer.cornerRadius = btBusiness.frame.size.width/2
        detailsView.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
