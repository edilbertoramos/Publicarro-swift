
import UIKit
import Parse

class PBCShowMotoristasInAnuncioTableViewController: UITableViewController
{
    var motoristas: [PFObject] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return motoristas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellMotorista") as! PBCShowMotoristasInAnuncioTableViewCell
        
        cell.lbMotorista.text = String(motoristas[indexPath.row])
        
        return cell
    }
}