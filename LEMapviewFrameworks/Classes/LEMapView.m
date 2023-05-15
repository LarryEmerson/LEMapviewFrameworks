//
//  LEMapView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapView.h"
#import "LEMapViewSettings.h"




#define RefreshZoomLevel 16
#define RefreshMoveSpace 0.003
#define ZoomSize 1200

@implementation LEMapViewCache
LESingleton_implementation(LEMapViewCache)
@end

typedef NS_ENUM(NSInteger, MapRotationStatus) {
    //Inside
    MapRotationStatusNone = 0,
    MapRotationStatusUser = 1,
    MapRotationStatusMap =2,
};
@interface LEMapView()
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
@property (nonatomic) CGFloat polylineWidth;
@end
@implementation LEMapView{
    UIImageView *curTopView;
    MAMapView *curMapView;
    NSMutableArray *curAnnotationArray;
    CLLocationManager *locationManager;
    NSMutableArray *curAnnotationDetails;
    BOOL isZoomInited;
    BOOL isRefreshDataOK;
    float lastRegion;
    float lastZoom;
    float lastZoomForRefresh;
    CLLocationCoordinate2D lastUserCoordinate;
    CLLocationCoordinate2D lastCoor;
    NSTimer *curTimer;
    NSTimer *curTipTimer;
    int topHeight;
    LEMapViewUserAnnotationView *curUserAnnotationView;
    MACircle *curUserCircle;
    LEMapCallOutAnnotationView *curCallOutView;
    NSMutableArray *curDataArrays;
    UIButton *reLocate;
    UIView *scaleView;
    UIImageView *curCompass;
    MapRotationStatus curMapRotationStatus;
    NSTimer *curCheckRotateTimer;
    NSMutableArray *curSearchAnnotationArray;
    BOOL skipHeading;
}
-(void) leSetEnableRelocate:(BOOL) enable{
    [reLocate setHidden:!enable];
}
-(void) leSetEnableScale:(BOOL) enable{
    [scaleView setHidden:!enable];
}
-(void) leSetCompassAnchor:(LEAnchors) anchor Offset:(CGPoint) offset Enable:(BOOL) enable{
    if(enable){
        [curCompass.leAutoLayoutSettings setLeAnchor:anchor];
        [curCompass.leAutoLayoutSettings setLeOffset:offset];
        [curCompass leExecAutoLayout];
    }
    [curCompass setHidden:!enable];
}
//
-(void) leSetAppMessageDelegate:(id<LEAppMessageDelegate>) messageDelegate{
    self.leAppMessageDelegate=messageDelegate;
}
-(void) leSetUserLocationDelegate:(id<LEMapViewUserLocationDelegate>) locationDelegate{
    self.leUserLocationDelegate=locationDelegate;
}
-(void) leSetMapDelegate:(id<LEMapViewDelegate>) mapDelegate{
    self.leMapDelegate=mapDelegate;
}
-(void) leSetAnnotationIcon:(UIImage *) annotationIcon{
    self.curAnnotationIcon=annotationIcon;
}
-(UIImage *) leGetAnnotationIcon{
    return self.curAnnotationIcon;
}
-(void) leSetCalloutBackground:(UIImage *) calloutBackground{
    self.curCallOutBackground=calloutBackground;
}
-(UIImage *) leGetCalloutBackground{
    return self.curCallOutBackground;
}
-(void) leSetAnnotationViewClass:(NSString *) annotationViewClass{
    self.curAnnotationViewClass=annotationViewClass;
}
-(void) leSetCalloutViewClass:(NSString *) calloutViewClass{
    self.curCallOutViewClass=calloutViewClass;
}
-(void) leSetEnableAnnotationRotation:(BOOL) enable{
    self.enableAnnotationRotation=enable;
}
-(BOOL) leGetEnableAnnotationRotation{
    return self.enableAnnotationRotation;
}
-(void) leSetEnablePolyline:(BOOL) enable{
    self.enablePolyline=enable;
}
-(BOOL) leGetEnablePolyline{
    return self.enablePolyline;
}
-(void) leSetEnableAnnotationCentered:(BOOL) enable{
    self.enableAnnotationCentered=enable;
}
-(BOOL) leGetEnableAnnotationCentered{
    return self.enableAnnotationCentered;
}
-(void) leSetMAPolyline:(MAPolyline *) line{
    self.curMApolyline=line;
}
-(MAPolyline *) leGetMAPolyline{
    return self.curMApolyline;
}
-(void) leSetPolylineStrokeColor:(UIColor *) color{
    self.polylineStrokeColor=color;
}
-(void) leSetPolylineWidth:(CGFloat) polylineWidth{
    self.polylineWidth=polylineWidth;
}
//
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleView = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleView.lineWidth   = 1.5f;
        circleView.strokeColor = [UIColor colorWithRed:0.110 green:0.494 blue:1.000 alpha:0.750];
        circleView.fillColor   = [UIColor colorWithRed:0.213 green:0.519 blue:0.757 alpha:0.250];
        return circleView;
    }else if([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineRenderer *line=[[MAPolylineRenderer alloc] initWithPolyline:overlay];
        [line setLineWidth:self.polylineWidth];
        [line setStrokeColor:self.polylineStrokeColor];
        [line setLineCapType:kMALineCapRound];
        return line;
    }
    return nil;
} 
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings AnnotationIcon:(UIImage *) icon CallOutBackground:(UIImage *) callOut AnnotationViewClass:(NSString *) annotationView CallOutViewClass:(NSString *) callOutClass MapDelegate:(id<LEMapViewDelegate>) delegate{
    self.curAnnotationIcon=icon;
    self.curCallOutBackground =callOut;
    self.curAnnotationViewClass=annotationView;
    self.curCallOutViewClass=callOutClass;
    self.leMapDelegate=delegate;
    curAnnotationArray=[[NSMutableArray alloc]init];
    curSearchAnnotationArray=[[NSMutableArray alloc] init];
    curMapRotationStatus=MapRotationStatusNone;
    self.polylineWidth=8;
    self.polylineStrokeColor=[UIColor colorWithRed:0.8804 green:0.8802 blue:0.523 alpha:0.986772629310345];
    self=[super initWithAutoLayoutSettings:settings];
    [self initMap];
    return self;
}
-(void) leOnRefreshedData:(NSMutableArray *)data{
    curDataArrays=data;
    [self leOnRemoveAllAnnotations];
    [self leOnOverwriteAnnotationMakerWithData:data];
}
-(void) leOnRemoveAllAnnotations{
    [curMapView removeAnnotations:curAnnotationArray];
    [curAnnotationArray removeAllObjects];
}
-(MAMapView *) leOnGetMapview{
    return curMapView;
} 
-(void) leOnAddAnnotationToCacheWith:(NSObject<MAAnnotation> *) annotation{
    [curAnnotationArray addObject:annotation];   
}
-(void) leOnRefreshMapviewAnnotationsAfterAnnotationsAdded{
    [curMapView addAnnotations:curAnnotationArray];
}
-(void) leOnOverwriteAnnotationMakerWithData:(NSMutableArray *) data{
    NSInteger count=data.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (int i=0; i<data.count; i++) {
        NSDictionary *dic=[data objectAtIndex:i];
        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
        commonPolylineCoords[i].latitude = coor.latitude;
        commonPolylineCoords[i].longitude = coor.longitude;
        LEMapViewAnnotation *anno=[[LEMapViewAnnotation alloc] initWithCoordinate:coor Index:i AnnotationIcon:self.curAnnotationIcon Data:dic];
        if(i+1<count){
            NSDictionary *dic=[data objectAtIndex:i+1];
            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
            [anno setNextCoordinate:coor];
        }
        [self leOnAddAnnotationToCacheWith:anno];
        
    }
    [self leOnRefreshMapviewAnnotationsAfterAnnotationsAdded];
    if(self.enablePolyline){
        [curMapView removeOverlay:self.curMApolyline];
        self.curMApolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
        [curMapView addOverlay:self.curMApolyline];
    }
}
//

