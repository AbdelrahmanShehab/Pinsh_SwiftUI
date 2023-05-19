//
//  PageModel.swift
//  Pinsh
//
//  Created by Abdelrahman Shehab on 04/04/2023.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
