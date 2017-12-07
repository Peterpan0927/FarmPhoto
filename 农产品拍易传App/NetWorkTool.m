//
//  NetWorkTool.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/11.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "NetWorkTool.h"
#import "LoginViewController.h"
#import "FarmPhotoViewController.h"


@interface NetWorkTool ()

@end


@implementation NetWorkTool


- (void)postWithSuccess:(SuccessBlock)SuccessBlock failBlock:(FailBlock)FailBlock andDict:(NSDictionary *)dict andURL:(NSURL *)url{
    //创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法为post,默认为get
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置请求体
    NSString *str1 = [self ObjectTojsonString:dict];
    NSData *data = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError * error) {
        if(data && !error){
            //执行成功回调
            if(SuccessBlock){
                SuccessBlock(data, response);
            }
        }else{
            FailBlock(error);
        }
    }] resume];
}

-(NSString*)ObjectTojsonString:(id)object

{
    
    NSString *jsonString = [[NSString
                             
                             alloc]init];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization
                        
                        dataWithJSONObject:object
                        
                        options:NSJSONWritingPrettyPrinted
                        
                        error:&error];
    
    if (! jsonData) {
        
        NSLog(@"error: %@", error);
        
    } else {
        
        jsonString = [[NSString
                       
                       alloc] initWithData:jsonData
                      
                      encoding:NSUTF8StringEncoding];
        
    }
    //去掉json字符串中不需要的字符
    NSMutableString *mutStr = [NSMutableString
                               
                               stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" "
     
                            withString:@""
     
                               options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n"
     
                            withString:@""
     
                               options:NSLiteralSearch range:range2];
    NSRange range3 = {0, mutStr.length};
    NSString * str = @"\\";
    [mutStr replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch range:range3];
    
    return mutStr;
    
}

- (NSString *)getSessionId{
    
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *path = [filePath stringByAppendingPathComponent:@"sessionId.plist"];
    
    NSDictionary *sessionDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"%@", sessionDict);
    
    NSString *session = sessionDict[@"sessionId"];
    
    return session;
}
- (NSString *)getCompanySid{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *path = [filePath stringByAppendingPathComponent:@"sessionId.plist"];
    
    NSDictionary *sessionDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"%@", sessionDict);
    
    NSString *companySid = sessionDict[@"companySid"];
    
    return companySid;
}
+ (instancetype)sharedNetWordTool{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return  _instance;
}



@end
