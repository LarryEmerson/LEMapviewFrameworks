//
//  LEMapViewSettings.h
//  Pods
//
//  Created by emerson larry on 16/7/13.
//
//

#import <Foundation/Foundation.h>
#import "LEFrameworks.h"
@interface LEMapViewSettings : NSObject
LESingleton_interface(LEMapViewSettings);
@property (nonatomic, readonly) NSBundle *leMapviewBundle;
@property (nonatomic, readonly) UIImage *leCompass;
@property (nonatomic, readonly) UIImage *leLocateStatusNormal;
@property (nonatomic, readonly) UIImage *leLocateStatusRotate;
@property (nonatomic, readonly) UIImage *leLocateStatusFollow; 
@property (nonatomic, readonly) UIImage *leScaleUp;
@property (nonatomic, readonly) UIImage *leScaleUpHighlighted;
@property (nonatomic, readonly) UIImage *leScaleDown;
@property (nonatomic, readonly) UIImage *leScaleDownHighlighted;
@property (nonatomic, readonly) UIImage *lePinForSearched;
@property (nonatomic, readonly) UIImage *lePinForUserAsArrow;
- (NSString *) leGetImagePathWithName:(NSString *) name;
- (UIImage *) leGetImageWithName:(NSString *) name;
@end
