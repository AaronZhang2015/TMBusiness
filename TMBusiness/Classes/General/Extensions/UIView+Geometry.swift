//
//  UIView+Geometry.swift
//  AZKitDemo
//
//  Created by ZhangMing on 1/21/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import Foundation
import UIKit

func RectMakeRect(origin: CGPoint, size: CGSize) -> CGRect {
    return CGRectMake(origin.x, origin.y, size.width, size.height)
}

func RectGetCenter(rect: CGRect) -> CGPoint {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
}

func RectGetMinRadius(rect: CGRect) -> CGFloat {
    return min(rect.width, rect.height) / 2
}

func RectGetMaxRadius(rect: CGRect) -> CGFloat {
    return max(rect.width, rect.height) / 2
}

func SizeGetMaxLength(size: CGSize) -> CGFloat {
    return max(size.width, size.height)
}


extension CGRect: StringLiteralConvertible {
    
    // The top coordinate of the rect.
    public var top: CGFloat {
        get {
            return origin.y
        }
        set(value) {
            origin.y = value
        }
    }
    
    // The left-side coordinate of the rect.
    public var left: CGFloat {
        get {
            return origin.x
        }
        set(value) {
            origin.x = value
        }
    }
    
    // The x coordinate of the rect.
    public var x: CGFloat {
        get {
            return origin.x
        }
        set(value) {
            origin.x = value
        }
    }
    
    // The y coordinate of the rect.
    public var y: CGFloat {
        get {
            return origin.y
        }
        set(value) {
            origin.y = value
        }
    }
    
    // The bottom coordinate of the rect. Setting this will change origin.y of the rect according to
    // the height of the rect.
    public var bottom: CGFloat {
        get {
            return origin.y + size.height
        }
        set(value) {
            origin.y = value - size.height
        }
    }
    
    // The right-side coordinate of the rect. Setting this will change origin.x of the rect according to
    // the width of the rect.
    public var right: CGFloat {
        get {
            return origin.x + size.width
        }
        set(value) {
            origin.x = value - size.width
        }
    }
    
    // The width of the rect.
    public var width: CGFloat {
        get {
            return size.width
        }
        set(value) {
            size.width = value
        }
    }
    
    // The height of the rect.
    public var height: CGFloat {
        get {
            return size.height
        }
        set(value) {
            size.height = value
        }
    }
    
    // The center x coordinate of the rect.
    public var centerX: CGFloat {
        get {
            return origin.x + size.width / 2
        }
        set(value) {
            origin.x = value - size.width / 2
        }
    }
    
    // The center y coordinate of the rect.
    public var centerY: CGFloat {
        get {
            return origin.y + size.height / 2
        }
        set(value) {
            origin.y = value - size.height / 2
        }
    }
    
    // The center of the rect.
    public var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set(value) {
            centerX = value.x
            centerY = value.y
        }
    }
    
    // MARK : - Protocol
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = StringLiteralType
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        if value[value.startIndex] != "{" {
            let comp = value.componentsSeparatedByString(",")
            if comp.count != 4 {
                self = CGRectZero
            } else {
                self = CGRectFromString("{{\(comp[0]), \(comp[1])}, {\(comp[2]), \(comp[3])}}")
            }
        } else {
            self = CGRectFromString(value)
        }
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(unicodeScalarLiteral: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(unicodeScalarLiteral: value)
    }
}

extension CGPoint: StringLiteralConvertible {
    // MARK : - Protocol
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias UnicodeScalarLiteralType = StringLiteralType
    
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        if value[value.startIndex] != "{" {
            self = CGPointFromString("{\(value)}")
        } else {
            self = CGPointFromString(value)
        }
    }
    
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(unicodeScalarLiteral: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(unicodeScalarLiteral: value)
    }
}

extension UIView {
    
    // The top coordinate of the view frame
    public var top: CGFloat {
        get {
            return frame.top
        }
        set(value) {
            var frame = self.frame
            frame.top = value
            self.frame = frame
        }
    }
    
    // The bottom coordinate of the view frame
    public var bottom: CGFloat {
        get {
            return frame.bottom
        }
        set(value) {
            var frame = self.frame
            frame.bottom = value
            self.frame = frame
        }
    }
    
    // The left coordinate of the view frame
    public var left: CGFloat {
        get {
            return frame.left
        }
        set(value) {
            var frame = self.frame
            frame.left = value
            self.frame = frame
        }
    }
    
    // The right coordinate of the view frame
    public var right: CGFloat {
        get {
            return frame.right
        }
        set(value) {
            var frame = self.frame
            frame.right = value
            self.frame = frame
        }
    }
    
    // The center x coordinate of the view frame
    public var centerX: CGFloat {
        get {
            return frame.centerX
        }
        set(value) {
            var frame = self.frame
            frame.centerX = value
            self.frame = frame
        }
    }
    
    // The center y coordinate of the view frame
    public var centerY: CGFloat {
        get {
            return frame.centerY
        }
        set(value) {
            var frame = self.frame
            frame.centerY = value
            self.frame = frame
        }
    }
    
    // The center of the view frame
    public var center: CGPoint {
        get {
            return frame.center
        }
        set(value) {
            var frame = self.frame
            frame.center = value
            self.frame = frame
        }
    }
    
    // The width of the view frame
    public var width: CGFloat {
        get {
            return frame.width
        }
        set(value) {
            var frame = self.frame
            frame.width = value
            self.frame = frame
        }
    }
    
    // The height of the view frame
    public var height: CGFloat {
        get {
            return frame.height
        }
        set(value) {
            var frame = self.frame
            frame.height = value
            self.frame = frame
        }
    }
}
