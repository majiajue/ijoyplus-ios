//
//  CustomBackButton.h
//  ijoyplus
//
//  Created by joyplus1 on 12-9-17.
//  Copyright (c) 2012年 joyplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavButton : UIButton

- (id)initWith:(UIImage*)backButtonImage highlight:(UIImage*)backButtonHighlightImage leftCapWidth:(CGFloat)capWidth text:(NSString *)text;

@end
