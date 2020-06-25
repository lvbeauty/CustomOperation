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
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let imageObj = DataSource.dataSource[indexPath.row]
        
        cell.titileLabel.text = imageObj.title
        
        if let image = imageObj.image
        {
            cell.photoImageView.image = image
        }
        
        viewModel.startDownloadImage(for: imageObj, at: indexPath) {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
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
}

extension TableViewController: ImageTransferDelegete
{
    func imageTransfer(image: UIImage, indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
//        cell.photoImageView.image = image
        DataSource.dataSource[indexPath.row].image = image
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension TableViewController
{
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.pendingOperations.downloadQueue.isSuspended = true
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.pendingOperations.downloadQueue.isSuspended = false
    }
}
