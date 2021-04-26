//
//  UICollectionView+Helper.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    /**
     Registers a nib file for use in creating new collection view cells.

     - Parameters:
        - type: The type containing the cell class type. it must contain only one top-level object and that object must be of the type UICollectionViewCell.
        - identifer: The reuse identifier to associate with the specified nib file. This parameter must not be `nil` and must not be an empty string
     */
    func registerCell<T: UICollectionViewCell>(type: T.Type, reuseIdentifer identifer: String = String(describing: T.self)) {
        register(type.nib, forCellWithReuseIdentifier: identifer)
    }

    /**
     Registers a class for use in creating new collection view cells.

     - Parameters:
       - className: The class of a cell that you want to use in the collection view.
       - identifer:  The reuse identifier to associate with the specified nib file. This parameter must not be `nil` and must not be an empty string
     */
    func registerCell<T: UICollectionViewCell>(className: T.Type, reuseIdentifer identifer: String = .init(describing: T.self)) {
        register(className, forCellWithReuseIdentifier: identifer)
    }

    /**
     Registers a nib file for use in creating supplementary views for the collection view by its type.

     - Parameters:
       - type: the `UICollectionReusableView` subclass type.
       - elementKind: The kind of supplementary view to create. The layout defines the types of supplementary views it supports.
                      The value of this string may correspond to one of the predefined kind strings or to a custom string that the layout added to support a new type of supplementary view. This parameter must not be `nil`.
       - identifer: The reuse identifier to associate with the specified nib file. This parameter must not be `nil` and must not be an empty string
     */
    func registerSupplementaryView<T>(type: T.Type, Ofkind elementKind: String,
                                   reuseIdentifer identifer: String = .init(describing: T.self)) where T: UICollectionReusableView {
        register(type.nib,forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifer)
    }

    /**
     Dequeues a reusable cell object located by its identifier.

     - Parameters:
       - type: the `UICollectionViewCell` subclass type.
       - indexPath: The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
       - identifer: The reuse identifier for the specified cell. This parameter must not be `nil`
     - Returns: The `UICollectionViewCell` subclass type object that given type.
     */
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, forIndexPath indexPath: IndexPath,
                                                      reuseIdentifer identifer: String = String(describing: T.self)) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifer,
                                                  for: indexPath) as? T else {
            preconditionFailure("Couldn't find nib file for \(String(describing: T.self))")
        }

        return cell
    }

    /**
     Dequeues a reusable supplementary view located by its identifier and kind.

     - Parameters:
       - type: the `UICollectionReusableView` subclass type.
       - kind: The kind of supplementary view to retrieve. This value is defined by the layout object. This parameter must not be nil
       - indexPath: The index path specifying the location of the supplementary view in the collection view. The data source receives this information when it is asked for the view and should just pass it along. This method uses the information to perform additional configuration based on the view’s position in the collection view.
       - identifer: The reuse identifier for the specified view. This parameter must not be nil.
     - Returns: The `UICollectionReusableView` subclass type object that given type.
     */
    func dequeueReusableSupplementaryView <T: UICollectionReusableView>(type: T.Type,
                                                                        kind: String, forIndexPath indexPath: IndexPath,
                                                                        reuseIdentifer identifer: String = String(describing: T.self)) -> T? {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifer, for: indexPath) as? T else {
            preconditionFailure("Couldn't find nib file for \(String(describing: T.self))")
        }

        return view
    }

}
