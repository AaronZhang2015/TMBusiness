//
//  AZPagingContainerViewController.swift
//  AAPagingContainerViewControllerDemo
//
//  Created by ZhangMing on 4/3/15.
//  Copyright (c) 2015 ZhangMing. All rights reserved.
//

import UIKit

let AZPagingContainerMenuViewDefaultHeight: CGFloat = 51

class AZPagingContainerViewController: UIViewController {
    
    private var contentScrollView: UIScrollView!
    private var menuView: AZPagingContainerMenuView!
    private var menuListView: AZPagingContainerMenuListView!
    
    private lazy var titles: [String] = {
        return [String]()
        }()
    
    var itemControllers: [UIViewController]! = [UIViewController]()
    
    convenience init(controllers: [UIViewController], parentViewController: UIViewController) {
        self.init()
        parentViewController.addChildViewController(self)
        didMoveToParentViewController(parentViewController)
        
        itemControllers = controllers
        
        titles.removeAll(keepCapacity: false)
        for controller in itemControllers {
            if let title = controller.title {
                titles.append(title)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentView = UIView()
        view.addSubview(contentView)
        
        // UIScrollView setup
        contentScrollView = UIScrollView(frame: CGRectMake(0, AZPagingContainerMenuViewDefaultHeight, view.width, view.height - AZPagingContainerMenuViewDefaultHeight))
        contentScrollView.delegate = self
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.scrollsToTop = false
        contentScrollView.pagingEnabled = true
        contentScrollView.backgroundColor = UIColor.clearColor()
        view.addSubview(contentScrollView)
        
        for var index = 0; index < itemControllers.count; ++index {
            var controller = itemControllers[index]
            contentScrollView.addSubview(controller.view)
        }
        
        // MenuView setup
        menuView = AZPagingContainerMenuView(frame: CGRectMake(0, 0, 0, AZPagingContainerMenuViewDefaultHeight))
        menuView.items = titles
        menuView.delegate = self
        view.addSubview(menuView)
        
        menuListView = AZPagingContainerMenuListView(frame: CGRectMake(0, AZPagingContainerMenuViewDefaultHeight, 0, 0))
        menuListView.delegate = self
        menuListView.items = titles
        view.addSubview(menuListView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.width = view.width
        
        contentScrollView.top = menuView.height
        contentScrollView.width = view.width
        contentScrollView.height = view.height - menuView.height
        
        for var index = 0; index < itemControllers.count; ++index {
            var controller = itemControllers[index]
            controller.view.frame = CGRectMake(CGFloat(index) * contentScrollView.width, 0, contentScrollView.width, contentScrollView.height)
        }
        
        contentScrollView.contentSize = CGSizeMake(view.width * CGFloat(itemControllers.count), contentScrollView.height)
    }
    
    func setChildViewController(currentIndex: Int) {
        for var index = 0; index < itemControllers.count; ++index {
            var controller = itemControllers[index]
            if currentIndex == index {
                controller.willMoveToParentViewController(self)
                controller.beginAppearanceTransition(true, animated: false)
                addChildViewController(controller)
                controller.didMoveToParentViewController(self)
                controller.endAppearanceTransition()
            } else {
                controller.willMoveToParentViewController(nil)
                controller.beginAppearanceTransition(false, animated: false)
                controller.removeFromParentViewController()
                controller.didMoveToParentViewController(nil)
                controller.endAppearanceTransition()
            }
        }
    }
    
}

extension AZPagingContainerViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var contentOffset = scrollView.contentOffset
        var selectedIndex = Int(contentOffset.x / scrollView.width)
        setChildViewController(selectedIndex)
        menuView.selectedIndex = selectedIndex
    }
}

extension AZPagingContainerViewController: AZPagingContainerMenuViewDelegate {
    func menuView(menuView: AZPagingContainerMenuView, didSelectedIndex index: Int) {
        setChildViewController(index)
        var offsetX = CGFloat(index) * contentScrollView.width
        contentScrollView.contentOffset = CGPointMake(offsetX, 0)
        
        // 在菜品分类列表展开的时候，可以同步进行，菜品的切换
        menuListView.selectedIndex = menuView.selectedIndex
    }
    
    func menuViewDidExpandMenuList(expand: Bool) {
        if expand {
            expandMenuListView()
        } else {
            hideMenuListView()
        }
    }
    
    func expandMenuListView() {
        menuView.expandView.expandButton.userInteractionEnabled = false
        
        // 初始化菜品分类列表默认选中
        menuListView.selectedIndex = menuView.selectedIndex
        
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.expandView.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.menuListView.frame = self.contentScrollView.frame
            }) { (finished) -> Void in
                self.menuView.expandView.expandButton.userInteractionEnabled = true
                self.menuView.expandView.expand = true
        }
    }
    
    func hideMenuListView() {
        menuView.expandView.expandButton.userInteractionEnabled = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.menuView.expandView.arrowImageView.transform = CGAffineTransformMakeRotation(0)
            self.menuListView.frame = CGRectMake(0, self.contentScrollView.top, self.contentScrollView.width, 0)
            }) { (finished) -> Void in
                self.menuView.expandView.expandButton.userInteractionEnabled = true
                self.menuView.expandView.expand = false
        }
    }
}

extension AZPagingContainerViewController: AZPagingContainerMenuListViewDelegate {
    func menuListView(menuListView: AZPagingContainerMenuListView, didSelectedInex index: Int) {
        setChildViewController(index)
        var offsetX = CGFloat(index) * contentScrollView.width
        contentScrollView.contentOffset = CGPointMake(offsetX, 0)
        menuView.selectedIndex = index
        hideMenuListView()
    }
}
