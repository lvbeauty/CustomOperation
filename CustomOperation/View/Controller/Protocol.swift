//
//  Protocol.swift
//  CustomOperation
//
//  Created by Tong Yi on 6/25/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

protocol ImageTransferDelegete: class //reference type
{
    func imageTransfer(image: UIImage, indexPath: IndexPath)
}
