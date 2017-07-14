//
//  ELMoreView.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/29.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELMoreView.h"
#import "ELMoreCell.h"

@interface ELMoreView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) NSArray *imgArray;

@end

@implementation ELMoreView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initializa];
    }
    
    return self;
}

- (void)initializa
{
    _imgArray = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sp", @"yy"];
    
    ELCVFlowLayout *flowLayout = [[ELCVFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.width / 4.0, self.width / 4.0);
    
    _moreCV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _moreCV.backgroundColor = ELColor(237, 237, 246);
    _moreCV.delegate = self;
    _moreCV.dataSource = self;
    [self addSubview:_moreCV];
    
    [_moreCV registerClass:[ELMoreCell class] forCellWithReuseIdentifier:@"ELMoreCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELMoreCell *moreCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ELMoreCell" forIndexPath:indexPath];
    moreCell.imgView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    return moreCell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
