//
//  ELEmoManage.h
//  ELKeyboard
//
//  Created by Parkin on 2017/7/7.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, PlistType) {
    NSArrayType = 0,  //数组类型
    NSDictionaryType //字典类型
};


@interface ELEmoManage : NSObject

+ (NSMutableDictionary *)emotionManage:(NSString *)plistPath plistType:(NSInteger)type itemCount:(int)count;

@end
