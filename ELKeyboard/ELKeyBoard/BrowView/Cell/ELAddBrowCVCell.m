//
//  ELAddBrowCVCell.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELAddBrowCVCell.h"

@interface ELAddBrowCVCell ()



@end

@implementation ELAddBrowCVCell

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

- (void)layoutSubviews
{
    
}

- (void)setNameL:(UILabel *)nameL
{
    _nameL = nameL;
}


- (void)setImg:(UIImage *)img
{
    _img = img;
    self.imgView.image = _img;
}

- (void)initializa
{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-(self.height-20-4))/2, 2, self.height-20-4, self.height-20-4)];
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    _nameL.textAlignment = NSTextAlignmentCenter;
    _nameL.font = [UIFont systemFontOfSize:13];
    _nameL.text = @"好的";
    [self.contentView addSubview:_imgView];
    [self.contentView addSubview:_nameL];
}

@end
