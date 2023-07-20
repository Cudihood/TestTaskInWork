//
//  ProfileTableViewModel.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 19.07.2023.
//

import Foundation

struct ProfileTableViewModel {
    var name: String?
    var birthday: String?
    var gender: String?
    var imageUser: Data?
    let id: Int64 = 228
    
    init(with model: Profile?) {
        self.name = model?.name
        self.birthday = model?.birthday
        self.gender = model?.gender
        self.imageUser = model?.imageUser
    }
}
