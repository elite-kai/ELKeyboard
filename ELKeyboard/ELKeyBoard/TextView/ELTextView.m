//
//  ELTextView.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/29.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELTextView.h"
#import "NSString+EMOEmoji.h"

//Emoji default max size

//行间距
static CGFloat lineSpacing = 5;

@interface ELTextView ()<UITextViewDelegate>

@property (nonatomic, copy) NSMutableString *textString;
@property (nonatomic, copy) NSArray *emoArray;

@property (nonatomic, copy) NSString *placeholder;




@end

@implementation ELTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initializa];
    }
    
    return self;
}

- (void)initializa
{
    self.layer.borderColor = ELColor(165, 165, 165).CGColor;
    self.layer. masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderWidth = 0.5f;

    self.returnKeyType = UIReturnKeySend;
    self.enablesReturnKeyAutomatically = YES;
   //解决内容自适应的时候，换行的时候文字会跳到顶部，再次输入会跳回原来的位置，让 scrollEnabled 为 NO
    self.scrollEnabled = NO;
    
    NSMutableDictionary *sysEmoDic = [ELEmoManage emotionManage:@"face.plist" plistType:NSDictionaryType itemCount:24];
    _emoArray = sysEmoDic[@"keyEmotion"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emotionNotification:) name:@"EmotionNotification" object:nil];
    

    //必须让delaysContentTouches为NO，点击uitextview的时候才会马上调用touchesCancelled
    self.delaysContentTouches = NO;
    self.delegate = self;

    
}



- (void)emotionNotification:(NSNotification *)notification
{
    NSString *text = [notification object];
    
    //删除
    if ([text isEqual:@"Delete_ios7"])
    {
        [self deleteBackward];
        
    }
    else
    {
        //添加文本
        [self replaceRange:self.selectedTextRange withText:(NSString *)text];
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    // 判断是否有候选字符，如果不为nil，代表有候选字符, 设置行间距
    if(textView.markedTextRange == nil){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpacing; // 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    }
    
    [self textViewHight:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    NSLog(@"开始编辑");
//    if ([super.text isEqual:_placeholder]) {
//        super.text = @"";
//        [super setTextColor:[UIColor blackColor]];
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        if ([self.textDelegate respondsToSelector:@selector(sendMessageText:)]) {
            [self.textDelegate sendMessageText:self.text];
            self.text = nil;
            [self textViewHight:NO];
        }
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)deleteBackward
{
    NSString *souceText = self.text;
    if (souceText.length == 0) return;
    
    NSRange range = self.selectedRange;
    
    if (range.location == NSNotFound)
    {
        
        range.location = self.text.length;
        
    }
    
    //正则匹配要替换的文字的范围
    
    //正则表达式
    
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    
    NSError *error = nil;
    
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re)
    {
        
        NSLog(@"%@", [error localizedDescription]);
        
    }
    
    //通过正则表达式来匹配字符串
    
    NSArray *resultArray = [re matchesInString:souceText options:0 range:NSMakeRange(0, souceText.length)];
    NSTextCheckingResult *checkingResult = resultArray.lastObject;

//    checkingResult.range
    for (NSString *faceName in _emoArray)
    {
        
        if ([souceText hasSuffix:@"]"] && (self.text.length - checkingResult.range.location == checkingResult.range.length))
        {
            if ([[souceText substringWithRange:checkingResult.range] isEqualToString:faceName])
            {
                
                NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length];
                
                self.text = newText;
                [self textViewHight:YES];
                return;
                
            }
            
        }
        else
        {
            
            if ([self.text emo_isPureEmojiString]) {
                NSArray *emotions = [self.text emo_emojiRanges];
                NSValue *value = emotions.lastObject;
                NSRange range = [value rangeValue];
                
                //最后一位是表情
                NSString *newText = [souceText substringToIndex:self.text.length-range.length];
                self.text = newText;
                [self textViewHight:YES];
                return;
            }
            else
            {
                //最后一位是text
                NSString *newText = [souceText substringToIndex:self.text.length-1];
                self.text = newText;
                [self textViewHight:YES];
                return;
            }
        }
    }

    //这是针对用户手动输入]的时候处理的
    if ([souceText hasSuffix:@"]"])
    {
        //最后一位是text
        NSString *newText = [souceText substringToIndex:self.text.length-1];
        self.text = newText;
        [self textViewHight:YES];
        return;
        
    }
}

- (void)textViewHight:(BOOL)isDelete
{
    //当内容出现第几行的时候开始滚动页面
    NSInteger lineNumber = 3;
    //34和23是根据字体大小变得，这个还需要调整
    CGFloat fixHeight = 34+(lineNumber-1)*23;
    
    CGFloat height = [self sizeThatFits:CGSizeMake(self.size.width, MAXFLOAT)].height;

    if (height > fixHeight) {
        
        self.scrollEnabled = YES;
        self.contentInset = UIEdgeInsetsMake(0, 0, 2*lineSpacing, 0);
        return;
    }
    else
    {
        if (isDelete) {
            self.contentInset = UIEdgeInsetsMake(2*lineSpacing, 0, 0, 0);
        }
        
        self.scrollEnabled = NO;
        
        if (self.changeHeightBlock != nil)
        {
            self.changeHeightBlock(height);
            
        }
    }
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
}

- (NSString *)text
{
    NSString *text = [super text];
    if ([text isEqual:_placeholder]) {
        return @"";
    }
    return text;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"------------- %d", [self ]);
    [[self nextResponder] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EmotionNotification" object:nil];
}

//        if ([userInfo[@"section"] isEqualToNumber:@0]) {
//
//            //添加表情
//            NSTextAttachment *emojiTextAttachment = [[NSTextAttachment alloc] init];
//
//            //设置表情图片
//            emojiTextAttachment.image = (UIImage *)userInfo[@"image"];
//
//            NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
//
//            [self.textStorage insertAttributedString:str atIndex:self.selectedRange.location];
//
//            self.selectedRange = NSMakeRange(self.selectedRange.location+1, 0); //
//            NSRange wholeRange = NSMakeRange(0, self.textStorage.length);
//
//            [self.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
//
//            [self.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:wholeRange];
//
//        }
//        else
//        {
//            //添加文本
//            [self replaceRange:self.selectedTextRange withText:(NSString *)text];
//
//        }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
