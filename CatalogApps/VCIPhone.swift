//
//  VCIPhone.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 23/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import QuartzCore

class VCIPhone: UIViewController {
    
    @IBOutlet weak var tvApps: UITableView!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    var _appsInfo: [AppInfo]? = nil
    var _categoria: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initTableView(tableView: self.tvApps)
        
        self.lblCategory.text = self._categoria?.capitalized

        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIDevice.current.model.lowercased().contains("iphone") {
            // To rotate and lock
            Global.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        } else {
            Global.AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // To reset when view is being removed
        Global.AppUtility.lockOrientation(.all)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Global.SEGUE_APP_DETAIL {
            
            let vcDet = segue.destination as! VCAppDetail
            
            vcDet.app = self._appsInfo?[(self.tvApps.indexPathForSelectedRow?.row)!]
        }
    }
    

}


extension VCIPhone: UITableViewDelegate, UITableViewDataSource {
    
    func initTableViewRowHeight(tableView: UITableView) {
        tableView.rowHeight = Global.ROW_HEIGHT_APPS_CELL
    }
    
    func initTableView(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]
        
        let identifier = "customAppCell"
        let myBundle = Bundle(for: VCIPhone.self)
        let nib = UINib(nibName: "CustomAppCell", bundle: myBundle)
        
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.allowsSelectionDuringEditing = true
        initTableViewRowHeight(tableView: tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        let array = self._appsInfo //self._categories
        if array != nil {
            if (array?.count)! > 0 {
                rows = (array?.count)!
            } else {
                rows = 0
            }
        } else {
            rows = 0
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "customAppCell"
        
        let cell: CustomAppCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! CustomAppCell
        
        let imageLayer: CALayer = cell.ivIcon.layer
        imageLayer.cornerRadius = Global.CORNER_RADIUS_FOR_ICON
        imageLayer.masksToBounds = true
        
        
        let app = self._appsInfo?[indexPath.row]
        
        cell.lblCategory.text = app?.category
        cell.lblIdn.text = app?.idn
        cell.lblTitle.text = app?.title
        
        if app?.iconurl != "" {
            cell.ivIcon.image = UIImage.init(data: (app?.icon)!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: Global.SEGUE_APP_DETAIL, sender: self)
    }
}
