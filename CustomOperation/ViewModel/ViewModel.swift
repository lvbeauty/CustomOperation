//
//  ViewModel.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewModel
{
    var pendingOperations = PendingOperations()
    var updateHandler: () -> () = {}
    
    func fetchData()
    {
        guard let url = URL(string: "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1") else { return }
        let jsonDownloadOp = JSONDownloadOperation(url)
        let jsonParsingOp = JSONParsarOperation()
        
        let op = BlockOperation {
            jsonParsingOp.data = jsonDownloadOp.data
        }
        
        op.addDependency(jsonDownloadOp)
        jsonParsingOp.addDependency(op)
//        jsonParsingOp.addDependency(jsonDownloadOp)
        
        jsonParsingOp.completionBlock = {
            OperationQueue.main.addOperation {
                self.updateHandler()
            }
        }
        
//        jsonDownloadOp.completionBlock = {
//                jsonParsingOp.data = jsonDownloadOp.data
//        }
        
        let queue = OperationQueue()
        queue.addOperations([jsonDownloadOp, op, jsonParsingOp], waitUntilFinished: false)
    }
    
    func startDownloadImage(for imageInfo: ImageModel, at indexPath: IndexPath, completeHandler: @escaping () -> ())
    {
        if DataSource.state == .downloaded, imageInfo.state == .new
        {
            guard pendingOperations.downloadingInProgress[indexPath] == nil else { return }
            
            let downloadImageOp = ImageDownloadOperation(imageInfo)
            
            pendingOperations.downloadingInProgress[indexPath] = downloadImageOp
            pendingOperations.downloadQueue.addOperation(downloadImageOp)
            
            downloadImageOp.completionBlock = {
                guard !downloadImageOp.isCancelled else { return }
                
                OperationQueue.main.addOperation {
                    self.pendingOperations.downloadingInProgress.removeValue(forKey: indexPath)
                    completeHandler()
                }
            }
        }
    }
    
    func startFilterImage(for imageInfo: ImageModel, at indexPath: IndexPath, completeHandler: @escaping () -> ())
    {
        guard imageInfo.state == .downloaded else { return }
        
        guard pendingOperations.filterationsInProgress[indexPath] == nil else { return }
        
        let filterOp = ImageFiltrationForAllImagesOperation(imageInfo)
//        let filterOp = ImageFiltrationOperation(imageInfo)
        
        filterOp.completionBlock = {
            guard !filterOp.isCancelled else { return }
            
            OperationQueue.main.addOperation {
                self.pendingOperations.filterationsInProgress.removeValue(forKey: indexPath)
                completeHandler()
            }
        }
        
        pendingOperations.filterationsInProgress[indexPath] = filterOp
        pendingOperations.filterationQueue.addOperation(filterOp)
    }
    
    deinit {
        print("View Model deallocated")
    }
}
