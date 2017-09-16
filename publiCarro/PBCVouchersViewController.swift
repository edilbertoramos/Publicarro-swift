
import UIKit
import Parse

class PBCVouchersViewController: UIViewController, UIPageViewControllerDataSource
{
    // MARK: - Oultlets
    
    @IBOutlet weak var lbFeedback: UILabel!
    
    private var pageViewController: UIPageViewController!
    private var contentImages:[UIImage] = []
    private var dadosVouchers:[PBCDadosVoucher] = []

    // MARK: - View
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        

    }

    override func viewWillAppear(animated: Bool)
    {
        lbFeedback.tag = 9090

        lbFeedback.hidden = true

        if PFUser.currentUser() != nil
        {
            criaVouchers()
        }
        else
        {
            removeSubViews()
            lbFeedback.hidden = false
            lbFeedback.text = "Voce precisa participar de uma campanha."
        }
    }
    
    // MARK: - Voucher
    func criaVouchers()
    {
        PBCVoucher().VouchersAnuncio { (success, anuncio, vouchers, motorista) -> Void in
            if success
            {
                if motorista!["ativado"] as! Bool
                {
                    self.dadosVouchers = []
                    for object in vouchers!
                    {
                        let tipo = object["tipo"] as! String
                        
                        let inicio : NSDate
                        let fim : NSDate
                        let endereco: String
                        let localizacao: CLLocationCoordinate2D
                        
                        if tipo == "lavagem"
                        {
                            inicio = anuncio!["inicioAdesivamento"] as! NSDate
                            fim = anuncio!["fimAdesivamento"] as! NSDate
                            
                            endereco = anuncio?.objectForKey("lavajato")!["endereco"] as! String
                            localizacao = CLLocationCoordinate2D.PBCConvertPFGeoPointToCLLocationCoordinate2D(anuncio?.objectForKey("lavajato")!["localizacao"] as! PFGeoPoint)

                            
                            self.dadosVouchers.append(PBCDadosVoucher(dataInicio: inicio, dataFim: fim, voucher: object, endereco: endereco, localizacao: localizacao))
                            
                        }
                        else if tipo == "adesivagem"
                        {
                            inicio = anuncio!["inicioAdesivamento"] as! NSDate
                            fim = anuncio!["fimAdesivamento"] as! NSDate
                            
                            endereco = anuncio?.objectForKey("grafica")!["endereco"] as! String
                            localizacao = CLLocationCoordinate2D.PBCConvertPFGeoPointToCLLocationCoordinate2D(anuncio?.objectForKey("grafica")!["localizacao"] as! PFGeoPoint)
                            
                            self.dadosVouchers.append(PBCDadosVoucher(dataInicio: inicio, dataFim: fim, voucher: object, endereco: endereco, localizacao:  localizacao))

                            
                        }
                        else if tipo == "retirada de adesivo"
                        {
                            inicio = anuncio!["inicioAnuncio"] as! NSDate
                            fim = anuncio!["fimAnuncio"] as! NSDate
                            
                            endereco = anuncio?.objectForKey("grafica")!["endereco"] as! String
                            localizacao = CLLocationCoordinate2D.PBCConvertPFGeoPointToCLLocationCoordinate2D(anuncio?.objectForKey("grafica")!["localizacao"] as! PFGeoPoint)

                            
                            self.dadosVouchers.append(PBCDadosVoucher(dataInicio: inicio, dataFim: fim, voucher: object, endereco: endereco, localizacao:  localizacao))

                            
                        }
                        else if tipo == "recompensa"
                        {
                            inicio = anuncio!["inicioRetirarAdesivo"] as! NSDate
                            fim = anuncio!["fimRetirarAdesivo"] as! NSDate
                            
                            self.dadosVouchers.append(PBCDadosVoucher(dataInicio: inicio, dataFim: fim, voucher: object, endereco: nil, localizacao:  nil))

                        }
                    }
                    if self.dadosVouchers.count == 0
                    {
                        self.lbFeedback.hidden = false
                        self.lbFeedback.text = "Voce precisa participar de uma campanha."

                    }
                    self.createPageViewController()

                }
                else
                {
                    self.removeSubViews()
                    print("Erro vouchers")
                    self.lbFeedback.hidden = false
                    self.lbFeedback.text = "Voce precisa participar de uma campanha."
                }
            }
            else
            {
                self.removeSubViews()
                self.lbFeedback.hidden = false
                self.lbFeedback.text = "Voce precisa participar de uma campanha."
            }
        }
    }
    
   // MARK: - Page View
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let itemController = viewController as! PBCVouchersPageItemController
        if itemController.itemIndex > 0
        {
            return getItemController(itemController.itemIndex!-1)
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let itemController = viewController as! PBCVouchersPageItemController

        if itemController.itemIndex!+1 < dadosVouchers.count
        {
            return getItemController(itemController.itemIndex!+1)
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return dadosVouchers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    private func createPageViewController()
    {
        removeSubViews()
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 50])
        pageViewController.dataSource = self
        
       
        if dadosVouchers.count > 0
        {
            pageViewController.setViewControllers([getItemController(0)!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
        
        pageViewController.view.frame = CGRectMake(0, 50, view.frame.width, view.frame.height-100)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
    }
    
    private func getItemController(itemIndex: Int) -> PBCVouchersPageItemController?
    {
        if itemIndex < dadosVouchers.count
        {
            let pageItemController = storyboard!.instantiateViewControllerWithIdentifier("contentVouchersController") as! PBCVouchersPageItemController
            
            let dados = dadosVouchers[itemIndex]
            
            pageItemController.itemIndex = itemIndex
            pageItemController.tipo = dados.voucher["tipo"] as! String
            pageItemController.resgatado = dados.voucher["resgatado"] as! Bool
            pageItemController.dateResgate = dados.voucher.objectForKey("dataResgate") as? NSDate
            pageItemController.id = dados.voucher.objectId!

            pageItemController.dataFim = dados.dataFim
            pageItemController.dataInicio = dados.dataInicio
            pageItemController.endereco = dados.endereco
            pageItemController.localizacao = dados.localizacao
            return pageItemController
        }
        return nil
    }
    
    func removeSubViews()
    {
        for subView in self.view.subviews
        {
            if subView.tag != 9090
            {
                subView.removeFromSuperview()
            }
        }

    }
}
