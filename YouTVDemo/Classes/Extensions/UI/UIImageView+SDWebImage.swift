//
//  UIImageView+SDWebImage.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/15/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

extension UIImageView {

    /// <#Description#>
    static let defaultSDWebImageOptions: SDWebImageOptions = [.lowPriority,.scaleDownLargeImages,.retryFailed,.refreshCached]

    /// <#Description#>
    static let cacheSDWebImageOptions: SDWebImageOptions = [.lowPriority,.scaleDownLargeImages,.queryMemoryData,.refreshCached]

    /**
     Set the imageView `image` with an `url`, placeholder and custom options.

     - Parameters:
       - url: The `URL` for the image.
       - placeHolderImage: The `UIImage` to be set initially until the image request finishes.
       - contentMode: The `UIView.ContentMode` to be used in contentMode. default is `UIView.ContentMode.scaleAspectFill`
       - options: The `SDWebImageOptions` options to use when downloading the image. The default is `UIImageView.defaultSDWebImageOptions`
       - completed: A `SDExternalCompletionBlock` block called when operation has been completed.
                    This block has no return value and takes the requested UIImage as first parameter.
                    In case of error the image parameter is nil and the second parameter may contain an NSError.
                    The third parameter is a Boolean indicating if the image was retrieved from the local cache or from the network. The fourth parameter is the original image url.
     - Seealso: `SDWebImageOptions`
     */
    func setImage(url: URL?, placeHolderImage: UIImage? = nil,
                  contentMode: UIView.ContentMode? = .scaleAspectFill,
                  options: SDWebImageOptions = UIImageView.defaultSDWebImageOptions,
                  completed: SDExternalCompletionBlock? = nil) {

        if let contentMode = contentMode {
            self.contentMode = contentMode
            self.setNeedsDisplay()
        }

        self.sd_setImage(with: url, placeholderImage: placeHolderImage,
                         options: options, completed: completed)
    }

    /**
     Cancel the current image load.
     */
    func cancelCurrentImageLoad() {
        sd_cancelCurrentImageLoad()
    }

}
