//
//  ELKeyboard.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/29.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELKeyboard.h"
#import "ELKeyboardCenter.h"
#import "ELTVVoiceBtn.h"

#import "ELTextView.h"
#import "ELBrowView.h"
#import "ELMoreView.h"
#import "ELTVVoiceBtn.h"

//按钮的宽度
static CGFloat KeyBoardBtnWidth = 34;
static CGFloat KeyboardHeight = 200;

//按钮与边框之间的间距
static CGFloat interval = 5;
//textview与其它按钮的间距
static CGFloat textVItl = 5;
//输入框的高度
static CGFloat textVHight = 34;


#define ELScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ELScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface ELKeyboard ()<ELKeyboardCenterDelegate, ELTextViewDelegate>

@property (nonatomic, assign) CGFloat initHeight; //初始化 ELKeyboard 的高度

@property (nonatomic, assign) CGFloat oneselfHeight;  //键盘落下和抬起的高度
@property (nonatomic, assign) CGFloat textViewHeight; //textview的高度

@property (nonatomic, assign) BOOL isBecomeFirstResponder;

@end

@implementation ELKeyboard

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"isbecome  %d", self.isBecomeFirstResponder);
        _initHeight = frame.size.height;
        self.backgroundColor = ELColor(241, 241, 248);
        [self initializa];
    }
    
    return self;
}


