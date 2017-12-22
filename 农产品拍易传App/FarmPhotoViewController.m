//
//  FarmPhotoViewController.m
//  农产品拍易传App
//
//  Created by 潘振鹏 on 2017/9/7.
//  Copyright © 2017年 潘振鹏. All rights reserved.
//

#import "FarmPhotoViewController.h"
#import "DrawerViewController.h"
#import "LoginViewController.h"
#import "NewFarmPhotoViewController.h"
#import "NetWorkTool.h"
#import "FarmWorkCell.h"
#import "UIImageView+WebCache.h"
#import "InputsViewController.h"


#define kScreenW [UIScreen mainScreen].bounds.size.width

#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface FarmPhotoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (atomic, assign) BOOL isDownload;

@property (atomic, assign) NSInteger count;

@property (nonatomic, strong) dispatch_group_t group;

@end

static BOOL first = YES;


@implementation FarmPhotoViewController

-(dispatch_group_t)group{
    if(_group == nil){
        _group = dispatch_group_create();
    }
    return _group;
}

- (IBAction)btnClick{
    [[DrawerViewController sharedDrawer] openLeftMenu];
}

- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)reloadTableView{
//    [self.dataArray removeAllObjects];
    [self postRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.isDownload = NO;
    [self setupRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadData" object:nil];
    [self addGestureRecognizer];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomButton.frame = CGRectMake(kScreenW - 80, kScreenH - 80, 60, 60);
    [self.bottomButton setBackgroundImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    [self.bottomButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton.layer.cornerRadius = self.bottomButton.frame.size.width/2;
    self.bottomButton.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomButton];
    self.tableView.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *view = [[UIView alloc] init];
    [[DrawerViewController sharedDrawer] addScreenEdgePanGestureRecognizerToView:view];
}


- (void)postRequest{
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
            //        NSLog(@"%@", array);
            for(NSDictionary *dict in array){
                dispatch_group_async(self.group,dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"%@",[NSThread currentThread]);
                    [self postRequestWithFarmWorkSid:dict[@"farmWorkSid"]andfarmType:dict[@"farmWorkOperateName"] andfarmpeople:dict[@"executorName"] andland:dict[@"landName"] andbase:dict[@"baseName"] andtime:dict[@"updateTime"]];
                    
                });
            }
            //        NSLog(@"%@", self.dataArray);
        } failBlock:^(NSError *error) {
            NSLog(@"getFarmWorks~Fail");
        } andDict:dict andURL:url];
}

- (void)postRequestWithFarmWorkSid:(NSString *)farmWorkSid andfarmType:(NSString *)type andfarmpeople:(NSString *)person andland:(NSString *)land andbase:(NSString *)base andtime:(NSString *)time{
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *session = [tool getSessionId];
    NSString *companySid = [tool getCompanySid];
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/system/photo/getPhotoByParams"];
    NSDictionary *dict = @{@"sessionId":session, @"companySid":companySid, @"farmWorkSid":farmWorkSid, @"type":@"farmWork"};
    [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
        NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *str = [dict1[@"code"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([str isEqualToString:@"N01"]){
            NSLog(@"success ~%@", dict1);
            NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
            NSString *realTime = [self exchangeTime:time];
            [dict2 addEntriesFromDictionary:dict1];
            [dict2 setValue:type forKey:@"farmWorkOperateName"];
            [dict2 setValue:person forKey:@"executorName"];
            [dict2 setValue:land forKey:@"landName"];
            [dict2 setValue:base forKey:@"baseName"];
            [dict2 setValue:realTime forKey:@"updateTime"];
            [dict2 setValue:farmWorkSid forKey:@"farmWorkSid"];
            [self.dataArray addObject:dict2];
            //判断是不是第一次请求，如果不是之后都是请求到一个就删除之前的一个
            if(!first){
                 [self.dataArray removeObjectAtIndex:self.count];
            }
            NSLog(@"%@",self.dataArray);
            self.count++;
            if(self.count == 5){
                NSLog(@"count的值是:%ld",self.count);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                self.isDownload = NO;
                first = NO;
            }
        }
    } failBlock:^(NSError *error) {
        NSLog(@"fail~");
    } andDict:dict andURL:url];
}

- (void)add{
   [self performSegueWithIdentifier:@"farm" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu", indexPath.item);
    FarmWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSLog(@"%@", self.dataArray);
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.farmworktype.text = dict[@"farmWorkOperateName"];
    cell.farmMan.text = [NSString stringWithFormat:@"负责人 : %@", dict[@"executorName"]];
    cell.landName.text = [NSString stringWithFormat:@"基地 : %@", dict[@"landName"]];
    cell.baseName.text = [NSString stringWithFormat:@"地块 : %@", dict[@"baseName"]];
    cell.updateTime.text = [NSString stringWithFormat:@"时间 : %@",  dict[@"updateTime"]];
    
    NSArray *array = dict[@"contents"];
    if(array.count != 0){
        NSDictionary *dict1 = array[0];
        NSURL *URL = [NSURL URLWithString: dict1[@"photoAddress"]];
        NSLog(@"%@-------imageurl", URL);
        [cell.farmWorkImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"加载中"]];
    }else{
        [cell setImageWithData:[UIImage imageNamed:@"Van"]];
    }
    
    
//    NSLog(@"%@", dict);
    
   
//    UIImage *image = [UIImage imageWithData:data];
//    NSDictionary *dict1 = @{@"farmWorkImage":image};
    cell.layer.cornerRadius = 5;
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
        
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此条农事活动" preferredStyle:UIAlertControllerStyleActionSheet];
        
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
    NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/farmwork/deleteFarmwork"];
    NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
    NSString *farmSid = self.dataArray[indexPath.row][@"farmWorkSid"];
    NSString *session = [tool getSessionId];
    NSDictionary *dict = @{@"sessionId":session, @"farmWorkSid":farmSid};
    [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
        NSLog(@"delete~success");
        [self.dataArray removeAllObjects];
        [self postRequest];
    } failBlock:^(NSError *error) {
        NSLog(@"delete~fail!");
    } andDict:(NSDictionary *)dict andURL:url];
    
}

- (NSString *)exchangeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
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
    self.count = 0;
    NSLog(@"refreshClick: -- 刷新触发 -- count :%d", self.count);
    // 此处添加刷新tableView数据的代码
    if(self.isDownload){
        NSLog(@"正在下载");
    }else{
        NSLog(@"开始下载");
        self.isDownload = YES;
        [self reloadTableView];
    }
    [refreshControl endRefreshing];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"input"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NetWorkTool *tool = [NetWorkTool sharedNetWordTool];
        NSString *session = [tool getSessionId];
        NSURL *url = [NSURL URLWithString:@"http://www.intelitea.com/api/1.0/ll/enterprice/input/getInputs"];
        NSDictionary *dict = @{@"sessionId":session, @"farmWorkSid":self.dataArray[indexPath.row][@"farmWorkSid"]};
        [tool postWithSuccess:^(NSData *data, NSURLResponse *response) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@", dict);
            if([dict[@"code"] isEqualToString:@"N01"]){
                InputsViewController *destVc = segue.destinationViewController;
                destVc.farmWorkSid = self.dataArray[indexPath.row][@"farmWorkSid"];
                destVc.dataArray = dict[@"contents"];
                NSLog(@"%@",destVc);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [destVc.tableView reloadData];
                });
            }
        } failBlock:^(NSError *error) {
            
        } andDict:dict andURL:url];
        
    }
}




@end
