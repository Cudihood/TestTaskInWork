//
//  UIImage+addImage.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func addImageFrom(url: URL?, options: KingfisherOptionsInfo? = [.cacheOriginalImage]) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: options)
    }
}
