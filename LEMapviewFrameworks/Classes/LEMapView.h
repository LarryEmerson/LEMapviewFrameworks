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
#import <LEFoundation/LEFoundations.h>

#import "LEUIFramework.h"

@interface LEMapViewCache : NSObject
LESingleton_interface(LEMapViewCache)
@property (nonatomic) MAMapView *leGlobalMapView;
@end

@protocol LEMapViewUserLocationDelegate <NSObject>
-(void) leOnUserLocationRefreshedWith:(CLLocation *) location;
@end


@interface LEMapView : UIView<MAMapViewDelegate>
/**
 * @brief 重置MapView
 */
-(void) leRestoreMapView;
/**
 * @brief 手动释放地图内存占用
 */
-(void) leReleaseView NS_REQUIRES_SUPER;
/**
 * @brief 自定义定位按钮开启关闭
 */
-(void) leSetEnableRelocate:(BOOL) enable;
/**
 * @brief 自定义缩放按钮开启关闭
 */
-(void) leSetEnableScale:(BOOL) enable;
/**
 * @brief 自定义罗盘位置及开启关闭
 */
-(void) leSetCompassAnchor:(LEAnchors) anchor Offset:(CGPoint) offset Enable:(BOOL) enable;
/**
 * @brief 自定义提示信息回调
 */
-(void) leSetAppMessageDelegate:(id<LEAppMessageDelegate>) messageDelegate;
/**
 * @brief 自定义位置信息变动回调
 */
-(void) leSetUserLocationDelegate:(id<LEMapViewUserLocationDelegate>) locationDelegate;
/**
 * @brief 地图位置变动后的数据请求及Callout点击后的回调
 */
-(void) leSetMapDelegate:(id<LEMapViewDelegate>) mapDelegate;
/**
 * @brief 自定义图钉的图片->LEMapViewAnnotationView
 */
-(void) leSetAnnotationIcon:(UIImage *) annotationIcon;
-(UIImage *) leGetAnnotationIcon;
/**
 * @brief 自定义callout的图片
 */
-(void) leSetCalloutBackground:(UIImage *) calloutBackground;
-(UIImage *) leGetCalloutBackground;
/**
 * @brief 自定义图钉的类名->LEMapViewAnnotation
 */
-(void) leSetAnnotationViewClass:(NSString *) annotationViewClass;
/**
 * @brief 自定义Callout的类名
 */
-(void) leSetCalloutViewClass:(NSString *) calloutViewClass;
/**
 * @brief 图钉是否固定于地图，跟随地图旋转
 */
-(void) leSetEnableAnnotationRotation:(BOOL) enable;
-(BOOL) leGetEnableAnnotationRotation;
/**
 * @brief 是否绘制图钉的连线（轨迹）
 */
-(void) leSetEnablePolyline:(BOOL) enable;
-(BOOL) leGetEnablePolyline;
/**
 * @brief 图钉是否居中于坐标点
 */
-(void) leSetEnableAnnotationCentered:(BOOL) enable;
-(BOOL) leGetEnableAnnotationCentered;
/**
 * @brief 当前轨迹
 */
-(void) leSetMAPolyline:(MAPolyline *) line;
-(MAPolyline *) leGetMAPolyline;
/**
 * @brief 设置轨迹颜色
 */
-(void) leSetPolylineStrokeColor:(UIColor *) color;
/**
 * @brief 设置轨迹宽度
 */
-(void) leSetPolylineWidth:(CGFloat) polylineWidth;
/** ===============================================
 * @brief 初始化
 */
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings AnnotationIcon:(UIImage *) icon CallOutBackground:(UIImage *) callOut AnnotationViewClass:(NSString *) annotationView CallOutViewClass:(NSString *) callOutClass MapDelegate:(id<LEMapViewDelegate>) delegate;
/**
 * @brief 获取地图引用
 */
-(MAMapView *) leOnGetMapview;
/**
 * @brief 刷新地图
 */
-(void) leOnNeedRefreshMap;
/**
 * @brief 刷新地图地点
 */
-(void) leOnRefreshedData:(NSMutableArray *)data;
/**
 * @brief 刷新地图搜索的地点
 */
-(void) leOnRefreshSearchedLocations:(NSMutableArray *) array;
/**
 * @brief 删除所有annotations
 */
-(void) leOnRemoveAllAnnotations;
/**
 * @brief 新增地图地点
 */
-(void) leOnAddAnnotationToCacheWith:(NSObject<MAAnnotation> *) annotation;
/**
 * @brief 新增地图后刷新
 */
-(void) leOnRefreshMapviewAnnotationsAfterAnnotationsAdded;
/**
 * @brief 地图地点解析（可重写）
 */
-(void) leOnOverwriteAnnotationMakerWithData:(NSMutableArray *) data;
/**
 * @brief 地图annottaion->annotationView（可重写）
 */
-(MAAnnotationView *) leOnOverwriteViewForAnnotation:(id<MAAnnotation>) annotation FromMapview:(MAMapView *) mapView;
/**
 * @brief 地图地点点击事件（可重写）
 */
-(BOOL) leOnOverwriteMapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view;
/**
 * @brief 地图地点点击事件（可重写）
 */
-(void) leOnOverwriteMapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view;
/**
 * @brief 删除Callout
 */
-(void) leRemoveCalloutView;
@end
