
import UIKit
import Parse

class PBCMotorista: NSObject
{
    func motorista(feedback:(Bool,PFObject?) -> Void)
    {
        PFQuery(className: "Motorista").whereKey("user", equalTo: PFUser.currentUser()!).getFirstObjectInBackgroundWithBlock { (motorista, errorMotorista) -> Void in
            if motorista != nil && errorMotorista == nil
            {
                feedback(true, motorista)
            }
            else
            {
                feedback(false, nil)
            }
        }
    }
    
    func signUp(dadosMotorista: PBCDadosCadastroMotorista, feedback:(Bool, String, PFObject?) -> Void)
    {
       
 
        let user = PFUser()
        user.username = dadosMotorista.email
        user.email = dadosMotorista.email
        user.password = dadosMotorista.senha
        user.signUpInBackgroundWithBlock { (sucess, error) -> Void in
            if sucess
            {
                print("\nSavou usuário")
                let motorista = PFObject(className: "Motorista")
                motorista["user"] = user
                motorista["ativado"] = false
                motorista["participando"] = false
                motorista["taxista"] = dadosMotorista.taxista
                motorista["telefone"] = dadosMotorista.celular
                motorista["nome"] = dadosMotorista.nome
                
                
                //        motorista["pais"] = placemark?.country
                //        motorista["uf"] = placemark?.administrativeArea
                //        motorista["cidade"] = placemark?.locality
                //        motorista["cep"] = placemark?.postalCode
                //        motorista["bairro"] = placemark?.subLocality
                //        motorista["endereco"] = placemark?.thoroughfare

                
                motorista["localizacao"] = PFGeoPoint(
                    latitude: dadosMotorista.coordenada.latitude,
                    longitude: dadosMotorista.coordenada.longitude)
                motorista.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success
                    {
                        print("\nSavou Motorista")
                        let carro = PFObject(className: "Carro")
                        carro["motorista"] = motorista
                        carro["renavam"] = dadosMotorista.renavam
                        
                        carro.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success
                            {
                                print("\nSavou Carro")
                                feedback(true,"Completou o cadastro", motorista)
                            }
                            else
                            {
                                print("\nErro ao salvar carro: \(error)")
                                feedback(false,"Erro, tente novamente", nil)
                            }
                        })
                  }
                    else
                    {
                        print("\nSave Motorista Error: \(error)")
                        user.deleteEventually()
                        feedback(false,"Erro, tente novamente", nil)
                    }
                })
            }
            else
            {
                feedback(false,PBCError().codeErrorParse(error: error!), nil)
            }
        }
    }
    
    func logIn(feedbackLogin:(Bool) -> Void)
    {
        
        PFQuery(className: "Motorista").whereKey("user", equalTo: PFUser.currentUser()!).getFirstObjectInBackgroundWithBlock { (motorista, errorMotorista) -> Void in
            if motorista != nil && errorMotorista == nil
            {
                feedbackLogin(true)
            }
            else
            {
                feedbackLogin(false)
            }
        }
        
    }
    
    func anuncios(feedback:(Bool, [PFObject]) -> Void)
    {

        // Query Motorista
        let queryMotorista = PFQuery(className: "Motorista")
        
        // Query Anuncio
        let queryAnuncios = PFQuery(className: "Anuncio")

        // Query somente Motorista logado
        queryMotorista.whereKey("user", equalTo: PFUser.currentUser()!)
        queryMotorista.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
            if error == nil && motorista != nil
            {
                
                AppDelegate.motorista = motorista

                // Query AnuncioMotorista
                let queryAM = PFQuery(className: "AnuncioMotorista")
                
                // Query somente do que o motorista participa
                queryAM.whereKey("motorista", equalTo: motorista!)
                queryAM.findObjectsInBackgroundWithBlock({ (arrayCurrentAnuncioMotorista, error) -> Void in
                    if error == nil
                    {
                        // Recebe os objectId's dos anúncios que o motorista participa e não poderão ser exibidos
                        var arrayCurrentAnuncios : [String] = []
                        
                        // Objetos de AnuncioMotorista que o motorista participa
                        if let objectsNotAnuncioMotorista = arrayCurrentAnuncioMotorista
                        {
                            for object in objectsNotAnuncioMotorista
                            {
                                // Adiciona objectId de Anuncio's na lista de Anuncio que o motorista participa
                                arrayCurrentAnuncios.append(object["anuncio"].objectId!!)
                            }
                        }
                        
                        
                        // Query somente de Anuncio's que o motorista não participa
                        queryAnuncios.whereKey("objectId", notContainedIn: arrayCurrentAnuncios)
                        
                        // Query somente de Anuncio's em aberto
                        queryAnuncios.whereKey("emAberto", equalTo: true)
                        
                        queryAnuncios.orderByAscending("inicioAdesivamento")
                        
                        queryAnuncios.findObjectsInBackgroundWithBlock({ (arrayAnuncios, error) -> Void in
                            if error == nil
                            {
                                // Lista de Anuncio's
                                feedback(true, arrayAnuncios!)
                            } else {
                                print("Erro na requisição de Anuncios")
                                feedback(false, [])
                            }
                        })
                    }
                    else
                    {
                        print("Erro na requisição de AnuncioMotorista")
                        feedback(false, [])
                    }
                })
            } else
            {
                
                print("Erro na requisição de Motorista")
                feedback(false, [])
            }
        }
    }
    
    func myAnuncios(feedback:(Bool, [PFObject]) -> Void)
    {
        if PFUser.currentUser() != nil
        {
            // Query Motorista
            let queryMotorista = PFQuery(className: "Motorista")
            
            // Query somente Motorista logado
            queryMotorista.whereKey("user", equalTo: PFUser.currentUser()!)
            queryMotorista.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
                if error == nil
                {
                    // Query AnuncioMotorista
                    let queryAM = PFQuery(className: "AnuncioMotorista")
                    
                    // Query somente do que o motorista participa
                    queryAM.whereKey("motorista", equalTo: motorista!)
                    queryAM.findObjectsInBackgroundWithBlock({ (arrayAnuncioMotorista, error) -> Void in
                        if error == nil
                        {
                            // Recebe os objectId's dos anúncios que o motorista participa
                            var arrayAnuncios : [String] = []
                            
                            // Objetos de AnuncioMotorista que o motorista participa
                            if let objectsAnuncioMotorista = arrayAnuncioMotorista
                            {
                                for object in objectsAnuncioMotorista
                                {
                                    // Adiciona objectId de Anuncio's na lista de Anuncio que o motorista participa
                                    
                                    arrayAnuncios.append(object["anuncio"].objectId!!)
                                }
                            }
                            
                            // Query Anuncio
                            let queryAnuncios = PFQuery(className: "Anuncio")
                            
                            // Query somente de Anuncio's que o motorista participa
                            queryAnuncios.whereKey("objectId", containedIn: arrayAnuncios)
                            
                            queryAnuncios.findObjectsInBackgroundWithBlock({ (arrayAnuncios, error) -> Void in
                                if error == nil
                                {
                                    // Lista de Anuncio's
                                    feedback(true, arrayAnuncios!)
                                } else {
                                    print("Erro na requisição de Anuncios")
                                    feedback(false, [])
                                }
                            })
                        } else
                        {
                            print("Erro na requisição de AnuncioMotorista")
                            feedback(false, [])
                        }
                    })
                } else
                {
                    print("Erro na requisição de Motorista")
                    feedback(false, [])
                }
            }
        }
        
    }
    
    func cancelarCampanha(anuncio: PFObject, motorista: PFObject, feedback:(Bool, String) -> Void)
    {
        print("Cancelar")
        
        
        // Query AnuncioMotorista
        let queryAM = PFQuery(className: "AnuncioMotorista")
        
        // Query somente do que o motorista participa
        queryAM.whereKey("motorista", equalTo: motorista)
        
        //Query de todos os objetos
        queryAM.findObjectsInBackgroundWithBlock { (tamanho, errorGet) -> Void in
            if errorGet == nil
            {
                
                // Query somente deste anúncio
                queryAM.whereKey("anuncio", equalTo: anuncio)
                
                // Query do objeto a ser excluído
                queryAM.getFirstObjectInBackgroundWithBlock({ (AnuncioMotorista, errorGet) -> Void in
                    if errorGet == nil
                    {
                        
                        // Deleta o objeto AnuncioMotorista
                        AnuncioMotorista?.deleteInBackgroundWithBlock({ (deleteAnuncioMotorista, delete) -> Void in
                            
                            if deleteAnuncioMotorista
                            {
                                anuncio.incrementKey("vagas")
                                
                                anuncio.saveEventually()
                                
                                // Se o motorista pertence a somente uma campanha, a participação será alterado para false
                                if tamanho?.count == 1
                                {
                                    motorista["participando"] = false
                                    motorista.saveEventually()
                                }
                                
                                feedback(true, "Você saiu da campanha")

                            } else
                            {
                                feedback(false, "Erro, tente novamente")
  
                            }
                            
                        })
                        
                    } else
                    {
                        feedback(false, "Erro, tente novamente")
                        print(errorGet)
                    }
                })
                
            } else
            {
                feedback(false, "Erro, tente novamente")
                print(errorGet)
            }
            
        }
        
    }
    func participarCampanha(anuncio: PFObject, motorista: PFObject, feedback:(Bool, String) -> Void)
    {
        // verifica se o cadastro do motorista foi aceito
        if motorista["ativado"] as! Bool
        {
            // verifica se o motorista já participa de um anúncio
            if motorista["participando"] as! Bool
            {
                feedback(false,"Você já está participando de uma campanha.")
            }
            else
            {
                let queryAnuncioMotorista = PFQuery(className: "AnuncioMotorista")

                // Faz requisição da tabela que une Anuncio e Motorista
                // Procurando se já existe um vínculo entre o Anuncio e o Motorista
                queryAnuncioMotorista.whereKey("motorista", equalTo: motorista)
                queryAnuncioMotorista.whereKey("anuncio", equalTo: anuncio)
                queryAnuncioMotorista.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    if error == nil
                    {
                        // se não achar nenhum objeto, confirma que realmente não há nenhum vínculo entre esses objetos
                        if objects == nil ||  objects!.count == 0
                        {
                            // verifica se ainda há vagas na Campanha
                            if (anuncio["vagas"] as! Int) > 0
                            {
                                self.salvarParticipacao(anuncio, motorista: motorista, feedbackSave: { (saved) -> Void in
                                    if saved
                                    {
                                        feedback(true,"Você foi aceito na campanha.")
                                    } else
                                    {
                                        feedback(false,"Erro, tente novamente.")
                                    }
                                })
                            }
                            else
                            {
                                feedback(false,"Não há mais vaga nesta campanha.")
                            }
                        }
                        else
                        {
                            // o motorista já está participando do anúncio, mas houve um erro ao atualizar seu status
                            feedback(false,"Você já está participando dessa campanha.")
                            motorista["participando"] = true
                            motorista.saveEventually()
                        }
                    }
                    else
                    {
                        feedback(false,"Erro, tente novamente.")
                    }
                })
            }
        }
        else
        {
            feedback(false, "Você está inativo, aguarde o publicarro ativar sua conta de motorista.")
        }

    }

    func salvarParticipacao(anuncio: PFObject, motorista: PFObject, feedbackSave:(Bool) -> Void)
    {
        let objectAnuncioMotorista = PFObject(className: "AnuncioMotorista")
        
        objectAnuncioMotorista["anuncio"] = anuncio
        objectAnuncioMotorista["motorista"] = motorista
        objectAnuncioMotorista["ativo"] = true
        
        objectAnuncioMotorista.saveInBackgroundWithBlock { (success, error) -> Void in
            if success && error == nil
            {
                print("salvou anuncio motorista")
                
                motorista["participando"] = true
                
                anuncio.incrementKey("vagas", byAmount: -1)
                
                motorista.saveEventually()
                anuncio.saveEventually()
                
                PBCVoucher().criaVouchers(objectAnuncioMotorista)

                feedbackSave(true)
            }
            else
            {
                feedbackSave(false)
                print("Erro ao salvar Anuncio")
            }
        }
        
    }

    
    // Comparando datas
    func menorIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970}
    
    func maiorIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970}
    
    func maior(lhs: NSDate, rhs: NSDate) -> Bool
    {
        print("\(lhs) > \(rhs)")
        return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
    }
    
    func menor(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970}
    
    func igual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970}

}