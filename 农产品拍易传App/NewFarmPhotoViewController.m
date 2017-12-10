//
//  NewFarmPhoto.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "FarmPhotoViewController.h"
#import "NewFarmPhotoViewController.h"
#import "underLine.h"
#import "LoginViewController.h"
#import "NetWorkTool.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#define kBoundary @"boundary"

@interface NewFarmPhotoViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet underLine *framTypeField;

@property (weak, nonatomic) IBOutlet underLine *farmActivityField;

@property (nonatomic, strong) NSArray *dataArray1;

@property (nonatomic, strong) NSArray *dataArray2;

@property (nonatomic, strong) UIPickerView *pickerView1;

@property (nonatomic, strong) UIPickerView *pickerView2;

@property (weak, nonatomic) IBOutlet UIButton *upLoadBtn;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSString *farmWorkSid;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end


@implementation NewFarmPhotoViewController

- (IBAction)BtnClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //相机
            UIImagePickerController *imagePickerController =  [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
        }];
        [alertController addAction:defaultAction];
    }
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //相册
        UIImagePickerController *imagePickerController =  [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:defaultAction1];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.imageButton setBackgroundImage:resultImage forState:UIControlStateNormal];
    //如果按钮创建时用的是系统风格UIButtonTypeSystem，需要在设置图片一栏设置渲染模式为"使用原图"
    
    //裁成边角
    self.imageButton.layer.cornerRadius = 10;
    self.imageButton.layer.masksToBounds = YES;
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
//{
//    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *documents = [array lastObject];
//    NSString *documentPath = [documents stringByAppendingPathComponent:@"arrayXML.xml"];
//
//    NSArray *dataArray = [NSArray arrayWithArray:assets];
//
//
//    [dataArray writeToFile:documentPath atomically:YES];
//
//
//
//    NSArray *resultArray = [NSArray arrayWithContentsOfFile:documentPath];
//    NSLog(@"%@", documentPath);
//
//
//    // 关闭图片选择界面
//    [picker dismissViewControllerAnimated:YES completion:nil];
//
//    // 遍历选择的所有图片
//    self.plCollection.photoArray = assets;
//    for (NSInteger i =0; i < assets.count; i++) {
//        // 基本配置
//        CGFloat scale = [UIScreen mainScreen].scale;
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        options.resizeMode   =PHImageRequestOptionsResizeModeExact;
//        options.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
//
//        PHAsset *asset = assets[i];
//        CGSize size =CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
//        //        // 获取图片
//        [[PHImageManager defaultManager] requestImageForAsset:asset  targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *_Nullable result,NSDictionary *_Nullable info) {
//            NSData *imageData =UIImageJPEGRepresentation([self  imageWithImageSimple:resultscaledToSize:CGSizeMake(200,200)], 0.5);
//            [self ossUpload:imageData];
//
//        }];
//    }
//}



- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    [self setborder:self.upLoadBtn WithRedis:6 AndBorderWidth:0.0 AndBorderColor:[UIColor grayColor]];
    self.framTypeField.inputView = self.pickerView1;
    self.framTypeField.inputAccessoryView = self.toolbar;
    [self setRightViewWithTextField:self.framTypeField imageName:@"tubiao"];
    [self setRightViewWithTextField:self.farmActivityField imageName:@"tubiao"];
    self.farmActivityField.inputView = self.pickerView2;
    self.farmActivityField.inputAccessoryView = self.toolbar;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == 0){
        return  self.dataArray1.count;
    }else return self.dataArray2.count;
}
//返回每一行显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //获取每一组的数据
    NSArray *group = [NSArray array];
    if(pickerView.tag == 0) {
        group = self.dataArray1;
    }else{
        group = self.dataArray2;
    }
    return group[row];
}

- (UIToolbar *)toolbar{
    if(_toolbar == nil){
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, 0, 0, 44);
        //按钮，取消 弹簧 完成
        //常用的创建方式
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
        //系统类型
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //自定义View
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
        _toolbar.items = @[cancel, flexSpace, done];
    }
    
    return _toolbar;
}

