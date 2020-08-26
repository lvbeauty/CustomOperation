//
//  TableViewCell.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/24/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titileLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryView = UIActivityIndicatorView(style: .medium)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: IndexPath, handler: (ImageModel) -> ())
    {
        guard let activityIndicator = self.accessoryView as? UIActivityIndicatorView else { return }
        
        let imageInfo = DataSource.dataSource[indexPath.row]
        
        self.titileLabel.text = imageInfo.title
        self.photoImageView.image = imageInfo.image
        
        activityIndicator.startAnimating()
        
        switch imageInfo.state {
            case .new, .downloaded:
                handler(imageInfo)
            case .failed, .cancelled:
                activityIndicator.stopAnimating()
                self.titileLabel.text = "Failed to load Image"
            case .filtered:
                activityIndicator.stopAnimating()
        }
        
    }

}
