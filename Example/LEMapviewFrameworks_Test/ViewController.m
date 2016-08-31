//
//  ViewController.m
//  LEMapviewFrameworks_Test
//
//  Created by emerson larry on 16/7/12.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "ViewController.h"

#import "LEMapviewFrameworks.h"
#import "LEFrameworks.h"

@interface TestLEMapViewEndPoint :   NSObject<MAAnnotation>{
@private
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationCoordinate2D nextCoordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) int index;
@property (nonatomic) UIImage *curAnnotationIcon;
@property (nonatomic) NSDictionary *curData;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(UIImage *) icon Data:(NSDictionary *) data;
@end
@implementation TestLEMapViewEndPoint

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
@interface TestLEMapViewEndPointView : LEMapBaseAnnotationView
@property (nonatomic) UIImageView *curAnnotationIcon;
@end
@implementation TestLEMapViewEndPointView
-(void) leExtraInits {
    TestLEMapViewEndPoint *anno=(TestLEMapViewEndPoint *)self.annotation;
    self.curAnnotationIcon=[[UIImageView alloc]initWithImage:anno.curAnnotationIcon];
    [self addSubview:self.curAnnotationIcon];
    [self setFrame:CGRectMake(0, 0, self.curAnnotationIcon.bounds.size.width, self.curAnnotationIcon.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -self.curAnnotationIcon.bounds.size.height/2)];
}
-(void) leOnSetViewCenter:(CGPoint) point{
    [self setCenterOffset:point];
}
@end
@interface TestLEMapview : LEMapView
@end
@implementation TestLEMapview

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
            TestLEMapViewEndPoint *anno=[[TestLEMapViewEndPoint alloc] initWithCoordinate:coor Index:i AnnotationIcon:[UIImage imageNamed:@"end@2x.jpg"] Data:dic];
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
    if([annotation isKindOfClass:[TestLEMapViewEndPoint class]]){
        TestLEMapViewEndPoint *anno=(TestLEMapViewEndPoint *)annotation;
        TestLEMapViewEndPointView *annotationView =(TestLEMapViewEndPointView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"endpoint"];
        if (annotationView == nil) {
            annotationView = [[TestLEMapViewEndPointView alloc] initWithAnnotation:annotation reuseIdentifier:@"endpoint"];
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
    if([view isKindOfClass:[TestLEMapViewEndPointView class]]){
        TestLEMapViewEndPoint *an=(TestLEMapViewEndPoint *) view.annotation;
        [self leRemoveCalloutView];
        LEMapCallOutViewAnnotation *anno=[[LEMapCallOutViewAnnotation alloc] initWithCoordinate:an.coordinate Index:an.index AnnotationIcon:self.leGetAnnotationIcon CallOutBackground:self.leGetCalloutBackground  Data:an.curData UserCoordinate:mapView.userLocation.coordinate];
        [mapView addAnnotation:anno];
        [mapView setCenterCoordinate:anno.coordinate animated:YES];
        return YES;
    }
    return NO;
}
@end

@interface TestLEMapviewSubview : LEMapViewAnnotationSubView
@end
@implementation TestLEMapviewSubview{
    UILabel *label;
    UIButton *btn;
}
-(void) leExtraInits{
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


@interface TestCell : LEBaseTableViewCell
@end
@implementation TestCell{
    UILabel *label;
}
-(void) leExtraInits{
    label=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(LELayoutSideSpace, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:14 Font:nil Width:0 Height:0 Color:LEColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
}
-(void) leSetData:(id)data IndexPath:(NSIndexPath *)path{
    [super leSetData:data IndexPath:path];
    [label leSetText:data];
}
@end
@interface ViewController ()<LEMapViewDelegate,LETableViewCellSelectionDelegate,LEMapSearchBarDelegate>
@end
@implementation ViewController{
    TestLEMapview *map;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeLeft&UIRectEdgeRight&UIRectEdgeBottom];
    [self leSetNavigationTitle:@"LEMapView 测试"];
    LEBaseTableView *tb=[[LEBaseTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.view ParentView:self.view TableViewCell:@"TestCell" EmptyTableViewCell:nil GetDataDelegate:nil TableViewCellSelectionDelegate:self AutoRefresh:NO]];
    [tb leOnRefreshedWithData:[@[@"LEMapView"] mutableCopy]];
    [tb leSetTopRefresh:NO];
    [tb leSetBottomRefresh:NO];
}  
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyOfIndexPath];
    switch (index.row) {
        case 0:
        {
            [AMapServices sharedServices].apiKey =  @"e81cd43379b47cb53892f6a7577597a4";
            LEBaseViewController *vc=[[LEBaseViewController alloc] init];
            LEBaseView *view=[[LEBaseView alloc] initWithViewController:vc];
            
            [self.navigationController pushViewController:vc animated:YES];
            [vc leSetNavigationTitle:@"综合测试"];
            map=[[TestLEMapview alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:view.leViewContainer EdgeInsects:UIEdgeInsetsZero] AnnotationIcon:[UIImage imageNamed:@"arrow@2x.jpg"] CallOutBackground:[LEColorBlue leImageStrechedFromSizeOne] AnnotationViewClass:@"LEMapViewAnnotationView" CallOutViewClass:@"TestLEMapviewSubview" MapDelegate:self];
            [map leSetEnableAnnotationRotation:YES];
            [map leSetEnablePolyline:YES];
            [map leSetEnableAnnotationCentered:YES];
            [map leSetPolylineWidth:8];
            [map leSetPolylineStrokeColor:[UIColor colorWithRed:1.0 green:0.6302 blue:0.6661 alpha:1.0]];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            [array addObject:@{@"latitude":@"31.810000",@"longitude":@"119.985000",@"index":@"1"}];
            [array addObject:@{@"latitude":@"31.807000",@"longitude":@"119.987000",@"index":@"2"}];
            [array addObject:@{@"latitude":@"31.804000",@"longitude":@"119.992000",@"index":@"3"}];
            [array addObject:@{@"latitude":@"31.807000",@"longitude":@"119.995000",@"index":@"4"}];
            [array addObject:@{@"latitude":@"31.810000",@"longitude":@"119.997000",@"index":@"5"}];
            [array addObject:@{@"latitude":@"31.813000",@"longitude":@"119.999000",@"index":@"6"}];
            [array addObject:@{@"latitude":@"31.816000",@"longitude":@"119.996000",@"index":@"7"}];
            [array addObject:@{@"latitude":@"31.819000",@"longitude":@"119.992000",@"index":@"8"}];
            [array addObject:@{@"latitude":@"31.816000",@"longitude":@"119.988000",@"index":@"9"}];
            [array addObject:@{@"latitude":@"31.812000",@"longitude":@"119.986000",@"index":@"10"}];
            [array addObject:@{@"latitude":@"31.810282",@"longitude":@"119.992165",@"index":@"11"}];
            [array addObject:@{@"latitude":@"31.814282",@"longitude":@"119.993265",@"index":@"12"}];
            [map leOnRefreshedData:array];
            
            [map.leOnGetMapview setCenterCoordinate:CLLocationCoordinate2DMake(31.810282,119.992165) animated:YES];
            LEMapSearchBar *bar=[[LEMapSearchBar alloc] initWithSuperView:view.leViewContainer];
            [bar leSetDelegate:self];
        }
            break;
        case 1:
        {
        }
            break;
        default:
            break;
    }
}
-(void) leOnDoneSearchWith:(NSMutableArray *)array{
    LELogObject(array);
    [map.leOnGetMapview addAnnotations:array];
    [map.leOnGetMapview showAnnotations:array animated:YES];
}
-(void) leOnCallOutViewClickedWithData:(NSDictionary *) data{
    LELogObject(data);
    [self.view leAddLocalNotification:[NSString stringWithFormat:@"CallOut %@,%@:%@",[data objectForKey:@"latitude"],[data objectForKey:@"longitude"],[data objectForKey:@"index"]]];
}
-(void) leOnMapRequestLaunchedWithData:(NSDictionary *) data{
    LELogObject(data);
    [self.view leAddLocalNotification:[NSString stringWithFormat:@"Requesting with startlatitude=%@,endlatitude=%@,startlongitude=%@,endlongitude=%@",[data objectForKey:@"startlatitude"],[data objectForKey:@"endlatitude"],[data objectForKey:@"startlongitude"],[data objectForKey:@"endlongitude"]]];
}

@end
