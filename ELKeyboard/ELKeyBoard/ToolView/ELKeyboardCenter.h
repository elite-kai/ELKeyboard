//
//  ELKeyboardCenter.h
//  ELKeyboard
//
//  Created by Parkin on 2017/7/4.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ELKeyboardCenterDelegate <NSObject>

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow;

@end

@interface ELKeyboardCenter : NSObject

+ (ELKeyboardCenter *)defaultCenter;


// 参数类型要求：请将作为第一响应者的控件所在的ViewController作为代理传入
// 设置位置要求：请将设置代理的代码放到ViewController的viewWillAppear:方法中
@property (nonatomic,assign) id <ELKeyboardCenterDelegate> delegate;

@end
