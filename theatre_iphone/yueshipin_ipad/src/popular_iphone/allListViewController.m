//
//  allListViewController.m
//  yueshipin
//
//  Created by 08 on 12-12-24.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "allListViewController.h"
#import "AFServiceAPIClient.h"
#import "ServiceConstants.h"
#import "AllListViewCell.h"
#import "UIImageView+WebCache.h"
#import "ListDetailViewController.h"
#import "MBProgressHUD.h"
#import "CacheUtility.h"
#import "IphoneSettingViewController.h"
#import "SearchPreViewController.h"
#import "UIUtility.h"
#import "UIImage+Scale.h"
#import "IphoneDownloadViewController.h"
#import "DownLoadManager.h"
#import "CommonMotheds.h"
#import "DownLoadManager.h"
#import "DimensionalCodeScanViewController.h"
#import "ContainerUtility.h"
#import "UnbundingViewController.h"
#define pageSize 20
#define MOVIE_TYPE 9001
#define TV_TYPE 9000
#define BUNDING_BUTTON_TAG 19999
#define BUNDING_HEIGHT 35
enum
{
    TYPE_BUNDING_TV = 1,
    TYPE_UNBUNDING
};
@interface allListViewController ()

@end

@implementation allListViewController
@synthesize listArray = listArray_;
@synthesize tableList = tableList_;
@synthesize customNavigationButtonView = customNavigationButtonView_;
@synthesize pullToRefreshManager = pullToRefreshManager_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)parseTopsListData:(id)result
{
    self.listArray = [[NSMutableArray alloc]initWithCapacity:pageSize];
    NSString *responseCode = [result objectForKey:@"res_code"];
    if(responseCode == nil){
        NSArray *tempTopsArray = [result objectForKey:@"tops"];
        if(tempTopsArray.count > 0){
           [[CacheUtility sharedCache] putInCache:@"top_list" result:result];
            [ self.listArray addObjectsFromArray:tempTopsArray];
        }
    }
    else {
      
    }
}


-(void)loadData{
    [CommonMotheds showNetworkDisAbledAlert:self.view];
    MBProgressHUD *tempHUD;
    id cacheResult = [[CacheUtility sharedCache] loadFromCache:@"top_list"];
    if(cacheResult != nil){
        self.listArray = [[NSMutableArray alloc]initWithCapacity:pageSize];
        NSString *responseCode = [cacheResult objectForKey:@"res_code"];
        if(responseCode == nil){
            NSArray *tempTopsArray = [cacheResult objectForKey:@"tops"];
            if(tempTopsArray.count > 0){
                [ self.listArray addObjectsFromArray:tempTopsArray];
            }
        }
    } else {
        if(tempHUD == nil){
            tempHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:tempHUD];
            tempHUD.labelText = @"加载中...";
            tempHUD.opacity = 0.5;
            [tempHUD show:YES];
        }
    }

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"1", @"page_num", [NSNumber numberWithInt:pageSize], @"page_size", nil];
    [[AFServiceAPIClient sharedClient] getPath:kPathTops parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        [self parseTopsListData:result];
        [tempHUD hide:YES];
        [self refreshCompleted];
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if(self.listArray == nil){
            self.listArray = [[NSMutableArray alloc]initWithCapacity:10];
        }
        [self refreshCompleted];
        [tempHUD hide:YES];
        [UIUtility showDetailError:self.view error:error];
    }];


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_common.png"]];
    backGround.frame = CGRectMake(0, 0, 320, kFullWindowHeight);
    [self.view addSubview:backGround];
    self.title = @"悦单";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 55, 44);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"search_f.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(0, 0, 55, 44);
//    rightButton.backgroundColor = [UIColor clearColor];
//    [rightButton setImage:[UIImage imageNamed:@"scan_btn.png"] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"scan_btn_f.png"] forState:UIControlStateHighlighted];
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight-92) style:UITableViewStylePlain];
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableList];
    
    pullToRefreshManager_ = [[PullRefreshManagerClinet alloc] initWithTableView:tableList_];
    pullToRefreshManager_.delegate = self;
    reloads_ = 2;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managerTVBunding)
                                                 name:@"bundingTVSucceeded"
                                               object:nil];
   
}
- (void)viewDidUnload{
    [super viewDidUnload];
    tableList_ = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self managerTVBunding];
    if (0 == self.listArray.count)
    {
        [self loadData];
    }
    return;
    
}

-(void)search:(id)sender{
    SearchPreViewController *searchViewCotroller = [[SearchPreViewController alloc] init];
    searchViewCotroller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewCotroller animated:YES];

}

