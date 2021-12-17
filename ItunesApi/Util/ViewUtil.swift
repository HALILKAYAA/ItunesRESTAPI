//
//  ViewUtil.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import Foundation
import UIKit

public typealias UIAlertActionHandler = ((UIAlertAction) -> Void)?

/// General View Utilities
public class ViewUtil {
    
    /// Creates ToolBar for using with Keyboard and TextFields
    /// - Parameters:
    ///   - buttonNames: Name of the Buttons
    ///   - targetVC: Target View Controller
    ///   - buttonSelectors: Button Selectors
    /// - Returns: UIToolbarObject
    public static func createToolBarObject(buttonNames: [String], targetVC: UIViewController, buttonSelectors: [Selector]) -> UIToolbar {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: Constants.ToolBar.Dimensions.height))
        toolbar.items = []
        
        if buttonNames.count > 1 {
            let barButton = UIBarButtonItem(title: buttonNames[0], style: .done, target: targetVC, action: buttonSelectors[0])
            barButton.setTitleTextAttributes([ NSAttributedString.Key.font: Constants.Fonts.toolbar,
                                               NSAttributedString.Key.foregroundColor: Constants.Colors.DarkSlateBlue70],
                                             for: .normal)
            barButton.setTitleTextAttributes([ NSAttributedString.Key.font: Constants.Fonts.toolbar,
                                               NSAttributedString.Key.foregroundColor: Constants.Colors.DarkSlateBlue70],
                                             for: .highlighted)
            toolbar.items?.append(barButton)
        }
        
        let barButtonFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items?.append(barButtonFlexSpace)
        
        let barButton = UIBarButtonItem(title: buttonNames[buttonNames.count-1], style: .done, target: targetVC, action: buttonSelectors[buttonNames.count-1])
        barButton.setTitleTextAttributes([ NSAttributedString.Key.font: Constants.Fonts.toolbar,
                                           NSAttributedString.Key.foregroundColor: Constants.Colors.LightRed],
                                         for: .normal)
        barButton.setTitleTextAttributes([ NSAttributedString.Key.font: Constants.Fonts.toolbar,
                                           NSAttributedString.Key.foregroundColor: Constants.Colors.LightRed],
                                         for: .highlighted)
        toolbar.items?.append(barButton)
        
        return toolbar
    }
    
    /// Displays Error Message
    /// - Parameter vc: ViewController
    public static func displayErrorMessage(vc : UIViewController) {
        let alert = UIAlertController(title: "dialog.title.error".localized, message: "error.general".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "dialog.button.ok".localized, style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    /// Displays Error Message
    /// - Parameters:
    ///   - message: message to display
    ///   - vc: target view controller
    ///   - okButtonAction: Action for Ok Button
    public static func displayErrorMessage(message : String, vc : UIViewController, okButtonAction : UIAlertActionHandler = nil) {
        ViewUtil.displayMessage(title : "dialog.title.error".localized, message: message, vc: vc, okButtonAction: okButtonAction)
    }
    
    /// Generic Message Display Method
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message
    ///   - vc: Target ViewController
    ///   - okButtonAction: OK Button Action
    private static func displayMessage(title : String? = "dialog.title.error".localized, message : String , vc : UIViewController, okButtonAction : UIAlertActionHandler = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "dialog.button.ok".localized, style: UIAlertAction.Style.default, handler: okButtonAction))
        vc.present(alert, animated: true, completion: nil)
    }
    
    /// Displays Yes No Dialog
    /// - Parameters:
    ///   - title: Title of the Dialog
    ///   - yesTitle: Yes title of the dialog
    ///   - noTitle: No title of the Dialog
    ///   - message: Message
    ///   - vc: Target ViewController
    ///   - okAction: OK Button Action
    ///   - noAction: NO Button Action
    public static func displayYesNoDialog(title : String? = "dialog.title.areyousure".localized, yesTitle : String? = "dialog.button.yes".localized, noTitle: String? = "dialog.button.no".localized , message : String, vc : UIViewController,  okAction :UIAlertActionHandler, noAction: UIAlertActionHandler ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: yesTitle, style: UIAlertAction.Style.default, handler: okAction))
        alert.addAction(UIAlertAction(title: noTitle, style: UIAlertAction.Style.cancel, handler: noAction))
        vc.present(alert, animated: true, completion: nil)
    }
}
