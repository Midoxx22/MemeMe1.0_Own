//
//  MemeAPI.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 09.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import Foundation
import UIKit

class MemeAPI {
    
    //MEME DATA
    var memeCount: Int = 0
    var memeNames: [String] = []
    
    
    enum Endpoint: String {
        case getDataFromAPI = "https://api.imgflip.com/get_memes"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestAPIImageData(completionHandler: @escaping (MemeFlipImg?, Error?) -> Void) {
        let apiURL = MemeAPI.Endpoint.getDataFromAPI.url
        
        let task = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            //Decode
            let decoder = JSONDecoder()
            let memeData = try! decoder.decode(MemeFlipImg.self, from: data)
            
            completionHandler(memeData, nil)
            
        }
        task.resume()
    }
    
    class func requestAPIImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return}
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
    
    
    
    
    class func requestMemeDataAPI(completionHandler: @escaping (MemeFlipImg?, Error?) -> Void) {
        
        //URL
        let apiURL = MemeAPI.Endpoint.getDataFromAPI.url
        
        //URL Session Task
        let task = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            guard let data = data else {
                print("Data is nil")
                completionHandler(nil, error)
                return
            }
            
            //Decode
            let decoder = JSONDecoder()
            let memeData = try! decoder.decode(MemeFlipImg.self, from: data)
            
            print(memeData)
        }
        task.resume()
    }
    
    
    
    class func requestTrendingMemesAPI() -> Void {
        let memeAPIEndpoint = MemeAPI.Endpoint.getDataFromAPI.url
        
        let task = URLSession.shared.dataTask(with: memeAPIEndpoint) { (data, response, error) in
            guard let data = data else {
                print("Data is NIL")
                return
            }
            print(data)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let memes = try! decoder.decode(MemeFlipImg.self, from: data)
            print(memes)
            print("Hello")
            
            //print(memes.data.memes[1].name)
            
            //var memeNames = memes.data.memes[1].name
            /*
            var i = 0
            while(i < memes.data.memes.count) {
                var memeName = MemeData(memeName: memes.data.memes[i].name!)
                i+=1
            }
            */
            var i = 0
            while(i < memes.data.memes.count) {
                
            }
            
          
            
            /*
            memeCount = memes.data.memes.count
            
            print(memeCount)
            
            for meme in memeNames {
                print(meme)
                print("lol")
            }
            */
          
        }
        
        task.resume()
        
    }
}