- (UIPickerView *)pickerView1{
    if(_pickerView1 == nil){
        _pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.tag = 0;
        self.pickerView1.dataSource = self;
        self.pickerView1.delegate = self;
    }
    return _pickerView1;
}

- (UIPickerView *)pickerView2{
    if(_pickerView2 == nil){
        _pickerView2 = [[UIPickerView alloc] init];
        _pickerView2.tag = 1;
        self.pickerView2.dataSource = self;
        self.pickerView2.delegate = self;
    }
    return _pickerView2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *name = [NSString string];
    if(pickerView.tag == 0){
        name = self.dataArray1[row];
        self.framTypeField.text = name;
    }else{
        name = self.dataArray2[row];
        self.farmActivityField.text = name;
    }
}

- (NSArray *)dataArray1{
    if(_dataArray1 == nil){
        _dataArray1 = @[@"种子处理", @"叶子处理", @"作物处理", @"栽培处理"];
    }
    return _dataArray1;
}

- (NSArray *)dataArray2{
    if(_dataArray2 == nil){
        _dataArray2 = @[@"清洗", @"除草", @"浇水"];
    }
    return _dataArray2;
}

- (void)cancelClick{
    self.farmActivityField.text = @"";
    self.framTypeField.text = @"";
    [self.view endEditing:YES];
}

- (void)btnClick{
    [self.view endEditing:YES];
}

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

-(void)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName{
    
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 40)];
    rightView.image = [UIImage imageNamed:imageName];
    rightView.contentMode = UIViewContentModeCenter;
    textField.rightView = rightView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
}

- (IBAction)submitBtnClick:(id)sender {
    if(self.farmActivityField.text.length && self.framTypeField.text.length){
        self.upLoadBtn.enabled = NO;
        [self addFarmWork];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"图片上传失败，请完善上传的信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}



- (void)addFarmWork{
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *session = [tool getSessionId];
    NSString *companySid = [tool getCompanySid];
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/farmwork/addFarmwork"];
    NSDate *date = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSDictionary *dict = @{@"sessionId":session, @"landNo":@"WY001001", @"landSid":@"1", @"baseSid":@"1",@"companySid":companySid, @"farmWorkVarietyCode":@"NSFL00103",  @"farmWorkVarietyName":self.framTypeField.text, @"farmWorkOperateCode":@"NSCZ0010301",  @"farmWorkOperateName":self.farmActivityField.text,
        @"executorName":@"pan",
        @"executorWorkno":@"11001",
        @"updateWriterName":@"pan",
        @"updateWriterNo":@"13100014582",
        @"note":@"hehe",
        @"executeDatetime":date2
    };
    [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];
        NSLog(@"%@～～～～～", dict);
        [self getFarmWorkSid];
    } failBlock:^(NSError *error) {
        
    } andDict:dict andURL:url];
}

- (void)Success{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"图片已经上传成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
        });
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    }

- (void)Fail{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"图片上传失败，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)uploadImage{
    //创建请求
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/system/photo/uploadPhotoByParams"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    request.HTTPMethod = @"POST";
    //设置请求头部
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSString *name = @"test";
    request.HTTPBody = [self getHTTPBodyWithName:name];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError * error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *str = [dict[@"code"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@", str);
        if([str isEqualToString:@"N01"]){
            [self Success];
        }else{
            [self Fail];
        }
    }] resume];
    
}

- (NSData *)getHTTPBodyWithName:(NSString *)name{
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    //将需要上传的文件格式转换为二进制数据
    NSMutableData *data = [NSMutableData data];
    //上传文件的上边界
    NSMutableString *headerStrM = [NSMutableString stringWithFormat:@"--%@\r\n", kBoundary];
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=\"file\";  filename=\"%@\"  \r\n", @"whoami.png"];
    
    [headerStrM appendFormat:@"Content-Type: image/jpeg, image,png \r\n\r\n"];
    
    NSData *photo;
    UIImage *image = [self.imageButton backgroundImageForState:UIControlStateNormal];
