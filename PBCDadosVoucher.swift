import UIKit
import CoreLocation
import Parse

class PBCDadosVoucher
{
    var dataInicio:NSDate!
    var dataFim: NSDate!
    var endereco:String!
    var localizacao: CLLocationCoordinate2D!
    var voucher: PFObject!
    
    init(dataInicio:NSDate, dataFim: NSDate, voucher:PFObject, endereco:String?, localizacao:CLLocationCoordinate2D?)
    {
        self.dataInicio = dataInicio
        self.dataFim = dataFim
        self.voucher = voucher
        self.localizacao = localizacao
        self.endereco = endereco
    }
    
    
}

