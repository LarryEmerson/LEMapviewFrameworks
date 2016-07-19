//
//  LEMapCallOutViewAnnotation.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LEMapViewAnnotation.h"
#define LEReuseableCellIdentifierForCallOutView @"CallOut"
@interface LEMapCallOutViewAnnotation : LEMapViewAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *)icon  CallOutBackground:(UIImage *) bg Data:(NSDictionary *) data UserCoordinate:(CLLocationCoordinate2D) userCoordinate;
-(void) leSetCalloutBackground:(UIImage *) image;
-(void) leGetUserCoordinate:(CLLocationCoordinate2D) location;
-(UIImage *) leGetCalloutBackground;
@end