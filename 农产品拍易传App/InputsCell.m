//
//  InputsCell.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/12/4.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "InputsCell.h"

@interface InputsCell()

@property (nonatomic, weak) UIView *seperateView;

@end

@implementation InputsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [super awakeFromNib];
    //创建分割线
    UIView *seperateView = [[UIView alloc] init];
    //设置背景颜色和透明度
    seperateView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
    
    self.seperateView = seperateView;
    
    [self addSubview:seperateView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat h = 2.f;
    
    CGFloat w = self.bounds.size.width;
    
    CGFloat x = 0;
    
    CGFloat y = self.bounds.size.height - h;
    
    _seperateView.frame = CGRectMake(x, y, w, h);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
