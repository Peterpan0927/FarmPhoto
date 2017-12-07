//
//  underLine.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "underLine.h"

@implementation underLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
