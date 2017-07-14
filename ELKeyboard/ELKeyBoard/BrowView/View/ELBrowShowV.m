//
//  ELBrowShowV.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELBrowShowV.h"
#import "ELAddBrowCVCell.h"
#import "ELSysBrowCVCell.h"

#import "ELEmotionModel.h"

#import "ELEmotionControl.h"

//pageControll的高度
CGFloat pageControllH = 15;

@interface ELBrowShowV ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>


//@property (nonatomic, strong) ELEmotionControl *pageControll;

@end

@implementation ELBrowShowV

- (id)initWithFrame:(CGRect)frame withEmoArray:(NSMutableArray *)emoArray
{
    if (self = [super initWithFrame:frame]) {
        
        _emoArray = emoArray;
        [self initializa];
    }
    
    return self;
}

- (ELEmotionControl *)pageControll
{
    if (_pageControll == nil) {
        
        _pageControll = [[ELEmotionControl alloc] initWithFrame:CGRectMake(0, _browShowCV.bottom, self.width, pageControllH)];
        [self addSubview:_pageControll];
    }
    return _pageControll;
}

//滑动UICollectionView的时候，能够切换下面的item
- (BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    self.isSelected = NO;
    return NO;
}


- (void)initializa
{
    
    ELCVFlowLayout *flowLayout = [[ELCVFlowLayout alloc] init];
    
    _browShowCV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _browShowCV.backgroundColor = ELColor(237, 237, 246);
    _browShowCV.pagingEnabled = YES;
    _browShowCV.height = self.height-pageControllH;
    _browShowCV.delegate = self;
    _browShowCV.dataSource = self;
    [self addSubview:_browShowCV];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeTap = [[UISwipeGestureRecognizer alloc] init];
    swipeTap.delegate = self;
    [_browShowCV addGestureRecognizer:swipeTap];
    
    [_browShowCV registerClass:[ELSysBrowCVCell class] forCellWithReuseIdentifier:@"ELSysBrowCVCell"];
    [_browShowCV registerClass:[ELAddBrowCVCell class] forCellWithReuseIdentifier:@"ELAddBrowCVCell"];
    
    NSDictionary *emoDic = _emoArray[0];
    NSInteger pageCounts = [emoDic[@"pageCount"] integerValue];
    self.pageControll.numberOfPages = pageCounts;
    
    [self.pageControll addObserver:self
                        forKeyPath:@"index"
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:nil];
    
    [_browShowCV addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _emoArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *emoDic = _emoArray[section];
//    NSString *key = [emoDic allKeys][0];
    NSArray *faceArr = emoDic[@"emotion"];
    
    if (section == 0) {
        
        return faceArr.count;
    }
    else if (section == 1) {

        
        return faceArr.count;
    }
    
    return faceArr.count;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *emoDic = _emoArray[indexPath.section];
//    NSString *key = [emoDic allKeys][0];
    NSArray *faceArr = emoDic[@"emotion"];
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        ELSysBrowCVCell *sysBrowCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ELSysBrowCVCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            sysBrowCell.imgView.hidden = NO;
            sysBrowCell.titleLabel.hidden = YES;
        }
        else if (indexPath.section == 1){
            if ([faceArr[indexPath.row] isEqual:@"Delete_ios7"]) {
                sysBrowCell.imgView.hidden = NO;
                sysBrowCell.titleLabel.hidden = YES;
                UIImage *image = [UIImage imageNamed:faceArr[indexPath.row]];
                sysBrowCell.img = image;
            }
            else {
                
                sysBrowCell.imgView.hidden = YES;
                sysBrowCell.titleLabel.hidden = NO;
                sysBrowCell.titleLabel.text = faceArr[indexPath.row];
            }
            
        }
        
        UIImage *image = [UIImage imageNamed:faceArr[indexPath.row]];
        sysBrowCell.img = image;
        return sysBrowCell;
    }
    
    ELAddBrowCVCell *addBrowCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ELAddBrowCVCell" forIndexPath:indexPath];
    
    addBrowCell.img = [UIImage imageNamed:faceArr[indexPath.row]];
    return addBrowCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *emoDic = _emoArray[indexPath.section];
    //    NSString *key = [emoDic allKeys][0];
    NSArray *faceArr = emoDic[@"keyEmotion"];
    NSString *object = faceArr[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionNotification" object:object userInfo:@{@"section" : @(indexPath.section)}];

//    if (indexPath.section == 0) {
//        NSArray *faceArr = emoDic[@"emotion"];
//        NSString *object = faceArr[indexPath.row];
//        UIImage *image = [UIImage imageNamed:object];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionNotification" object:object userInfo:@{@"section" : @(indexPath.section), @"image" : image}];
//    }
//    else {
//        
//    }

}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 || indexPath.section == 1) {
        return CGSizeMake(self.width/8.0, (self.height-pageControllH)/3.0);
    }
    else {

        return CGSizeMake(self.width/4.0, (self.height-pageControllH)/2.0);
    }

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    //通过这个方法获取到将要滑动到第几组
    NSArray *indexPaths = [_browShowCV indexPathsForVisibleItems];
    NSInteger pageCount = 0;
    if (indexPaths.count > 0)
    {
        NSIndexPath *indexPath = indexPaths[0];
        
        NSDictionary *emoDic = _emoArray[indexPath.section];
        NSInteger pageCounts = [emoDic[@"pageCount"] integerValue];
        self.pageControll.numberOfPages = pageCounts;
        
        //对section中的页码数进行相加，滑动到第二组的话，section为1，相当于x轴偏移量减去第一组的偏移量
        
        for (int index = 0; index < indexPath.section; index++)
        {
            NSDictionary *emoDic = _emoArray[index];
            pageCount += [emoDic[@"pageCount"] integerValue];
        }
        
        /*赋值的时候必须用 "."语法
         *如果是来自ELBrowRaiseV中的点击行为，则不走方法
         */
        if (!self.isSelected) {
            //表情跟随pageControll滑动
            self.section = [NSString stringWithFormat:@"%ld", indexPath.section];
        }
    }
    
    
    if ([keyPath isEqual:@"index"]) {
        //表情跟随pageControll滑动
        [_browShowCV setContentOffset:CGPointMake((pageCount+self.pageControll.currentPage)*CGRectGetWidth(_browShowCV.frame), 0)];
    }
    else if ([keyPath isEqual:@"contentOffset"]) {

        //表情跟随pageControll滑动
        
        //pageControll跟随表情滑动
        NSInteger page = (_browShowCV.contentOffset.x - pageCount*CGRectGetWidth(_browShowCV.frame)) / CGRectGetWidth(_browShowCV.frame);
        
        self.pageControll.currentPage = page;
    
    }
    
}

- (void)dealloc
{
    [self.pageControll removeObserver:self forKeyPath:@"index"];
    [_browShowCV removeObserver:self forKeyPath:@"contentOffset"];
    
}

//- (NSArray *)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
