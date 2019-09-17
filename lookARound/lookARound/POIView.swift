//
//  POIView.swift
//  lookARound
//
//  Created by Jesse Liu on 2019-09-08.
//  Copyright © 2019 Jesse Liu. All rights reserved.
//

import Foundation
import UIKit

class POIView: UIView {
    var name = ""
    var dist = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        //backgroundColor = .red
    }
}
