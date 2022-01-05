//
//  LoginRegisterButton.swift
//  guntagram
//
//  Created by Ali Sutcu on 4.01.2022.
//  Inspired from: https://mobikul.com/set-activity-indicator-uibutton-swift-3/
//

import UIKit

class LoginRegisterButton: UIButton {
    var originalText: String?
    var activityIndicator: UIActivityIndicatorView?
    
    func hideLoading() {
        self.setTitle(originalText, for: .normal)
        activityIndicator?.stopAnimating()
    }
    
    func showLoading() {
        originalText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.color = UIColor.white
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator!)
        centerActivityIndicatorInButton()
        activityIndicator?.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}
