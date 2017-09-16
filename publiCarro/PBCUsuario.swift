
import UIKit
import Parse
class PBCUsuario{

    let erro = 0
    let motorista = 1
    let anunciante = 2
    
    func tipoUsuario(usuario:(Int) -> Void)
    {
        if PFUser.currentUser() != nil
        {
            PBCMotorista().logIn({ (isMotorista) -> Void in
                if isMotorista
                {
                    usuario(self.motorista)
                }
                else
                {
                    PBCAnunciante().logIn({ (isAnunciante) -> Void in
                        if isAnunciante
                        {
                            usuario(self.anunciante)
                        }
                        else
                        {
                            usuario(self.erro)
                        }
                    })
                }
            })
        }
        else
        {
            usuario(self.erro)
        }
    }
}
