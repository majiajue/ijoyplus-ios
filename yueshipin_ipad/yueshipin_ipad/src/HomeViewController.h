//
//  HomeViewController.h
//  yueshipin_ipad
//
//  Created by joyplus1 on 12-11-20.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import "CommonHeader.h"
#import "MenuViewController.h"

@interface HomeViewController : GenericBaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MNMBottomPullToRefreshManagerClient>

- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, weak)id <MenuViewControllerDelegate> menuViewControllerDelegate;

@end
