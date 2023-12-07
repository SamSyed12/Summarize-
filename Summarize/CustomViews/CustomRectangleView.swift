//
//  CustomRectangleView.swift
//  Summarize
//
//  Created by Sameel Syed on 11/21/23.
//
import UIKit

class CustomRectangleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: width, height: height))
    }

    private func commonInit() {
        
        backgroundColor = UIColor.black
        layer.cornerRadius = 3
        layer.masksToBounds = true
        
    }
}
