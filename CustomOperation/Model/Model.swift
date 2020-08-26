//
//  Model.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

enum ImageState
{
    case new, downloaded, cancelled, filtered, failed
}

class ImageModel
{
    let title: String
    let imageURL: URL?
    var state: ImageState = .new
    var imageData: Data?
    var image: UIImage?
    var filteredImages: [FilteredModel]?
    
    init(title: String, url: URL) {
        self.title = title
        self.imageURL = url
    }
}

struct FilteredModel
{
    var filterName: String
    var filteredImage: UIImage
}

//class JSONData
//{
//    static var data = Data()
//    static var state: ImageState = .new
//}

class DataSource
{
    static var dataSource = [ImageModel]()
    static var state: ImageState = .new
}

enum FilterType: String
{
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
    case SepiaTone = "CISepiaTone"
}


