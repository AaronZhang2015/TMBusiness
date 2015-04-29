//
//  PullToRefreshConst.swift
//  PullToRefreshSwift
//
//  Created by Yuji Hato on 12/11/14.
//
import UIKit

struct PullToRefreshConst {
    static let backgroundColor = UIColor.clearColor()
    static let imageName: String = "pulltorefresharrow.png"
    static let height: CGFloat = 80
    static let animationDuration: Double = 0.5
    static let autoStop = false
    static let autoStopDuration: Double = 1.0
    static let fixedTop = false
    static let fixedSectionHeader = false
    static let alpha = true
    static let tag = 810
}

public class PullToRefreshView: UIView {
    enum PullToRefreshState {
        case Normal
        case Pulling
        case Refreshing
    }
    
    // MARK: Variables
    let contentOffsetKeyPath = "contentOffset"
    var kvoContext = ""
    
    private var backgroundView: UIView!
    private var arrow: UIImageView!
    private var indicator: UIActivityIndicatorView!
    private var scrollViewBounces: Bool = true
    private var scrollViewInsets: UIEdgeInsets = UIEdgeInsetsZero
    private var previousOffset: CGFloat = 0
    private var refreshCompletion: (() -> ()) = {}
    
    var state: PullToRefreshState = PullToRefreshState.Normal {
        didSet {
            switch self.state {
            case .Normal:
                stopAnimating()
            case .Refreshing:
                startAnimating()
            default:
                break
            }
        }
    }
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(refreshCompletion :(() -> ()), frame: CGRect) {
        self.init(frame: frame)
        self.refreshCompletion = refreshCompletion;

        self.backgroundView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.backgroundView.backgroundColor = PullToRefreshConst.backgroundColor
        self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.addSubview(backgroundView)
        
        self.arrow = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        self.arrow.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin |  UIViewAutoresizing.FlexibleRightMargin
        self.arrow.image = UIImage(named: PullToRefreshConst.imageName)
        self.addSubview(arrow)
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.indicator.bounds = self.arrow.bounds
        self.indicator.autoresizingMask = self.arrow.autoresizingMask
        self.indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    }
   
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.arrow.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        self.indicator.center = self.arrow.center
    }
    
    public override func willMoveToSuperview(superView: UIView!) {
        superview?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
        if (superView != nil && superView is UIScrollView) {
            superView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .Initial, context: &kvoContext)
            scrollViewBounces = (superView as! UIScrollView).bounces
            scrollViewInsets = (superView as! UIScrollView).contentInset
        }
    }
    
    deinit {
        var scrollView = superview as? UIScrollView
        scrollView?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
    }
    
    // MARK: KVO
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        
        if (context == &kvoContext && keyPath == contentOffsetKeyPath) {
            if let scrollView = object as? UIScrollView {
                
                // Debug
//                println(scrollView.contentOffset.y)
                
                var offsetWithoutInsets = self.previousOffset + self.scrollViewInsets.top
                
                // Update the content inset for fixed section headers
                if PullToRefreshConst.fixedSectionHeader && self.state == .Refreshing {
                    if (scrollView.contentOffset.y > 0) {
                        scrollView.contentInset = UIEdgeInsetsZero;
                    }
                    return
                }
                
                // Alpha set
                if PullToRefreshConst.alpha {
                    var alpha = fabs(offsetWithoutInsets) / (self.frame.size.height + 30)
                    if alpha > 0.9 {
                        alpha = 0.9
                    }
                    self.arrow.alpha = alpha
                }
                
                // Backgroundview frame set
                if PullToRefreshConst.fixedTop {
                    if PullToRefreshConst.height < fabs(offsetWithoutInsets) {
                        self.backgroundView.frame.size.height = fabs(offsetWithoutInsets)
                    } else {
                        self.backgroundView.frame.size.height =  PullToRefreshConst.height
                    }
                } else {
                    self.backgroundView.frame.size.height = PullToRefreshConst.height + fabs(offsetWithoutInsets)
                    self.backgroundView.frame.origin.y = -fabs(offsetWithoutInsets)
                }
                
                // Pulling State Check
                if (offsetWithoutInsets < -self.frame.size.height) {
                    
                    // pulling or refreshing
                    if (scrollView.dragging == false && self.state != .Refreshing) {
                        self.state = .Refreshing
                    } else if (self.state != .Refreshing) {
                        self.arrowRotation()
                        self.state = .Pulling
                    }
                } else if (self.state != .Refreshing && offsetWithoutInsets < 0) {
                    // normal
                    self.arrowRotationBack()
                }
                self.previousOffset = scrollView.contentOffset.y
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: private
    
    private func startAnimating() {
        self.indicator.startAnimating()
        self.arrow.hidden = true
        
        var scrollView = superview as! UIScrollView
        var insets = scrollView.contentInset
        insets.top += self.frame.size.height
        scrollView.contentOffset.y = self.previousOffset
        scrollView.bounces = false
        UIView.animateWithDuration(PullToRefreshConst.animationDuration, delay: 0, options:nil, animations: {
            scrollView.contentInset = insets
            //scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -insets.top)
        }, completion: {finished in
            if PullToRefreshConst.autoStop {
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(PullToRefreshConst.autoStopDuration * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.state = .Normal
                }
            }
            self.refreshCompletion()
        })
    }
    
    private func stopAnimating() {
        self.indicator.stopAnimating()
        self.arrow.transform = CGAffineTransformIdentity
        self.arrow.hidden = false
        
        var scrollView = superview as! UIScrollView
        scrollView.bounces = self.scrollViewBounces
        UIView.animateWithDuration(PullToRefreshConst.animationDuration, animations: { () -> Void in
            scrollView.contentInset = self.scrollViewInsets
        }) { (Bool) -> Void in

        }
    }
    
    private func arrowRotation() {
        UIView.animateWithDuration(0.2, delay: 0, options:nil, animations: {
            // -0.0000001 for the rotation direction control
            self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI-0.0000001))
            }, completion: nil)
    }
    
    private func arrowRotationBack() {
        UIView.animateWithDuration(0.2, delay: 0, options:nil, animations: {
            self.arrow.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
}

extension UIScrollView {
    
    private var pullToRefreshView: PullToRefreshView? {
        get {
            var pullToRefreshView = viewWithTag(PullToRefreshConst.tag)
            return pullToRefreshView as? PullToRefreshView
        }
    }
    
    func addPullToRefresh(refreshCompletion: (() -> ())) {
        let refreshViewFrame = CGRectMake(0, -PullToRefreshConst.height, self.frame.size.width, PullToRefreshConst.height)
        var refreshView = PullToRefreshView(refreshCompletion: refreshCompletion, frame: refreshViewFrame)
        refreshView.tag = PullToRefreshConst.tag
        addSubview(refreshView)
    }
    
    func startPullToRefresh() {
        pullToRefreshView?.state = .Refreshing
    }
    
    func stopPullToRefresh() {
        pullToRefreshView?.state = .Normal
    }
    
    // If you want to PullToRefreshView fixed top potision, Please call this function in scrollViewDidScroll
    func fixedPullToRefreshViewForDidScroll() {
        if PullToRefreshConst.fixedTop {
            if self.contentOffset.y < -PullToRefreshConst.height {
                if var frame = pullToRefreshView?.frame {
                    frame.origin.y = self.contentOffset.y
                    pullToRefreshView?.frame = frame
                }
            } else {
                if var frame = pullToRefreshView?.frame {
                    frame.origin.y = -PullToRefreshConst.height
                    pullToRefreshView?.frame = frame
                }
            }
        }
    }
}

