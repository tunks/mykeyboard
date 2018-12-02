//
//  PageUIView.swift
//  AKboard
//
//  Created by Ebrima Tunkara on 12/1/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class PageView: UIView {
    var index: Int?
    
    // Designated Init method
    init(index: Int, backgroundColor: UIColor) {
        super.init(frame: .zero)
        //setup()
        self.index =  index
        self.backgroundColor = backgroundColor
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

















