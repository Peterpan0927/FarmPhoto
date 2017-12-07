//
//  DrawerViewController.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "DrawerViewController.h"
#import "LeftMenuController.h"
#import "FarmPhotoViewController.h"
#import "LoginViewController.h"

#define SCREENBOUNDS [UIScreen mainScreen].bounds.size.width

@interface DrawerViewController ()

@property (nonatomic, strong) FarmPhotoViewController *mainVc;

@property (nonatomic, assign) CGFloat leftWidth;

@property (nonatomic, strong) LeftMenuController *leftMenuVc;

@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIViewController *destViewController;
@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //左边控制器默认向左偏移
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = item;
  
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    //设置阴影效果
    self.mainVc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainVc.view.layer.shadowOffset = CGSizeMake(-3, -3);
    self.mainVc.view.layer.shadowOpacity = 0.2;
    self.mainVc.view.layer.shadowRadius = 5;
}

- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)view{
    NSLog(@"sa");
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenEdgePanGestureRecognizer:)];
    pan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:pan];
    NSLog(@"sa");
}

/**
 边缘拖拽手势的回调
 */
- (void)screenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan{
    CGFloat OffsetX = [pan translationInView:pan.view].x;
    //判断手势是否结束
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateEnded) {
        if(self.mainVc.view.frame.origin.x > SCREENBOUNDS*0.5)
            [self openLeftMenu];
        else [self closeLeftMenu];
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        if (OffsetX > 0 && OffsetX < self.leftWidth) {
            self.mainVc.view.transform = CGAffineTransformMakeTranslation(OffsetX, 0);
            self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth + OffsetX, 0);
        }
    }
}


+ (instancetype)sharedDrawer{
    return  (DrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc leftWidth:(CGFloat)leftWidth{
     NSLog(@"%f", leftWidth);
    DrawerViewController *drawerVc = [[DrawerViewController alloc] init];
    [drawerVc.view addSubview:leftMenuVc.view];
    drawerVc.mainVc = (FarmPhotoViewController *)mainVc;
    drawerVc.leftWidth = leftWidth;
    drawerVc.leftMenuVc = (LeftMenuController *)leftMenuVc;
    [drawerVc.view addSubview:leftMenuVc.view];
    [drawerVc.view addSubview:mainVc.view];
    //苹果规定如果两个控制器的view为父子关系，则这两个控制器也必须为父子关系
    [drawerVc addChildViewController:leftMenuVc];
    [drawerVc addChildViewController:mainVc];

    return drawerVc;
}

- (void)openLeftMenu{
    NSLog(@"%f", self.leftWidth);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //为了实现共同偏移的效果
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(self.leftWidth, 0);
        self.leftMenuVc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //在主控制器的view上添加遮盖按钮
        [self.mainVc.view addSubview:self.coverButton];
    }];
}

- (void)closeLeftMenu{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainVc.view.transform = CGAffineTransformIdentity;
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    } completion:^(BOOL finished) {
        [self.coverButton removeFromSuperview];
        self.coverButton = nil;
    }];
}

- (UIButton *)coverButton{
    if(_coverButton == nil){
        _coverButton = [[UIButton alloc] init];
        _coverButton.backgroundColor = [UIColor clearColor];
        _coverButton.frame = self.mainVc.view.bounds;
        [_coverButton addTarget:self action:@selector(closeLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (void)switchViewController:(UIViewController *)viewController{
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
    self.destViewController = viewController;
    
    viewController.view.transform = CGAffineTransformMakeTranslation(SCREENBOUNDS, 0);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        viewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.mainVc.view.transform = CGAffineTransformIdentity;
        [self.coverButton removeFromSuperview];
        self.coverButton = nil;
    }];
}

- (void)swithToMainViewController{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.destViewController.view.transform = CGAffineTransformMakeTranslation(SCREENBOUNDS, 0);
        
        
    } completion:^(BOOL finished) {
        [self.destViewController removeFromParentViewController];
        [self.destViewController.view removeFromSuperview];
        self.destViewController = nil;
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
