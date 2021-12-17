//
//  BaseViewController.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    //General ToolBar Object
    var toolBar : UIToolbar?
    // Empty Placeholder View
    var emptyIndicatorView = EmptyIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var emptyPlaceHolderView : UIView?
    
    var isLoading = false {
        didSet{
            if isLoading {
                self.showLoadingView()
            }
            else
            {
                self.removeLoadingView()
            }
        }
    }
    
    var isEmptyList = false {
        didSet {
            if isEmptyList {
                self.showEmptyView()
            }
            else
            {
                self.hideEmptyView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolBar = ViewUtil.createToolBarObject(buttonNames: ["general.done".localized], targetVC: self, buttonSelectors: [#selector(closeKeyboard)])
    }
    
    /// Shows Empty View
    private func showEmptyView() {
        if emptyPlaceHolderView == nil {
            emptyPlaceHolderView = self.view
        }
        self.view.addSubview(emptyIndicatorView)
        setupEmptyViewConstraints(placeholderView: emptyPlaceHolderView!)
        emptyIndicatorView.center = self.view.center
    }
    
    /// Hides Empty View
    private func hideEmptyView() {
        emptyIndicatorView.removeFromSuperview()
    }
    
    /// Sets Empty View Constraints
    private func setupEmptyViewConstraints(placeholderView : UIView) {
        emptyIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        let margins = placeholderView.layoutMarginsGuide
        let parentMargins = self.view.layoutMarginsGuide
        emptyIndicatorView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        emptyIndicatorView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        emptyIndicatorView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        emptyIndicatorView.bottomAnchor.constraint(equalTo: parentMargins.bottomAnchor, constant: 0).isActive = true
    }
    
    /// Keyboard Event Subscribing
    func subscribeForKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWasShown(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardDidShow(notification:)), name:UIResponder.keyboardDidShowNotification, object: nil);
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {}
    
    @objc func keyboardWillHide(notification: NSNotification) {}
    
    @objc func keyboardDidShow(notification: NSNotification) {}
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
}
