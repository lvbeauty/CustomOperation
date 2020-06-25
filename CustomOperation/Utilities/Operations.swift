//
//  Operations.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class PendingOperations
{
    lazy var downloadingInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download.Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filterationsInProgress: [IndexPath: Operation] = [:]
    lazy var filterationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Filteration.Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class JSONDownloadOperation: Operation
{
    var url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        guard let data = try? Data(contentsOf: url) else { return }
        
        guard !isCancelled else { return }
        
        JSONData.data = data
        JSONData.state = .downloaded
    }
}

class JSONParsarOperation: Operation
{
    override func main() {
        
        guard !isCancelled else { return }
        
        do
        {
            guard let jsonObj = try JSONSerialization.jsonObject(with: JSONData.data, options: .allowFragments) as? [String: Any] else { print("json error"); return }
            
            guard !isCancelled else { return }
            
            let items = jsonObj["items"] as! [[String: Any]]
            
            for obj in items
            {
                guard !isCancelled else { return }
                
                let title = obj["title"] as? String
                let media = obj["media"] as? [String: String]
                let imageUrlString = media?["m"]
                if let urlString = imageUrlString, let title = title, !title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
                {
                    guard let url = URL(string: urlString) else { return }
                    let imageInfo = ImageModel(title: title, url: url)
                    DataSource.dataSource.append(imageInfo)
                }
            }
            
            DataSource.state = .downloaded
        }
        catch
        {
            print(error.localizedDescription)
        }
        
    }
}

class ImageDownloadOperation: Operation
{
    let imageInfo: ImageModel
    
    init(_ imageInfo: ImageModel) {
        self.imageInfo = imageInfo
    }
    
    override func main() {
        guard !isCancelled else { self.imageInfo.state = .downloadCancelled; return }
        
        guard let url = self.imageInfo.imageURL else { self.imageInfo.state = .failed; return }
        
        guard let data = try? Data(contentsOf: url) else { self.imageInfo.state = .failed; return }
        
        guard !isCancelled else { self.imageInfo.state = .downloadCancelled; return }
        
        self.imageInfo.imageData = data
        self.imageInfo.image = UIImage(data: data)
        self.imageInfo.state = .downloaded
    }
}

class ImageFiltrationOperation: Operation
{
    let imageInfo: ImageModel
    
    init(_ imageInfo: ImageModel) {
        self.imageInfo = imageInfo
    }
    
    override func main() {
        
        guard let imageData = imageInfo.imageData else { return }
        guard let image = UIImage(data: imageData) else { return }
        
        let chrome = FilteredModel(filterName: "Chrome", filteredImage: image.filterImage(filter: .Chrome))
        let fade = FilteredModel(filterName: "Fade", filteredImage: image.filterImage(filter: .Fade))
        let instant = FilteredModel(filterName: "Instant", filteredImage: image.filterImage(filter: .Instant))
        let mono = FilteredModel(filterName: "Mono", filteredImage: image.filterImage(filter: .Mono))
        let noir = FilteredModel(filterName: "Noir", filteredImage: image.filterImage(filter: .Noir))
        let process = FilteredModel(filterName: "Process", filteredImage: image.filterImage(filter: .Process))
        let tonal = FilteredModel(filterName: "Tonal", filteredImage: image.filterImage(filter: .Tonal))
        let transfer = FilteredModel(filterName: "Transfer", filteredImage: image.filterImage(filter: .Transfer))
        let sepiaTone = FilteredModel(filterName: "SepiaTone", filteredImage: image.filterImage(filter: .SepiaTone))
        
        imageInfo.filteredImages = [chrome, fade, instant, mono, noir, process, tonal, transfer, sepiaTone]
        
    }
}
