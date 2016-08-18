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
    var sectionData : Array<Array<DataBaseModel>> = [[]]
    var allDataArray: Array<DataBaseModel> = []
    var viewBackFlg : Bool = false

    @IBOutlet weak var listTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectIndex = listTableView.indexPathForSelectedRow {
            listTableView.deselectRowAtIndexPath(selectIndex, animated: true)
        }
        
        if viewBackFlg {
            viewBackFlg = false
            return
        }
        
        // CSV DownLoad Check
        APIManager.csvDownloadCheckAPI { (isDownload) -> () in
            
            if isDownload {
                
                // CSV DownLoad
                APIManager.downloadCSVData { (isSuccess) in
                    
                    if isSuccess {
                        self.loadDocumentCSVData()
                        
                    } else {
                        self.existDataCheck()
                    }
                }
                
            } else {
                self.existDataCheck()
            }
            
            /*
            if self.sectionTitle.isEmpty && CSVManager().CSVFileExistsAtPath() {
                // CSVダウンロード等で失敗した場合にもDocument Folderにデータが有れば表示する
                self.loadDocumentCSVData()
            }
            */
        }
    }
    
    func existDataCheck()  {
        // DataBaseにデータがあれば表示する
        if DataBaseManager.existData() {
            self.loadDocumentCSVData()
        }
    }
    
    func loadDocumentCSVData() {
        
        // DataBaseから読み込み
        let dataArray = DataBaseManager.readDataBase()
        
        // Documents CSVから読み込み
        //let dataArray = CSVManager().generateCSVDataFromDocument()
        
        self.sectionTitle = dataArray.sectionTitle
        self.sectionData  = dataArray.sectionData
        self.allDataArray = dataArray.allDataArray
        
        self.allDataArray.forEach { (value) in
            let imageV = UIImageView()
            imageV.sd_setImageWithURL(NSURL(string: value.eventImage)!)
        }
        
        self.listTableView.reloadData()
    }
    
    // MARK: - UITableView Delegate & DataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle.isEmpty ? "" : sectionTitle[section]
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
        // Cell Select → Detail View
        performSegueWithIdentifier("PushDetail", sender: selectDataFromIndexPath(indexPath))
    }
    
    func selectDataFromIndexPath(indexPath: NSIndexPath) -> DataBaseModel {
        return sectionData[indexPath.section][indexPath.row]
    }
    
    // MARK: - View Transition
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let detail = segue.destinationViewController as? DetailViewController {
            detail.allDataArray = allDataArray
            detail.data = sender as! DataBaseModel
            viewBackFlg = true
        }
    }
    
    // MARK: - Memory Warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



