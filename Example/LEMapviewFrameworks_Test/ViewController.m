//
//  ViewController.m
//  LEMapviewFrameworks_Test
//
//  Created by emerson larry on 16/7/12.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "ViewController.h"

//#import "LEMapviewFrameworks.h"

//@interface TestLEMapViewEndPoint :   NSObject<MAAnnotation>{
//@private
//    CLLocationCoordinate2D _coordinate;
//    NSString *_title;
//    NSString *_subtitle;
//}
//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//@property (nonatomic, assign) CLLocationCoordinate2D nextCoordinate;
//@property (nonatomic, readonly, copy) NSString *title;
//@property (nonatomic, readonly, copy) NSString *subtitle;
//@property (nonatomic) int index;
//@property (nonatomic) UIImage *curAnnotationIcon;
//@property (nonatomic) NSDictionary *curData;
//-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *) icon Data:(NSDictionary *) data;
//@end
//@implementation TestLEMapViewEndPoint
//
//@synthesize coordinate=_coordinate;
//@synthesize title = _title;
//@synthesize subtitle = _subtitle;
//@synthesize curAnnotationIcon = _curAnnotationIcon;
//@synthesize curData=_curData;
//-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index  AnnotationIcon:(UIImage *) icon Data:(NSDictionary *)data{
//    if (self = [super init]) {
//        self.coordinate = coordinate;
//        self.index=index;
//        self.curAnnotationIcon=icon;
//        self.curData=data;
//    }
//    return self;
//}
//@end
//@interface TestLEMapViewEndPointView : LEMapBaseAnnotationView
//@property (nonatomic) UIImageView *curAnnotationIcon;
//@end
//@implementation TestLEMapViewEndPointView
//-(void) initUI {
//    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)self.annotation;
//    self.curAnnotationIcon=[[UIImageView alloc]initWithImage:anno.curAnnotationIcon];
//    [self addSubview:self.curAnnotationIcon];
//    [self setFrame:CGRectMake(0, 0, self.curAnnotationIcon.bounds.size.width, self.curAnnotationIcon.bounds.size.height)];
//    [self setCenterOffset:CGPointMake(0, -self.curAnnotationIcon.bounds.size.height/2)];
//}
//-(void) onSetViewCenter:(CGPoint) point{
//    [self setCenterOffset:point];
//}
//@end
//@interface TestLEMapview : LEMapView
//@end
//@implementation TestLEMapview
//
//-(void) onOverwriteAnnotationMakerWithData:(NSMutableArray *)data{
//    NSInteger count=data.count;
//    CLLocationCoordinate2D commonPolylineCoords[count];
//    for (int i=0; i<count; i++) {
//        NSDictionary *dic=[data objectAtIndex:i];
//        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
//        commonPolylineCoords[i].latitude = coor.latitude;
//        commonPolylineCoords[i].longitude = coor.longitude;
//        if(i+1<count){
//            LEMapViewAnnotation *anno=[[LEMapViewAnnotation alloc] initWithCoordinate:coor Index:i AnnotationIcon:self.curAnnotationIcon Data:dic];
//            NSDictionary *dic=[data objectAtIndex:i+1];
//            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
//            [anno setNextCoordinate:coor];
//            [self onAddAnnotationToCacheWith:anno];
//        }else{
//            TestLEMapViewEndPoint *anno=[[TestLEMapViewEndPoint alloc] initWithCoordinate:coor Index:i AnnotationIcon:[[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"map_userpin_circle"] Data:dic];
//            NSDictionary *dic=[data objectAtIndex:i];
//            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"longitude"] floatValue]);
//            [anno setNextCoordinate:coor];
//            [self onAddAnnotationToCacheWith:anno];
//        }
//    }
//    [self onRefreshMapviewAnnotationsAfterAnnotationsAdded];
//    if(self.enablePolyline){
//        [[self onGetMapview] removeOverlay:self.curMApolyline];
//        self.curMApolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
//        [[self onGetMapview] addOverlay:self.curMApolyline];
//    }
//}
//-(MAAnnotationView *) onOverwriteViewForAnnotation:(id<MAAnnotation>)annotation FromMapview:(MAMapView *)mapView{
//    if([annotation isKindOfClass:[TestLEMapViewEndPoint class]]){
//        TestLEMapViewEndPoint *anno=(TestLEMapViewEndPoint *)annotation;
//        TestLEMapViewEndPointView *annotationView =(TestLEMapViewEndPointView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"endpoint"];
//        if (annotationView == nil) {
//            annotationView = [[TestLEMapViewEndPointView alloc] initWithAnnotation:annotation reuseIdentifier:@"endpoint"];
//        }
//        if(self.enableAnnotationCentered) {
//            [annotationView onSetViewCenter:CGPointZero];
//        }
//        [annotationView setAnnotation:annotation];
//        [annotationView setCurData:anno.curData];
//        return annotationView;
//    }else if([annotation isKindOfClass:[LEMapViewAnnotation class]]){
//        return [super onOverwriteViewForAnnotation:annotation FromMapview:mapView];
//    }
//    return nil;
//}
//@end


