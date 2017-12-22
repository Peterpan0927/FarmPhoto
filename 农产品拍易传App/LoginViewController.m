//
//  LoginViewController.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "LoginViewController.h"
#import "DrawerViewController.h"
#import "underLine.h"
#import "NetWorkTool.h"
#import "MBProgressHUD+CZ.h"

@interface LoginViewController ()<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet underLine *userNameField;
@property (weak, nonatomic) IBOutlet underLine *userPasswordFild;

@end


static NSDictionary *dict1;



@implementation LoginViewController


- (void)setborder:(UIButton *)btn WithRedis:(int)redis AndBorderWidth:(CGFloat)width AndBorderColor:(UIColor *)color{
    //设置圆角的半径
    [btn.layer setCornerRadius:redis];
    //切割超出圆角范围的子视图
    btn.layer.masksToBounds = YES;
    //设置边框的颜色
    [btn.layer setBorderColor:color.CGColor];
    //设置边框的粗细
    [btn.layer setBorderWidth:width];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSLog(@"%@", filePath);
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"账号"];
    imageView1.image = [UIImage imageNamed:@"密码"];
    self.userNameField.leftView = imageView;
    self.userPasswordFild.leftView = imageView1;
    //默认的mode不会显示出LeftView
    self.userPasswordFild.leftViewMode = UITextFieldViewModeAlways;
    self.userNameField.leftViewMode = UITextFieldViewModeAlways;
    [self setborder:self.loginBtn WithRedis:6 AndBorderWidth:1.0 AndBorderColor:[UIColor grayColor]];
    self.userPasswordFild.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnCLick:(id)sender {
    __block NSString *str;
    [MBProgressHUD showMessage:@"正在拼命登陆..." toView:self.navigationController.view ];
    //模拟网络延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        //去掉提示
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if(self.userPasswordFild.text.length && self.userNameField.text.length){
            NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
            NSDictionary *dict = @{@"userNo":self.userNameField.text, @"password":self.userPasswordFild.text};
            NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/system/account/login"];
            [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                str = [dict[@"code"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                if([str isEqualToString:@"N01"]){
                    NSLog(@"success");
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    //要保持同步，所以要返回主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.navigationController.view];
                        //保存值(key值同名的时候会覆盖的)
                        [defaults setObject:self.userNameField.text forKey:@"kUsernameKey"];
                        [defaults setObject:self.userPasswordFild.text forKey:@"kUserPassWordKey"];
                        //立即保存
                        [defaults synchronize];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                    });
                    [self saveSession:dict];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showError:@"账号密码有误!"];
                    });
                }
            } failBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"对不起，请检查你的网络状态"];
                });
            } andDict:dict andURL:url];
        }else{
            [MBProgressHUD showError:@"请输入账号和密码"];
        }
    });
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
}

- (void)saveSession:(NSDictionary *)dict{
    NSDictionary *dict1 = dict[@"contents"];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *path = [filePath stringByAppendingPathComponent:@"sessionId.plist"];
    [dict1 writeToFile:path atomically:YES];
    NSLog(@"%@", path);
}

+ (instancetype)sharedLoginVc{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return  _instance;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameField resignFirstResponder];
    [self.userPasswordFild resignFirstResponder];
}

//+ (instancetype)sharedLoginVc1{
//    static id _instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc] init];
//    });
//    return _instance;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareFo
 rSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
