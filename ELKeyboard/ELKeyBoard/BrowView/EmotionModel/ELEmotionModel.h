//
//  ELEmotionModel.h
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELEmotionModel : NSObject

- (instancetype)initWithDic:(NSDictionary*)dic;

@property (nonatomic, copy)   NSString *themeIcon;
@property (nonatomic, copy)   NSString *themeDecribe;
@property (nonatomic, strong) NSArray *faceModels;

@end
