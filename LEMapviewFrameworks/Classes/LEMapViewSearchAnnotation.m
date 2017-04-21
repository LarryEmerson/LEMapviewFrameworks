//
//  LEMapViewSearchAnnotation.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewSearchAnnotation.h"

@implementation LEMapViewSearchAnnotation
@synthesize coordinate=_coordinate; 
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self = [super init]) {
        self.coordinate = coordinate;
    }
    return self;
}
@end
