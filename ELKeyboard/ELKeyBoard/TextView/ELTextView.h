//
//  ELTextView.h
//  ELKeyboard
//
//  Created by Parkin on 2017/6/29.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BEditingBlock)();

@protocol ELTextViewDelegate <NSObject>

- (void)sendMessageText:(NSString *)message;

@end

//输入框
@interface ELTextView : UITextView

@property (nonatomic, copy) BEditingBlock bEditingBlock;

@property (nonatomic, weak) id<ELTextViewDelegate>textDelegate;

/**
 *  ELTextView所占高度
 */
@property (nonatomic, copy)void(^changeHeightBlock)(CGFloat height);

@end
