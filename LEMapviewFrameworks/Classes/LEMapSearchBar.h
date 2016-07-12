//
//  LEMapSearchBar.h
//  ticket
//
//  Created by emerson larry on 15/11/24.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEUIFramework.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@protocol LEMapSearchBarDelegate<NSObject>
-(void) onDoneSearchWith:(NSMutableArray *) array;
@end
@interface LEMapSearchBar : UIView
@property (nonatomic) LEUIFramework *globalVar;
@property (nonatomic) id<LEMapSearchBarDelegate> delegate;
-(id) initWithSuperView:(UIView *) parent;
@end
