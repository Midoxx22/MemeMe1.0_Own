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
    enum Endpoint: String {
        case getDataFromAPI = "https://api.imgflip.com/get_memes"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
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
        
            var i = 0
            while(i < memes.data.memes.count) {
                memeNames.append(memes.data.memes[i].name!)
                i+=1
            }
            
            memeCount = memes.data.memes.count
            
            print(memeCount)
            
            for meme in memeNames {
                print(meme)
                print("lol")
            }
            
            
            
        }
        
        task.resume()
    }
}
