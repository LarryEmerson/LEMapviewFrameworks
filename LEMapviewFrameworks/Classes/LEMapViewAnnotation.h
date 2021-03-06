//
//  LEMapViewAnnotation.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//
#import <MAMapKit/MAMapKit.h>
#import <Foundation/Foundation.h> 
@protocol LEMapViewDelegate <NSObject>
-(void) leOnCallOutViewClickedWithData:(NSDictionary *) data;
-(void) leOnMapRequestLaunchedWithData:(NSDictionary *) data;
@end

@interface LEMapViewAnnotation : NSObject<MAAnnotation>{
@private
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationCoordinate2D nextCoordinate;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) int leIndex;
@property (nonatomic, readonly) UIImage *leCurrentAnnotationIcon;
@property (nonatomic, readonly) NSDictionary *leMapData;
@property (nonatomic) float zAxisOffset;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *) icon Data:(NSDictionary *) data;
@end
