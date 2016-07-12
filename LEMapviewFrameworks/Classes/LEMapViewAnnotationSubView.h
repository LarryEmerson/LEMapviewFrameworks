//
//  LEMapViewAnnotationSubView.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEMapCallOutViewAnnotation.h"
#import "LEUIFramework.h" 
#import "LEMapCallOutAnnotationView.h"
@interface LEMapViewAnnotationSubView : UIButton
@property (nonatomic) UIView *callOutViewContainer;
@property (nonatomic) id callOutDelegate;
@property (nonatomic) LEMapCallOutViewAnnotation *annotation;
@property (nonatomic) UIImageView *curBG;
@property (nonatomic) LEMapCallOutAnnotationView *curAnnotationView;
-(id) initWithAnnotation:(LEMapCallOutViewAnnotation *) anno;
-(void) setData:(NSDictionary *) data; 
-(void) initUI;
@end
