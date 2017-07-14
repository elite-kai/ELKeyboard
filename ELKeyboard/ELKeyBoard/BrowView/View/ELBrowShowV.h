//
//  ELBrowShowV.h
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELEmotionControl;
//显示表情的view

@interface ELBrowShowV : UIView

- (id)initWithFrame:(CGRect)frame withEmoArray:(NSMutableArray *)emoArray;

@property (nonatomic, strong) UICollectionView *browShowCV;
@property (nonatomic, strong) ELEmotionControl *pageControll;

@property (nonatomic, copy) NSMutableArray *emoArray;

@property (nonatomic, copy) NSString *section;

//是否是来自ELBrowRaiseV的点击 YES是来自ELBrowRaiseV的点击
@property (nonatomic, assign) BOOL isSelected;

@end
