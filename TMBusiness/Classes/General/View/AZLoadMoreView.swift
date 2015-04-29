//
//  AZLoadMoreView.swift
//  Poster
//
//  Created by ZhangMing on 2/5/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

struct AZLoadMoreConst {
    static let animationDuration: Double = 0.5
    static let height: CGFloat = 80
    static let tag = 811
    static let title = "加载更多"
}

class AZLoadMoreView: UIView {
    
    enum LoadMoreState {
        case Normal
        case Refreshing
    }
    
    let contentSizeKeyPath = "contentSize"
    let contentOffsetKeyPath = "contentOffset"
    var kvoContext = ""
    
    private var indicator: UIActivityIndicatorView!
    private var textLabel: UILabel!
    private var scrollViewInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var scrollViewBounces: Bool = true
    private var scrollView: UIScrollView!
    private var refreshCompletion: (() -> ()) = {}
    
    var state: LoadMoreState = .Normal {
        didSet {
            switch self.state {
            case .Normal:
                self.stopAnimating()
            case .Refreshing:
                self.startAnimating()
            }
        }
    }
    
    var title: String = AZLoadMoreConst.title {
        didSet {
            self.textLabel.text = title
            self.setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(refreshCompletion: (() -> ()), frame: CGRect) {
        self.init(frame: frame)
        self.refreshCompletion = refreshCompletion
        
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.indicator.bounds = CGRectMake(0, 0, 30, 30)
        self.indicator.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin
        self.indicator.hidesWhenStopped = false
        self.addSubview(indicator)
        
        self.textLabel = UILabel(frame: CGRectMake(0, 0, 100, 21))
        self.textLabel.font = UIFont.systemFontOfSize(20.0)
        self.textLabel.backgroundColor = UIColor.clearColor()
        self.textLabel.textColor = UIColor.grayColor()
        self.textLabel.text = AZLoadMoreConst.title
        self.addSubview(self.textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.indicator.center = CGPointMake(self.width / 2 - 100, self.height / 2)
        
        if let title = self.textLabel.text {
            var size = title.boundingRectWithSize(CGSizeMake(200, 21), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.textLabel.font], context: nil).size
            self.textLabel.frame.size = size
            
            var totalWidth = self.indicator.width + self.textLabel.width + 10
            
            self.indicator.center = CGPointMake((self.width - self.textLabel.width - 10) / 2, self.height / 2)
            
            self.textLabel.center = CGPointMake(self.indicator.right + 10 + self.textLabel.width / 2, self.height / 2)
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        self.superview?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
        self.superview?.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &kvoContext)
        
        if (newSuperview != nil && newSuperview is UIScrollView) {
            self.scrollViewInsets = (newSuperview as! UIScrollView).contentInset
            self.scrollView = newSuperview as! UIScrollView
            
            newSuperview?.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .Initial, context: &kvoContext)
            newSuperview?.addObserver(self, forKeyPath: contentSizeKeyPath, options: .Initial, context: &kvoContext)
            
            self.adjustFrameWithContentSize()
        }
    }
    
    deinit {
        self.scrollView?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
        self.scrollView?.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &kvoContext)
    }
    
    private func adjustFrameWithContentSize() {
        var contentHeight = self.scrollView.contentSize.height
        var scrollHeight = self.scrollView.height - self.scrollViewInsets.top - self.scrollViewInsets.bottom
        self.top = max(contentHeight, scrollHeight)
    }
    
    private func contentHeightBeyondViewHeight() -> CGFloat {
        var height = self.scrollView.height - self.scrollViewInsets.bottom - self.scrollViewInsets.top
        return self.scrollView.contentSize.height - height
    }
    
    private func adjustStateWithContentOffset() {
        var currentOffsetY = self.scrollView.contentOffset.y
        
        // footer control offset y
        var controlOffsetY = self.controlOffsetY()
        
        if currentOffsetY <= controlOffsetY {
            return
        }
        
        if self.scrollView.dragging {
            var willLoadMoreOffsetY = controlOffsetY + self.height
            
            if self.state == .Normal && currentOffsetY > willLoadMoreOffsetY {
                self.state = .Refreshing
            } else if self.state == .Refreshing && currentOffsetY <= willLoadMoreOffsetY {
                self.state = .Normal
            }
        }
    }
    
    private func controlOffsetY() -> CGFloat {
        var deltaHeight = self.contentHeightBeyondViewHeight()
        
        if deltaHeight > 0.0 {
            return deltaHeight - self.scrollViewInsets.top
        } else {
            return -scrollViewInsets.top
        }
    }
    
    private func startAnimating() {
        self.indicator.startAnimating()
        var bottom = self.height + self.scrollViewInsets.bottom
        var deltaHeight = self.contentHeightBeyondViewHeight()
        if deltaHeight < 0.0 {
            bottom -= deltaHeight
        }
        
        UIView.animateWithDuration(AZLoadMoreConst.animationDuration, animations: { () -> Void in
            self.scrollView.contentInset.bottom = bottom
        }) { (finished) -> Void in
            self.refreshCompletion()
        }
    }
    
    private func stopAnimating() {
        self.indicator.stopAnimating()
        UIView.animateWithDuration(AZLoadMoreConst.animationDuration, animations: { () -> Void in
            self.scrollView.contentInset.bottom = self.scrollViewInsets.bottom
        })
    }
    
    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if !self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden {
            return
        }
        
        if context == &kvoContext && keyPath == contentSizeKeyPath {
            self.adjustFrameWithContentSize()
        } else if keyPath == contentOffsetKeyPath {
            // while refreshing
            if self.state == .Refreshing {
                return
            }
            
            self.adjustStateWithContentOffset()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

extension UIScrollView {
    private var loadMoreView: AZLoadMoreView? {
        get {
            var loadMoreView = viewWithTag(AZLoadMoreConst.tag)
            return loadMoreView as? AZLoadMoreView
        }
    }
    
    func addLoadMoreView(refreshCompletion: (() -> ())) {
        let loadMoreViewFrame = CGRectMake(0, AZLoadMoreConst.height, self.width, AZLoadMoreConst.height)
        var loadMoreView = AZLoadMoreView(refreshCompletion: refreshCompletion, frame: loadMoreViewFrame)
        loadMoreView.tag = AZLoadMoreConst.tag
        addSubview(loadMoreView)
    }
    
    func startLoadMore() {
        loadMoreView?.state = .Refreshing
    }
    
    func stopLoadMore() {
        loadMoreView?.state = .Normal
    }
}
