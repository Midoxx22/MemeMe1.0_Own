//
//  MemeFlipIMG.swift
//  MemeMe1.0_Own
//
//  Created by Patrick Sauerwein on 09.05.20.
//  Copyright © 2020 Patrick Sauerwein. All rights reserved.
//

import Foundation
import UIKit

struct MemeRawData {
    let name: String?
    let url: String?
    let img: UIImage?
}

struct MemeFlipImg: Codable {
    let success: Bool
    let data: Memes
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
