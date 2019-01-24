//
//  AddPosDemo.m
//  LEMapviewFrameworks_Test
//
//  Created by emerson larry on 2018/1/17.
//  Copyright © 2018年 LarryEmerson. All rights reserved.
//

#import "AddPosDemo.h"

@interface AddPosMapViewEndPoint :   NSObject<MAAnnotation>{
@private
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationCoordinate2D nextCoordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) int index;
@property (nonatomic) UIImage *curAnnotationIcon;
@property (nonatomic) NSDictionary *curData;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *) icon Data:(NSDictionary *) data;
@end
@implementation AddPosMapViewEndPoint

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
@interface AddPosMapViewEndPointView : LEMapBaseAnnotationView
@property (nonatomic) UIImageView *curAnnotationIcon;
@end
@implementation AddPosMapViewEndPointView
-(void) leAdditionalInits {
    AddPosMapViewEndPoint *anno=(AddPosMapViewEndPoint *)self.annotation;
    self.curAnnotationIcon=[[UIImageView alloc]initWithImage:anno.curAnnotationIcon];
    [self addSubview:self.curAnnotationIcon];
    [self setFrame:CGRectMake(0, 0, self.curAnnotationIcon.bounds.size.width, self.curAnnotationIcon.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -self.curAnnotationIcon.bounds.size.height/2)];
}
-(void) leOnSetViewCenter:(CGPoint) point{
    [self setCenterOffset:point];
}
@end
@interface AddPosMapView ()<LEMapViewDelegate,LEMapViewUserLocationDelegate>
@end
@implementation AddPosMapView{
    NSMutableArray *dots;
} 
-(void) addPos{
    LELogObject(dots)
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic setObject:LEFloatToString(self.leOnGetMapview.centerCoordinate.latitude) forKey:@"latitude"];
    [dic setObject:LEFloatToString(self.leOnGetMapview.centerCoordinate.longitude) forKey:@"longitude"];
    [dic setObject:LEIntegerToString(dots.count) forKey:@"index"];
