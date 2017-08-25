//
//  VCCategories.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 22/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import UIKit

class VCCategories: UIViewController {
    
    @IBOutlet weak var tvCategories: UITableView!
    
    @IBOutlet weak var ivSignal: UIImageView!
    
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    var isOnline: Bool = true
    
    var _appsInfo = [AppInfo]()
    
    var _categories = [String]()
    

    func initCategories(apps: [AppInfo]? ) {
        var cat = [String]()
        for item in apps! {
            if item.category != "" {
                if !cat.contains(item.category) {
                    cat.append(item.category)
                }
            } else if !cat.contains(Global.NO_CATEGORY) {
                cat.append(Global.NO_CATEGORY)
            }
        }
        
        self._categories = cat.sorted(by: { $0 < $1 })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initTableView(tableView: self.tvCategories)
        
        //let sqllite = getPath("DBCatalogApps.sqlite")
        //print("db: \(sqllite)")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
        
        self.checkReachability()
        
        self.getData()
        
        self.navigationController?.isToolbarHidden = false
        
    }
    

    func appInfoCopy(from coredataset: [AnyObject], to apps: inout [AppInfo]) {
        apps.removeAll()
        for item in coredataset {
            let appData = item as! CDAppInfo
            
            let app = AppInfo()
            
            app._idn = appData.idn
            app._title = appData.title
            app._headerTitle = appData.headerTitle
            app._iconurl = appData.imageurl
            if app.iconurl != "" {
                app._icon = appData.image! as Data
            }
            app._description = appData.detail
            app._category = appData.category
            
            apps.append(app)
            
        }
    }
    
    func getData() {
        if self.isOnline {
            // get data from internet
            
            APILib().downloadAPINative(completed: {
                apps -> Void in
                
                self._appsInfo = apps!
                
                self.initCategories(apps: self._appsInfo)
                
                self.tvCategories.reloadData()
            })
            
            /*APILib().downloadAPI(completed: {
             apps -> Void in
             
             self._appsInfo = apps!
             
             self.initCategories(apps: self._appsInfo)
             
             self.tvCategories.reloadData()
             })
             */
            print("data is recovery from internet")
        } else {
            // get data from storage
            
            let objects = APILib().fetchAppInfoBy()
            
            self.appInfoCopy(from: objects!, to: &self._appsInfo)
            
            self.initCategories(apps: self._appsInfo)
            
            self.tvCategories.reloadData()
            
            print("data is recovery from local storage")
        }
        
        
        
    }

    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        checkReachability()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIDevice.current.model.lowercased().contains("iphone") {
            // To rotate and lock
            Global.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        } else {
            Global.AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        }
    
        self.tvCategories.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // To reset when view is being removed
        Global.AppUtility.lockOrientation(.all)
    }

    func checkReachability() {
        guard let r = reachability else { return }
        if r.isReachable  {
            self.ivSignal.image = UIImage.init(named: "signal")
            self.isOnline = true
            print("We are online ;)")
        } else {
            self.ivSignal.image = UIImage.init(named: "nosignal")
            self.isOnline = false
            print("We are offline :(")
            self.showCustomAlert(self, titleApp: "CatalogApps Network Notice", strMensaje: "The device has lost internet connection.  However we are going to work offline.", toFocus: nil)
        }
    }

    func reachabilityDidChange(_ notification: Notification) {
        checkReachability()
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let categoriaSeleccionada = ((self.tvCategories.cellForRow(at: self.tvCategories.indexPathForSelectedRow!)) as! CustomCategoryCell).lblCategory.text?.lowercased()
        
        if segue.identifier == Global.SEGUE_IPHONE {
            let vcIPhone = segue.destination as! VCIPhone
            
            vcIPhone._categoria = categoriaSeleccionada
            
            vcIPhone._appsInfo = self._appsInfo.filter({ ($0 as AppInfo).category.lowercased() == categoriaSeleccionada!})

            
        } else if segue.identifier == Global.SEGUE_IPAD {
            let vcIPad = segue.destination as! VCIPad

            vcIPad._categoria = categoriaSeleccionada
            
            vcIPad._appsInfo = self._appsInfo.filter({ ($0 as AppInfo).category.lowercased() == categoriaSeleccionada!})
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension VCCategories: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]
        
        let identifier = "customCategoryCell"
        let myBundle = Bundle(for: VCCategories.self)
        let nib = UINib(nibName: "CustomCategoryCell", bundle: myBundle)
        
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.allowsSelectionDuringEditing = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        let array = self._categories
        if array != [String]() {
            if array.count > 0 {
                rows = array.count
            } else {
                rows = 0
            }
        } else {
            rows = 0
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "customCategoryCell"
        let cell: CustomCategoryCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! CustomCategoryCell
        
        cell.lblCategory.text = self._categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if UIDevice.current.model.lowercased().contains("iphone") {
            self.performSegue(withIdentifier: Global.SEGUE_IPHONE, sender: self)
        } else {
            self.performSegue(withIdentifier: Global.SEGUE_IPAD, sender: self)
        }
    }

}
