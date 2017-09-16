
import UIKit
import Parse
import SystemConfiguration

class PBCError: NSObject
{
    func codeErrorParse(error error: NSError) -> String
    {
        var text: String
        switch error.code
        {
            case PFErrorCode.ErrorObjectNotFound.rawValue:
                text = "Email ou senha incorretos."
                break
            case PFErrorCode.ErrorUsernameMissing.rawValue:
                text = "Preencha o email."
                break
            case PFErrorCode.ErrorUsernameTaken.rawValue:
                text = "Email já cadastrado."
                break
            case PFErrorCode.ErrorInvalidEmailAddress.rawValue:
                text = "Email inválido."
                break
            case PFErrorCode.ErrorConnectionFailed.rawValue:
                text = "Sem acesso a internet."
                break;
            case PFErrorCode.ErrorUserEmailMissing.rawValue:
                text = "Email em branco."
                break;
            case PFErrorCode.ErrorUserWithEmailNotFound.rawValue:
                text = "Email não cadastrado."
                break
            default:
                text = "Ocorreu um erro. ERRO = " + String(error.code)
        }
        return text
    }
    
    static func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress)
        {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}