//
//  DrawerViewController.h
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawerViewController : UIViewController

+ (instancetype)sharedDrawer;

+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc leftWidth:(CGFloat)leftWidth;

- (void)openLeftMenu;

- (void)closeLeftMenu;

- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)view;

- (void)switchViewController:(UIViewController *)viewController;

- (void)swithToMainViewController;
@end
