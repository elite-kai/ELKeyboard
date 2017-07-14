//
//  ELBrowRaiseV.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELBrowRaiseV.h"
#import "ELBrowMaCell.h"

@interface ELBrowRaiseV ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) NSMutableArray *dataArray;

@end

@implementation ELBrowRaiseV

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadData];
        [self initializa];
    }
    
    return self;
}

- (void)loadData
{
    _dataArray = [@[@"f_static_000", @"emoji_1_big", @"section0_emotion2"] mutableCopy];
}

- (void)initializa
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = 30;
    //添加按钮
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (self.height-btnWidth)/2, btnWidth, btnWidth)];
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBrowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    //设置按钮
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-btnWidth-10, 0, btnWidth, btnWidth)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setBtn];
    
    
    ELCVFlowLayout *flowLayout = [[ELCVFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40, self.height);
    
    _browMaV = [[UICollectionView alloc] initWithFrame:CGRectMake(addBtn.right, 0, self.width-2*btnWidth-20, self.height) collectionViewLayout:flowLayout];
    _browMaV.backgroundColor = [UIColor whiteColor];
    _browMaV.delegate = self;
    _browMaV.dataSource = self;
    [self addSubview:_browMaV];
    
    [_browMaV registerClass:[ELBrowMaCell class] forCellWithReuseIdentifier:@"ELBrowMaCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELBrowMaCell *maCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ELBrowMaCell" forIndexPath:indexPath];

    maCell.imageView.image = [UIImage imageNamed:_dataArray[indexPath.row]];
//    maCell.selected = YES;
    return maCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    self.pageIndex = [NSString stringWithFormat:@"%ld", indexPath.row];
    NSLog(@"self.index --- %@", self.pageIndex);
}


- (void)addBrowAction:(UIButton *)button
{
    
}

- (void)settingAction:(UIButton *)button
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
