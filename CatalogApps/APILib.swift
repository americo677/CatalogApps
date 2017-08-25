//
//  APILib.swift
//  CatalogApps
//
//  Created by Américo Cantillo on 22/08/17.
//  Copyright © 2017 Américo Cantillo Gutiérrez. All rights reserved.
//

import Foundation
import UIKit
//import Alamofire
import CoreData

public class APILib {
    
    func downloadImageFrom(url: URL, complete: @escaping DownloadImageData) {
        var tempData: Data?
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let _ = UIImage(data: data)
                else {
                    return
            }
            DispatchQueue.main.async() { () -> Void in
                //downloadedImage = data
                tempData = data
            }
            complete(tempData)
            //downloadedImage = tempData!
            }.resume()
    }
    
    func fetchAppInfoBy(index: String?) -> CDAppInfo? {
        
        var results = [AnyObject]()
        
        if index != nil {
            let moc = SingleManagedObjectContext.sharedInstance.getMOC()
            
            let fetchAppInfo: NSFetchRequest<CDAppInfo> = CDAppInfo.fetchRequest()
            fetchAppInfo.entity = NSEntityDescription.entity(forEntityName: "CDAppInfo", in: moc)
            
            let predicate = NSPredicate(format: " idn == %@ ", index!)
            //let predicate = NSPredicate(format: " descripcion contains[c] %@ ", "norte" as String)
            fetchAppInfo.predicate = predicate
            
            do {
                results = try moc.fetch(fetchAppInfo)
                
            } catch {
                let fetchError = error as NSError
                print("Error fetching data: \(fetchError.localizedDescription)")
            }
        } else {
            
        }
        
        var result: CDAppInfo? = nil
        if (results.count) > 0 {
            result = (results.first as! CDAppInfo)
        }
        return result
    }
    
    func fetchAppInfoBy() -> [AnyObject]? {
        
        var results = [AnyObject]()
        
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        
        let fetchAppInfo: NSFetchRequest<CDAppInfo> = CDAppInfo.fetchRequest()
        
        fetchAppInfo.entity = NSEntityDescription.entity(forEntityName: "CDAppInfo", in: moc)
        
        do {
            results = try moc.fetch(fetchAppInfo)
            
        } catch {
            let fetchError = error as NSError
            print("Error fetching data: \(fetchError.localizedDescription)")
        }
        
        let ordered = results.sorted(by: {($0 as! CDAppInfo).title! < ($1 as! CDAppInfo).title!})
        
        return ordered
    }
    
    
    func prepareData(app: AppInfo? = nil, isDataReady isComplete: inout Bool) {
        isComplete = true
        
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        
        if app != nil {
            
            // Mandatory data for record
            if (app?.idn.isEmpty)! {
                isComplete = false
            }
            
            //if (app?.iconurl.isEmpty)! {
            //    isComplete = false
            //}
            
            if (app?.title.isEmpty)! {
                isComplete = false
            }
            
            //if (app?.description.isEmpty)! {
            //    isComplete = false
            //}
            
            let appFetched = fetchAppInfoBy(index: app?.idn)
            
            if isComplete {
                
                if appFetched == nil {
                    let appStorage = NSEntityDescription.insertNewObject(forEntityName: "CDAppInfo", into: moc)
                    
                    appStorage.setValue(app?.idn, forKey: "idn")
                    
                    appStorage.setValue(app?.iconurl, forKey: "imageurl")
                    
                    appStorage.setValue(app?.title, forKey: "title")
                    
                    appStorage.setValue(app?.headerTitle, forKey: "headerTitle")
                    
                    appStorage.setValue(app?.description, forKey: "detail")
                    
                    appStorage.setValue(app?.category, forKey: "category")
                    
                    appStorage.setValue(app?.icon, forKey: "image")
                } else {
                    appFetched?.setValue(app?.idn, forKey: "idn")
                    
                    appFetched?.setValue(app?.iconurl, forKey: "imageurl")
                    
                    appFetched?.setValue(app?.title, forKey: "title")
                    
                    appFetched?.setValue(app?.headerTitle, forKey: "headerTitle")
                    
                    appFetched?.setValue(app?.description, forKey: "detail")
                    
                    appFetched?.setValue(app?.category, forKey: "category")
                    
                    appFetched?.setValue(app?.icon, forKey: "image")
                }
            }
        }
    }
    
    // MARK: - Precedimiento de guardado
    func save(app: AppInfo) -> Bool {
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        var canISave: Bool = true
        do {
            
            prepareData(app: app, isDataReady: &canISave)
            
            if canISave {
                
                try moc.save()
                
                //showCustomAlert(self, titleApp: Global.APP_NAME, strMensaje: "Los datos del rango de calificaciones fueron grabados con éxito.", toFocus: nil)
            }
        } catch {
            print("No se pudo guardar los datos.  Error: \(error.localizedDescription)")
        }
        
        return canISave
    }
    
    
    func clearAppInfoStorage() {
        
        let moc = SingleManagedObjectContext.sharedInstance.getMOC()
        
        let fetchRequestForDelete: NSFetchRequest<CDAppInfo> = CDAppInfo.fetchRequest()
        
        let filter = NSPredicate(format: "idn != %@", "")
        
        fetchRequestForDelete.predicate = filter
        
        let deletedFetch = NSBatchDeleteRequest(fetchRequest: fetchRequestForDelete as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            
            try moc.execute(deletedFetch)
            
        } catch let error as NSError {
            print("No se pudo eliminar los datos de la compra.  Error: \(error.localizedDescription)")
        }
        
    }
    
    func downloadAPINative(completed: @escaping DownloadComplete) {
        let url = URL.init(string: Global.JSON_URL)
        
        self.clearAppInfoStorage()
        
        var apps = [AppInfo]()
        
        apps.removeAll()
        
        DispatchQueue.main.async(execute: {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    do {
                        if let jsonData = try JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject> {
                            if let data = jsonData["data"] as? Dictionary<String, AnyObject> {
                                
                                if let children = data["children"] as? [Dictionary<String, AnyObject>] {
                                    for item in 0...(children.count-1) {
                                        if let childrenData = children[item]["data"] as? Dictionary<String, AnyObject> {
                                            let appInfo = AppInfo()
                                            if let categoryData = childrenData["advertiser_category"] as? String {
                                                appInfo._category = categoryData
                                            }
                                            if let titleData = childrenData["title"] as? String {
                                                appInfo._title = titleData
                                            }
                                            if let headerTitle = childrenData["header_title"] as? String {
                                                appInfo._headerTitle = headerTitle
                                            }
                                            if let iconData = childrenData["icon_img"] as? String {
                                                appInfo._iconurl = iconData
                                                if appInfo.iconurl != "" {
                                                    let urlData = URL.init(string: appInfo.iconurl)
                                                    do {
                                                        let dataImage: Data = try Data.init(contentsOf: urlData!)
                                                        
                                                        appInfo._icon = dataImage
                                                    } catch {
                                                        print("Error downloading image.  \(error.localizedDescription)")
                                                    }
                                                }
                                            }
                                            if let descriptionData = childrenData["public_description"] as? String {
                                                appInfo._description = descriptionData
                                            }
                                            if let idnData = childrenData["id"] as? String {
                                                appInfo._idn = idnData
                                            }
                                            apps.append(appInfo)
                                            let _ = self.save(app: appInfo)
                                        }
                                    }
                                }
                                completed(apps)
                            }
                        } else {
                            print("Failure!.  It is not possible downloading the data.")
                            completed(nil)
                        }
                    } catch {
                        print("Failure on request API.  It is not possible downloading the data: \(error.localizedDescription)")
                    }
                }
                
                }.resume()
        })
        
    }
    
    /*
     func downloadAPI(completed: @escaping DownloadComplete) {
     let url = URL.init(string: Global.JSON_URL)
     
     self.clearAppInfoStorage()
     
     var apps = [AppInfo]()
     
     apps.removeAll()
     
     DispatchQueue.main.async(execute: {
     Alamofire.request(url!).responseJSON(completionHandler: { response in
     let result = response.result
     
     if result.isSuccess {
     if let jsonData = result.value as? Dictionary<String, AnyObject> {
     
     if let data = jsonData["data"] as? Dictionary<String, AnyObject> {
     
     if let children = data["children"] as? [Dictionary<String, AnyObject>] {
     for item in 0...(children.count-1) {
     if let childrenData = children[item]["data"] as? Dictionary<String, AnyObject> {
     
     let appInfo = AppInfo()
     
     if let categoryData = childrenData["advertiser_category"] as? String {
     appInfo._category = categoryData
     }
     
     if let titleData = childrenData["title"] as? String {
     appInfo._title = titleData
     }
     
     if let headerTitle = childrenData["header_title"] as? String {
     appInfo._headerTitle = headerTitle
     }
     
     if let iconData = childrenData["icon_img"] as? String {
     appInfo._iconurl = iconData
     
     if appInfo.iconurl != "" {
     // Get image
     
     //var imageData: Data? = nil
     
     let urlData = URL.init(string: appInfo.iconurl)
     
     do {
     let dataImage: Data = try Data.init(contentsOf: urlData!)
     
     appInfo._icon = dataImage
     } catch {
     print("Error downloading image.  \(error.localizedDescription)")
     }
     
     }
     }
     
     if let descriptionData = childrenData["public_description"] as? String {
     appInfo._description = descriptionData
     }
     
     if let idnData = childrenData["id"] as? String {
     appInfo._idn = idnData
     }
     
     //self._appsInfo.append(appInfo)
     
     apps.append(appInfo)
     
     let _ = self.save(app: appInfo)
     
     //print("category: \(appInfo.category)")
     //print("id: \(appInfo.idn)")
     //print("title: \(appInfo.title)")
     //print("iconurl: \(appInfo.iconurl)")
     //print("description: \(appInfo.description)")
     }
     }
     }
     
     }
     completed(apps)
     }
     
     } else {
     print("Failure!.  It is not possible downloading the data")
     completed(nil)
     }
     
     })
     
     })
     
     }
     */
    
}
