//
//  AZPlaceholderTextView.swift
//  TMBusiness
//
//  Created by ZhangMing on 15/4/7.
//  Copyright (c) 2015年 南京寻觅信息科技有限公司. All rights reserved.
//

import UIKit

class AZPlaceholderTextView: UITextView {
    
    var placeholder: String? {
        didSet {
            if let string = placeholder {
                placeholderLabel.hidden = false
                placeholderLabel.text = string
            } else {
                placeholderLabel.hidden = true
            }
        }
    }
    
    var placeholderColor: UIColor! {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    var placeholderFont: UIFont = UIFont.systemFontOfSize(15.0) {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }
    
    override var text: String! {
        didSet {
            
            if countElements(text) > 0 {
                placeholderLabel.hidden = true
            } else {
                placeholderLabel.hidden = false
            }
            
            super.text = text
        }
    }
    
    private var placeholderLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholderLabel = UILabel(frame: CGRectMake(5, 2, width - 10, 30))
        placeholderLabel.textColor = UIColor.lightGrayColor()
        addSubview(placeholderLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChange:", name: UITextViewTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidBeginEditing:", name:UITextViewTextDidBeginEditingNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidEndEditing:", name:UITextViewTextDidEndEditingNotification, object: nil)
        font = UIFont.systemFontOfSize(15.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
         placeholderLabel.frame = CGRectMake(5, 2, width - 10, 30)
    }

   
    // MARK: - Notifications
    
    func textViewDidChange(notification: NSNotification) {
        if countElements(text) > 0 {
            placeholderLabel.hidden = true
        } else {
            placeholderLabel.hidden = false
        }
    }
    
    func textViewDidBeginEditing(notification: NSNotification) {
        
    }
    
    func textViewDidEndEditing(notification: NSNotification) {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
