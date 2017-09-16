
import UIKit
import Parse

class PBCAnunciante: NSObject
{
    func anunciante(feedback:(Bool,PFObject?) -> Void)
    {
        if PFUser.currentUser() != nil
        {
            PFQuery(className: "Anunciante").whereKey("user", equalTo: PFUser.currentUser()!).getFirstObjectInBackgroundWithBlock { (anunciante, errorAnunciante) -> Void in
                if anunciante != nil && errorAnunciante == nil
                {
                    feedback(true, anunciante)
                }
                else
                {
                    feedback(false, nil)
                }
            }
        }
        feedback(false, nil)
    }

    func orcamento(nome nome: String, email: String, telefone: String, carros:String, meses:String, feedback:(Bool, String) -> Void)
    {
        let orcamento = PFObject(className: "Orcamento")
        orcamento["nome"] = nome
        orcamento["telefone"] = telefone
        orcamento["email"] = email
        orcamento["carros"] = Int(carros)
        orcamento["meses"] = Int(meses)
        orcamento.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success
            {
                feedback(true, "Salvou")
            }
            else
            {
                feedback(false,PBCError().codeErrorParse(error: error!))
            }
        })
    }
    
    func historico(feedback: (Bool, [PFObject], PFObject?) -> Void)
    {
        let queryAnunciante = PFQuery(className: "Anunciante")
        queryAnunciante.whereKey("user", equalTo: PFUser.currentUser()!)
        queryAnunciante.getFirstObjectInBackgroundWithBlock { (anunciante, error) -> Void in
            if anunciante != nil && error == nil
            {
                let queryAnuncianteAnuncio = PFQuery(className: "AnuncianteAnuncio")
                queryAnuncianteAnuncio.whereKey("anunciante", equalTo: anunciante!)
                queryAnuncianteAnuncio.includeKey("anuncio")
                queryAnuncianteAnuncio.findObjectsInBackgroundWithBlock({ (anuncianteAnuncio, error) -> Void in
                    if anuncianteAnuncio != nil && error == nil
                    {
                        var anuncios: [PFObject] = []
                        for object in anuncianteAnuncio!
                        {
                            anuncios.append(object["anuncio"] as! PFObject)
                        }
                        feedback(true,anuncios, anunciante!)
                    }
                    else
                    {
                        feedback(false, [], anunciante)
                    }
                })
            }
            else
            {
               feedback(false, [], nil)
            }
        }
    }
    
    func signUp(email email: String, password: String, cidade: String, celular: String, feedback:(Bool, String) -> Void)
    {
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        user.signUpInBackgroundWithBlock { (sucess, error) -> Void in
            if sucess
            {
                print("\nSave User Sucess")
                let motorista = PFObject(className: "Motorista")
                motorista["user"] = user
                motorista["ativado"] = false
                motorista.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success
                    {
                        print("\nSave Motorista Sucess")
                        let carro = PFObject(className: "Carro")
                        carro["motorista"] = motorista
                        carro.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success
                            {
                                print("\nSave Carro Sucess")
                                
                                feedback(true,"Logou")
                            
                            }
                            else
                            {
                                print("\nSave Carro Error: \(error)")
                                motorista.deleteEventually()
                                user.deleteEventually()
                                feedback(false,"Algum erro")
                            }
                        })
                    }
                    else
                    {
                        print("\nSave Motorista Error: \(error)")
                        user.deleteEventually()
                        feedback(false,"Algum erro")
                    }
                })
            }
            else
            {
                feedback(false,PBCError().codeErrorParse(error: error!))
            }
        }
    }
    
    func logIn(feedbackLogin:Bool -> Void)
    {
        
        PFQuery(className: "Anunciante").whereKey("user", equalTo: PFUser.currentUser()!).getFirstObjectInBackgroundWithBlock { (anunciante, errorAnunciante) -> Void in
            if anunciante != nil && errorAnunciante == nil
            {
                feedbackLogin(true)
            }
            else
            {
                feedbackLogin(false)
            }
        }
        
    }
    
    func motoristas(anuncio:PFObject, feedback:(Bool, [PFObject]) -> Void)
    {
        // Query AnuncioMotorista
        let queryAM = PFQuery(className: "AnuncioMotorista")
        
        // Query somente do que o anuncio participa
        queryAM.whereKey("anuncio", equalTo: anuncio)
        queryAM.includeKey("motorista")
        queryAM.findObjectsInBackgroundWithBlock({ (arrayCurrentAnuncioMotorista, error) -> Void in
            if error == nil
            {
                // Recebe os motoristas que participam do anúncio
                var arrayMotorista : [PFObject] = []
                
                // Objetos de AnuncioMotorista que o anúncio participa
                if let objectsAnuncioMotorista = arrayCurrentAnuncioMotorista
                {
                    for object in objectsAnuncioMotorista
                    {
                        // Adiciona objectId de Anuncio's na lista de Anuncio que o motorista participa
                        arrayMotorista.append(object["motorista"] as! PFObject)
                    }
                    feedback(true, arrayMotorista)
                }
                            }
            else
            {
                print("Erro query AnuncioMotorista")
                feedback(false, [])
            }
        })    }

}