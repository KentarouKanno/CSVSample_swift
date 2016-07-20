//
//  ListViewController.swift
//  CSVSample_swift
//
//  Created by KentarOu on 2016/01/23.
//  Copyright © 2016年 KentarOu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sectionTitle: Array<String> = []
    var sectionData : Array<Array<DataModel>> = [[]]
    var allDataArray: Array<DataModel> = []

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        APIManager.downloadCSVData { (isSuccess) in
            if isSuccess {
                let dataArray = CSVManager().generateCSVDataFromDocument()
                self.sectionTitle = dataArray.sectionTitle
                self.sectionData  = dataArray.sectionData
                self.allDataArray = dataArray.allDataArray
                
                self.listTableView.reloadData()
            }
        }
        
        if let selectIndex = listTableView.indexPathForSelectedRow {
            listTableView.deselectRowAtIndexPath(selectIndex, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionTitle.isEmpty {
            return ""
        }
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
