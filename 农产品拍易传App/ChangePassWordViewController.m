//
//  ChangePassWordViewController.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/10/5.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "NetWorkTool.h"
#import "underLine.h"
#import "DrawerViewController.h"
@interface ChangePassWordViewController ()



@property (weak, nonatomic) IBOutlet underLine *oldPassNumber;

@property (weak, nonatomic) IBOutlet UIButton *ChangePasswdBtn;

@property (weak, nonatomic) IBOutlet underLine *passwdNew;

@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet underLine *identifyNumber;
@end

@implementation ChangePassWordViewController
- (IBAction)ChangePasswdBtnClick:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pass= [defaults objectForKey:@"kUserPassWordKey"];
    if([self.passwdNew.text isEqualToString:self.identifyNumber.text] && self.passwdNew.text.length && self.identifyNumber.text.length  && [self.oldPassNumber.text isEqualToString:pass]){
        NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
        NSString *session = [tool getSessionId];
        NSDictionary *dict = @{@"sessionId":session, @"password":self.oldPassNumber.text, @"newPassword":self.identifyNumber.text};
        NSLog(@"%@", session);
        NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/system/account/modifyPassword"];
        [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *str = [dict[@"code"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([str isEqualToString:@"N01"]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"密码修改成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self turnBackToMainViewConttoller];
                });
                NSLog(@"success");
            }else{
                NSLog(@"%@", str);
                NSLog(@"failed");
            }
        } failBlock:^(NSError *error) {
            NSLog(@"oh sad");
        } andDict:dict andURL:url];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"旧密码错误或密码格式不对" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    self.changeButton.layer.cornerRadius = 5;
    self.changeButton.layer.masksToBounds = YES;
    self.oldPassNumber.secureTextEntry = YES;
    self.passwdNew.secureTextEntry = YES;
    self.identifyNumber.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)turnBackToMainViewConttoller{
    [[DrawerViewController sharedDrawer] swithToMainViewController];
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
