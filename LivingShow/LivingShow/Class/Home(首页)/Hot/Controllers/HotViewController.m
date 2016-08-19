//
//  HotViewController.m
//  LivingShow
//
//  Created by LI on 16/8/11.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "HotViewController.h"

/** 自定义 cell */
#import "HomeADCell.h"
#import "HotLiveCell.h"

/** 自定义的舒心视图 */
#import "RefreshGifHeader.h"

/** 模型视图 */
#import "Live.h"
#import "TopAD.h"

/** 直播控制器 */
#import "LiveCollectionViewController.h"

/** 广告点击 */
#import "ADWebViewController.h"

@interface HotViewController ()

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray *lives;
/** 广告 */
@property(nonatomic, strong) NSArray *topADS;

@end

static NSString *reuseIdentifier = @"HotLiveCell";
static NSString *ADReuseIdentifier = @"HomeADCell";

@implementation HotViewController
- (NSMutableArray *)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HotLiveCell class]) bundle:nil]forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerClass:[HomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];
    
    self.currentPage = 1;
    self.tableView.mj_header = [RefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [self getTopAD];
        [self getHotLiveList];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)getTopAD
{
    [[NetWorkRequest sharedNetWorkRequest] get:@"http://live.9158.com/Living/GetAD" params:nil success:^(id object) {
        NSArray *result = object[@"data"];
        if ([self isNotEmpty:result]) {
            self.topADS = [TopAD mj_objectArrayWithKeyValuesArray:result];
            [self.tableView reloadData];
        }else{
            [self showHint:@"网络异常"];
        }
    } failure:^(NSError *error) {
        [self showHint:@"网络异常"];
    }];
}

- (void)getHotLiveList
{
    [[NetWorkRequest sharedNetWorkRequest] get:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", (unsigned long)self.currentPage] params:nil success:^(id object) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *result = [Live mj_objectArrayWithKeyValuesArray:object[@"data"][@"list"]];
        if ([self isNotEmpty:result]) {
            [self.lives addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage --;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage --;
        [self showHint:@"网络异常"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lives.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 465;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一行的 cell 上加图片轮播图
    if (indexPath.row == 0) {
        HomeADCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
        if (self.topADS.count) {
            cell.topADs = self.topADS;
            [cell setImageClickBlock:^(TopAD *topAD) {
                if (topAD.link.length) {
                    ADWebViewController *web = [[ADWebViewController alloc] initWithUrlStr:topAD.link];
                    web.navigationItem.title = topAD.title;
                    [self.navigationController pushViewController:web animated:YES];
                }
            }];
        }
        return cell;
    }
    HotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (self.lives.count) {
        Live *live = self.lives[indexPath.row - 1];
        cell.live = live;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCollectionViewController *liveVc = [[LiveCollectionViewController alloc] init];
    liveVc.lives = self.lives;
    liveVc.currentIndex = indexPath.row - 1;
    [self presentViewController:liveVc animated:YES completion:nil];
}
@end
