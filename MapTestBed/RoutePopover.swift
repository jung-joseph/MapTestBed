//
//  RoutePopover.swift
//  MapsMacOS
//
//  Created by Joseph Jung on 8/5/22.
//

import Foundation
import UIKit
import MapKit

class RoutePopover: UIViewController {
    
    init(controller: RouteContentViewController) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.popover

//        self.contentViewController = controller
//        self.contentSize = controller.view.frame.size
//        self.behavior = .transient
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
