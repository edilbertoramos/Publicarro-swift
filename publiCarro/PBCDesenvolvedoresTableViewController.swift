//
//  PBCDesenvolvedoresTableViewController.swift
//  publiCarro
//
//  Created by Eduarda Pinheiro on 27/01/16.
//  Copyright © 2016 tambatech. All rights reserved.
//

import UIKit

class PBCDesenvolvedoresTableViewController: UITableViewController {

    @IBOutlet weak var vwDiana: UIView!
    @IBOutlet weak var vwDuda: UIView!
    @IBOutlet weak var vwEdilberto: UIView!
    @IBOutlet weak var vwFelipe: UIView!
    @IBOutlet weak var vwLucio: UIView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwDiana.layer.cornerRadius = 8.0
        vwDuda.layer.cornerRadius = 8.0
        vwEdilberto.layer.cornerRadius = 8.0
        vwFelipe.layer.cornerRadius = 8.0
        vwLucio.layer.cornerRadius = 8.0
        
        
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()

    
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

   
}
