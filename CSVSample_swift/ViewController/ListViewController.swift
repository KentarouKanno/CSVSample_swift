//
//  ListViewController.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/01/23.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionTitle = [String]()
    var sectionData  = [[DataModel]]()
    var allDataArray = [DataModel]()

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        let manager = CSVManager()
        let dataArray = manager.generateCSVDataFromDocument()
        
        sectionTitle = dataArray.sectionTitle
        sectionData  = dataArray.sectionData
        allDataArray = dataArray.allDataArray
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selectIndex = listTableView.indexPathForSelectedRow {
            listTableView.deselectRowAtIndexPath(selectIndex, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        let cellData = selectDataFromIndexPath(indexPath)
        cell.textLabel?.text = cellData.eraText
        cell.detailTextLabel?.text = cellData.eventText
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("PushDetail", sender: selectDataFromIndexPath(indexPath))
    }
    
    func selectDataFromIndexPath(indexPath: NSIndexPath) -> DataModel {
        return sectionData[indexPath.section][indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushDetail" {
            let detail = segue.destinationViewController as! DetailViewController
            detail.allDataArray = allDataArray
            detail.data = sender as! DataModel
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
