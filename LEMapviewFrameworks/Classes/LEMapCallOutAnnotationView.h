//
//  LEMapCallOutAnnotationView.h
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapBaseAnnotationView.h"
#import "LEMapCallOutViewAnnotation.h"
@interface LEMapCallOutAnnotationView : LEMapBaseAnnotationView
-(id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier CallOutDelegate:(id) delegate  SubViewClass:(NSString *) subClass;
-(id<LEMapViewDelegate>) leGetDelegate;
-(void) leReSetCenterOffset:(int) offset;
-(void) leSetDelegate:(id<LEMapViewDelegate>) delegate;
@end
