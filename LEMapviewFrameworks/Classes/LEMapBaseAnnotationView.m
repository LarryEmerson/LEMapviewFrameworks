//
//  LEMapBaseAnnotationView.m
//  https://github.com/LarryEmerson/LEMapviewFrameworks
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapBaseAnnotationView.h"

@implementation LEMapBaseAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        [self initUI]; 
    }
    return self;
}
-(void) initUI{

}
-(void) setCurData:(NSDictionary *)curData{
    _curData=curData;
    [self refreshUI];
}
-(void) refreshUI{

}
@end
