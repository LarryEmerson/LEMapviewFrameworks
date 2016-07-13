//
//  LEShowQrcode.m
//  Letou
//
//  Created by emerson larry on 16/3/21.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEShowQrcode.h"

@interface LEShowQrcodePage : LEBaseView
@end
@implementation LEShowQrcodePage{
    NSString *curQrcode;
    UIImageView *curQrcodeView;
}
-(void) setExtraViewInits{
    int size=self.curFrameWidth*3/4;
    curQrcodeView=[LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(size,size)] Image:[LEUIFramework createQRForString:curQrcode Size:size]];
}
-(id) initWithViewController:(LEBaseViewController *)vc Qrcode:(NSString *) qrcode{
    curQrcode=qrcode;
    self=[super initWithViewController:vc];
    return self;
}
@end
@interface LEShowQrcode ()
@end
@implementation LEShowQrcode{
    LEShowQrcodePage *page;
} 
-(id) initWithTitle:(NSString *) title Qrcode:(NSString *) qrcode{
    self=[super init];
    page=[[LEShowQrcodePage alloc] initWithViewController:self Qrcode:qrcode];
    [self.navigationItem setTitle:title];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.view addSubview:page];
    [self setLeftBarButtonAsBackWith:IMG_ArrowLeft];
}

@end