@interface ViewController ()
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) onTestMap{
//    [AMapServices sharedServices].apiKey =  @"e81cd43379b47cb53892f6a7577597a4";
//    TestLEMapview *map=[[TestLEMapview alloc] initUIWithFrame:self.viewContainer.bounds AnnotationIcon:[[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"dj_arrow_down"] CallOutBackground:[[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"map_tip_hot"] AnnotationViewClass:@"LEMapViewAnnotationView" CallOutViewClass:@"LEMapCallOutAnnotationView" MapDelegate:self];
//    //    LEMapView *map=[[LEMapView alloc] initUIWithFrame:self.view.bounds AnnotationIcon:[[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"map_pin_brown"] CallOutBackground:[[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"map_tip_hot"] AnnotationViewClass:@"LEMapViewAnnotationView" CallOutViewClass:@"LEMapCallOutAnnotationView" MapDelegate:self];
//    [self.viewContainer addSubview:map];
//    [map setEnableAnnotationRotation:YES];
//    [map setEnablePolyline:YES];
//    [map setEnableAnnotationCentered:YES];
//    [map setPolylineWidth:8];
//    [map setPolylineStrokeColor:[UIColor colorWithRed:1.0 green:0.6302 blue:0.6661 alpha:1.0]];
//    NSMutableArray *array=[[NSMutableArray alloc] init];
//    [array addObject:@{@"latitude":@"31.810000",@"longitude":@"119.985000"}];
//    [array addObject:@{@"latitude":@"31.807000",@"longitude":@"119.987000"}];
//    [array addObject:@{@"latitude":@"31.804000",@"longitude":@"119.992000"}];
//    [array addObject:@{@"latitude":@"31.807000",@"longitude":@"119.995000"}];
//    [array addObject:@{@"latitude":@"31.810000",@"longitude":@"119.997000"}];
//    [array addObject:@{@"latitude":@"31.813000",@"longitude":@"119.999000"}];
//    [array addObject:@{@"latitude":@"31.816000",@"longitude":@"119.996000"}];
//    [array addObject:@{@"latitude":@"31.819000",@"longitude":@"119.992000"}];
//    [array addObject:@{@"latitude":@"31.816000",@"longitude":@"119.988000"}];
//    [array addObject:@{@"latitude":@"31.812000",@"longitude":@"119.986000"}];
//    [array addObject:@{@"latitude":@"31.810282",@"longitude":@"119.992165"}];
//    [array addObject:@{@"latitude":@"31.814282",@"longitude":@"119.993265"}];
//    [map onRefreshedData:array];
//}
-(void) onCallOutViewClickedWithData:(NSDictionary *) data{
    //    NSLogObject(data);
}
-(void) onMapRequestLaunchedWithData:(NSDictionary *) data{
    //    NSLogObject(data);
}

@end
