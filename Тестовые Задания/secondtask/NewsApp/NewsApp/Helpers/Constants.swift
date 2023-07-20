//
//  Constants.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit

enum Constants {
    enum Spacing {
        static let standart = 16
        static let space = 20
        static let miniSpacing = 10
    }
    
    enum Size {
        static let little = 60
        static let big = 300
        static let cornerRadius: CGFloat = 20
    }
    
    enum Font {
        static let title1 = UIFont.preferredFont(forTextStyle: .title1)
        static let title2 = UIFont.preferredFont(forTextStyle: .title2)
        static let title3 = UIFont.preferredFont(forTextStyle: .title3)
        static let body = UIFont.preferredFont(forTextStyle: .body)
    }
    
    enum Color {
        static let background = UIColor.systemBackground
        static let black = UIColor.black
        static let gray = UIColor.systemGray
        static let blue = UIColor.systemBlue
        static let red = UIColor.systemRed
    }
    
    static let defaultImageURL = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUFwgxxqFCIkJ8VV6xwo0-PVDsPDHVmRTc4w&usqp=CAU"
}
