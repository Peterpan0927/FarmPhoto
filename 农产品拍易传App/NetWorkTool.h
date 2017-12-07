//
//  NetWorkTool.h
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/11.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义两个block：成功回调和失败回调
typedef void(^SuccessBlock)(NSData *data, NSURLResponse *response);

typedef void(^FailBlock)(NSError *error);


@interface NetWorkTool : NSObject

+ (instancetype)sharedNetWordTool;

- (void)postWithSuccess:(SuccessBlock)SuccessBlock failBlock:(FailBlock)FailBlock andDict:(NSDictionary *)dict andURL:(NSURL *)url;

- (NSString *)getSessionId;

- (NSString *)getCompanySid;

@end
