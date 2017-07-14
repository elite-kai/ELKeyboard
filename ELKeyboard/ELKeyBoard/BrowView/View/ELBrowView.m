//
//  ELBrowView.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/29.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELBrowView.h"
#import "ELBrowShowV.h"
#import "ELBrowRaiseV.h"
#import "ELEmotionControl.h"

@interface ELBrowView ()
//{
//    ELBrowShowV *_browShowV;
//    ELBrowRaiseV *_browRaiseV;
//}

@property (nonatomic, strong) ELBrowShowV *browShowV;
@property (nonatomic, strong) ELBrowRaiseV *browRaiseV;
@property (nonatomic, copy) NSMutableArray *emoArray;

@end

@implementation ELBrowView

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

    _emoArray = [NSMutableArray array];
    //第一组系统表情
    NSMutableDictionary *sysEmoDic = [ELEmoManage emotionManage:@"face.plist" plistType:NSDictionaryType itemCount:24];

    //第二组，系统的小表情
    NSMutableDictionary *sysSmaEmoDic = [ELEmoManage emotionManage:@"Emoji.plist" plistType:NSArrayType itemCount:24];
    
    //第三组，添加的表情
    
    NSMutableDictionary *addEmoDic = [ELEmoManage emotionManage:@"emotion.plist" plistType:NSDictionaryType itemCount:8];
    
    [_emoArray addObject:sysEmoDic];
    [_emoArray addObject:sysSmaEmoDic];
    [_emoArray addObject:addEmoDic];

}

- (void)initializa
{
    //显示表情的view
    _browShowV = [[ELBrowShowV alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-30) withEmoArray:self.emoArray];
//    browShowV.emoArray = self.emoArray;
    [self addSubview:_browShowV];
    
    //下方控制切换表情的view，添加表情，设置等
    _browRaiseV = [[ELBrowRaiseV alloc] initWithFrame:CGRectMake(0, _browShowV.bottom, self.width, self.height-_browShowV.height)];

    [self addSubview:_browRaiseV];
    
    //默认选中第一个
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_browRaiseV.browMaV selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    
    [_browShowV addObserver:self
                forKeyPath:@"section"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context:nil];
    
    [_browRaiseV addObserver:self
                forKeyPath:@"pageIndex"
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context:nil];
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqual:@"section"]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_browShowV.section intValue] inSection:0];
        [_browRaiseV.browMaV selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
    }
    else if ([keyPath isEqual:@"pageIndex"]) {
        
        _browShowV.isSelected = YES;
        
        NSInteger pageCount = 0;
        
        //对section中的页码数进行相加，滑动到第二组的话，section为1，相当于x轴偏移量减去第一组的偏移量
        
        for (int index = 0; index < [_browRaiseV.pageIndex intValue]; index++)
        {
            NSDictionary *emoDic = _emoArray[index];
            pageCount += [emoDic[@"pageCount"] integerValue];
        }
    
        [_browShowV.browShowCV setContentOffset:CGPointMake(pageCount*CGRectGetWidth(_browShowV.browShowCV.frame), 0) animated:NO];
        
        NSDictionary *emoDic = _emoArray[[_browRaiseV.pageIndex intValue]];
        NSInteger pageCounts = [emoDic[@"pageCount"] integerValue];
        _browShowV.pageControll.numberOfPages = pageCounts;
        _browShowV.pageControll.currentPage = 0;

    }
}


- (void)dealloc
{
    [_browRaiseV removeObserver:self forKeyPath:@"pageIndex"];
    [_browShowV removeObserver:self forKeyPath:@"section"];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