//    UIImage *image = self.imageButton.imageView.image;
//    UIImage *image = [UIImage imageNamed:@"Van.jpeg"];
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        photo = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        photo = UIImageJPEGRepresentation(image, 1.0);
    }
    
    
    //
    //    NSData *photo = [NSData dataWithContentsOfFile:@"/Users/peterpan/Downloads/WeFamily_icon.png"];
    NSString *session = [tool getSessionId];
    NSString *sid = [NSString stringWithFormat:@"%@", self.farmWorkSid];
    NSString *company = [NSString stringWithFormat:@"%@", [tool getCompanySid]];
    NSLog(@"%@", sid);
    NSDictionary *dict = @{@"sessionId":session,@"companySid":company, @"farmWorkSid":sid, @"updateWriterNo":@"11001", @"updateWriterName":@"pan", @"note":@"test", @"type":@"farmWork"};
    NSLog(@"%@", dict);
    
    for (NSString *key in dict) {
        //循环参数按照部分1、2、3那样循环构建每部分数据
        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",kBoundary,key];
        NSLog(@"%@", pair);
        [data appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
        
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            NSLog(@"%@", value);
            [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([value isKindOfClass:[NSData class]]){
            [data appendData:value];
        }
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSLog(@"%@", headerStrM);
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:photo];
    //一定要注意换行的问题，不能少换一行
    
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n\r\n--%@--\r\n", kBoundary];
    NSLog(@"%@", footerStrM);
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];

    return data;
}

- (NSData *)theWrong{
    //验证格式
    NSMutableString *str = [NSMutableString string];
    //将需要上传的文件格式转换为二进制数据
    NSMutableData *data = [NSMutableData data];
    //上传文件的上边界
    NSMutableString *headerStrM = [NSMutableString stringWithFormat:@"\r\n--%@\r\n", kBoundary];
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=\"file\";  filename=\"%@\"\r\n", @"hello.png"];
    
    [headerStrM appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    UIButton *button = (UIButton *)[self.view viewWithTag:1004];
    
    UIImage *image = [button backgroundImageForState:UIControlStateNormal];
    
    NSData *photo = UIImagePNGRepresentation(image);
    //
    //    NSData *photo = [NSData dataWithContentsOfFile:@"/Users/peterpan/Downloads/WeFamily_icon.png"];
    NSString *encodedImageStr = [photo base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"%@", encodedImageStr);
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *session = [tool getSessionId];
    NSDictionary *dict = @{@"sessionId":session,@"companySid":@"34", @"farmWorkSid":self.farmWorkSid, @"updateWriterNo":@"80000005@1.com", @"updateWriterName":@"测试用户5", @"note":@"测试", @"type":@"farmWork"};
    NSLog(@"%@", session);
    
    for (NSString *key in dict) {
        //循环参数按照部分1、2、3那样循环构建每部分数据
        NSString *pair = [NSString stringWithFormat:@"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",kBoundary,key];
        [data appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
        [str appendString:pair];
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([value isKindOfClass:[NSData class]]){
            [data appendData:value];
        }
        [str appendString:value];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [str appendString:headerStrM];
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData:photo];
    //一定要注意换行的问题，不能少换一行
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n\r\n--%@--\r\n", kBoundary];
    [str appendString:footerStrM];
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", str);
    return data;
  
}

- (void)getFarmWorkSid{
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *session = [tool getSessionId];
    NSString *companySid = [tool getCompanySid];
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/farmwork/getFarmworks"];
    NSDictionary *dict = @{@"sessionId":session,@"companySid":companySid ,@"landSid":@"-1", @"baseSid":@"-1", @"number":@"5", @"page":@"1"};
    [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *dict1 = dict[@"contents"];
        NSArray *array = dict1[@"list"];
        NSLog(@"getFarmWorks~success");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.farmWorkSid = array[0][@"farmWorkSid"];
            NSLog(@"%@", self.farmWorkSid);
            [self uploadImage];
        });
        
        } failBlock:^(NSError *error) {
            NSLog(@"getFarmWorks~Fail");
        } andDict:dict andURL:url];
}

@end
