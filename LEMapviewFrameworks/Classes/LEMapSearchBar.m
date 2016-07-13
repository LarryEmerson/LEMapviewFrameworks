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


@interface LEMapSearchBarEmptyCell : LEBaseEmptyTableViewCell
@end
@implementation LEMapSearchBarEmptyCell
-(void) initUI{
    [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"暂无内容" FontSize:LayoutFontSize10 Font:nil Width:0 Height:0 Color:ColorTextBlack Line:1 Alignment:NSTextAlignmentCenter]];
}
@end
@interface LEMapSearchBarCell : LEBaseTableViewCell
@end
@implementation LEMapSearchBarCell{
    UILabel *curLabel;
}
-(void) initUI{
    curLabel=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(LayoutSideSpace, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:LayoutFontSize10 Font:nil Width:0 Height:0 Color:ColorTextBlack Line:1 Alignment:NSTextAlignmentLeft]];
}
-(void) setData:(id)data IndexPath:(NSIndexPath *)path{
    [super setData:data IndexPath:path];
    AMapTip *tip=(AMapTip *)data;
    [curLabel leSetText:tip.name];
}
@end
//@interface LEMapSearchBarTableView : LEBaseTableViewWithRefresh
//@end
//@implementation LEMapSearchBarTableView
//-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LEMapSearchBarCell *cell = [self dequeueReusableCellWithIdentifier:CommonTableViewReuseableCellIdentifier];
//    if (cell == nil) {
//        cell = [[LEMapSearchBarCell alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
//    }
//    AMapTip *tip = self.itemsArray[indexPath.row];
//    [cell setData:tip.name IndexPath:indexPath];
//    return cell;
//}
//@end
@interface LEMapSearchBar()<UISearchBarDelegate,LETableViewCellSelectionDelegate,AMapSearchDelegate>
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
-(id) initWithSuperView:(UIView *) parent{
    parentView=parent;
    self.globalVar=[LEUIFramework sharedInstance];
    self=[super initWithFrame:CGRectMake(0, 0, self.globalVar.ScreenWidth, NavigationBarHeight)];
    [self initUI];
    [parent addSubview:self];
    return self;
}
-(void) initUI{
    tips=[[NSMutableArray alloc] init];
    maskView=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [maskView setBackgroundColor:ColorMask2];
    [maskView setAlpha:0];
    searchBar=[[UISearchBar alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, NavigationBarHeight)]];
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入地点"];
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setKeyboardType:UIKeyboardTypeDefault];
    [searchBar setTranslucent:YES];
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    //
    tableViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomCenter RelativeView:searchBar Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, parentView.bounds.size.height-NavigationBarHeight)]];
    tableView=[[LEBaseTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self ParentView:tableViewContainer TableViewCell:@"LEMapSearchBarCell" EmptyTableViewCell:@"LEMapSearchBarEmptyCell" GetDataDelegate:nil TableViewCellSelectionDelegate:self]];
    
    [tableView setTopRefresh:NO];
    [tableView setBottomRefresh:NO];
    //    [tableViewContainer setBackgroundColor:[UIColor colorWithRed:0.311 green:1.000 blue:0.932 alpha:0.138]];
    //    [tableView setBackgroundColor:[UIColor colorWithRed:0.9859 green:0.0 blue:0.027 alpha:0.5]];
    //
    [tableViewContainer addTapEventWithSEL:@selector(onCancleSearch) Target:self];
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
        [tableViewContainer leSetSize:CGSizeMake(self.globalVar.ScreenWidth, parentView.frame.size.height-keyboardRect.size.height-NavigationBarHeight)];
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
        [tableViewContainer leSetSize:CGSizeMake(self.globalVar.ScreenWidth, parentView.frame.size.height-keyboardRect.size.height-NavigationBarHeight)];
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
        [self leSetSize:CGSizeMake(self.globalVar.ScreenWidth, NavigationBarHeight)];
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
    searchBar.placeholder = key;
    [searchBar resignFirstResponder];
}
//
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSLogObject(info);
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    AMapTip *tip = [tips objectAtIndex:index.row];
    [self clear];
    [self clearAndSearchGeocodeWithKey:[tip.district stringByAppendingString:tip.name]];
    searchBar.placeholder = tip.name;
}
//=======================Search
-(void) dealloc{
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
        [self.delegate onDoneSearchWith:curSearchAnnotationArray];
    }
    [tableView onRefreshedWithData:[@[]mutableCopy]];
    [self onCancleSearch];
}
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    [tips removeAllObjects];
    [tips addObjectsFromArray:response.tips];
    //    NSLog(@"onInputTipsSearchDone %@",tips);
    [tableView onRefreshedWithData:tips];
    [tableView reloadData];
}
@end
