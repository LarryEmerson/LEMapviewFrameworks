//
//  LEMapViewAnnotation.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotation.h"

@interface LEMapViewAnnotation ()
@property (nonatomic, readwrite) int leIndex;
@property (nonatomic, readwrite) UIImage *leCurrentAnnotationIcon;
@property (nonatomic, readwrite) NSDictionary *leMapData;
@end
@implementation LEMapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize leCurrentAnnotationIcon = _leCurrentAnnotationIcon;
@synthesize leMapData=_leMapData;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index  AnnotationIcon:(UIImage *) icon Data:(NSDictionary *)data{
    if (self = [super init]) {
        self.coordinate = coordinate;
        self.leIndex=index;
        self.leCurrentAnnotationIcon=icon;
        self.leMapData=data;
    }
    return self;
}
@end