-(void)setting:(id)sender{
    UIImageView * scanView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"scan_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 342.5, 0)]];
    scanView.frame = CGRectMake(0, 0, 320, (kCurrentWindowHeight - 44));
    scanView.backgroundColor = [UIColor clearColor];
    
    DimensionalCodeScanViewController * reader = [DimensionalCodeScanViewController new];
    reader.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    reader.showsZBarControls = NO;
    reader.showsHelpOnFail = NO;
    reader.showsCameraControls = NO;
    reader.cameraOverlayView = scanView;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    reader.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reader
                                         animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    AllListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AllListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];   
    }
    NSDictionary *item = [self.listArray objectAtIndex:indexPath.row];
    NSMutableArray *items = [item objectForKey:@"items"];
    cell.label.text = [item objectForKey:@"name"];
    for (int i = 0; i< [items count];i++) {
        switch (i) {
            case 0:
                cell.label1.text = [[items objectAtIndex:0] objectForKey:@"prod_name" ];
                break;
            case 1:
                cell.label2.text = [[items objectAtIndex:1] objectForKey:@"prod_name" ];
                break;
            case 2:
                cell.label3.text = [[items objectAtIndex:2] objectForKey:@"prod_name" ];
                break;
            case 3:
                cell.label4.text = [[items objectAtIndex:3] objectForKey:@"prod_name" ];
                break;
            case 4:
                cell.label5.text = [[items objectAtIndex:4] objectForKey:@"prod_name" ];
                break;
                
            default:
                break;
        }
    }
   
    [cell.imageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"pic_url"]] /*placeholderImage:[UIImage imageNamed:@"video_placeholder"]*/];
    
    NSString *typeStr = [item objectForKey:@"prod_type"];
    if ([typeStr isEqualToString:@"1"]) {
        cell.typeImageView.image = [UIImage imageNamed:@"tab1_movieflag.png"];
    }
    else if ([typeStr isEqualToString:@"2"]){
        cell.typeImageView.image = [UIImage imageNamed:@"tab1_seriesflag.png"];
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CommonMotheds showNetworkDisAbledAlert:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [self.listArray objectAtIndex:indexPath.row];
    ListDetailViewController *listDetailViewController = [[ListDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    NSString *type = [item objectForKey:@"prod_type"];
    if ([type isEqualToString:@"1"]) {
        listDetailViewController.Type = MOVIE_TYPE;
    }
    else if ([type isEqualToString:@"2"]||[type isEqualToString:@"131"]){
        listDetailViewController.Type = TV_TYPE;
    }
    
    listDetailViewController.topicId = [item objectForKey:@"id"];
    listDetailViewController.title = [item objectForKey:@"name"];
    listDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listDetailViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [pullToRefreshManager_ scrollViewBegin];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [pullToRefreshManager_ scrollViewScrolled:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [pullToRefreshManager_ scrollViewEnd:scrollView];
}


#pragma mark -
#pragma mark - PullRefreshManagerClinetDelegate
-(void)pulltoReFresh{
    reloads_ = 2;
    [self loadData];
}

-(void)pulltoLoadMore{
    [CommonMotheds showNetworkDisAbledAlert:self.view];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:reloads_], @"page_num", [NSNumber numberWithInt:pageSize], @"page_size", nil];
    [[AFServiceAPIClient sharedClient] getPath:kPathTops parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        NSString *responseCode = [result objectForKey:@"res_code"];
        NSArray *tempTopsArray;
        if(responseCode == nil){
            tempTopsArray = [result objectForKey:@"tops"];
            if(tempTopsArray.count > 0){
                [self.listArray addObjectsFromArray:tempTopsArray];
                reloads_ ++;
            }
        } else {
            
        }
        [self loadMoreCompleted];
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        [UIUtility showDetailError:self.view error:error];
        [pullToRefreshManager_ refreshCompleted];
    }];
    
}


- (void)refreshCompleted {
    [tableList_ reloadData];
    [pullToRefreshManager_ refreshCompleted];
}

-(void)loadMoreCompleted{
    [tableList_ reloadData];
    pullToRefreshManager_.canLoadMore = YES;
    [pullToRefreshManager_ loadMoreCompleted];
}

#pragma mark -
#pragma mark - TVBunding
-(void)showBundingView{
    UIButton *btn = (UIButton *)[self.view viewWithTag:BUNDING_BUTTON_TAG];
    if (btn == nil) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 320, BUNDING_HEIGHT);
        [btn setBackgroundImage:[UIImage imageNamed:@"bunding_tv.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bunding_tv_s.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = BUNDING_BUTTON_TAG;
        [self.view addSubview:btn];
    }
    btn.hidden = NO;
    
    self.tableList.frame = CGRectMake(0, BUNDING_HEIGHT, 320, kCurrentWindowHeight-92-BUNDING_HEIGHT);
}

-(void)reFreshViewController{
    [self pulltoReFresh];
}

-(void)dismissBundingView{
    UIButton *btn = (UIButton *)[self.view viewWithTag:BUNDING_BUTTON_TAG];
    btn.hidden = YES;
    
   self.tableList.frame = CGRectMake(0, 0, 320, kCurrentWindowHeight-92);
}
- (void)managerTVBunding
{
    NSString *userId = (NSString *)[[ContainerUtility sharedInstance]attributeForKey:@"kUserId"];
    NSDictionary * data = (NSDictionary *)[[ContainerUtility sharedInstance] attributeForKey:[NSString stringWithFormat:@"%@_isBunding",userId]];
    NSNumber *isbunding = [data objectForKey:KEY_IS_BUNDING];
    if (![isbunding boolValue] || nil == isbunding)
    {
        [self setViewType:TYPE_UNBUNDING];
    }
    else
    {
        [self setViewType:TYPE_BUNDING_TV];
    }
  
}

- (void)setViewType:(NSInteger)type
{
    if (TYPE_BUNDING_TV == type)
    {
        [self showBundingView];
        
    }
    else if (TYPE_UNBUNDING == type)
    {
        [self dismissBundingView];
    }
}

-(void)pushView{
    UnbundingViewController *ubCtrl = [[UnbundingViewController alloc] init];
    [self.navigationController pushViewController:ubCtrl animated:YES];
}

@end
