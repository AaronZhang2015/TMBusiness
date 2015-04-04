//
//  AAContainerViewController.swift
//  AAContainerViewControllerDemo
//
//  Created by ZhangMing on 3/31/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

let AAScrollMenuViewHeight: CGFloat = 40.0

class AAContainerViewController: UIViewController {
    
    private var contentScrollView: UIScrollView!
    private var menuView: AAScrollMenuView!
    private lazy var titles: [String] = {
        return [String]()
        }()
    private var childControllers: [UIViewController]!
    private var topBarHeight: CGFloat = 0.0
    
    // 当前选中的controller索引
    private var currentIndex: Int! = 0
    
    convenience init(controllers: [UIViewController], topBarHeight: CGFloat, parentViewController: UIViewController) {
        self.init()
        
        parentViewController.addChildViewController(self)
        didMoveToParentViewController(parentViewController)
        self.topBarHeight = topBarHeight
        childControllers = controllers
        
        titles.removeAll(keepCapacity: false)
        for vc in controllers {
            if let title = vc.title {
                titles.append(title)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var contentView = UIView()
        view.addSubview(contentView)
        
        // UIScrollView setup
        contentScrollView = UIScrollView()
        contentScrollView.bounces = false
        contentScrollView.backgroundColor = UIColor.clearColor()
        contentScrollView.pagingEnabled = true
        contentScrollView.delegate = self
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.scrollsToTop = false
        view.addSubview(contentScrollView)
        
        // child viewcontroller setup
        for var index = 0; index < childControllers.count; ++index {
            var controller = childControllers[index]
            var scrollWidth = contentScrollView.width
            var scrollHeight = contentScrollView.height
            controller.view.frame = CGRectMake(CGFloat(index) * scrollWidth, 0, scrollWidth, scrollHeight)
            contentScrollView.addSubview(controller.view)
        }
        
        // menu view setup
        menuView = AAScrollMenuView(frame: CGRectMake(0, topBarHeight, view.width, AAScrollMenuViewHeight))
        menuView.delegate = self
        menuView.itemTitleColor = UIColor.whiteColor()
        menuView.itemTitleHightlightedColor = UIColor.blackColor()
        menuView.itemViewNormalImage = "caipinbg"
        menuView.itemViewSelectedImage = "caipinbg_on"
        menuView.itemTitleList = titles
        menuView.backgroundColor = UIColor.blackColor()
        view.addSubview(menuView)
        
        scrollMenuView(menuView, didSelectedIndex: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentScrollView.frame = CGRectMake(0, topBarHeight + AAScrollMenuViewHeight, view.width, view.height - (topBarHeight + AAScrollMenuViewHeight))
        
        contentScrollView.contentSize = CGSizeMake(contentScrollView.width * CGFloat(childControllers.count), contentScrollView.height)
        
        menuView.frame = CGRectMake(0, topBarHeight, view.width, AAScrollMenuViewHeight)
        println("menuView.frame = \(menuView.frame)")
        // child viewcontroller setup
        for var index = 0; index < childControllers.count; ++index {
            var controller = childControllers[index]
            var scrollWidth = contentScrollView.width
            var scrollHeight = contentScrollView.height
            controller.view.frame = CGRectMake(CGFloat(index) * scrollWidth, 0, scrollWidth, scrollHeight)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChildViewController(currentIndex: Int) {
        for var index = 0; index < childControllers.count; ++index {
            var controller = childControllers[index]
            if currentIndex == index {
                controller.willMoveToParentViewController(self)
//                controller.beginAppearanceTransition(true, animated: false)
                addChildViewController(controller)
                controller.didMoveToParentViewController(self)
//                controller.endAppearanceTransition()
            } else {
                controller.willMoveToParentViewController(nil)
//                controller.beginAppearanceTransition(false, animated: false)
                controller.removeFromParentViewController()
                controller.didMoveToParentViewController(nil)
//                controller.endAppearanceTransition()
            }
        }
    }
}

extension AAContainerViewController: AAScrollMenuViewDelegate {
    func scrollMenuView(menuView: AAScrollMenuView, didSelectedIndex: Int) {
        contentScrollView.setContentOffset(CGPointMake(CGFloat(didSelectedIndex) * contentScrollView.width, 0), animated: true)
        setChildViewController(didSelectedIndex)
        
        if didSelectedIndex == currentIndex {
            return
        }
        self.currentIndex = didSelectedIndex
        
        // Delegate
    }
}


extension AAContainerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var oldPointX = CGFloat(currentIndex) * scrollView.width
        var ratio = (scrollView.contentOffset.x - oldPointX) / scrollView.width
        var isToNextItem = contentScrollView.contentOffset.x > oldPointX
        var targetIndex = isToNextItem ? currentIndex + 1 : currentIndex - 1
        
        var nextItemOffsetX: CGFloat = 1.0
        var currentItemOffsetX: CGFloat = 1.0
        
        nextItemOffsetX = (menuView.scrollView.contentSize.width - menuView.scrollView.width) * CGFloat(targetIndex) / CGFloat(menuView.itemViewList.count - 1)
        currentItemOffsetX = (menuView.scrollView.contentSize.width - menuView.scrollView.width) * CGFloat(currentIndex) / CGFloat(menuView.itemViewList.count - 1)
        if targetIndex >= 0 && targetIndex < childControllers.count {
            // MenuView Move
            var indicatorUpdateRatio = ratio
            if (isToNextItem) {
                var offset = menuView.scrollView.contentOffset
                offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX
                menuView.scrollView.setContentOffset(offset, animated: false)
            } else {
                var offset = menuView.scrollView.contentOffset;
                offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio
               menuView.scrollView.setContentOffset(offset, animated: false)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var currentIndex = Int(scrollView.contentOffset.x / contentScrollView.width)
        
        if currentIndex == self.currentIndex {
            return
        }
        
        self.currentIndex = currentIndex
        menuView.currentSelectedIndex = currentIndex
        // Delegate
        
        setChildViewController(currentIndex)
    }
}