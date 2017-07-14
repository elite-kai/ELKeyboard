//
//  ViewController.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/29.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ViewController.h"
#import "ELKeyboard.h"

@interface ViewController ()<ELKeyboardDelegate>

@property (nonatomic, strong) ELKeyboard *keyBoard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _keyBoard = [[ELKeyboard alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    _keyBoard.delegate = self;
    [self.view addSubview:_keyBoard];
    

}

#pragma mark - ELKeyboardDelegate
- (void)sendMessageText:(NSString *)message
{
    self.textLab.text = message;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
