//
//  DSNNavigationBackground.swift
//  disney
//
//  Created by ebuser on 2017/4/24.
//  Copyright © 2017年 e-business. All rights reserved.
//

import UIKit

class NavigationBackground {
    static let image: UIImage? = {
        let screenWidth = UIScreen.main.bounds.width

        // Setup our context
        let size = CGSize(width: screenWidth, height: 64)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)

        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Color Declarations
        let gradientColor = #colorLiteral(red: 0.7803921569, green: 0.4392156863, blue: 0.9882352941, alpha: 1)
        let gradientColor2 = #colorLiteral(red: 0.3215686275, green: 0.8431372549, blue: 1, alpha: 1)

        //// Gradient Declarations
        let linearGradient1 = CGGradient(colorsSpace: nil,
                                         colors: [gradientColor.cgColor, gradientColor2.cgColor] as CFArray,
                                         locations: [0, 1])!

        //// Page-1
        //// navigation_bar_bg
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
        context.saveGState()
        rectangle2Path.addClip()
        context.drawLinearGradient(linearGradient1,
                                   start: CGPoint(x: 0, y: 32),
                                   end: CGPoint(x: screenWidth, y: 32),
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return backgroundImage
    }()
}
