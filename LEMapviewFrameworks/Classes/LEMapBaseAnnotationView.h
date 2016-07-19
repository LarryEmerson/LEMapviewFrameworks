//
//  LEMapBaseAnnotationView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import <MAMapKit/MAMapKit.h> 
#import "LEFrameworks.h"
@interface LEMapBaseAnnotationView : MAAnnotationView
-(NSDictionary *) leGetMapData;
-(void) leSetMapData:(NSDictionary *) data; 
-(void) leRefreshUI;
@end
