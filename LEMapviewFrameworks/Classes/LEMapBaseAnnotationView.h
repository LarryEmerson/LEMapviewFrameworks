//
//  LEMapBaseAnnotationView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "LEMapViewAnnotation.h" 

@interface LEMapBaseAnnotationView : MAAnnotationView
@property (nonatomic) NSDictionary *curData;
-(void) initUI;
-(void) refreshUI;
@end
