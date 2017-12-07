//
//  InputsViewController.h
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/10.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSString *farmWorkSid;

@property (nonatomic, strong) NSMutableArray *imageArray;



@end
