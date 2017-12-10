//
//  InputsViewController.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/10.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "InputsViewController.h"
#import "NewInputsViewController.h"
#import "InputsCell.h"
#import "UIImageView+WebCache.h"
#import "NetWorkTool.h"


#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kScreenH [UIScreen mainScreen].bounds.size.height


@interface InputsViewController ()<UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>

@property (nonatomic, strong) UIButton *bottomButton;

@property (atomic, assign) BOOL isDownload;

@end

@implementation InputsViewController

- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)imageArray{
    if(_imageArray == nil){
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupUI{
    self.isDownload = NO;
    [self setupRefresh];
    [self addGestureRecognizer];
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomButton.frame = CGRectMake(kScreenW - 80, kScreenH - 80, 60, 60);
    [self.bottomButton setBackgroundImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    [self.bottomButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton.layer.cornerRadius = self.bottomButton.frame.size.width/2;
    self.bottomButton.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomButton];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)add{
    [self performSegueWithIdentifier:@"newInputs" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataArray.count == 0){
        return 1;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InputsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputs"];
    cell.userInteractionEnabled = NO;
    if(self.dataArray.count!=0){
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        [UIView animateWithDuration:1 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
        cell.chemicalVariety.text = self.dataArray[indexPath.row][@"chemicalName"];
        cell.producerName.text = [NSString stringWithFormat:@"生产商: %@", self.dataArray[indexPath.row][@"producerName"]];
        cell.usageAmount.text = [NSString stringWithFormat:@"%@%@",self.dataArray[indexPath.row][@"usageAmountInt"], self.dataArray[indexPath.row][@"usageUnit"]];
        cell.safetyInterval.text = [NSString stringWithFormat:@"安全间隔期: %@",self.dataArray[indexPath.row][@"safeInterval"]];
        cell.function.text = [NSString stringWithFormat:@"功能: %@", self.dataArray[indexPath.row][@"function"]];
        NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
        NSString *session = [tool getSessionId];
        NSString *company = [tool getCompanySid];
        NSDictionary *dict = @{@"sessionId":session, @"companySid":company, @"inputOrderSid":self.dataArray[indexPath.row][@"inputOrderSid"], @"type":@"input"};
        NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/system/photo/getPhotoByParams"];
        [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];
//            [self.dataArray[indexPath.row] addObject:dict[@"contents"][0][@"photoAddress"]];
            NSLog(@"%@----%@", dict, dict[@"contents"][0][@"photoAddress"]);
            if(![dict[@"contents"][0][@"photoAddress"] isEqualToString:@""]){
                NSURL *URL = [NSURL URLWithString: dict[@"contents"][0][@"photoAddress"]];
//                NSURL *URL = [NSURL URLWithString:@"http://114.55.25.231:92/apqts/image/input/0/1512378572022whoami.png"];
//
                [cell.image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"加载中"]];            }
        } failBlock:^(NSError *error) {
            
        } andDict:dict andURL:url];
//        [self getPhotoWith:session andCompany:company andDict:self.dataArray[indexPath.row]];
//        NSLog(@"%lu", self.imageArray.count);
//        if(self.imageArray.count != 0){
//            NSURL *URL = [NSURL URLWithString: self.imageArray[indexPath.row]];
//            NSLog(@"%@-------imageurl", URL);
        
//        }else{
//            cell.image.image = [UIImage imageNamed:@"Van"];
//        }
//    }else{
//
        
    }
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    return cell;
}


- (void)addGestureRecognizer {
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGRAction:)];
    
    longPressGR.minimumPressDuration = 1.0; // 设置最短长按的时间
    [self.tableView addGestureRecognizer:longPressGR];
}

- (void)longPressGRAction:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressPoint = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pressPoint];
        
        if (indexPath == nil) {
            return;
        }
        
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此条投入品信息" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"indexPath.row = %ld",indexPath.row);
            
            // 删除数据
            [self deleteOrderWithIndexPath:indexPath];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertViewController addAction:okAction];
        [alertViewController addAction:cancelAction];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

-(void)deleteOrderWithIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/input/deleteInput"];
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *inputSid = self.dataArray[indexPath.row][@"inputOrderSid"];
    NSString *session = [tool getSessionId];
    NSDictionary *dict = @{@"sessionId":session, @"inputOrderSid":inputSid};
    [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
        NSLog(@"delete~success");
        dispatch_async(dispatch_get_main_queue(), ^{
            //要先回到主线程
            [self performSegueWithIdentifier:@"back" sender:nil];
        });
    } failBlock:^(NSError *error) {
        NSLog(@"delete~fail!");
    } andDict:(NSDictionary *)dict andURL:url];
    
}

// 下拉刷新
- (void)setupRefresh {
    NSLog(@"setupRefresh -- 下拉刷新");
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [refreshControl beginRefreshing];
    [self refreshClick:refreshControl];
}
// 下拉刷新触发，在此获取数据
- (void)refreshClick:(UIRefreshControl *)refreshControl {
    NSLog(@"refreshClick: -- 刷新触发");
    // 此处添加刷新tableView数据的代码
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"newInputs"]){
        NewInputsViewController *newInputVc = segue.destinationViewController;
        newInputVc.farmWorkSid = self.farmWorkSid;
        newInputVc.inputOrderSid = [NSString stringWithFormat:@"%lu", self.dataArray.count+1];
        NSLog(@"嘿嘿嘿");
    }
}


@end
