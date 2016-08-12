//
//  LEMapViewSettings.m
//  Pods
//
//  Created by emerson larry on 16/7/13.
//
//

#import "LEMapViewSettings.h"

@interface LEMapViewSettings ()
@property (nonatomic, readwrite) NSBundle *leMapviewBundle;
@property (nonatomic, readwrite) UIImage *leCompass;
@property (nonatomic, readwrite) UIImage *leLocateStatusNormal;
@property (nonatomic, readwrite) UIImage *leLocateStatusRotate;
@property (nonatomic, readwrite) UIImage *leLocateStatusFollow;
@property (nonatomic, readwrite) UIImage *leScaleUp;
@property (nonatomic, readwrite) UIImage *leScaleUpHighlighted;
@property (nonatomic, readwrite) UIImage *leScaleDown;
@property (nonatomic, readwrite) UIImage *leScaleDownHighlighted;
@property (nonatomic, readwrite) UIImage *lePinForSearched;
@property (nonatomic, readwrite) UIImage *lePinForUserAsArrow;
@end
@implementation LEMapViewSettings
#pragma Singleton
LESingleton_implementation(LEMapViewSettings);

-(void) leExtraInits{
    self.leMapviewBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LEMapviewFrameworks" ofType:@"bundle"]];
    self.leCompass              =[self leGetImageWithName:@"map_compass"];
    self.leLocateStatusNormal   =[self leGetImageWithName:@"map_btn_status"];
    self.leLocateStatusRotate   =[self leGetImageWithName:@"map_btn_status2"];
    self.leLocateStatusFollow   =[self leGetImageWithName:@"map_btn_status3"]; 
    self.leScaleUp              =[self leGetImageWithName:@"mapScaleUp"];
    self.leScaleDown            =[self leGetImageWithName:@"mapScaleDown"];
    self.leScaleUpHighlighted   =[self leGetImageWithName:@"mapScaleUp2"];
    self.leScaleDownHighlighted =[self leGetImageWithName:@"mapScaleDown2"];
    self.lePinForSearched       =[self leGetImageWithName:@"map_pin_searched"];
    self.lePinForUserAsArrow    =[self leGetImageWithName:@"map_userpin_arrow"];
    
}
- (NSString *) leGetImagePathWithName:(NSString *) name{
    NSString *path= [NSString stringWithFormat:@"%@/%@.png",self.leMapviewBundle.bundlePath,name];
    return path;
}
- (UIImage *) leGetImageWithName:(NSString *) name{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self leGetImagePathWithName:name]];
    return image;
}
@end
