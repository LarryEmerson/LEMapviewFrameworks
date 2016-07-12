//
//  LEMapSearchBar.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by emerson larry on 15/11/24.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import "LEMapSearchBar.h"
#import "LEBaseTableView.h"
#import "LEBaseTableViewCell.h"

#import "LEMapViewSearchAnnotation.h"


@interface LEMapSearchBarEmptyCell : LEBaseEmptyTableViewCell
@end
@implementation LEMapSearchBarEmptyCell
-(void) initUI{
}
@end
@interface LEMapSearchBarTableView : LEBaseTableView
@end
@implementation LEMapSearchBarTableView
-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LEBaseTableViewCell *cell = [self dequeueReusableCellWithIdentifier:CommonTableViewReuseableCellIdentifier];
    if (cell == nil) {
        cell = [[LEBaseTableViewCell alloc] initWithSettings:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
    }
    AMapTip *tip = self.itemsArray[indexPath.row];
    [cell setData:@{KeyOfCellTitle:tip.name} IndexPath:indexPath];
    return cell;
}
@end

@interface LEMapSearchBar()<UISearchBarDelegate,LETableViewCellSelectionDelegate,LEGetDataDelegate,AMapSearchDelegate>
@end

@implementation LEMapSearchBar{
    UIView *parentView;
    UIView *maskView;
    UISearchBar *searchBar;
    UIButton *buttonCancle;
    //
    LEMapSearchBarTableView *tableView;
    AMapSearchAPI *search;
    NSMutableArray *tips;
    LEMapViewSearchAnnotation *curSearchAnnotation;
    NSMutableArray *curSearchAnnotationArray;
    
    UIView *tableViewContainer;
    
}

-(id) initWithSuperView:(UIView *) parent{
    parentView=parent;
    self.globalVar=[LEUIFramework sharedInstance];
    self=[super initWithFrame:CGRectMake(0, 0, self.globalVar.ScreenWidth, NavigationBarHeight+StatusBarHeight)];
    [self initUI];
    [parent addSubview:self];
    return self;
}
-(void) initUI{
    maskView=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero]];
    [maskView setBackgroundColor:ColorMask2];
    [maskView setAlpha:0];
    
    searchBar=[[UISearchBar alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointMake(0, StatusBarHeight) CGSize:CGSizeMake(self.globalVar.ScreenWidth, NavigationBarHeight)]];
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入地点"];
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setKeyboardType:UIKeyboardTypeDefault];
    [searchBar setTranslucent:YES];
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    //
    tableViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomCenter RelativeView:searchBar Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, parentView.bounds.size.height-StatusBarHeight-NavigationBarHeight)]];
    tableView=[[LEMapSearchBarTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self ParentView:tableViewContainer TableViewCell:nil EmptyTableViewCell:@"LEMapSearchBarEmptyCell" GetDataDelegate:self TableViewCellSelectionDelegate:self]];
    
    [tableView setTopRefresh:NO];
    [tableView setBottomRefresh:NO];
    //    [tableViewContainer setBackgroundColor:[UIColor colorWithRed:0.311 green:1.000 blue:0.932 alpha:0.138]];
    //    [tableView setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.138]];
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
        [tableViewContainer leSetSize:CGSizeMake(self.globalVar.ScreenWidth, parentView.frame.size.height-keyboardRect.size.height-StatusBarHeight-NavigationBarHeight+BottomTabbarHeight)];
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
        [tableViewContainer leSetSize:CGSizeMake(self.globalVar.ScreenWidth, parentView.frame.size.height-keyboardRect.size.height-StatusBarHeight-NavigationBarHeight+BottomTabbarHeight)];
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
}
//
-(void) onRefreshData{}
-(void) onLoadMore{}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
//    NSLogObject(info);
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
//    if([MAMapServices sharedServices]&&[MAMapServices sharedServices].apiKey)
//        search=[[AMapSearchAPI alloc]initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
}
/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key
{
    if (key.length == 0) {
        return;
    }
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    if(search)
        [search AMapGeocodeSearch:geo];
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0) {
        return;
    }
    AMapInputTipsSearchRequest *aMapTips = [[AMapInputTipsSearchRequest alloc] init];
    aMapTips.keywords = key;
    //    NSMutableArray *cityArray=[[NSMutableArray alloc]init];
    //    [cityArray addObject:@"常州"];
    aMapTips.city=@"常州";
    if(search)
        [search AMapInputTipsSearch:aMapTips];
}
/* 清除annotation. */
- (void)clear
{
//    [curMapView removeAnnotations:curSearchAnnotationArray];
//    [curMapView removeAnnotation:curSearchAnnotation];
    curSearchAnnotation=nil;
    [curSearchAnnotationArray removeAllObjects];
}

- (void)clearAndSearchGeocodeWithKey:(NSString *)key
{
    /* 清除annotation. */
    [self clear];
    [self searchGeocodeWithKey:key];
}
/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
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
//    if (curSearchAnnotationArray.count == 1) {
//        [curMapView setCenterCoordinate:[curSearchAnnotationArray[0] coordinate] animated:YES];
//    } else {
//        [curMapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:curSearchAnnotationArray] animated:NO];
//    }
//    [curMapView addAnnotations:curSearchAnnotationArray];
    //    NSLog(@"onGeocodeSearchDone");
    [self onCancleSearch];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
//    NSLog(@"onInputTipsSearchDone %@",response.tips);
    [tips removeAllObjects];
    [tips addObjectsFromArray:response.tips];
    [tableView onRefreshedWithData:tips];
}

@end
