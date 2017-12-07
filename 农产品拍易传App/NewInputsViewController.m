//
//  NewInputsViewController.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/13.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "NewInputsViewController.h"
#import "underLine.h"
#import "NetWorkTool.h"

#define kBoundary @"boundary"

@interface NewInputsViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet underLine *inputsName;

@property (weak, nonatomic) IBOutlet underLine *manufacturerName;

@property (weak, nonatomic) IBOutlet underLine *safetyInterval;

@property (weak, nonatomic) IBOutlet underLine *useNumber;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (weak, nonatomic) IBOutlet underLine *company;

@property (nonatomic, strong) NSArray *dataArray0;

@property (nonatomic, strong) NSArray *dataArray1;

@property (nonatomic, strong) NSArray *dataArray2;

@property (nonatomic, strong) NSArray *dataArray3;

@property (nonatomic, strong) NSArray *dataArray4;

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIPickerView *pickerView0;

@property (nonatomic, strong) UIPickerView *pickerView1;

@property (nonatomic, strong) UIPickerView *pickerView2;

@property (nonatomic, strong) UIPickerView *pickerView3;

@property (nonatomic, strong) UIPickerView *pickerView4;


@end

@implementation NewInputsViewController


- (IBAction)photoBtnClick:(id)sender {
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
        [self presentViewController:imagePickerController animated:YES completion:^{}];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setborder:self.submitBtn WithRedis:6 AndBorderWidth:0 AndBorderColor: [UIColor greenColor]];
    [self setUIField];
            // Do any additional setup after loading the view.
}


- (void)setUIField{
    [self setRightViewWithTextField:self.inputsName imageName:@"tubiao"];
    [self setRightViewWithTextField:self.manufacturerName imageName:@"tubiao"];
    [self setRightViewWithTextField:self.safetyInterval imageName:@"tubiao"];
    [self setRightViewWithTextField:self.useNumber imageName:@"tubiao"];
    [self setRightViewWithTextField:self.company imageName:@"tubiao"];

    self.inputsName.inputView = self.pickerView0;
    self.inputsName.inputAccessoryView = self.toolbar;
    self.manufacturerName.inputView = self.pickerView1;
    self.manufacturerName.inputAccessoryView = self.toolbar;
    self.safetyInterval.inputView = self.pickerView2;
    self.safetyInterval.inputAccessoryView = self.toolbar;
    self.useNumber.inputView = self.pickerView3;
    self.useNumber.inputAccessoryView = self.toolbar;
    self.company.inputView = self.pickerView4;
    self.company.inputAccessoryView = self.toolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *name = [NSString string];
    if(pickerView.tag == 0){
        name = self.dataArray0[row];
        self.inputsName.text = name;
    }else if(pickerView.tag == 1){
        name = self.dataArray1[row];
        self.manufacturerName.text = name;
    }else if (pickerView.tag == 2){
        name = self.dataArray2[row];
        self.safetyInterval.text = name;
    }else if (pickerView.tag == 3){
        name = self.dataArray3[row];
        self.useNumber.text = name;
    }else if (pickerView.tag == 4){
        name = self.dataArray4[row];
        self.company.text = name;
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == 0){
        return self.dataArray0.count;
    }else if(pickerView.tag == 1){
        return self.dataArray1.count;
    }else if(pickerView.tag == 2){
        return self.dataArray2.count;
    }else if(pickerView.tag == 3){
        return self.dataArray3.count;
    }else if(pickerView.tag == 4){
        return self.dataArray4.count;
    }
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *group = [NSArray array];
    if(pickerView.tag == 0){
        group = self.dataArray0;
        return group[row];
    }else if(pickerView.tag == 1){
        group = self.dataArray1;
        return group[row];
    }else if (pickerView.tag == 2){
        group = self.dataArray2;
        return group[row];
    }else if (pickerView.tag == 3){
        group = self.dataArray3;
        return group[row];
    }else if (pickerView.tag == 4){
        group = self.dataArray4;
        return group[row];
    }
    return group[row];
}

- (UIPickerView *)pickerView0{
    if(_pickerView0 == nil){
        _pickerView0 = [[UIPickerView alloc] init];
        _pickerView0.tag = 0;
        self.pickerView0.delegate = self;
        self.pickerView0.dataSource = self;
    }
    return _pickerView0;
}

- (UIPickerView *)pickerView1{
    if(_pickerView1 == nil){
        _pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.tag = 1;
        self.pickerView1.delegate = self;
        self.pickerView1.dataSource = self;
    }
    return _pickerView1;
}

