//
//  MovieDetailViewController.m
//  yueshipin_ipad
//
//  Created by joyplus1 on 12-11-20.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "LightMenuBar.h"
#import "ShowListViewController.h"
#import "CommonHeader.h"
#import "ProgramViewController.h"
#import "MediaPlayerViewController.h"
#import "CommentListViewController.h"

#define LEFT_GAP 50
#define USE_CUSTOM_DISPLAY 0

@interface ShowDetailViewController (){
    ShowListViewController *listViewController;
    NSMutableArray *commentArray;
    NSArray *episodeArray;
    CommentListViewController *commentListViewController;
    UIButton *introBtn;
    float introContentHeight;
    BOOL introExpand;
    UITapGestureRecognizer *tapGesture;
}

@end

@implementation ShowDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBgScrollView:nil];
    [self setPlaceholderImage:nil];
    [self setFilmImage:nil];
    [self setTitleImage:nil];
    [self setTitleLabel:nil];
    [self setScoreLabel:nil];
    [self setDoulanLogo:nil];
    [self setActorLabel:nil];
    [self setActorName1Label:nil];
    [self setActorName2Label:nil];
    [self setActorName3Label:nil];
    [self setPlayLabel:nil];
    [self setPlayTimeLabel:nil];
    [self setRegionLabel:nil];
    [self setRegionNameLabel:nil];
    [self setDingBtn:nil];
    [self setCollectionBtn:nil];
    [self setPlayBtn:nil];
    [self setShareBtn:nil];
    [self setAddListBtn:nil];
    [self setLineImage:nil];
    [self setIntroImage:nil];
    [self setIntroBgImage:nil];
    [self setIntroContentTextView:nil];
    [self setCommentImage:nil];
    [self setNumberLabel:nil];
    [self setCommentBtn:nil];
    [self setDingNumberImage:nil];
    [self setCollectioNumber:nil];
    [self setPlayRoundBtn:nil];
    [self setDingNumberLabel:nil];
    [self setCollectionNumberLabel:nil];
    [self setCloseBtn:nil];
    [super viewDidUnload];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bgScrollView.frame = CGRectMake(0, 260, self.view.frame.size.width, self.view.frame.size.height);
    [self.bgScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.5)];
    
    self.closeBtn.frame = CGRectMake(470, 20, 40, 42);
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"cancel_pressed"] forState:UIControlStateHighlighted];
    [self.closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.filmImage.frame = CGRectMake(LEFT_GAP+6, 84, 205, 300);
    
    self.placeholderImage.frame = CGRectMake(LEFT_GAP, 78, 217, 312);
    self.placeholderImage.image = [UIImage imageNamed:@"movie_frame"];
    
    self.playRoundBtn.frame = CGRectMake(0, 0, 63, 63);
    [self.playRoundBtn setBackgroundImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
    [self.playRoundBtn setBackgroundImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateHighlighted];
    [self.playRoundBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.playRoundBtn.center = self.filmImage.center;
    
    self.titleImage.frame = CGRectMake(LEFT_GAP, 35, 62, 26);
    self.titleImage.image = [UIImage imageNamed:@"detail_title"];
    
    self.titleLabel.frame = CGRectMake(290, 85, 180, 20);
    self.scoreLabel.frame = CGRectMake(290, 110, 50, 20);
    self.doulanLogo.frame = CGRectMake(335, 113, 15, 15);
    self.doulanLogo.image = [UIImage imageNamed:@"douban"];
    
    self.playBtn.frame = CGRectMake(290, 150, 185, 40);
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play_pressed"] forState:UIControlStateHighlighted];
    [self.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    self.actorLabel.frame = CGRectMake(290, 210, 80, 15);
    self.actorName1Label.frame = CGRectMake(335, 210, 100, 15);
    self.actorName2Label.frame = CGRectMake(335, 235, 100, 15);
    self.actorName3Label.frame = CGRectMake(335, 260, 100, 15);
    self.playLabel.frame = CGRectMake(290, 290, 80, 15);
    self.playTimeLabel.frame = CGRectMake(370, 290, 100, 15);
    self.regionLabel.frame = CGRectMake(290, 330, 50, 15);
    self.regionNameLabel.frame = CGRectMake(335, 330, 100, 15);
    
    self.dingNumberImage.frame = CGRectMake(290, 360, 75, 24);
    self.dingNumberImage.image = [UIImage imageNamed:@"pushinguser"];
    self.dingNumberLabel.frame = CGRectMake(295, 360, 40, 24);
    
    self.collectioNumber.frame = CGRectMake(390, 360, 84, 24);
    self.collectioNumber.image = [UIImage imageNamed:@"collectinguser"];
    self.collectionNumberLabel.frame = CGRectMake(395, 360, 40, 24);
    
    self.dingBtn.frame = CGRectMake(LEFT_GAP, 405, 55, 34);
    [self.dingBtn setBackgroundImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.dingBtn setBackgroundImage:[UIImage imageNamed:@"push_pressed"] forState:UIControlStateHighlighted];
    [self.dingBtn addTarget:self action:@selector(dingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectionBtn.frame = CGRectMake(115, 405, 74, 34);
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"collection_pressed"] forState:UIControlStateHighlighted];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn.frame = CGRectMake(195, 405, 74, 34);
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share_pressed"] forState:UIControlStateHighlighted];
    [self.shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.addListBtn.frame = CGRectMake(290, 405, 104, 34);
    [self.addListBtn setBackgroundImage:[UIImage imageNamed:@"listing"] forState:UIControlStateNormal];
    [self.addListBtn setBackgroundImage:[UIImage imageNamed:@"listing_pressed"] forState:UIControlStateHighlighted];
    [self.addListBtn addTarget:self action:@selector(addListBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineImage.frame = CGRectMake(LEFT_GAP, 450, 430, 2);
    self.lineImage.image = [UIImage imageNamed:@"dividing"];
    
    self.introImage.frame = CGRectMake(LEFT_GAP, 460, 45, 20);
    self.introImage.image = [UIImage imageNamed:@"brief_title"];
    
    self.introBgImage.frame = CGRectMake(LEFT_GAP, 490, 440, 86);
    self.introBgImage.image = [UIImage imageNamed:@"brief"];
    
    self.introContentTextView.frame = CGRectMake(LEFT_GAP + 10, 493, 420, 80);
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(introBtnClicked)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.introContentTextView addGestureRecognizer:tapGesture];
    
    commentArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    introBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [introBtn setBackgroundImage:[UIImage imageNamed:@"listing"] forState:UIControlStateNormal];
    [introBtn setBackgroundImage:[UIImage imageNamed:@"listing_pressed"] forState:UIControlStateHighlighted];
    introBtn.frame = CGRectMake(LEFT_GAP + 420, self.introContentTextView.frame.origin.y + 60, 15, 15);
    [introBtn addTarget:self action:@selector(introBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:introBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(video == nil){
        [self retrieveData];
    }
}


- (void)introBtnClicked
{
    if(introContentHeight > 80){
        introExpand = !introExpand;
        if(introExpand){
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                [self.introContentTextView setFrame:CGRectMake(self.introContentTextView.frame.origin.x, self.introContentTextView.frame.origin.y, self.introContentTextView.frame.size.width, introContentHeight)];
                self.introBgImage.frame = CGRectMake(LEFT_GAP, self.introBgImage.frame.origin.y, self.introBgImage.frame.size.width, 86 + introContentHeight - 80);
                [introBtn setBackgroundImage:[UIImage imageNamed:@"listing"] forState:UIControlStateNormal];
                [introBtn setBackgroundImage:[UIImage imageNamed:@"listing_pressed"] forState:UIControlStateHighlighted];
                introBtn.frame = CGRectMake(introBtn.frame.origin.x, self.introContentTextView.frame.origin.y + 60 + introContentHeight - 80, 15, 15);
                [self repositElements:introContentHeight - 80];
            } completion:^(BOOL finished) {
            }];
        } else {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                [self.introContentTextView setFrame:CGRectMake(self.introContentTextView.frame.origin.x, self.introContentTextView.frame.origin.y, self.introContentTextView.frame.size.width, 80)];
                self.introBgImage.frame = CGRectMake(LEFT_GAP, self.introBgImage.frame.origin.y, self.introBgImage.frame.size.width, 86);
                [introBtn setBackgroundImage:[UIImage imageNamed:@"listing"] forState:UIControlStateNormal];
                [introBtn setBackgroundImage:[UIImage imageNamed:@"listing_pressed"] forState:UIControlStateHighlighted];
                introBtn.frame = CGRectMake(introBtn.frame.origin.x, self.introContentTextView.frame.origin.y + 60, introBtn.frame.size.width, introBtn.frame.size.height);
                [self repositElements:0];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)retrieveData
{
    NSString *key = [NSString stringWithFormat:@"%@%@", @"show", self.prodId];
    id cacheResult = [[CacheUtility sharedCache] loadFromCache:key];
    if(cacheResult != nil){
        [self parseData:cacheResult];
    }
    if([[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.prodId, @"prod_id", nil];
        [[AFServiceAPIClient sharedClient] getPath:kPathProgramView parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
            [self parseData:result];
            
        } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MB_PROGRESS_BAR object:self userInfo:nil];
            [UIUtility showSystemError:self.view];
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MB_PROGRESS_BAR object:self userInfo:nil];
    }
}

- (void)calculateIntroContentHeight
{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(self.introContentTextView.contentSize.width - fPadding, CGFLOAT_MAX);
    CGSize size = [[video objectForKey:@"summary"] sizeWithFont: self.introContentTextView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    introContentHeight = size.height + 16.0;
}

- (void)parseData:(id)result
{
    NSString *responseCode = [result objectForKey:@"res_code"];
    if(responseCode == nil){
        NSString *key = [NSString stringWithFormat:@"%@%@", @"show", self.prodId];
        [[CacheUtility sharedCache] putInCache:key result:result];
        video = (NSDictionary *)[result objectForKey:@"show"];
        episodeArray = [video objectForKey:@"episodes"];
        NSArray *tempArray = (NSMutableArray *)[result objectForKey:@"comments"];
        [commentArray removeAllObjects];
        if(tempArray != nil && tempArray.count > 0){
            [commentArray addObjectsFromArray:tempArray];
        }
        [self calculateIntroContentHeight];
        [self showValues];
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MB_PROGRESS_BAR object:self userInfo:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MB_PROGRESS_BAR object:self userInfo:nil];
        [UIUtility showSystemError:self.view];
    }
}

- (void)showValues
{
    [self.filmImage setImageWithURL:[NSURL URLWithString:[video objectForKey:@"ipad_poster"]] placeholderImage:[UIImage imageNamed:@"video_placeholder"]];
    
    self.titleLabel.text = [video objectForKey:@"name"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@ 分", [video objectForKey:@"score"]];
    NSString *stars = [video objectForKey:@"stars"];
    NSArray *starArray;
    if([stars rangeOfString:@"/"].length > 0){
        starArray = [stars componentsSeparatedByString:@"/"];
    } else if([stars rangeOfString:@","].length > 0){
        starArray = [stars componentsSeparatedByString:@","];
    } else {
        starArray = [stars componentsSeparatedByString:@" "];
    }
    if(starArray.count > 0)
        self.actorName1Label.text = [((NSString *)[starArray objectAtIndex:0]) stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(starArray.count > 1)
        self.actorName2Label.text = [((NSString *)[starArray objectAtIndex:1]) stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(starArray.count > 2)
        self.actorName3Label.text = [((NSString *)[starArray objectAtIndex:2]) stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.regionNameLabel.text = [video objectForKey:@"area"];
    self.playTimeLabel.text = [video objectForKey:@"publish_date"];
    self.dingNumberLabel.text = [NSString stringWithFormat:@"%@", [video objectForKey:@"support_num"]];
    self.collectionNumberLabel.text = [NSString stringWithFormat:@"%@", [video objectForKey:@"favority_num"]];
    
    self.introContentTextView.text = [video objectForKey:@"summary"];
    
    [self repositElements:0];
}

- (void)repositElements:(int)increasePositionY
{
    if(listViewController == nil){
        listViewController = [[ShowListViewController alloc]initWithStyle:UITableViewStylePlain];
        listViewController.parentDelegate = self;
        listViewController.view.backgroundColor = [UIColor yellowColor];
        [self.bgScrollView addSubview:listViewController.view];
    }
    listViewController.listData = episodeArray;
    listViewController.view.frame = CGRectMake(LEFT_GAP, 590 + increasePositionY, 425, (episodeArray.count > 5 ? 5 : episodeArray.count)*30);
    
    int totalCommentNum = [[video objectForKey:@"total_comment_number"] integerValue];
    
    int positionY = listViewController.view.frame.origin.y + (episodeArray.count > 5 ? 5 : episodeArray.count)*30;
    self.commentImage.frame = CGRectMake(LEFT_GAP, positionY + 30, 74, 19);
    self.commentImage.image = [UIImage imageNamed:@"comment_title"];
    
    self.numberLabel.frame = CGRectMake(139, positionY + 30, 100, 18);
    self.numberLabel.text = [NSString stringWithFormat:@"(%i条)", totalCommentNum];
    
    self.commentBtn.frame = CGRectMake(410, positionY + 27, 66, 26);
    [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comment_pressed"] forState:UIControlStateHighlighted];
    [self.commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if(commentListViewController == nil){
        commentListViewController = [[CommentListViewController alloc]initWithStyle:UITableViewStylePlain];
        commentListViewController.parentDelegate = self;
        commentListViewController.prodId = self.prodId;
        [self.bgScrollView addSubview:commentListViewController.view];
    }
    commentListViewController.totalCommentNum = totalCommentNum;
    commentListViewController.listData = commentArray;
    [commentListViewController.tableView reloadData];
    commentListViewController.view.frame = CGRectMake(LEFT_GAP, positionY + 60, 425, commentListViewController.tableHeight);
    
    [self.bgScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+commentListViewController.tableHeight+5 * 30 + 200 + increasePositionY)];
    //    commentListViewController.view.frame = CGRectMake(LEFT_GAP, positionY + 70, 425, commentListViewController.tableHeight);
}

- (void)getTopComments:(int)num
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.prodId, @"prod_id", nil];
    [[AFServiceAPIClient sharedClient] getPath:kPathProgramView parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        NSString *responseCode = [result objectForKey:@"res_code"];
        if(responseCode == nil){
            NSString *key = [NSString stringWithFormat:@"%@%@", @"show", self.prodId];
            [[CacheUtility sharedCache] putInCache:key result:result];
            video = (NSDictionary *)[result objectForKey:@"show"];
            episodeArray = [video objectForKey:@"episodes"];
            NSArray *tempArray = (NSMutableArray *)[result objectForKey:@"comments"];
            [commentArray removeAllObjects];
            if(tempArray != nil && tempArray.count > 0){
                [commentArray addObjectsFromArray:tempArray];
            }
            if(introContentHeight > 80){
                if(introExpand){
                    [self repositElements:introContentHeight - 80];
                } else {
                    [self repositElements:0];
                }
            }
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)refreshCommentListView:(int)tableHeight
{
    [self.bgScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+tableHeight+5 * 30 + 200)];
    commentListViewController.view.frame = CGRectMake(LEFT_GAP, commentListViewController.view.frame.origin.y, 425, tableHeight);
}

- (void)playVideo
{
    if(![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]){
        [UIUtility showNetWorkError:self.view];
        return;
    }
    [self playVideo:0];
}

- (void)playVideo:(NSInteger)num
{
    if(![[UIApplication sharedApplication].delegate performSelector:@selector(isWifiReachable)]){
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"" message:@"播放视频会消耗大量流量，您确定要在非WiFi环境下播放吗？"];
        [alert setCancelButtonWithTitle:NSLocalizedString(@"cancel", nil) block:nil];
        [alert setDestructiveButtonWithTitle:@"确定" block:^{
            [self willPlayVideo:num];
        }];
        [alert show];
    } else {
        [self willPlayVideo:num];
    }
}

- (void)playVideoCallback:(NSInteger)num
{
    [self playVideo:num];
}


- (void)willPlayVideo:(NSInteger)num
{
    NSArray *videoUrlArray = [[episodeArray objectAtIndex:num] objectForKey:@"down_urls"];
    if(videoUrlArray.count > 0){
        NSString *videoUrl = nil;
        for(NSDictionary *tempVideo in videoUrlArray){
            if([LETV isEqualToString:[tempVideo objectForKey:@"source"]]){
                videoUrl = [self parseVideoUrl:tempVideo];
                break;
            }
        }
        if(videoUrl == nil){
            if (videoUrlArray.count > 0) {
                videoUrl = [self parseVideoUrl:[videoUrlArray objectAtIndex:0]];
            }
        }
        if(videoUrl == nil){
            [self gotoWebsite:num];
        } else {
            MediaPlayerViewController *viewController = [[MediaPlayerViewController alloc]initWithNibName:@"MediaPlayerViewController" bundle:nil];
            viewController.videoUrl = videoUrl;
            viewController.type = 3;
            viewController.name = [video objectForKey:@"name"];
            viewController.subname = [[episodeArray objectAtIndex:num] objectForKey:@"name"];
            [[AppDelegate instance].rootViewController pesentMyModalView:viewController];
        }
    }else {
        [self gotoWebsite:num];
    }
}

- (void)gotoWebsite:(NSInteger)num
{
    ProgramViewController *viewController = [[ProgramViewController alloc]initWithNibName:@"ProgramViewController" bundle:nil];
    NSArray *urlArray = [[episodeArray objectAtIndex:num] objectForKey:@"video_urls"];
    NSString *url = [[urlArray objectAtIndex:0] objectForKey:@"url"];
    if([StringUtility stringIsEmpty:url]){
        url = @"";
    }
    viewController.programUrl = url;
    viewController.title = [video objectForKey:@"name"];
    viewController.type = 3;
    viewController.subname = [[episodeArray objectAtIndex:num] objectForKey:@"name"];
    [[AppDelegate instance].rootViewController pesentMyModalView:[[UINavigationController alloc]initWithRootViewController:viewController]];
}

- (void)dingBtnClicked:(id)sender
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.prodId, @"prod_id", nil];
    [[AFServiceAPIClient sharedClient] postPath:kPathSupport parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        NSString *responseCode = [result objectForKey:@"res_code"];
        if([responseCode isEqualToString:kSuccessResCode]){
            [[AppDelegate instance].rootViewController showSuccessModalView:1.5];
            self.dingNumberLabel.text = [NSString stringWithFormat:@"%i", [self.dingNumberLabel.text intValue] + 1 ];
        } else {
            [[AppDelegate instance].rootViewController showFailureModalView:1.5];
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        [UIUtility showSystemError:self.view];
    }];
}

- (void)collectionBtnClicked
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: self.prodId, @"prod_id", nil];
    [[AFServiceAPIClient sharedClient] postPath:kPathProgramFavority parameters:parameters success:^(AFHTTPRequestOperation *operation, id result) {
        NSString *responseCode = [result objectForKey:@"res_code"];
        if([responseCode isEqualToString:kSuccessResCode]){
            [[AppDelegate instance].rootViewController showSuccessModalView:1.5];
            self.collectionNumberLabel.text = [NSString stringWithFormat:@"%i", [self.collectionNumberLabel.text intValue] + 1 ];
        } else {
            [[AppDelegate instance].rootViewController showFailureModalView:1.5];
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        [UIUtility showSystemError:self.view];
    }];
}

@end