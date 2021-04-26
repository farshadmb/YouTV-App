//
//  UITableView+Helper.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    /**
     Registers a class for use in creating new table cells.

     - Parameters:
       - className: The class of a cell that you want to use in the table (must be a UITableViewCell subclass).
       - identifer: The reuse identifier for the cell. This parameter must not be `nil` and must not be an empty string.
     */
    func registerCell<T: UITableViewCell>(className: T.Type,
                                    reuseIdentifer identifer: String = String(describing: T.self)) {
        self.register(className, forCellReuseIdentifier: identifer)
    }

    /**
     Registers a nib type object containing a cell with the table view under a specified identifier.

     - Parameters:
       - type: A `Class.Type` object that specifies the nib file to use to create the cell.
       - identifer: The reuse identifier for the cell. This parameter must not be `nil` and must not be an empty string.
     */
    func registerCell<T: UITableViewCell>(type: T.Type,
                                          reuseIdentifer identifer: String = String(describing: T.self)) {
        register(type.nib, forCellReuseIdentifier: identifer)
    }

    /**
     Registers a nib object containing a header or footer with the table view under a specified identifier.

     - Parameters:
        - type: A `Class.Type` object that specifies the nib file to use to create the header or footer view. This parameter cannot be `nil`.
        - identifer: The reuse identifier for the header or footer view. This parameter must not be `nil` and must not be an empty string.
     */
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type,
                                                                  reuseIdentifer identifer: String = String(describing: T.self)) {
        register(type.nib, forHeaderFooterViewReuseIdentifier: identifer)
    }

    /**
     Returns a reusable table-view cell object located by its identifier and type.

     - Parameters:
     - type: the cell object `Class` to be reused.
     - identifer: A string identifying the cell object to be reused. This parameter must not be `nil`.
     - Returns: Returns a reusable cell that is `T`.
     */
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type,
                                                 reuseIdentifer identifer: String = String(describing: T.self)) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifer) as? T else {
            preconditionFailure("Couldn't find nib file for \(String(describing: T.self))")
        }
        return cell
    }

    /**
     Returns a reusable table-view `T` cell object for the specified reuse identifier and adds it to the table.

     - Parameters:
       - type: the cell object `Class` to be reused.
       - indexPath: The index path specifying the location of the cell. Always specify the index path provided to you by your data source object.
                    This method uses the index path to perform additional configuration based on the cell’s position in the table view.
       - identifer: A string identifying the cell object to be reused. This parameter must not be `nil`.
     - Returns: Returns a reusable `T` cell type that `T` must be subclass of `UITableViewCell`.
     */
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, forIndexPath indexPath: IndexPath,
                                                 reuseIdentifer identifer: String = String(describing: T.self)) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifer,
                                                  for: indexPath) as? T else {
            preconditionFailure("Couldn't find nib file for \(String(describing: T.self))")
        }
        return cell
    }

    /**
     Returns a reusable header or footer view located by its identifier.

     - Parameters:
        - type: The header or footer view type to be reused.
        - identifer: A string identifying the header or footer view to be reused. This parameter must not be `nil`.
     - Returns: a reusable header or footer view.
     */
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type,
                                                                         reuseIdentifer identifer: String = String(describing: T.self) ) -> T {
        guard let headerFooterView = self
            .dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else {
            preconditionFailure("Couldn't find nib file for \(String(describing: T.self))")
        }
        return headerFooterView
    }

}
