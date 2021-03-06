//
//  LEMapSearchBar.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by emerson larry on 15/11/24.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import "LEMapSearchBar.h"
#import "LEFrameworks.h"
#import "LEMapViewSearchAnnotation.h"

@interface LEMapSearchBarCell : LEBaseTableViewCell
@end
@implementation LEMapSearchBarCell{
    UILabel *curLabel;
}
-(void) leAdditionalInits{
    curLabel=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(LELayoutSideSpace, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:LELayoutFontSize10 Font:nil Width:0 Height:0 Color:LEColorTextBlack Line:1 Alignment:NSTextAlignmentLeft]];
}
-(void) leSetData:(id)data IndexPath:(NSIndexPath *)path{
    [super leSetData:data IndexPath:path];
    AMapTip *tip=(AMapTip *)data;
    [curLabel leSetText:tip.name];
}
@end
@interface LEMapSearchBar()<UISearchBarDelegate,LETableViewCellSelectionDelegate,AMapSearchDelegate>
@property (nonatomic) id<LEMapSearchBarDelegate> delegate;
@end
@implementation LEMapSearchBar{
    UIView *parentView;
    UIView *maskView;
    UISearchBar *searchBar;
    UIButton *buttonCancle;
    //
    LEBaseTableView *tableView;
    AMapSearchAPI *search;
    NSMutableArray *tips;
    LEMapViewSearchAnnotation *curSearchAnnotation;
    NSMutableArray *curSearchAnnotationArray;
    UIView *tableViewContainer;
}
-(void) leSetDelegate:(id<LEMapSearchBarDelegate>)delegate{
    self.delegate=delegate;
}
-(id) initWithSuperView:(UIView *) parent{
    parentView=parent; 
    self=[super initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LENavigationBarHeight)];
    [self leAdditionalInits];
    [parent addSubview:self];
    return self;
}
-(void) leAdditionalInits{
    tips=[[NSMutableArray alloc] init];
    maskView=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [maskView setBackgroundColor:LEColorMask2];
    [maskView setAlpha:0];
    searchBar=[[UISearchBar alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(LESCREEN_WIDTH, LENavigationBarHeight)]];
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入地点"];
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setKeyboardType:UIKeyboardTypeDefault];
    [searchBar setTranslucent:YES];
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    //
    tableViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomCenter RelativeView:searchBar Offset:CGPointZero CGSize:CGSizeMake(LESCREEN_WIDTH, parentView.bounds.size.height-LENavigationBarHeight)]];
    tableView=[[LEBaseTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self ParentView:tableViewContainer TableViewCell:@"LEMapSearchBarCell" EmptyTableViewCell:nil GetDataDelegate:nil TableViewCellSelectionDelegate:self]];
    
    [tableView leSetTopRefresh:NO];
    [tableView leSetBottomRefresh:NO];
    //    [tableViewContainer setBackgroundColor:[UIColor colorWithRed:0.311 green:1.000 blue:0.932 alpha:0.138]];
    //    [tableView setBackgroundColor:[UIColor colorWithRed:0.9859 green:0.0 blue:0.027 alpha:0.5]];
    //
    [tableViewContainer leAddTapEventWithSEL:@selector(onCancleSearch) Target:self];
    [self initSearch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [tableViewContainer leSetSize:CGSizeMake(LESCREEN_WIDTH, parentView.frame.size.height-keyboardRect.size.height-LENavigationBarHeight)];
        [tableView leSetSize:tableViewContainer.bounds.size];
    } completion:^(BOOL finished){ }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [tableViewContainer leSetSize:CGSizeMake(LESCREEN_WIDTH, parentView.frame.size.height-keyboardRect.size.height-LENavigationBarHeight)];
        [tableView leSetSize:tableViewContainer.bounds.size];
    } completion:^(BOOL finished){ }];
}
- (void) onCancleSearch{
    [searchBar setText:@""];
    [searchBar setUserInteractionEnabled:NO];
    [searchBar resignFirstResponder];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(enableSearchBar) userInfo:nil repeats:NO];
}
-(void) enableSearchBar{
    [searchBar setUserInteractionEnabled:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self onCancleSearch];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)bar{
    [tableViewContainer setHidden:NO];
    [tableViewContainer setAlpha:0];
    [self leSetSize:parentView.bounds.size];
    [UIView animateWithDuration:1 animations:^(void){
        [maskView setAlpha:1];
        [tableViewContainer setAlpha:1];
    }];
    [bar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *) bar{
    [UIView animateWithDuration:1 animations:^(void){
        [maskView setAlpha:0];
        [tableViewContainer setAlpha:0];
    } completion:^(BOOL done){
        [self leSetSize:CGSizeMake(LESCREEN_WIDTH, LENavigationBarHeight)];
        [tableViewContainer setHidden:YES]; 
    }];
    [bar setShowsCancelButton:NO animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchTipsWithKey:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)bar{
    //    NSLog(@"searchBarSearchButtonClicked %@",searchBar.text);
    NSString *key = bar.text;
    [self clearAndSearchGeocodeWithKey:key];
    //    [displayController setActive:NO animated:NO];
    //    searchBar.placeholder = key;
    [searchBar resignFirstResponder];
}
//
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    //    NSLogObject(info);
    NSIndexPath *index=[info objectForKey:LEKeyOfIndexPath];
    AMapTip *tip = [tips objectAtIndex:index.row];
    [self clear];
    [self clearAndSearchGeocodeWithKey:[tip.district stringByAppendingString:tip.name]];
    searchBar.placeholder = tip.name;
}
//=======================Search
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if(search){
        [search setDelegate:nil];
    }
}
-(void) initSearch{
    tips = [NSMutableArray array];
    curSearchAnnotationArray=[[NSMutableArray alloc] init];
    if([AMapServices sharedServices]&&[AMapServices sharedServices].apiKey){
        search=[[AMapSearchAPI alloc]init];
        [search setDelegate:self];
    }
}
/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key{
    if (key.length == 0) {
        return;
    }
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    if(search)
        [search AMapGeocodeSearch:geo];
}
/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key{
    if (key.length == 0) {
        return;
    }
    AMapInputTipsSearchRequest *aMapTips = [[AMapInputTipsSearchRequest alloc] init];
    aMapTips.keywords = key;
    aMapTips.city=@"常州";
    if(search){
        [search AMapInputTipsSearch:aMapTips];
    }
}
/* 清除annotation. */
- (void)clear{
    curSearchAnnotation=nil;
    [curSearchAnnotationArray removeAllObjects];
}
- (void)clearAndSearchGeocodeWithKey:(NSString *)key{
    [self clear];
    [self searchGeocodeWithKey:key];
}
/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    //    NSLog(@"%@ || %@",request,response);
    if (response.geocodes.count == 0) {
        return;
    }
    [curSearchAnnotationArray removeAllObjects];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        CLLocationCoordinate2D coor = ((CLLocationCoordinate2D){obj.location.latitude,obj.location.longitude});
        LEMapViewSearchAnnotation *geocodeAnnotation = [[LEMapViewSearchAnnotation alloc] initWithCoordinate:coor];
        if(response.geocodes.count==1){
            curSearchAnnotation=geocodeAnnotation;
        }
        [curSearchAnnotationArray addObject:geocodeAnnotation];
    }];
    if(self.delegate){
        [self.delegate leOnDoneSearchWith:curSearchAnnotationArray];
    }
    [tableView leOnRefreshedWithData:[@[]mutableCopy]];
    [self onCancleSearch];
}
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    [tips removeAllObjects];
    [tips addObjectsFromArray:response.tips];
    //    NSLog(@"onInputTipsSearchDone %@",tips);
    [tableView leOnRefreshedWithData:tips];
}
@end
