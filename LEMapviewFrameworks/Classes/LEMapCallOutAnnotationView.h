//
//  LEMapCallOutAnnotationView.h
//  four23
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapBaseAnnotationView.h"
#import "LEMapCallOutViewAnnotation.h"
@interface LEMapCallOutAnnotationView : LEMapBaseAnnotationView 
@property (nonatomic) id callOutDelegate;
- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier CallOutDelegate:(id) delegate  SubViewClass:(NSString *) subClass;
-(void) reSetCenterOffset:(int) offset;
@end
