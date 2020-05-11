//
//  MemeFlipIMG.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 09.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import Foundation

//MEME DATA
var memeCount: Int = 0
var memeNames: [String] = []

struct MemeFlipImg: Codable {
    let success: Bool
    let data: Memes
    static var instances = 0
    
    init(success: Bool, data: Memes) {
        self.success = success
        self.data = data
        
        MemeFlipImg.instances += 1
    }
}

struct Memes: Codable {
    let memes: [MemeDetail]
}

struct MemeDetail: Codable {
    
    let id: String?
    let name: String?
    let url: String?
    let width: Int?
    let height: Int?
    let box_count: Int?
}
