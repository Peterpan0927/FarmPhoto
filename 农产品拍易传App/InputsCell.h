//
//  InputsCell.h
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/12/4.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chemicalVariety;
@property (weak, nonatomic) IBOutlet UILabel *producerName;
@property (weak, nonatomic) IBOutlet UILabel *usageAmount;

@property (weak, nonatomic) IBOutlet UILabel *safetyInterval;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *function;

@end
