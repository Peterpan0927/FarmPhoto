//
//  AppDelegate.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "LeftMenuController.h"
#import "LoginViewController.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD+CZ.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithRed:0 green:150.0f/255.0f blue:136.0f/255.0f alpha:1];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //创建箭头指向控制器
    UIViewController *loginVc = [sb instantiateViewControllerWithIdentifier:@"login"];;
    //创建主控制器

    self.window.rootViewController = loginVc;
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Logout) name:@"LogoutSuccess" object:nil];
    // Override point for customization after application launch.
    return YES;
}

- (void)LoginSuccess{
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.5];//设置动画时间
    
    animation.type = kCATransitionFade;//设置动画类型
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    //左边的个人菜单控制器
    LeftMenuController *leftViewController = [[LeftMenuController alloc] init];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //创建箭头指向控制器
    UINavigationController *navVc = sb.instantiateInitialViewController;
    //创建主控制器
    
    self.window.rootViewController = [DrawerViewController drawerVcWithMainVc:navVc leftMenuVc:leftViewController leftWidth:300 ];
    
}

- (void)Logout{
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.5];//设置动画时间
    
    animation.type = kCATransitionFade;//设置动画类型
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //创建箭头指向控制器
    UIViewController *loginVc = [sb instantiateViewControllerWithIdentifier:@"login"];;
    //创建主控制器
    
    self.window.rootViewController = loginVc;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    //1.清空缓存
    //cleanDisk:清除过期缓存，计算当前缓存大小，和设置的最大缓存数量比较，如果超出就继续删
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
    //2.取消当前所有的操作
    [[SDWebImageManager sharedManager] cancelAll];
    //3.最大并发数量
    //4.缓存文件的保存名称处理,将名称做一次md5加密作为磁盘缓存中的名字
    //5.框架内部对内存警告的处理方式？内部通过监听通知的方式清理缓存
    //6.框架内部进行缓存处理的方式？可变字典-->NSCache
    //7.如何判断图片类型？根据十六进制的文件头
    //8.如何处理下载的图片？NSURLConnection
    //9.如何处理超时时间？设置的属性
}


@end
