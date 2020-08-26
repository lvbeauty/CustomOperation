//
//  TableViewController.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController
{
    let viewModel = ViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup()
    {
        self.title = "Custom Operation"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.fetchData()
        viewModel.updateHandler = self.tableView.reloadData
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard DataSource.state == .downloaded else { return 0 }
        
        return DataSource.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    } // don't impelement it(use constriants)

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.configureCell(indexPath: indexPath) { imageObj in
            startOperations(for: imageObj, at: indexPath)
        }
        
        return cell
    }
    
    func startOperations(for imageObj: ImageModel, at indexPath: IndexPath)
    {
        switch imageObj.state {
        case .new:
            self.viewModel.startDownloadImage(for: imageObj, at: indexPath) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .downloaded:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.viewModel.startFilterImage(for: imageObj, at: indexPath) {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSegue"
        {
            let cell = sender as! TableViewCell
            
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            let vc = segue.destination as! ViewController
            vc.delegate = self
            vc.imageInfo = DataSource.dataSource[indexPath.row]
            vc.indexPath = indexPath
        }
    }
    
    deinit {
        print("Table view controller deallocated")
    }
}

//MARK: - Image Transfer Delegete Method

extension TableViewController: ImageTransferDelegete
{
    func imageTransfer(image: UIImage, indexPath: IndexPath) {
        DataSource.dataSource[indexPath.row].image = image
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//MARK: - Scroll View Delegate Methods

extension TableViewController
{
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.pendingOperations.downloadQueue.isSuspended = true
        viewModel.pendingOperations.filterationQueue.isSuspended = true
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate
        {
            viewModel.pendingOperations.downloadQueue.isSuspended = false
            viewModel.pendingOperations.filterationQueue.isSuspended = false
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.pendingOperations.downloadQueue.isSuspended = false
        viewModel.pendingOperations.filterationQueue.isSuspended = false
    }
}
