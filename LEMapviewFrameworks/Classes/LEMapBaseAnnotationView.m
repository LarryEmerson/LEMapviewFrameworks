//
//  LEMapBaseAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapBaseAnnotationView.h"

@interface LEMapBaseAnnotationView ()
@property (nonatomic) NSDictionary *leMapData;
@end
@implementation LEMapBaseAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        [self leAdditionalInits]; 
    }
    return self;
} 
-(NSDictionary *) leGetMapData{
    return self.leMapData;
}
-(void) leSetMapData:(NSDictionary *) data{
    self.leMapData=data;
    [self leRefreshUI];
}
-(void) leRefreshUI{
    
}
@end
