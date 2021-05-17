//
//  AlertableView.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/16/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import MaterialComponents

/**
 Struct which provides the a Snackbar customization.
 */
struct AlertableViewConfiguration {

    /// The font for the message text in the Snackbar message view.
    var messageFont: UIFont

    /// The color for the message text in the Snackbar message view.
    var messageColor: UIColor

    /// The color for the background of the Snackbar message view.
    var backgroundColor: UIColor

    /// The color for the shadow color for the Snackbar message view.
    var shadowColor: UIColor

    /// The color for the button text in the Snackbar message view
    var buttonColor: UIColor
    
    /// The font for the button text in the Snackbar message view.
    var buttonFont: UIFont

    private static let alertAppearance = MDCSnackbarMessageView.appearance()

    /**
     The Default Configuration for `AlertView`

     The default values would be:
     * `messageFont` is `.system`
     * `messageColor` is `.white`
     * `backgroundColor` is `.gray`
     * `shadowColor` is `.black`
     * `buttonColor` is `.white.withAlphaComponent(0.6)`
     */
    static let `default` = AlertableViewConfiguration(messageFont: alertAppearance.messageFont ?? .systemFont(ofSize: 14.0, weight: .medium),
                                                      messageColor: alertAppearance.messageTextColor ?? .white,
                                                      backgroundColor: alertAppearance.snackbarMessageViewBackgroundColor ?? .gray,
                                                      shadowColor: alertAppearance.snackbarMessageViewShadowColor ?? .black,
                                                      buttonColor: alertAppearance.buttonTitleColor(for: .normal) ?? .white,
                                                      buttonFont: alertAppearance.buttonFont ?? .systemFont(ofSize: 14.0, weight: .semibold))

    /**
     The Error Configuration for `AlertView`

     The default values would be:
     * `messageFont` is `.system`
     * `messageColor` is `.red`
     * `backgroundColor` is `.gray.withAlphaComponent(0.8)`
     * `shadowColor` is `.black`
     * `buttonColor` is `.orange`
     */
    static let error: AlertableViewConfiguration = {
        var error = AlertableViewConfiguration.default
        error.messageColor = .red
        error.buttonColor = .white
        return error
    }()
}

/// Abstract `AlertableView` to create Snack Alert View.
protocol AlertableView: class, NSObjectProtocol {

    /**
     Present And Config Snack Alert View.

     A Snackbar message provides brief feedback about an operation. Messages are passed to the Snackbar manager to be displayed.

     - Note:`actionHandler` always called on the main thread.

     - Parameters:
       - message: The `String` text to display in the message.
       - actionTitle: The `String` title text be used on the button.
       - actionHandler: Called when the button in the Snackbar is tapped.
       - config: The `AlertableViewConfiguration` to be used to customize the alert view.
     - Seealso: `AlertableViewConfiguration` struct.
     */
    func presentAlert(message: String, actionTitle: String?, config: AlertableViewConfiguration, actionHandler:@escaping () -> Void)

}

extension AlertableView {

    func presentAlert(message: String, actionTitle: String?, config: AlertableViewConfiguration, actionHandler:@escaping () -> Void) {
        let alert = MDCSnackbarMessage(text: message)
        
        // if actionTitle has a value, create snackbar action and assign to alert
        if let actionTitle = actionTitle {
            alert.action = MDCSnackbarMessageAction()
            alert.action?.title = actionTitle
            alert.action?.handler = actionHandler
        }

        alert.snackbarMessageWillPresentBlock = { _, view in
            
            view.snackbarMessageViewBackgroundColor = config.backgroundColor
            view.snackbarMessageViewShadowColor = config.shadowColor
            view.messageFont = config.messageFont
            view.messageTextColor = config.messageColor
            view.setButtonTitleColor(config.buttonColor, for: .normal)
            view.setButtonTitleColor(config.buttonColor, for: .highlighted)
            view.setButtonTitleColor(config.buttonColor, for: .selected)
            
        }
        
        MDCSnackbarManager.default.show(alert)
        MDCSnackbarManager.default.uppercaseButtonTitle = false

    }
}

// MARK: - UIViewController extension for AlertableView Abstract.
extension AlertableView where Self: UIViewController {

    /**
     Present And Config Snack Alert View.

     A Snackbar message provides brief feedback about an operation. Messages are passed to the Snackbar manager to be displayed.

     - Note:`actionHandler` always called on the main thread.

     - Parameters:
       - message: The `String` text to display in the message.
       - actionTitle: The `String` title text be used on the button.
       - actionHandler: Called when the button in the Snackbar is tapped.
     */
    func presentAlertView(withMessage message: String, actionTitle: String? = nil, actionHandler: @escaping () -> Void = {}) {
        presentAlert(message: message, actionTitle: actionTitle,
                     config: .default, actionHandler: actionHandler)
    }

    /**
     Present And Config Snack Alert View.

     A Snackbar message provides brief feedback about an operation. Messages are passed to the Snackbar manager to be displayed.

     - Note:`actionHandler` always called on the main thread.

     - Parameters:
        - error: The `Error` to display in the message.
        - actionTitle: The `String` title text be used on the button.
        - actionHandler: Called when the button in the Snackbar is tapped.
     */
    func presentAlert(withError error: Error, actionTitle: String? = nil, actionHandler: @escaping () -> Void = {}) {
        presentAlert(message: error.localizedDescription,
                     actionTitle: actionTitle, config: .error,
                     actionHandler: actionHandler)
    }

}