-(void) onCheckAnnotationAngle{
    if(self.enableAnnotationRotation){
        NSArray *array=curMapView.annotations;
        for (int i=0; i<array.count; i++) {
            id<MAAnnotation> annotation=(LEMapViewAnnotation *)[array objectAtIndex:i];
            if([annotation isKindOfClass:[LEMapViewAnnotation class]]){
                LEMapBaseAnnotationView *view=(LEMapBaseAnnotationView *)[curMapView viewForAnnotation:annotation];
                if([view isKindOfClass:[LEMapViewAnnotationView class]]){
                    [(LEMapViewAnnotationView *)view leOnSetAngle:curMapView.rotationDegree];
                }
            }
        }
    }
}
//


-(void) leOnRefreshSearchedLocations:(NSMutableArray *) array{
    [curMapView removeAnnotations:curSearchAnnotationArray];
    [curSearchAnnotationArray removeAllObjects];
    if(array.count>0){
        [curSearchAnnotationArray addObjectsFromArray:array];
        [curMapView addAnnotations:curSearchAnnotationArray];
        if (curSearchAnnotationArray.count == 1) {
            [curMapView setCenterCoordinate:[curSearchAnnotationArray[0] coordinate] animated:YES];
        } else {
            [curMapView showAnnotations:curSearchAnnotationArray edgePadding:UIEdgeInsetsMake(LELayoutSideSpace, LELayoutSideSpace, LELayoutSideSpace, LELayoutSideSpace) animated:NO];
        }
    }
}
//=========================Compass
-(void) onRotateToNormal{
    [curMapView setRotationDegree:0 animated:YES duration:0.2];
    [curCompass setTransform:CGAffineTransformMakeRotation(0)];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onEndChecking) userInfo:nil repeats:NO];
    [self onBeginChecking];
}

