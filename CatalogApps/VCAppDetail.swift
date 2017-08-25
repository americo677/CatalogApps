//
//  VCAppDetail.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 24/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import QuartzCore

class VCAppDetail: UIViewController {

    
    @IBOutlet weak var vHeader: UIView!
    
    @IBOutlet weak var ivAppIcon: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var tvDescription: UITextView!
    
    var app: AppInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let imageLayer: CALayer = self.ivAppIcon.layer
        imageLayer.cornerRadius = Global.CORNER_RADIUS_FOR_ICON
        imageLayer.masksToBounds = true
        
        if self.app != nil {
            self.showAppInfo(app: self.app!)
        }
        
        self.navigationController?.title = "App details"
        
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

    func showAppInfo(app: AppInfo) {
        if app.iconurl != "" {
            let icon: Data = app.icon!
            self.ivAppIcon.image = UIImage.init(data: icon)
        }
        
        self.lblTitle.text = app.title
        self.lblHeaderTitle.text = app.headerTitle
        self.lblCategory.text = app.category
        self.tvDescription.text = app.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
