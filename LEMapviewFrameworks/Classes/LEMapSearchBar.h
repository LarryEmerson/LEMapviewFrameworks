//
//  LEMapSearchBar.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by emerson larry on 15/11/24.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEUIFramework.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@protocol LEMapSearchBarDelegate<NSObject>
-(void) leOnDoneSearchWith:(NSMutableArray *) array;
@end
@interface LEMapSearchBar : UIView 
-(id) initWithSuperView:(UIView *) parent;
-(void) leSetDelegate:(id<LEMapSearchBarDelegate>) delegate;
@end
