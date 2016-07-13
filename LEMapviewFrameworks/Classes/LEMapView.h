//
//  LEMapView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "LEMapViewAnnotation.h"
#import "LEMapViewAnnotationView.h"

#import "LEMapViewSearchAnnotation.h"
#import "LEMapViewSearchAnnotationView.h"

#import "LEMapViewUserAnnotationView.h"

#import "LEMapCallOutAnnotationView.h"
#import "LEMapCallOutViewAnnotation.h"
#import <AMapFoundationKit/AMapUtility.h>
#import "LEAppMessageDelegate.h"
#import "LEUIFramework.h"

@protocol LEMapViewUserLocationDelegate <NSObject>
-(void) onUserLocationRefreshedWith:(CLLocation *) location;
@end


@interface LEMapView : UIView<MAMapViewDelegate>
/**
 * @brief 自定义提示信息回调
 */
@property (nonatomic) id<LEAppMessageDelegate> leAppMessageDelegate;
/**
 * @brief 自定义位置信息变动回调
 */
@property (nonatomic) id<LEMapViewUserLocationDelegate> leUserLocationDelegate;
/**
 * @brief 地图位置变动后的数据请求及Callout点击后的回调
 */
@property (nonatomic) id<LEMapViewDelegate> leMapDelegate;
/**
 * @brief 自定义图钉的图片->LEMapViewAnnotationView
 */
@property (nonatomic) UIImage *curAnnotationIcon;
/**
 * @brief 自定义callout的图片
 */
@property (nonatomic) UIImage *curCallOutBackground;
/**
 * @brief 自定义图钉的类名->LEMapViewAnnotation
 */
@property (nonatomic) NSString *curAnnotationViewClass;
/**
 * @brief 自定义Callout的类名
 */
@property (nonatomic) NSString *curCallOutViewClass;
/**
 * @brief 图钉是否固定于地图，跟随地图旋转
 */
@property (nonatomic) BOOL enableAnnotationRotation;
/**
 * @brief 是否绘制图钉的连线（轨迹）
 */
@property (nonatomic) BOOL enablePolyline;
/**
 * @brief 图钉是否居中于坐标点
 */
@property (nonatomic) BOOL enableAnnotationCentered;
/**
 * @brief 当前轨迹
 */
@property (nonatomic) MAPolyline *curMApolyline;
/**
 * @brief 设置轨迹颜色
 */
@property (nonatomic) UIColor *polylineStrokeColor;
/**
 * @brief 设置轨迹宽度
 */
@property (nonatomic) CGFloat polylineWidth;
/**
 * @brief 初始化
 */
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings AnnotationIcon:(UIImage *) icon CallOutBackground:(UIImage *) callOut AnnotationViewClass:(NSString *) annotationView CallOutViewClass:(NSString *) callOutClass MapDelegate:(id<LEMapViewDelegate>) delegate;
//-(void) initMap;
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