//    LEMapViewAnnotation *anno=[[LEMapViewAnnotation alloc] initWithCoordinate:self.leOnGetMapview.centerCoordinate Index:0 AnnotationIcon:self.leGetAnnotationIcon Data:dic];
//    [anno setNextCoordinate:self.leOnGetMapview.centerCoordinate];
//    [self leOnAddAnnotationToCacheWith:anno];
//    if(dots.count>0){
//        LEMapViewAnnotation *last=[dots lastObject];
//        [last setNextCoordinate:self.leOnGetMapview.centerCoordinate];
//    }
//    [dots addObject:anno];
//    [self.leOnGetMapview addAnnotation:anno];
    
    [dots addObject:dic];
    [self leOnRefreshedData:dots];
}
-(void) leOnCallOutViewClickedWithData:(NSDictionary *) data{
    LELogObject(data);
}
-(void) leOnMapRequestLaunchedWithData:(NSDictionary *) data{
    LELogObject(data);
}
-(void) leOnUserLocationRefreshedWith:(CLLocation *)location{
}
-(void) leAdditionalInits{
    dots=[NSMutableArray new];
//    [self leSetMapDelegate:self];
//    [self leSetUserLocationDelegate:self];
//    [[self leOnGetMapview] setShowsUserLocation:YES];
//    [self.leOnGetMapview setCenterCoordinate:CLLocationCoordinate2DMake(31.810282,119.992165) animated:YES];
}
-(void) leOnOverwriteAnnotationMakerWithData:(NSMutableArray *)data{
    NSInteger count=data.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (int i=0; i<count; i++) {
        NSDictionary *dic=[data objectAtIndex:i];
        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
        commonPolylineCoords[i].latitude = coor.latitude;
        commonPolylineCoords[i].longitude = coor.longitude;
        if(i+1<count){
            LEMapViewAnnotation *anno=[[LEMapViewAnnotation alloc] initWithCoordinate:coor Index:i AnnotationIcon:self.leGetAnnotationIcon Data:dic];
            NSDictionary *dic=[data objectAtIndex:i+1];
            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
            [anno setNextCoordinate:coor];
            [self leOnAddAnnotationToCacheWith:anno];
        }else{
            AddPosMapViewEndPoint *anno=[[AddPosMapViewEndPoint alloc] initWithCoordinate:coor Index:i AnnotationIcon:[UIImage imageNamed:@"end@2x.jpg"] Data:dic];
            NSDictionary *dic=[data objectAtIndex:i];
            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
            [anno setNextCoordinate:coor];
            [self leOnAddAnnotationToCacheWith:anno];
        }
    }
    [self leOnRefreshMapviewAnnotationsAfterAnnotationsAdded];
    if(self.leGetEnablePolyline){
        [[self leOnGetMapview] removeOverlay:self.leGetMAPolyline];
        [self leSetMAPolyline: [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count]];
        [[self leOnGetMapview] addOverlay:self.leGetMAPolyline];
    }
}
-(MAAnnotationView *) leOnOverwriteViewForAnnotation:(id<MAAnnotation>)annotation FromMapview:(MAMapView *)mapView{
    if([annotation isKindOfClass:[AddPosMapViewEndPoint class]]){
        AddPosMapViewEndPoint *anno=(AddPosMapViewEndPoint *)annotation;
        AddPosMapViewEndPointView *annotationView =(AddPosMapViewEndPointView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"endpoint"];
        if (annotationView == nil) {
            annotationView = [[AddPosMapViewEndPointView alloc] initWithAnnotation:annotation reuseIdentifier:@"endpoint"];
        }
        if(self.leGetEnableAnnotationCentered) {
            [annotationView leOnSetViewCenter:CGPointZero];
        }
        [annotationView setAnnotation:annotation];
        [annotationView leSetMapData:anno.curData];
        return annotationView;
    }else if([annotation isKindOfClass:[LEMapViewAnnotation class]]){
        return [super leOnOverwriteViewForAnnotation:annotation FromMapview:mapView];
    }
    return nil;
}
-(BOOL) leOnOverwriteMapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if([view isKindOfClass:[AddPosMapViewEndPointView class]]){
        AddPosMapViewEndPoint *an=(AddPosMapViewEndPoint *) view.annotation;
        [self leRemoveCalloutView];
        LEMapCallOutViewAnnotation *anno=[[LEMapCallOutViewAnnotation alloc] initWithCoordinate:an.coordinate Index:an.index AnnotationIcon:self.leGetAnnotationIcon CallOutBackground:self.leGetCalloutBackground  Data:an.curData UserCoordinate:mapView.userLocation.coordinate];
        [mapView addAnnotation:anno];
        [mapView setCenterCoordinate:anno.coordinate animated:YES];
        return YES;
    }
    return NO;
}
@end

@interface AddPosMapViewSubview : LEMapViewAnnotationSubView
@end
@implementation AddPosMapViewSubview{
    UILabel *label;
    UIButton *btn;
}
-(void) leAdditionalInits{
    [self leSetSize:CGSizeMake(200, 80)];
    [self.leGetCalloutViewContainer leSetLeAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    btn=[LEUIFramework leGetButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointZero CGSize:CGSizeMake(50, 50)] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:@"@" FontSize:10 Font:nil Image:nil BackgroundImage:[LEColorMask leImageStrechedFromSizeOne] Color:LEColorWhite SelectedColor:LEColorGray MaxWidth:0 SEL:@selector(onBtn) Target:self]];
    [btn setBackgroundImage:[LEColorMask5 leImageStrechedFromSizeOne] forState:UIControlStateHighlighted];
    label=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leGetCalloutViewContainer Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"Callout" FontSize:0 Font:LEBoldFont(LELayoutFontSize14) Width:0 Height:0 Color:LEColorWhite Line:1 Alignment:NSTextAlignmentCenter]];
}
-(void) setData:(NSDictionary *)data{
    int index=[[data objectForKey:@"index"] intValue];
    [self leSetSize:CGSizeMake(200, 40+index*6)];
    [label leSetText:[NSString stringWithFormat:@"你点击了第%d个图钉",index]];
    if(index==12){
        [label leSetText:@"您已到达终点"];
    }
}
-(void) onBtn{
    LELogFunc;
    [self leAddLocalNotification:@"测试按钮"];
}
@end
 
