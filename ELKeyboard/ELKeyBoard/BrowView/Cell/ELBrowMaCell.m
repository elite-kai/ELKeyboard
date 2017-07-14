//
//  ELBrowMaCell.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELBrowMaCell.h"

@interface ELBrowMaCell ()

@end

@implementation ELBrowMaCell

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

- (void)initializa
{
    CGFloat width = 20;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-width)/2, (self.height-width)/2, width, width)];
//    _imageView.image = _img;
    [self.contentView addSubview:_imageView];

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
//        _imageView.backgroundColor = ELColor(237, 237, 246);
        self.contentView.backgroundColor = ELColor(237, 237, 246);
    }else{
//        _imageView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the view for the selected state
}

@end
