/*
 This module is licenced under the BSD license.
 
 Copyright (C) 2011 by raw engineering <nikhil.jain (at) raweng (dot) com, reefaq.mohammed (at) raweng (dot) com>.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
//
//  RootView.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "StackScrollViewController.h"
#import "CommonHeader.h"

#define LEFT_MENU_DIPLAY_WIDTH 150

@class UIViewExt;

@interface RootViewController : GenericBaseViewController <UITextViewDelegate> {
	UIViewExt* rootView;
	UIView* leftMenuView;
	UIView* rightSlideView;
    UITextView *contentTextView;
    UIButton *shareBtn;
}

@property (nonatomic, strong) MenuViewController* menuViewController;
@property (nonatomic, strong) StackScrollViewController* stackScrollViewController;
@property (nonatomic, strong) NSString *prodId;
@property (nonatomic, strong) NSString *prodUrl;
@property (nonatomic, strong) NSString *prodName;
- (void)showSuccessModalView:(int)closeTime;
- (void)showFailureModalView:(int)closeTime;
- (void)showListFailureModalView:(int)closeTime;
- (void)showSharePopup;
@end
