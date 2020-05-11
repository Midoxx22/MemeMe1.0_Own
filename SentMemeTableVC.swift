//
//  SentMemeTableVC.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 05.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import UIKit

class SentMemeTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
 
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemeCell")
        
        let data = self.memes[(indexPath as NSIndexPath).row]
        
        //Why Optionals are forced?
        cell?.textLabel?.text = data.topText + " " + data.botText
        cell?.imageView?.image = data.memedImage
        
        return cell!
    }
    
    
    //Button for Testing if Array Contains Data which Works
    @IBAction func testAPI(_ sender: Any) {
        //MemeAPI.requestTrendingMemesAPI()
        let url = MemeAPI.Endpoint.getDataFromAPI.url
        //MemeAPI.requestTrendingMemesAPI()
        
        /*
        MemeAPI.requestAPIImageFile(url: url) { (image, error) in
            //RETURNS NOW UI IMAGE AND AN ERROR!!!
        }
         */
        
        MemeAPI.requestAPIImageData { (data, error) in
            print(data?.data.memes.count)
            print("Looser lol bob")
            
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableViewOutlet.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
