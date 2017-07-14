//
//  ELEmotionModel.m
//  ELKeyboard
//
//  Created by Parkin on 2017/6/30.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELEmotionModel.h"

#import <objc/runtime.h>

@implementation ELEmotionModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (self = [super init]) {
        for (NSString *key in [dic allKeys]) {
            id value = dic[key];
            //1.处理对象类型和数组类型
            if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [self setValue:value forKeyPath:key];
            }
            //2.处理空类型:防止出现unRecognized selector exception
            else if ([value isKindOfClass:[NSNull class]]) {
                //                [self setValue:nil forKey:key];
            }
            //3.处理其他类型：包括数字，字符串，布尔，全部使用NSString来处理
            else{
                [self setValue:[NSString stringWithFormat:@"%@",value] forKeyPath:key];
            }
            
        }
        
    }
    return self;
}


#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%s",__func__);
}
- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"%s",__func__);
}

-(NSString *)description
{
    NSMutableString* text = [NSMutableString stringWithFormat:@"<%@> \n", [self class]];
    NSArray* properties = [self filterPropertys];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* key = (NSString*)obj;
        id value = [self valueForKey:key];
        NSString* valueDescription = (value)?[value description]:@"(null)";
        
        if ( ![value respondsToSelector:@selector(count)] && [valueDescription length]>60  ) {
            valueDescription = [NSString stringWithFormat:@"%@...", [valueDescription substringToIndex:59]];
        }
        valueDescription = [valueDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
        [text appendFormat:@"   [%@]: %@\n", key, valueDescription];
    }];
    [text appendFormat:@"</%@>", [self class]];;
    return text;
    
}

#pragma mark 获取一个类的属性列表
- (NSArray *)filterPropertys
{
    NSMutableArray* props = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for(int i = 0; i < count; i++){
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
        //        NSLog(@"name:%s",property_getName(property));
        //        NSLog(@"attributes:%s",property_getAttributes(property));
    }
    free(properties);
    return props;
}

#pragma mark 模型中的字符串类型的属性转化为字典
-(NSDictionary*)modelStringPropertiesToDictionary
{
    NSArray* properties = [self filterPropertys];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString* key = (NSString*)obj;
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString* va =  (NSString*)value;
            if (va.length > 0) {
                [dic setObject:value forKey:key];
            }
        }
        
    }];
    return dic;
}



@end
