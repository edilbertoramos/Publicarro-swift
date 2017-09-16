
import UIKit
import Parse

class PBCVoucher: NSObject
{
    
    func VouchersAnuncio(feedback:(Bool, PFObject?, [PFObject]?, PFObject?) -> Void)
    {
        
        // Query Motorista
        let queryMotorista = PFQuery(className: "Motorista")
        
        // Query AnuncioMotorista
        let queryAM = PFQuery(className: "AnuncioMotorista")

        // Query Vouchers
        let queryVouchers = PFQuery(className: "Vouchers")
        
        // Query Anuncio
        let queryAnuncio = PFQuery(className: "Anuncio")


        // Query somente Motorista logado
        queryMotorista.whereKey("user", equalTo: PFUser.currentUser()!)
        
        queryMotorista.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
            if error == nil && motorista != nil
            {
                // Query somente do que o motorista participa
                queryAM.whereKey("motorista", equalTo: motorista!)
                
                // Query somente do AnuncioMotorista que está ativo
                queryAM.whereKey("ativo", equalTo: true)                
                
                queryAM.getFirstObjectInBackgroundWithBlock({ (AnuncioMotorista, errorAnuncioMotorista) -> Void in
                    if error == nil && AnuncioMotorista != nil
                    {
                        //Query somente do anúncio que o motorista participa
                        queryAnuncio.whereKey("objectId", equalTo: ((AnuncioMotorista!["anuncio"] as? PFObject)?.objectId)!)
                        queryAnuncio.includeKey("grafica")
                        queryAnuncio.includeKey("lavajato")
                        
                        queryAnuncio.getFirstObjectInBackgroundWithBlock({ (anuncio, errorAnuncio) -> Void in
                            if error == nil && anuncio != nil
                            {
                                // Query somente dos Vouchers do Anuncio que o motorista participa
                                queryVouchers.whereKey("AnuncioMotorista", equalTo: AnuncioMotorista!)
                                
                                queryVouchers.findObjectsInBackgroundWithBlock({ (vouchers, error) -> Void in
                                    if error == nil && vouchers != nil
                                    {
                                        // Lista de Vouchers com um objeto de Anuncio
                                        feedback(true, anuncio, vouchers!, motorista)
                                    } else {
                                        print("Erro na requisição de Vouchers")
                                        feedback(false,nil, [], nil)
                                    }
                                })
                            }
                            else
                            {
                                print("Erro na requisição de Anuncio")
                                feedback(false,nil, [], nil)

                            }

                        })
                    }
                    else
                    {
                        print("Erro na requisição de AnuncioMotorista")
                        feedback(false,nil,  [], nil)
                    }

                })
            } else
            {
                print("Erro na requisição de Motorista")
                feedback(false,nil, [], nil)
            }
        }
    }

    func criaVouchers(anuncioMotorista:PFObject)
    {
        for tipo in ["lavagem", "adesivagem", "retirada de adesivo", "recompensa"]
        {
            let voucher = PFObject(className: "Vouchers")
            voucher["AnuncioMotorista"] = anuncioMotorista
            voucher["tipo"] = tipo
            voucher["resgatado"] = false
            
            voucher.saveEventually()
        }
    }

}
