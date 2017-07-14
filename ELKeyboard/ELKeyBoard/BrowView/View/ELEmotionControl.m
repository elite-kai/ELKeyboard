//
//  ELEmotionControl.m
//  ELKeyboard
//
//  Created by Parkin on 2017/7/3.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELEmotionControl.h"

@implementation ELEmotionControl

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initializa];
    }
    
    return self;
}

- (void)initializa
{
    self.backgroundColor = ELColor(237, 237, 246);
    self.currentPageIndicatorTintColor =[UIColor grayColor];
    self.pageIndicatorTintColor =[UIColor lightGrayColor];
    [self addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pageTurn:(UIPageControl*)sender
{
    
    self.index = [NSString stringWithFormat:@"%ld", self.currentPage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
