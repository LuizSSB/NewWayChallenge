//
//  UIViewController+HUD.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/25/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import Foundation
import MBProgressHUD

func showError(message: String, from viewController: UIViewController) {
    let hud = MBProgressHUD.showAdded(to:viewController.view, animated:true);
    hud.mode = .text
    hud.detailsLabel.text = message
    hud.hide(animated: true, afterDelay: 2)
}

extension UIViewController {
    fileprivate static var nwc_kHUDProp = "nwc_loadingHUD"
    
    var nwc_loadingHUD: MBProgressHUD {
        get {
            var hud = objc_getAssociatedObject(
                self, &UIViewController.nwc_kHUDProp
            ) as? MBProgressHUD
            
            if hud == nil {
                hud = MBProgressHUD(view: view)
                objc_setAssociatedObject(
                    self, &UIViewController.nwc_kHUDProp, hud,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
            
            return hud!
        }
    }
    
    func nwc_setBusy(_ busy: Bool) {
        if (busy) {
            nwc_loadingHUD.show(animated: true)
        } else {
            nwc_loadingHUD.hide(animated: true)
        }
    }
}
