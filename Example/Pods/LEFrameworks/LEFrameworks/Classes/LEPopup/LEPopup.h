//
//  LEPopup.h
//  YuSen
//
//  Created by emerson larry on 16/4/18.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LEUIFramework.h"
#define LEPopupCancleImage  [[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_common_btn_gray"]
#define LEPopupOKImage      [[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_common_btn_blue"]
#define LEPopupBGImage      [[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_popup_bg"]


@protocol LEPopupDelegate<NSObject>
@optional
-(void) leOnPopupLeftButtonClicked;
-(void) leOnPopupRightButtonClicked;
-(void) leOnPopupCenterButtonClicked;

@end

@interface LEPopupSettings:NSObject
@property (nonatomic) id<LEPopupDelegate> leDelegate;
@property (nonatomic) NSString *leBckgroundImage;
@property (nonatomic) int leSideEdge;
@property (nonatomic) int leMaxHeight;
@property (nonatomic) UIEdgeInsets leContentInsects;
//
@property (nonatomic) NSString *leTitle;
@property (nonatomic) UIFont *leTitleFont;
@property (nonatomic) UIColor *leTitleColor;
//
@property (nonatomic) BOOL leHasTopSplit;
@property (nonatomic) UIColor *leColorSplit;
//
@property (nonatomic) NSString *leSubtitle;
@property (nonatomic) int leSubtitleLineSpace;
@property (nonatomic) UIFont *leSubtitleFont;
@property (nonatomic) UIColor *leSubTitleColor;
@property (nonatomic) NSTextAlignment leTextAlignment;
//
@property (nonatomic) LEAutoLayoutUIButtonSettings *leLeftButtonSetting;
@property (nonatomic) LEAutoLayoutUIButtonSettings *leRightButtonSetting;
@property (nonatomic) LEAutoLayoutUIButtonSettings *leCenterButtonSetting;
@property (nonatomic) UIEdgeInsets leLeftButtonEdge;
@property (nonatomic) UIEdgeInsets leRightButtonEdge;
@property (nonatomic) UIEdgeInsets leCenterButtonEdge;
@end

@interface LEPopup : UIView
-(id) initWithSettings:(LEPopupSettings *) settings;
-(void) leOnUpdatePopupLayout;
-(void) leOnResetPopupContent;
-(void) leEaseIn;
+(LEPopup *) leShowLEPopupWithSettings:(LEPopupSettings *) settings;
+(LEPopup *) leShowQuestionPopupWithSubtitle:(NSString *)leSubtitle Delegate:(id<LEPopupDelegate>) delegate;
+(LEPopup *) leShowQuestionPopupWithTitle:(NSString *)title Subtitle:(NSString *)leSubtitle Alignment:(NSTextAlignment) leTextAlignment Delegate:(id<LEPopupDelegate>) delegate;
+(LEPopup *) leShowQuestionPopupWithTitle:(NSString *)title Subtitle:(NSString *)leSubtitle Alignment:(NSTextAlignment) leTextAlignment LeftButtonText:(NSString *)leftText RightButtonText:(NSString *)rightText Delegate:(id<LEPopupDelegate>) delegate;
+(LEPopup *) leShowQuestionPopupWithTitle:(NSString *)title Subtitle:(NSString *)leSubtitle Alignment:(NSTextAlignment) leTextAlignment LeftButtonImage:(UIImage *)leftImg RightButtonImage:(UIImage *)rightImg LeftButtonText:(NSString *)leftText RightButtonText:(NSString *)rightText Delegate:(id<LEPopupDelegate>) delegate;
+(LEPopup *) leShowTipPopupWithTitle:(NSString *)title Subtitle:(NSString *)leSubtitle Alignment:(NSTextAlignment) leTextAlignment;
+(LEPopup *) leShowTipPopupWithTitle:(NSString *)title Subtitle:(NSString *)leSubtitle Alignment:(NSTextAlignment) leTextAlignment ButtonImage:(UIImage *)img ButtonText:(NSString *) text;

@end
