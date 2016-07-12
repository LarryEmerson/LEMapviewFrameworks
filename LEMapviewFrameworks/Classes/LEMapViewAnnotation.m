//
//  LEMapViewAnnotation.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotation.h"

@implementation LEMapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize curAnnotationIcon = _curAnnotationIcon;
@synthesize curData=_curData;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index  AnnotationIcon:(UIImage *) icon Data:(NSDictionary *)data{
    if (self = [super init]) {
        self.coordinate = coordinate;
        self.index=index;
        self.curAnnotationIcon=icon;
        self.curData=data;
    }
    return self;
}
@end
