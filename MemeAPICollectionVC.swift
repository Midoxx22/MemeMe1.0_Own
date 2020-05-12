//
//  MemeAPICollectionVC.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 11.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import UIKit
import Alamofire

class MemeAPICollectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var image: UIImage = UIImage()
    var memeNames: [String] = []
    var memeImages: [UIImage] = []
    
    var memeRawData: [MemeRawData] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeRawData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeAPICell")
        
        cell?.textLabel?.text = memeRawData[indexPath.row].name
        //cell?.imageView?.image = memeRawData[indexPath.row].img
        self.setImage(imageView: cell!.imageView!, url: URL(string: memeRawData[indexPath.row].url!)!)

        return cell!
    }
    
    func setImage(imageView:UIImageView,url:URL){
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            if error != nil{
                return
            }
            DispatchQueue.main.async {
                let img = UIImage(data: data!)
                imageView.image = img
            }
        }
        task.resume()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setImageFromUrl(ImageURL :String) {
       URLSession.shared.dataTask( with: NSURL(string:ImageURL)! as URL, completionHandler: {
          (data, response, error) -> Void in
          DispatchQueue.main.async {
             if let data = data {
                self.image = UIImage(data: data)!
             }
          }
       }).resume()
        
        
    }

  

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