- (UIPickerView *)pickerView2{
    if(_pickerView2 == nil){
        _pickerView2 = [[UIPickerView alloc] init];
        _pickerView2.tag = 2;
        self.pickerView2.delegate = self;
        self.pickerView2.dataSource = self;
    }
    return _pickerView2;
}

- (UIPickerView *)pickerView3{
    if(_pickerView3 == nil){
        _pickerView3 = [[UIPickerView alloc] init];
        _pickerView3.tag = 3;
        self.pickerView3.delegate = self;
        self.pickerView3.dataSource = self;
    }
    return _pickerView3;
}

- (UIPickerView *)pickerView4{
    if(_pickerView4 == nil){
        _pickerView4 = [[UIPickerView alloc] init];
        _pickerView4.tag = 4;
        self.pickerView4.delegate = self;
        self.pickerView4.dataSource = self;
    }
    return _pickerView4;
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


- (NSArray *)dataArray0{
    if(_dataArray0 == nil){
        _dataArray0 = @[@"沼液", @"菜籽饼", @"农家肥"];
    }
    return _dataArray0;
}

- (NSArray *)dataArray1{
    if(_dataArray1 == nil){
        _dataArray1 = @[@"茶农自制", @"农户自制"];
    }
    return _dataArray1;
}

- (NSArray *)dataArray2{
    if(_dataArray2 == nil){
        _dataArray2 = @[@"10天", @"15天",@"20天",@"25天",@"1个月"];
    }
    return _dataArray2;
}

- (NSArray *)dataArray3{
    if(_dataArray3 == nil){
        _dataArray3 = @[@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    }
    return _dataArray3;
}

- (NSArray *)dataArray4{
    if(_dataArray4 == nil){
        _dataArray4 = @[@"斤", @"公斤", @"毫升",@"升",@"克",@"毫克"];
    }
    return _dataArray4;
}

- (void)btnClick{
    [self.view endEditing:YES];
}

- (void)cancelClick{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitBtnClick:(UIButton *)sender {
    if(self.manufacturerName.text.length && self.inputsName.text.length && self.useNumber.text.length && self.company.text.length && self.safetyInterval.text.length){
        self.submitBtn.enabled = NO;
        NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
        NSString *companySid = [tool getCompanySid];
        NSString *session = [tool getSessionId];
        NSDictionary *dict = @{@"sessionId":session, @"inputOrderSid":self.inputOrderSid, @"companySid":companySid, @"farmWorkSid":self.farmWorkSid, @"chemicalName":self.inputsName.text, @"chemicalVariety": @"化肥",
                               @"effectiveConstituent":@"有机质、氮磷钾",
                               @"function":@"打破休眠、催芽、提高作物的抗逆性",
                             @"producerName":self.manufacturerName.text,
                               @"producerNo":@"scs001",
                               @"usageAmountInt":self.useNumber.text,
                               @"usageAmountNumerato":@"2",
                               @"usageAmountDenominator":@"10",
                               @"usageUnit":self.company.text,
                               @"safeInterval":self.safetyInterval.text,
                               @"updateWriterName":@"张伟",
                               @"updateWriterNo":@"13100014582",
                               @"note":@"addtest"};
        NSLog(@"%@", dict);
        NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/input/addInput"];
        [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];
            NSLog(@"%@", dict);
            NSString *str = [dict[@"code"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([str isEqualToString:@"N01"]){
                [self getInputOrderSid];
            }else{
            }
        } failBlock:^(NSError *error) {
            
        } andDict:dict andURL:url];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"上传失败，请完善上传的信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)getInputOrderSid{
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *session = [tool getSessionId];
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/input/getInputs"];
    NSDictionary *dict = @{@"sessionId":session, @"farmWorkSid":self.farmWorkSid};
    [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@", dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = dict[@"contents"];
            self.inputOrderSid = array[array.count-1][@"inputOrderSid"];
            NSLog(@"%@", self.inputOrderSid);
            [self uploadImage];
        });
    } failBlock:^(NSError *error) {
         
     } andDict:dict andURL:url];
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
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=\"file\";  filename=\"%@\"  \r\n", @"whoami.jpg"];
    
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
    NSString *sid = [NSString stringWithFormat:@"%@", self.inputOrderSid];
    NSLog(@"%@", sid);
    NSDictionary *dict = @{@"sessionId":session,@"companySid":@"34", @"inputOrderSid":sid, @"updateWriterNo":@"11001", @"updateWriterName":@"pan", @"note":@"test", @"type":@"input"};
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

- (void)Success{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"图片已经上传成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
@end
