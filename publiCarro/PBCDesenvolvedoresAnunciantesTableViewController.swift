//
//  PBCDesenvolvedoresAnunciantesTableViewController.swift
//  publiCarro
//
//  Created by Eduarda Pinheiro on 27/01/16.
//  Copyright © 2016 tambatech. All rights reserved.
//

import UIKit

class PBCDesenvolvedoresAnunciantesTableViewController: UITableViewController {
    
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
