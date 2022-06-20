//
//  PageModel.swift
//  zoom
//
//  Created by Feng Yuan Yap on 2022/06/20.
//

import Foundation

struct Page: Identifiable {
  let id: Int
  let imageName: String
}

extension Page {
  var thumbnail: String {
    return "thumb-" + imageName
  }
}
