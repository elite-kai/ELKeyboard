//
//  ELSysBrowCVCell.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELSysBrowCVCell.h"

@interface ELSysBrowCVCell ()


@end

@implementation ELSysBrowCVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initializa];
    }
    
    return self;
}

- (void)setImg:(UIImage *)img
{
    _img = img;
    self.imgView.image = _img;
}


- (void)initializa
{
    CGFloat imgViewW = 30;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width-imgViewW)/2, (self.width-imgViewW)/2, imgViewW, imgViewW)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:imgViewW-5];
    [self.contentView addSubview:_titleLabel];
    
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-imgViewW)/2, (self.width-imgViewW)/2, imgViewW, imgViewW)];
    _imgView.image = _img;
    [self.contentView addSubview:_imgView];
}

@end
