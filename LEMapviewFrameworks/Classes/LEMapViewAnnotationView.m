//
//  LEMapViewAnnotationView.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotationView.h"
@implementation LEMapViewAnnotationView{
}

-(void) initUI { 
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)self.annotation; 
    self.curAnnotationIcon=[[UIImageView alloc]initWithImage:anno.curAnnotationIcon];
    [self addSubview:self.curAnnotationIcon];
    [self setFrame:CGRectMake(0, 0, self.curAnnotationIcon.bounds.size.width, self.curAnnotationIcon.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -self.curAnnotationIcon.bounds.size.height/2)];
    [self onResetAngle];
}
-(void) onResetAngle{
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)self.annotation;
    if(anno.nextCoordinate.latitude!=0&&anno.nextCoordinate.longitude!=0){
        self.originalAngle=90-[self angleBetweenFirstPoint:anno.coordinate SecondPoint:anno.nextCoordinate];
    }
    [self onSetAngle:0];
}
-(void) onSetAngle:(float) angle{
    float finalAngle=(-(angle+self.originalAngle))*M_PI/180;
    [self.curAnnotationIcon setTransform:CGAffineTransformMakeRotation(finalAngle)];
}
-(void) onSetViewCenter:(CGPoint) point{
    [self setCenterOffset:point];
}
-(float) angleBetweenFirstPoint:(CLLocationCoordinate2D) first SecondPoint:(CLLocationCoordinate2D)second {
    float height = first.latitude    -  second.latitude;
    float width  = second.longitude  -  first.longitude;
    float rads   = atan(height/width);
    float angle  =  ( rads * 180 / M_PI);
    if(width<0){
        angle+=180;
    }
    return angle;
}

@end
