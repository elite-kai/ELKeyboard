//
//  ELMoreCell.m
//  ELKeyboard
//
//  Created by Parkin on 2017/7/3.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELMoreCell.h"

@implementation ELMoreCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initializa];
    }
    
    return self;
}

- (void)initializa
{
    CGFloat itemW = (self.width-30);
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-itemW)/2, (self.width-itemW)/2, itemW, itemW)];
    [self.contentView addSubview:_imgView];
}

@end
