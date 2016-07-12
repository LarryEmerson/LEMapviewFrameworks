//
//  LEBaseTableView.h
//  https://github.com/LarryEmerson/LEFrameworks
//
//  Created by Larry Emerson on 15/2/4.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LEBaseEmptyTableViewCell.h"

#define KeyOfClassNameForTableView @"tableview"
#define KeyOfClassNameForTableViewCell @"cell"
#define KeyOfClassNameForTableViewEmptyCell @"emptycell"
#define KeyOfSuperViewContainer @"superviewcontainer"
#define KeyOfParentView @"parentview"
#define KeyOfGetDataDelegate @"getdata"
#define KeyOfSetDataDelegate @"setdata"
#define KeyOfCellSelectionDelegate @"cellselection"

#define KeyOfCellSplit @"cellsplit"
#define KeyOfCellIndexPath  @"cellindex"
#define KeyOfCellClickStatus @"cellstatus"
#define KeyOfCellClickStatusContent @"cellstatuscontent"
#define KeyOfCellClickStatusContentExtra @"cellstatuscontentextra"
#define KeyOfCellClickDefaultStatus 0
#define KeyOfCellClickDetailesStatus 1

#define KeyOfCellTitle @"emptycelltitle"

#define CommonTableViewReuseableCellIdentifier @"LECELL"

@protocol LETableViewCellSelectionDelegate <NSObject>
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *) info;
@end

@protocol LEGetDataDelegate <NSObject>
-(void) onRefreshData;
@optional
-(void) onLoadMore;
@end

@interface LETableViewCellSettings : NSObject
@property (nonatomic) id<LETableViewCellSelectionDelegate> selectionDelegate;
@property (nonatomic) UITableViewCellStyle style;
@property (nonatomic) NSString *reuseIdentifier;
@property (nonatomic) BOOL gesture;
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate;
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate EnableGesture:(BOOL) gesture;
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate reuseIdentifier:(NSString *) reuseIdentifier;
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate reuseIdentifier:(NSString *) reuseIdentifier  EnableGesture:(BOOL) gesture;
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate TableViewCellStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier;
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate TableViewCellStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier  EnableGesture:(BOOL) gesture;
@end
@interface LETableViewSettings : NSObject
@property (nonatomic) NSString *emptyTableViewCellClassName;
@property (nonatomic) NSString *tableViewCellClassName;
@property (nonatomic) UIView *superViewContainer;
@property (nonatomic) UIView *parentView;
@property (nonatomic) id<LEGetDataDelegate> getDataDelegate;
@property (nonatomic) id<LETableViewCellSelectionDelegate> tableViewCellSelectionDelegate;
@property (nonatomic) BOOL isAutoRefresh;
-(id) initWithSuperViewContainer:(UIView *) superView ParentView:(UIView *) parent GetDataDelegate:(id<LEGetDataDelegate>) get   TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selection;
-(id) initWithSuperViewContainer:(UIView *) superView ParentView:(UIView *) parent TableViewCell:(NSString *) cell EmptyTableViewCell:(NSString *) empty GetDataDelegate:(id<LEGetDataDelegate>) get   TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selection;
-(id) initWithSuperViewContainer:(UIView *) superView ParentView:(UIView *) parent TableViewCell:(NSString *) cell EmptyTableViewCell:(NSString *) empty GetDataDelegate:(id<LEGetDataDelegate>) get   TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selection AutoRefresh:(BOOL) autorefresh;
@end

@interface LEBaseTableView : UITableView
@property (nonatomic) LEBaseEmptyTableViewCell *emptyTableViewCell;
@property (nonatomic) id<LEGetDataDelegate> getDataDelegate;
@property (nonatomic) id<LETableViewCellSelectionDelegate> cellSelectionDelegate;
@property (nonatomic) UIView * superViewContainer;
@property (nonatomic) NSMutableArray *itemsArray;
@property (nonatomic) NSString *emptyTableViewCellClassName;
@property (nonatomic) NSString *tableViewCellClassName;
- (id) initWithSettings:(LETableViewSettings *) settings; 
-(void) initTableView NS_REQUIRES_SUPER;
-(void) setTopRefresh:(BOOL) enable;
-(void) setBottomRefresh:(BOOL) enable;
//
-(void) onStopTopRefresh;
-(void) onStopBottomRefresh;
-(void) onAutoRefresh;
-(void) onAutoRefreshWithDuration:(float) duration;
-(void) onRefreshedWithData:(NSMutableArray *)data;
-(void) onLoadedMoreWithData:(NSMutableArray *)data;
-(NSInteger) _numberOfSections;
-(CGFloat) _heightForSection:(NSInteger) section;
-(UIView *) _viewForHeaderInSection:(NSInteger) section;
-(NSInteger) _numberOfRowsInSection:(NSInteger) section;
-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *) indexPath;
@end