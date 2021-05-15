//
//  HomeSectionLayout.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/8/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

/// <#Description#>
private let defaultWidthSize: CGFloat = 140.0

/// <#Description#>
let defaultAspectRatio: CGFloat = 1.571_428_571_4

/// <#Description#>
let movieWidthSize: CGFloat = 150.0

/**
 <# Property Summery Here#>
 */
protocol HomeSectionLayout {

    /**
     <# Property Summery Here#>
     */
    func sectionLayout() -> NSCollectionLayoutSection
    
}

extension HomeSectionLayout {

    /**
     <# Property Summery Here#>
     */
    func headerElement() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))

        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .topLeading)

        return headerElement
    }

    /**
     <# Property Summery Here#>
     */
    func movieItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(defaultAspectRatio))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        return item
    }

    /**
     <# Property Summery Here#>
     */
    func showItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.77))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)

        return item
    }

    /**
     <# Property Summery Here#>
     */
    func popularShowItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.576_119_403))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)

        return item
    }

    /**
     <# Property Summery Here#>
     - Parameters:
       - width: <#width description#>
       - height: <#height description#>
     - Returns: <#description#>
     */
    func groupSize(width: NSCollectionLayoutDimension = .absolute(defaultWidthSize),
                   height: NSCollectionLayoutDimension = .estimated(defaultWidthSize * defaultAspectRatio)) -> NSCollectionLayoutSize {

        let groupSize = NSCollectionLayoutSize(widthDimension: width,
                                               heightDimension: height)
        return groupSize
    }

}
