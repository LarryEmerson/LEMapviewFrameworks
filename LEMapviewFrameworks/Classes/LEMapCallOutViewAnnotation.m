//
//  LEMapCallOutViewAnnotation.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapCallOutViewAnnotation.h"

@interface LEMapCallOutViewAnnotation ()
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (nonatomic) UIImage *callOutBackground;
@end
@implementation LEMapCallOutViewAnnotation 
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *)icon  CallOutBackground:(UIImage *) bg  Data:(NSDictionary *) data UserCoordinate:(CLLocationCoordinate2D) userCoordinate{
    self.userCoordinate=userCoordinate; 
    self.callOutBackground=bg;
    return [super initWithCoordinate:coordinate Index:index AnnotationIcon:icon Data:data];
}
-(void) leSetCalloutBackground:(UIImage *) image{
    self.callOutBackground=image;
}
-(void) leGetUserCoordinate:(CLLocationCoordinate2D) location{
    self.userCoordinate=location;
}
-(UIImage *) leGetCalloutBackground{
    return self.callOutBackground;
}
@end