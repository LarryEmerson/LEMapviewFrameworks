//
//  LEMapViewAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotationView.h"
@interface LEMapViewAnnotationView()
@property (nonatomic, readwrite) UIImageView *leCurrentAnnotationIcon;
@property (nonatomic, readwrite) float leOriginalAngle;
@end
@implementation LEMapViewAnnotationView

-(void) leExtraInits { 
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)self.annotation;
    self.leCurrentAnnotationIcon=[[UIImageView alloc]initWithImage:anno.leCurrentAnnotationIcon];
    [self addSubview:self.leCurrentAnnotationIcon];
    [self setFrame:CGRectMake(0, 0, self.leCurrentAnnotationIcon.bounds.size.width, self.leCurrentAnnotationIcon.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -self.leCurrentAnnotationIcon.bounds.size.height/2)];
    [self leOnResetAngle];
}
-(void) leOnResetAngle{
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)self.annotation;
    if(anno.nextCoordinate.latitude!=0&&anno.nextCoordinate.longitude!=0){
        self.leOriginalAngle=90-[self angleBetweenFirstPoint:anno.coordinate SecondPoint:anno.nextCoordinate];
    }
    [self leOnSetAngle:0];
}
-(void) leOnSetAngle:(float) angle{
    float finalAngle=(-(angle+self.leOriginalAngle))*M_PI/180;
    [self.leCurrentAnnotationIcon setTransform:CGAffineTransformMakeRotation(finalAngle)];
}
-(void) leOnSetViewCenter:(CGPoint) point{
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
