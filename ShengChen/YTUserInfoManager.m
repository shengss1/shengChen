//
//  YTUserInfoManager.m
//  ShengChen
//
//  Created by 金鼎玉铉 on 2019/12/31.
//  Copyright © 2019 金鼎玉铉. All rights reserved.
//

#import "YTUserInfoManager.h"

@implementation YTUserInfoManager


//判断是否为空
+ (BOOL)dx_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

@end
