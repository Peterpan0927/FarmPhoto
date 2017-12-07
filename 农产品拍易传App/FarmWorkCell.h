//
//  FarmWorkCell.h
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/11/27.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FarmWorkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *farmworktype;
@property (weak, nonatomic) IBOutlet UIImageView *farmWorkImage;
@property (weak, nonatomic) IBOutlet UILabel *farmMan;
@property (weak, nonatomic) IBOutlet UILabel *baseName;
@property (weak, nonatomic) IBOutlet UILabel *landName;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
- (instancetype)initCellWithDict:(NSDictionary *)dict;

+ (instancetype)cellWithDict:(NSDictionary *)dict;

- (void)setImageWithData:(UIImage *)image;
@end