-(void) initCompass{
    UIImage *img=[[LEMapViewSettings sharedInstance] leCompass];
    curCompass=[LEUIFramework leGetImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopRight Offset:CGPointMake(0, LEStatusBarHeight) CGSize:img.size] Image:img];
    [curCompass setUserInteractionEnabled:YES];
    [curCompass leAddTapEventWithSEL:@selector(onRotateToNormal) Target:self];
}
//-(void) resetUserAnnotationImage{
//    if(curUserAnnotationView){
//        [curUserAnnotationView.userImage setImage:[UIImage imageNamed:curMapRotationStatus!=MapRotationStatusNone?@"LEMapviewFrameworksAroundUserIconArrow":@"LEMapviewFrameworksAroundUserIconDot"]];
//    }
//}
-(void) resetUserAnnotationRotation:(float) angle{
    if(curUserAnnotationView){
        [curUserAnnotationView.leUserImage setTransform:CGAffineTransformMakeRotation(angle)];
    }
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if(curMapRotationStatus!=MapRotationStatusNone){
        curMapRotationStatus=curMapRotationStatus==MapRotationStatusMap?MapRotationStatusUser:MapRotationStatusMap;
        [reLocate setImage:curMapRotationStatus==MapRotationStatusMap?[[LEMapViewSettings sharedInstance] leLocateStatusFollow]:[LEMapViewSettings sharedInstance].leLocateStatusRotate  forState:UIControlStateNormal];
        //        [self resetUserAnnotationImage];
    }
}
-(void) leSetSkipHeading:(BOOL) skipHead{
    skipHeading=skipHead;
}
-(void) onCheckRotating{
    [curCompass setTransform:CGAffineTransformMakeRotation(-curMapView.rotationDegree*M_PI/180.0)];
    if (fabs(curMapView.centerCoordinate.longitude-lastUserCoordinate.longitude)>0.00002 && fabs(curMapView.centerCoordinate.latitude-lastUserCoordinate.latitude)>0.00002){
        [reLocate setImage:[[LEMapViewSettings sharedInstance] leLocateStatusNormal] forState:UIControlStateNormal];
        curMapRotationStatus=MapRotationStatusNone;
        if(curMapView.cameraDegree!=0)
            [curMapView setCameraDegree:0 animated:YES duration:0.2];
        //        [self resetUserAnnotationImage];
    }else{
        if(curMapRotationStatus!=MapRotationStatusNone){
        }else{
            curMapRotationStatus=MapRotationStatusUser;
            if(curMapView.cameraDegree!=0)
                [curMapView setCameraDegree:0 animated:YES duration:0.2];
        }
        [reLocate setImage:curMapRotationStatus==MapRotationStatusMap?[LEMapViewSettings  sharedInstance].leLocateStatusFollow: [LEMapViewSettings  sharedInstance].leLocateStatusRotate forState:UIControlStateNormal];
    }
    //    [self resetUserAnnotationImage];
    [self onCheckAnnotationAngle];
    
}
-(void) onRotateSwitch{
    //        NSLog(@"onRotateSwitch %d %f %f %f %f %f %f",isRotateSwitcherOn,curMapView.centerCoordinate.longitude,curMapView.userLocation.coordinate.longitude,lastUserCoordinate.longitude, curMapView.centerCoordinate.latitude,curMapView.userLocation.coordinate.latitude,lastUserCoordinate.latitude);
    if ( fabs(curMapView.centerCoordinate.longitude-lastUserCoordinate.longitude)>0.00002 && fabs(curMapView.centerCoordinate.latitude-lastUserCoordinate.latitude)>0.00002){
        [curMapView setCenterCoordinate:lastUserCoordinate animated:YES];
        [reLocate setImage:[[LEMapViewSettings sharedInstance] leLocateStatusRotate] forState:UIControlStateNormal];
        curMapRotationStatus=MapRotationStatusUser;
        if(curMapView.cameraDegree!=0)
            [curMapView setCameraDegree:0 animated:YES duration:0.2];
    }else if (curMapRotationStatus==MapRotationStatusUser) {
        curMapRotationStatus=MapRotationStatusMap;
        [reLocate setImage:[[LEMapViewSettings sharedInstance] leLocateStatusFollow] forState:UIControlStateNormal];
        //        [self resetUserAnnotationImage];
        float degree= curMapView.userLocation.heading.trueHeading-curMapView.rotationDegree;
        [UIView animateWithDuration:0.1 animations:^{
            [curMapView setRotationDegree:curMapView.userLocation.heading.trueHeading animated:YES duration:0.1];
            [curCompass setTransform:CGAffineTransformMakeRotation(-degree*M_PI/180.0)];
            [self resetUserAnnotationRotation:0];
            //            [self resetUserAnnotationRotation:-degree*M_PI/180.0];
        }];
        if(curMapView.cameraDegree!=45)
            [curMapView setCameraDegree:45 animated:YES duration:0.2];
    } else {
        if(curMapView.cameraDegree!=0)
            [curMapView setCameraDegree:0 animated:YES duration:0.2];
        curMapRotationStatus=MapRotationStatusUser;
        [reLocate setImage: [[LEMapViewSettings sharedInstance] leLocateStatusRotate] forState:UIControlStateNormal];
        //        [self resetUserAnnotationImage];
        float degree=curMapView.userLocation.heading.trueHeading-curMapView.rotationDegree;
        [UIView animateWithDuration:0.1 animations:^{
            //            [curMapView setRotationDegree:isRotateSwitcherOn?curMapView.userLocation.heading.trueHeading:0 animated:YES duration:0.1];
            //            [curCompass setTransform:CGAffineTransformMakeRotation(-degree*M_PI/180.0)];
            [self resetUserAnnotationRotation:-degree*M_PI/180.0];
        }];
    }
    //    [self resetUserAnnotationImage];
    //     NSLog(@"  onRotateSwitch %d",isRotateSwitcherOn);
}
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    LELogFunc;
}
-(void) mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction{
    [self onBeginChecking];
}
-(void) mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
    //        NSLog(@"regionWillChangeAnimated");
    [self onBeginChecking];
}
-(void) onBeginChecking{
    [curCheckRotateTimer invalidate];
    curCheckRotateTimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onCheckRotating) userInfo:nil repeats:YES];
}
//========================End Compass
-(void) leRestoreMapView{
    if(![curMapView.superview isEqual:self]){
        if([LEMapViewCache sharedInstance].leGlobalMapView){
            curMapView=[LEMapViewCache sharedInstance].leGlobalMapView;
            [curMapView removeAnnotations:curMapView.annotations];
            [curMapView setFrame:self.bounds];
        }else{
            curMapView =[[MAMapView alloc] initWithFrame:self.bounds];
            [LEMapViewCache sharedInstance].leGlobalMapView=curMapView;
        }
        [self addSubview:curMapView];
        [self bringSubviewToFront:curCompass];
        [curMapView removeOverlay:curUserCircle];
        [curMapView setDelegate:self];
    }
}
-(void) leReleaseView{
    LELogFunc
    [curMapView removeAnnotations:curMapView.annotations];
    self.leMapDelegate=nil;
    self.leAppMessageDelegate=nil;
    self.leUserLocationDelegate=nil;
    self.curMApolyline=nil;
    curUserCircle=nil;
    curCallOutView=nil;
    [curMapView setShowsUserLocation:NO];
    [curMapView setDelegate:nil];
    if(locationManager){
        [locationManager stopUpdatingLocation];
        [locationManager stopUpdatingHeading];
        [locationManager setDelegate:nil];
        locationManager=nil;
    }
    [curCheckRotateTimer invalidate];
}
-(void) initMap {
    skipHeading=NO;
    if([LEMapViewCache sharedInstance].leGlobalMapView){
        curMapView=[LEMapViewCache sharedInstance].leGlobalMapView;
        [curMapView removeAnnotations:curMapView.annotations];
        [curMapView setFrame:self.bounds];
    }else{
        curMapView =[[MAMapView alloc] initWithFrame:self.bounds];
        [LEMapViewCache sharedInstance].leGlobalMapView=curMapView;
    }
    [self addSubview:curMapView];
    [curMapView setDelegate:self];
    [curMapView setZoomEnabled:YES];
    [curMapView setRotateEnabled:YES];
    [curMapView setRotateCameraEnabled:YES];
    [curMapView setScrollEnabled:YES];
    [curMapView setCameraDegree:0 animated:YES duration:0.2];
    [curMapView setShowsCompass:NO];
    //    [curMapView setCompassOrigin:CGPointMake([LEUIFramework sharedInstance].ScreenWidth-StatusBarHeight/2-curMapView.compassSize.width, StatusBarHeight*1.5+NavigationBarHeight)];
    [curMapView setShowsScale:NO];
    [curMapView removeOverlays:curMapView.overlays];
    [curMapView setShowsUserLocation:NO];
    [curMapView setPausesLocationUpdatesAutomatically:YES];
    [curMapView setAllowsBackgroundLocationUpdates:NO];
    //
    [self initCompass];
    [self checkGPSSettings];
    //
    UIImage *buttonImage=[[LEMapViewSettings sharedInstance] leLocateStatusFollow];
    reLocate=[[UIButton alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomLeft Offset:CGPointMake(LELayoutSideSpace, -LEStatusBarHeight) CGSize:buttonImage.size]];
    [self addSubview:reLocate];
    [reLocate addTarget:self action:@selector(onRotateSwitch) forControlEvents:UIControlEventTouchUpInside];
    [reLocate setImage:buttonImage forState:UIControlStateNormal];
    
    UIImage *imgScaleUp=[[LEMapViewSettings sharedInstance] leScaleUp];
    UIImage *imgScaleUp2=[[LEMapViewSettings sharedInstance] leScaleUpHighlighted];
    UIImage *imgScaleDown=[[LEMapViewSettings sharedInstance] leScaleDown];
    UIImage *imgScaleDown2=[[LEMapViewSettings sharedInstance] leScaleDownHighlighted];
    int scaleW=imgScaleUp.size.width;
    int scaleH=imgScaleUp.size.height+imgScaleDown.size.height;
    scaleView=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomRight Offset:CGPointMake(-LELayoutSideSpace, -LEStatusBarHeight) CGSize:CGSizeMake(scaleW, scaleH)]];
    UIButton *sizeUp=[[UIButton alloc]initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:scaleView Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:imgScaleUp.size]];
    UIButton *sizeDown=[[UIButton alloc]initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:scaleView Anchor:LEAnchorInsideBottomCenter Offset:CGPointZero CGSize:imgScaleDown.size]];
    [sizeUp setBackgroundImage:imgScaleUp forState:UIControlStateNormal];
    [sizeUp setBackgroundImage:imgScaleUp2 forState:UIControlStateHighlighted];
    [sizeDown setBackgroundImage:imgScaleDown forState:UIControlStateNormal];
    [sizeDown setBackgroundImage:imgScaleDown2 forState:UIControlStateHighlighted];
    [sizeUp addTarget:self action:@selector(onSizeDownMap) forControlEvents:UIControlEventTouchUpInside];
    [sizeDown addTarget:self action:@selector(onSizeUpMap) forControlEvents:UIControlEventTouchUpInside];
    // 
}

