//
//  RemoteImageAssetBuilder.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/16/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

protocol RemoteImageAssetBuilder {

    typealias Size = APIConfigs.Images.Size

    func set(size: Size, forType type: KeyPath<APIConfigs.Images, [Size]?>) -> Self

    func build(imageName: String) -> URL?

}

struct DefaultImageAssetBuilder: RemoteImageAssetBuilder {

    let imageConfig: APIConfigs.Images

    @LateInit
    var size: Size

    private var lookupArray: [Size]?

    init(imageConfig: APIConfigs.Images) {
        self.imageConfig = imageConfig
    }

    func set(size: Size, forType type: KeyPath<APIConfigs.Images, [Size]?>) -> Self {
        var clone = self
        clone.size = size
        clone.lookupArray = clone.imageConfig[keyPath: type]
        return clone
    }

    func build(imageName: String) -> URL? {
        guard !self.lookupArray.isEmpty,
              let lookupArray = self.lookupArray else {
            return nil
        }

        guard lookupArray.contains(where: { $0 == size }) else {
            return nil
        }

        guard let baseURL = imageConfig.secureBaseUrl,
              !imageName.isEmptyOrBlank,
              let components = URLComponents(string: "\(size.rawValue)/\(imageName)") else {
            return nil
        }

        return components.url(relativeTo: baseURL)
    }

}
