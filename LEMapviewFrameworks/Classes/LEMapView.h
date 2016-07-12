//
//  LEMapView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "LEMapViewAnnotation.h"
#import "LEAppMessageDelegate.h"
#import "LEUIFramework.h"

@protocol LEMapViewUserLocationDelegate <NSObject>
-(void) onUserLocationRefreshedWith:(CLLocation *) location;
@end


@interface LEMapView : UIView<MAMapViewDelegate>
@property (nonatomic) id<LEAppMessageDelegate> leAppMessageDelegate;
@property (nonatomic) id<LEMapViewUserLocationDelegate> leUserLocationDelegate;
@property (nonatomic) id<LEMapViewDelegate> leMapDelegate;
@property (nonatomic) UIImage *curAnnotationIcon;
@property (nonatomic) UIImage *curCallOutBackground;
@property (nonatomic) NSString *curAnnotationViewClass;
@property (nonatomic) NSString *curCallOutViewClass;
@property (nonatomic) BOOL enableAnnotationRotation;
@property (nonatomic) BOOL enablePolyline;
@property (nonatomic) BOOL enableAnnotationCentered;
@property (nonatomic) MAPolyline *curMApolyline;
@property (nonatomic) UIColor *polylineStrokeColor;
@property (nonatomic) UIColor *polylineFillColor;
@property (nonatomic) CGFloat polylineWidth;
-(id) initUIWithFrame:(CGRect) frame AnnotationIcon:(UIImage *) icon CallOutBackground:(UIImage *) callOut AnnotationViewClass:(NSString *) annotationView CallOutViewClass:(NSString *) callOutClass MapDelegate:(id<LEMapViewDelegate>) delegate;
-(void) initMap;
-(void) onNeedRefreshMap;
-(void) onRefreshedData:(NSMutableArray *)data;
-(void) onRefreshSearchedLocations:(NSMutableArray *) array;

-(void) onRemoveAllAnnotations;
-(MAMapView *) onGetMapview;
-(void) onAddAnnotationToCacheWith:(NSObject<MAAnnotation> *) annotation;
-(void) onRefreshMapviewAnnotationsAfterAnnotationsAdded;
-(void) onOverwriteAnnotationMakerWithData:(NSMutableArray *) data;
-(MAAnnotationView *) onOverwriteViewForAnnotation:(id<MAAnnotation>) annotation FromMapview:(MAMapView *) mapView;
-(void) onOverwriteMapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view;
-(void) removeCalloutView;
@end