-(void) checkGPSSettings{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        locationManager=[[CLLocationManager alloc]init];
        [locationManager requestAlwaysAuthorization];
        if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isOn=YES;
        if([CLLocationManager locationServicesEnabled]){
            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied
               || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
               || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
                isOn=NO;
            }
        }else{
            isOn=NO;
        }
        if(isOn==NO){
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现定位服务未开启"
                                                                message:[NSString stringWithFormat:@"定位服务手动开启方法：\r\n(设置>隐私>定位服务>开启%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil,nil];
                [alert show];                
            });
        }
    });
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [curMapView setDelegate:self];
    }
}
//
-(MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{ 
    if([annotation isKindOfClass:[LEMapCallOutViewAnnotation class]]){
        curCallOutView=(LEMapCallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:LEReuseableCellIdentifierForCallOutView];
        if(!curCallOutView){
            curCallOutView=[[LEMapCallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:LEReuseableCellIdentifierForCallOutView CallOutDelegate: self.leMapDelegate SubViewClass:self.curCallOutViewClass];
        }
        [curCallOutView leSetDelegate:self.leMapDelegate];
        [curCallOutView setAnnotation:annotation];
        curCallOutView.layer.transform=CATransform3DMakeTranslation(0, 0, 5);
        //        [curCallOutView setCurData:anno.curData];
        return curCallOutView;
    }else if([annotation isKindOfClass:[MAUserLocation class]]){
        //        return nil;
        static NSString *userLocationStyleReuseIndetifier = @"LEMapViewUserAnnotationView";
        curUserAnnotationView = (LEMapViewUserAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (curUserAnnotationView == nil) {
            curUserAnnotationView = [[LEMapViewUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        return curUserAnnotationView;
    } else if([annotation isKindOfClass:[LEMapViewSearchAnnotation class]]){
        LEMapViewSearchAnnotation *geoAnno=(LEMapViewSearchAnnotation *)annotation;
        LEMapViewSearchAnnotationView *searchView =(LEMapViewSearchAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"LEMapViewSearchAnnotation"];
        if (searchView == nil) {
            searchView = [[LEMapViewSearchAnnotationView alloc] initWithAnnotation:geoAnno reuseIdentifier:@"LEMapViewSearchAnnotation"];
        }
        [searchView setAnnotation:geoAnno];
        return searchView;
    } else{
        return [self leOnOverwriteViewForAnnotation:annotation FromMapview:mapView];
    }
    return nil;
}
-(MAAnnotationView *) leOnOverwriteViewForAnnotation:(id<MAAnnotation>) annotation FromMapview:(MAMapView *) mapView{
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)annotation;
    LEMapViewAnnotationView *annotationView =(LEMapViewAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation"];
    if (annotationView == nil) {
        LESuppressPerformSelectorLeakWarning(
                                             annotationView = [[self.curAnnotationViewClass leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithAnnotation:reuseIdentifier:") withObject:anno withObject: @"annotation"];
                                             );
    }
    if(self.enableAnnotationCentered) {
        [annotationView leOnSetViewCenter:CGPointZero];
    }
    [annotationView setAnnotation:annotation];
    annotationView.layer.transform=CATransform3DMakeTranslation(0, 0, anno.zAxisOffset);
    [annotationView leSetMapData:anno.leMapData];
    [annotationView leOnResetAngle];
    return annotationView;
}
// // //
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    //    NSLog(@"didAddAnnotationViews %d",isZoomInited);
    if(!isZoomInited){
        [curMapView setShowsUserLocation:YES];
        MACoordinateRegion zoomRegion;
        zoomRegion = MACoordinateRegionMakeWithDistance(curMapView.userLocation.coordinate, ZoomSize, ZoomSize);
        [curMapView setRegion:zoomRegion];// animated:YES];
        isZoomInited=YES;
        lastZoomForRefresh=curMapView.zoomLevel;
    }
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    LELogFunc; 
}
-(void) mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
    [self onEndChecking];
}
-(void) mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    [self onEndChecking];
}
-(void) onEndChecking{
    [curCheckRotateTimer invalidate];
    if(curMapView.zoomLevel>RefreshZoomLevel && (lastZoomForRefresh!=curMapView.zoomLevel  || fabs(lastCoor.longitude-curMapView.centerCoordinate.longitude)>RefreshMoveSpace||fabs(lastCoor.latitude-curMapView.centerCoordinate.latitude)>RefreshMoveSpace ) ){
        [curTimer invalidate];
        [curTipTimer invalidate];
        if(!curCallOutView){
            curTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(leOnNeedRefreshMap) userInfo:nil repeats:NO];
        }
        lastCoor=curMapView.centerCoordinate;
        isRefreshDataOK=YES;
    }else if(isZoomInited && curMapView.zoomLevel<=RefreshZoomLevel &&(lastZoomForRefresh!=curMapView.zoomLevel ||fabs(lastCoor.longitude-curMapView.centerCoordinate.longitude)>RefreshMoveSpace||fabs(lastCoor.latitude-curMapView.centerCoordinate.latitude)>RefreshMoveSpace )){
        isRefreshDataOK=NO;
        [curTipTimer invalidate];
        curTipTimer=[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(onShowMapTip) userInfo:nil repeats:NO];
    }
    lastRegion=curMapView.region.span.longitudeDelta;
    lastZoom=curMapView.zoomLevel;
    lastZoomForRefresh=curMapView.zoomLevel;
    lastUserCoordinate=curMapView.userLocation.coordinate;
    if(self.leUserLocationDelegate&&[self.leUserLocationDelegate respondsToSelector:@selector(leOnUserLocationRefreshedWith:)]){
        [self.leUserLocationDelegate leOnUserLocationRefreshedWith:[[CLLocation alloc] initWithLatitude:lastUserCoordinate.latitude longitude:lastUserCoordinate.longitude]];
    }
    [self onCheckAnnotationAngle];
}
-(void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if(![self leOnOverwriteMapView:mapView didSelectAnnotationView:view]){
        if([view isKindOfClass:[LEMapViewAnnotationView class]]){
            //add
            LEMapViewAnnotation *an=(LEMapViewAnnotation *) view.annotation;
            [self leRemoveCalloutView];
            if(an.leIndex<curDataArrays.count){
                LEMapCallOutViewAnnotation *anno=[[LEMapCallOutViewAnnotation alloc] initWithCoordinate:an.coordinate Index:an.leIndex AnnotationIcon:self.curAnnotationIcon CallOutBackground:self.curCallOutBackground  Data:[curDataArrays objectAtIndex:an.leIndex] UserCoordinate:mapView.userLocation.coordinate];
                [mapView addAnnotation:anno];
                [curMapView setCenterCoordinate:anno.coordinate animated:YES];
            }
        }
    }
}
-(BOOL) leOnOverwriteMapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    return NO;
}
-(void) leRemoveCalloutView{
    if(curCallOutView&&curCallOutView.annotation){
        [curMapView removeAnnotations:@[curCallOutView.annotation]];
        curCallOutView=nil;
    }
}
-(void) leOnNeedRefreshMap{
    //    NSLogFunc;
    CLLocationCoordinate2D location1= [curMapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:curMapView];
    CLLocationCoordinate2D location2=[curMapView convertPoint:CGPointMake(curMapView.bounds.size.width,curMapView.frame.size.height) toCoordinateFromView:curMapView];
    CLLocationCoordinate2D locationCenter=[curMapView convertPoint:CGPointMake(curMapView.bounds.size.width/2, curMapView.bounds.size.height/2) toCoordinateFromView:curMapView];
    float latitudes=location1.latitude-location2.latitude;
    float longitudes=location1.longitude-location2.longitude;
    float radius=sqrtf(latitudes*latitudes+longitudes*longitudes);
    float startlongitude=0;
    float endlongitude=0;
    float startlatitude=0;
    float endlatitude=0;
    startlongitude=locationCenter.longitude-radius;
    endlongitude=locationCenter.longitude+radius;
    startlatitude=locationCenter.latitude-radius;
    endlatitude=locationCenter.latitude+radius;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithFloat:startlongitude] forKey:@"startlongitude"];
    [parameters setObject:[NSNumber numberWithFloat:endlongitude] forKey:@"endlongitude"];
    [parameters setObject:[NSNumber numberWithFloat:startlatitude] forKey:@"startlatitude"];
    [parameters setObject:[NSNumber numberWithFloat:endlatitude] forKey:@"endlatitude"];
    if(self.leMapDelegate){
        [self.leMapDelegate leOnMapRequestLaunchedWithData:parameters];
    }
}
-(void) onShowAppMessageWith:(NSString *) message{
    if(self.leAppMessageDelegate&&[self.leAppMessageDelegate respondsToSelector:@selector(onShowAppMessageWith:)]){
        [self.leAppMessageDelegate leOnShowAppMessageWith:message];
    }
}
-(void) onShowMapTip{
    //    NSLogFunc;
    [self onShowAppMessageWith:@"地图范围过大，请放大后查看"];
    
}
-(void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    [self leOnOverwriteMapView:mapView didDeselectAnnotationView:view];
}
-(void) leOnOverwriteMapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    if(curCallOutView&&curCallOutView.annotation){
        [mapView removeAnnotations:@[curCallOutView.annotation]];
        curCallOutView=nil;
    }
}
-(void) onSizeUpMap{
    [curMapView setZoomLevel:curMapView.zoomLevel-0.5 animated:YES];
    //    NSLog(@"onSizeUp %f",lastZoom);
}
-(void) onSizeDownMap{
    [curMapView setZoomLevel:curMapView.zoomLevel+0.5 animated:YES];
    //    NSLog(@"onSizeDown %f",lastZoom);
}
//-(void) onReLocate{
//    //    NSLog(@"onReLocate");
//    [curMapView setShowsUserLocation:YES];
//    [curMapView setCenterCoordinate:curMapView.userLocation.coordinate animated:YES];
//}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    //    31.809794 119.992120
    
    lastUserCoordinate=userLocation.coordinate;
    if(self.leUserLocationDelegate&&[self.leUserLocationDelegate respondsToSelector:@selector(leOnUserLocationRefreshedWith:)]){
        [self.leUserLocationDelegate leOnUserLocationRefreshedWith:[[CLLocation alloc] initWithLatitude:lastUserCoordinate.latitude longitude:lastUserCoordinate.longitude]];
    }
    [curMapView removeOverlay:curUserCircle];
    curUserCircle=[MACircle circleWithCenterCoordinate:lastUserCoordinate radius:500];
    [curMapView addOverlay:curUserCircle];
    
    //    if(curMapRotationStatus!=MapRotationStatusNone){
    if(!skipHeading){
        [UIView animateWithDuration:0.1 animations:^{
            if(curMapRotationStatus==MapRotationStatusMap){
                [curMapView setRotationDegree:userLocation.heading.trueHeading animated:YES duration:0.1];
                [curCompass setTransform:CGAffineTransformMakeRotation((360-userLocation.heading.trueHeading)*M_PI/180.0)];
            }else{
                [self resetUserAnnotationRotation:(userLocation.heading.trueHeading-curMapView.rotationDegree)*M_PI/180.0];
            }
            //            [curCompass setTransform:CGAffineTransformIdentity];
            //            [curCompass setTransform:CGAffineTransformMakeRotation(degree)];
        }];        
    }
    //    }
    
    if(!isZoomInited){
        isZoomInited=YES;
        MACoordinateRegion zoomRegion = MACoordinateRegionMakeWithDistance(curMapView.userLocation.coordinate, ZoomSize, ZoomSize);
        [curMapView setRegion:zoomRegion];
        lastZoomForRefresh=curMapView.zoomLevel;
    }
}
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    //    NSLog(@"mapViewDidStopLocatingUser");
}
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView{
    //    NSLog(@"mapViewWillStartLocatingUser");
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"didFailToLocateUserWithError");
}
//
NSInteger sortBylatitude(id obj1, id obj2, void *context){
    float latitude1 =[[obj1 objectForKey:@"latitude02"] floatValue]; // ibj1  和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    float latitude2 =[[obj2 objectForKey:@"latitude02"] floatValue];
    if (latitude1 <= latitude2) {
        return NSOrderedDescending;
    }
    return NSOrderedAscending;
}
NSInteger sortBylongitude(id obj1, id obj2, void *context){
    float longitude1 =[[obj1 objectForKey:@"longitude02"] floatValue]; // ibj1  和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    float longitude2 =[[obj2 objectForKey:@"longitude02"] floatValue];
    if (longitude1 > longitude2) {
        return NSOrderedDescending;
    }
    return NSOrderedAscending;
}
@end
