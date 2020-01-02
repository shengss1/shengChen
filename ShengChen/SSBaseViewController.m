//
//  SSBaseViewController.m
//  SSGodPanUnion
//
//  Created by 金鼎玉铉 on 2019/8/2.
//  Copyright © 2019 金鼎玉铉. All rights reserved.
//

#import "SSBaseViewController.h"

@interface SSBaseViewController ()

@end

@implementation SSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//
//- (void)popView:(NSString *)title {
//    MBProgressHUD *hud = [MBProgressHUD showMessage:title customView:nil mode:MBProgressHUDModeText toView:self.view];
//    [hud hide:YES afterDelay:1.0f];
//    [hud removeFromSuperViewOnHide];
//}

- (CGFloat)getFuLabelHeightWithString:(NSAttributedString*)attributedStr Size:(CGSize)size{
    
    CGFloat qHeight = [attributedStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    if (qHeight > size.height) {
        return size.height;
    }
    return qHeight;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
