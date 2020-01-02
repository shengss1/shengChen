//
//  SSBaseViewController.h
//  SSGodPanUnion
//
//  Created by 金鼎玉铉 on 2019/8/2.
//  Copyright © 2019 金鼎玉铉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSBaseViewController : UIViewController
//- (void)popView:(NSString *)title;

//获取富文本高度
- (CGFloat)getFuLabelHeightWithString:(NSAttributedString*)attributedStr Size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