- (void)initializa
{
    NSLog(@"-------bottom   %f", self.bottom);
    // 设置代理
    [ELKeyboardCenter defaultCenter].delegate = self;
    
    //语音
    _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(interval, (self.height-KeyBoardBtnWidth)/2, KeyBoardBtnWidth, KeyBoardBtnWidth)];
    //    _voiceBtn.backgroundColor = [UIColor blackColor];
    [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_yuyin_nor"] forState:UIControlStateNormal];
    [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_jianpan_nor"] forState:UIControlStateSelected];
    [_voiceBtn addTarget:self action:@selector(voiceSceneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_voiceBtn];
    
    //更多
    _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-KeyBoardBtnWidth-interval, _voiceBtn.top, KeyBoardBtnWidth, KeyBoardBtnWidth)];
    //    _moreBtn.backgroundColor = [UIColor blackColor];
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_gengduo_nor"] forState:UIControlStateNormal];
    [_browBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_gengduo_nor"] forState:UIControlStateSelected];
    [_moreBtn addTarget:self action:@selector(moreSceneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    
    //表情
    _browBtn = [[UIButton alloc] initWithFrame:CGRectMake(_moreBtn.left-KeyBoardBtnWidth, _voiceBtn.top, KeyBoardBtnWidth, KeyBoardBtnWidth)];
    //    _browBtn.backgroundColor = [UIColor blackColor];
    [_browBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_nor"] forState:UIControlStateNormal];
    [_browBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_jianpan_nor"] forState:UIControlStateSelected];
    [_browBtn addTarget:self action:@selector(browSceneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_browBtn];
    
    //表情
    _browView = [[ELBrowView alloc] initWithFrame:CGRectMake(0, 0, self.width, KeyboardHeight)];
    //更多
    _moreView = [[ELMoreView alloc] initWithFrame:CGRectMake(0, 0, self.width, KeyboardHeight)];

    
    //输入框
    _textView = [[ELTextView alloc] initWithFrame:CGRectMake(_voiceBtn.right+textVItl, (self.height-textVHight)/2, self.width-interval-2*textVItl-3*KeyBoardBtnWidth-interval, textVHight)];
    _textView.textDelegate = self;
    [self addSubview:_textView];
    

    __weak __typeof(self)weakself = self;
    
    
    _textView.changeHeightBlock = ^(CGFloat height) {
    
        weakself.frame = CGRectMake(0, ELScreenHeight-(height+(weakself.initHeight-textVHight))-weakself.oneselfHeight, weakself.width, height+(weakself.initHeight-textVHight));
        weakself.textView.frame = CGRectMake(_voiceBtn.right+textVItl, (weakself.height-height)/2, weakself.width-interval-2*textVItl-3*KeyBoardBtnWidth-interval, height);

        NSLog(@"weakself.frame   %@", weakself);
        NSLog(@"weakself.textView.frame   %@", weakself.textView);
        weakself.textViewHeight = height;
        
        height = (height == textVHight) ? 0 : height-textVHight;
        weakself.voiceBtn.top = weakself.browBtn.top = weakself.moreBtn.top = (weakself.initHeight-KeyBoardBtnWidth)/2+height;
        
    };
    
    _tvVoiceBtn = [[ELTVVoiceBtn alloc] initWithFrame:_textView.bounds];
    [_textView addSubview:_tvVoiceBtn];
    
}


/*
 resignFirstResponder  让键盘下落
 resignFirstResponder  让键盘抬起
 */


//点击语音按钮
- (void)voiceSceneAction:(UIButton *)button
{
    
    
    _browBtn.selected = NO;
    _moreBtn.selected = NO;
    
    if (button.selected) {
        
        //设置frame
        self.textViewHeight = (self.textViewHeight == 0) ? textVHight : self.textViewHeight;
        self.frame = CGRectMake(0, ELScreenHeight-(self.textViewHeight+14)-self.oneselfHeight, self.width, self.textViewHeight+14);
        self.textView.frame = CGRectMake(_voiceBtn.right+textVItl, (self.height-self.textViewHeight)/2, self.width-interval-2*textVItl-3*KeyBoardBtnWidth-interval, self.textViewHeight);
        
        [self resetBtnFrame];
        
        
        _textView.inputView = nil;
        _tvVoiceBtn.hidden = YES;
        
        self.isBecomeFirstResponder = YES;
        [_textView becomeFirstResponder];
    
    }
    else {
        
        //设置frame 最开始的frame
        self.frame = CGRectMake(0, ELScreenHeight-_initHeight-self.oneselfHeight, self.width, _initHeight);
        _textView.frame = CGRectMake(_voiceBtn.right+textVItl, (self.height-textVHight)/2, self.width-interval-2*textVItl-3*KeyBoardBtnWidth-interval, textVHight);
        
        _tvVoiceBtn.height = _textView.height;
        self.voiceBtn.top = self.browBtn.top = self.moreBtn.top = (self.initHeight-KeyBoardBtnWidth)/2;
        
        
        self.isBecomeFirstResponder = NO;
        [_textView resignFirstResponder];
        _tvVoiceBtn.hidden = NO;
        
    }
    
    
    button.selected = !button.selected;
}

//点击表情按钮
- (void)browSceneAction:(UIButton *)button
{
     //设置frame
    [self resetFrame];
    
    _tvVoiceBtn.hidden = YES;
    _voiceBtn.selected = NO;
    _moreBtn.selected = NO;
    
    [_textView resignFirstResponder];
    [_textView canCancelContentTouches];
    
    if (!button.selected) {
        self.isBecomeFirstResponder = NO;
        _textView.inputView = _browView;
        
    }
    else {
        self.isBecomeFirstResponder = YES;
        _textView.inputView = nil;
    }
    
    
    [_textView becomeFirstResponder];
    
    
    button.selected = !button.selected;
    
}

//点击更多按钮
- (void)moreSceneAction:(UIButton *)button
{
     //设置frame
    [self resetFrame];
    
    _tvVoiceBtn.hidden = YES;
    _voiceBtn.selected = NO;
    _browBtn.selected = NO;
    [_textView resignFirstResponder];
    
    if (!button.selected) {
        self.isBecomeFirstResponder = NO;
        _textView.inputView = _moreView;
    }
    else {
        self.isBecomeFirstResponder = YES;
        _textView.inputView = nil;
    }
    
    [_textView becomeFirstResponder];
    button.selected = !button.selected;
}


//设置frame
- (void)resetFrame
{
    if (_voiceBtn.selected) {
        
        self.textViewHeight = (self.textViewHeight == 0) ? textVHight : self.textViewHeight;
        
        self.frame = CGRectMake(0, ELScreenHeight-(self.textViewHeight+14)-self.oneselfHeight, self.width, self.textViewHeight+14);
        self.textView.frame = CGRectMake(_voiceBtn.right+textVItl, (self.height-self.textViewHeight)/2, self.width-interval-2*textVItl-3*KeyBoardBtnWidth-interval, self.textViewHeight);
        
        CGFloat height = (self.textViewHeight == textVHight) ? 0 : self.textViewHeight-textVHight;
        self.voiceBtn.top = self.browBtn.top = self.moreBtn.top = (self.initHeight-KeyBoardBtnWidth)/2 + height;
        
        [self resetBtnFrame];
    }
}

- (void)resetBtnFrame
{
    CGFloat height = (self.textViewHeight == textVHight) ? 0 : self.textViewHeight-textVHight;
    self.voiceBtn.top = self.browBtn.top = self.moreBtn.top = (self.initHeight-KeyBoardBtnWidth)/2 + height;

}

#pragma mark - ELKeyboardCenterDelegate

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow{
    
//    NSLog(@"ViewController1 接收到%@通知\n高度值：%f\n时间：%f",isShow ? @"弹出":@"隐藏", height,animationDuration);
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:7];
    self.top = ELScreenHeight - height - self.height;
    _oneselfHeight = height;
    [UIView commitAnimations];
    
}

#pragma mark - ELTextViewDelegate
- (void)sendMessageText:(NSString *)message
{

    if ([self.delegate respondsToSelector:@selector(sendMessageText:)]) {
        [self.delegate sendMessageText:message];
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (self.isBecomeFirstResponder == NO)
    {
        UITouch *touch = [touches anyObject];
        
        if ([touch.view isKindOfClass:NSClassFromString(@"UITextView")])
        {
            self.voiceBtn.selected = NO;
            self.browBtn.selected = NO;
            self.moreBtn.selected = NO;
            
            [self.textView resignFirstResponder];
            self.textView.inputView = nil;
            [self.textView becomeFirstResponder];
            
            self.isBecomeFirstResponder = YES;
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
