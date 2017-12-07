//
//  FarmWorkCell.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/11/27.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "FarmWorkCell.h"

@interface FarmWorkCell()



@property (weak, nonatomic) IBOutlet UILabel *farmWorkType;

@property (weak, nonatomic) IBOutlet UILabel *farmWorkMan;

@property (nonatomic, weak) UIView *seperateView;

@end


@implementation FarmWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.farmWorkImage.layer.cornerRadius = 5;
    //创建分割线
    UIView *seperateView = [[UIView alloc] init];
    //设置背景颜色和透明度
    seperateView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
    
    self.seperateView = seperateView;
    
    [self addSubview:seperateView];
    // Initialization code
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

- (instancetype)initCellWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cellWithDict:(NSDictionary *)dict{
    return [[self alloc] initCellWithDict:dict];
}

- (void)setImageWithData:(UIImage *)image{
    self.farmWorkImage.image = image;
}
@end
