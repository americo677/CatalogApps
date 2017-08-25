//
//  VCIPad.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 23/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import QuartzCore

class VCIPad: UIViewController {

    
    @IBOutlet weak var cvApps: UICollectionView!
    
    var _appsInfo: [AppInfo]? = nil
    var _categoria: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initCollectionView(collectionView: self.cvApps)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // To rotate and lock
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
            
            if let cell = sender as? UICollectionViewCell {
                let indexPath = self.cvApps.indexPath(for: cell)
                
                let vcDet = segue.destination as! VCAppDetail
                
                vcDet.app = self._appsInfo?[(indexPath?.row)!]
                
            }
        }
        
    }
 

}

extension VCIPad: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView(collectionView: UICollectionView) {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame = self.view.bounds
        collectionView.autoresizingMask = [.flexibleWidth]
        
        //let identifier = "customAppCell"
        //let myBundle = Bundle(for: VCIPhone.self)
        //let nib = UINib(nibName: "CustomAppCell", bundle: myBundle)
        
        //tableView.register(nib, forCellReuseIdentifier: identifier)
        
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        
        //initTableViewRowHeight(tableView: tableView)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items: Int = 0
        if self._appsInfo != nil {
            items = (self._appsInfo?.count)!
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "customCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        let ivIcon: UIImageView = cell.viewWithTag(1) as! UIImageView
        
        let imageLayer: CALayer = ivIcon.layer
        imageLayer.cornerRadius = Global.CORNER_RADIUS_FOR_ICON
        imageLayer.masksToBounds = true
        
        
        let lblTitle: UILabel = cell.viewWithTag(2) as! UILabel
        let lblCategory: UILabel = cell.viewWithTag(3) as! UILabel
        
        let app = self._appsInfo?[indexPath.row]
        
        
        if app?.iconurl != "" {
            ivIcon.image = UIImage.init(data: (app?.icon)!)
        }
        
        lblTitle.text = app?.title
        lblCategory.text = app?.category
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            self.performSegue(withIdentifier: Global.SEGUE_APP_DETAIL, sender: cell)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
        
    }
    
}
