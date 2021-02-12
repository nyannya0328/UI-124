//
//  Asset.swift
//  UI-124
//
//  Created by にゃんにゃん丸 on 2021/02/12.
//

import SwiftUI
import Photos

struct Asset: Identifiable {
    var id = UUID().uuidString
    var asset : PHAsset
    var image : UIImage
}


