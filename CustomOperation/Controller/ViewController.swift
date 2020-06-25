//
//  ViewController.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ImageTransferDelegete?
    var imageInfo: ImageModel!
    var viewModel = ViewModel()
    var image: UIImage?
    var indexPath: IndexPath?
    var imageArr = [UIImage]()
    
    private var pendingOperations = PendingOperations()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI()
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 110, height: 140)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        
        if let imageIF = imageInfo, let indexP = indexPath
        {
            photoImageView.image = imageIF.image
            viewModel.startFilterImage(for: imageIF, at: indexP) {
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any)
    {
        guard let image = photoImageView.image, let indexP = indexPath else { return }
        delegate?.imageTransfer(image: image, indexPath: indexP)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let filteredImages = imageInfo.filteredImages else { return 0 }
        
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        guard let filteredImages = imageInfo.filteredImages else { return cell }
        
        cell.filterLabel.text = filteredImages[indexPath.item].filterName
        
        cell.photoImageView.image = filteredImages[indexPath.item].filteredImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let filteredImages = imageInfo.filteredImages else { return }
        
        photoImageView.image = filteredImages[indexPath.item].filteredImage
    }
}
