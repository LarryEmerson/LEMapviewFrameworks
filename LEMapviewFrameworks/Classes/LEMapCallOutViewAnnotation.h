//
//  LEMapCallOutViewAnnotation.h
//  four23
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LEMapViewAnnotation.h"
#define ReUseIdentifierForCallOutView @"CallOut"
@interface LEMapCallOutViewAnnotation : LEMapViewAnnotation
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (nonatomic) UIImage *callOutBackground;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *)icon  CallOutBackground:(UIImage *) bg Data:(NSDictionary *) data UserCoordinate:(CLLocationCoordinate2D) userCoordinate;
@end