//
//  ELEmoManage.m
//  ELKeyboard
//
//  Created by Parkin on 2017/7/7.
//  Copyright © 2017年 Parkin. All rights reserved.
//

#import "ELEmoManage.h"

static NSMutableArray *emotionArray;
@implementation ELEmoManage

+ (NSMutableDictionary *)emotionManage:(NSString *)plistPath plistType:(NSInteger)type itemCount:(int)count
{

    NSMutableDictionary *emoDic = [self dictionaryWithPlistPath:plistPath plistType:type  withItemCount:count];
    return emoDic;

}

+ (NSMutableDictionary *)dictionaryWithPlistPath:(NSString *)plist plistType:(NSUInteger)plistType withItemCount:(int)count
{
    //存放每组表情和每组表情的页码数的字典
    NSMutableDictionary *emotionDic = [NSMutableDictionary dictionary];
    
    //存放从plist中获取到的表情，用来进行升序排序
    NSMutableArray *emoArray = [NSMutableArray array];
    NSMutableArray *sysEmoArr = [NSMutableArray array];
    
    //对应的key值
    NSMutableArray *emoKeyArray = [NSMutableArray array];
    NSMutableArray *sysKeyEmoArr = [NSMutableArray array];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:nil];
    
    NSArray *array;
    
    if (plistType == NSDictionaryType) {
        
        NSDictionary *emoDic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        for (NSString *key in [emoDic allKeys]) {
            
            [emoKeyArray addObject:key];
            
            NSString *value = emoDic[key];
            [emoArray addObject:value];
        }
        
        //升序
        NSArray *result = [emoArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
            
            return [obj1 compare:obj2];
            
        }];
        array = result;
        //        NSLog(@"result-------- %@", emoDic);
        [sysEmoArr setArray:array];
        
        for (int index = 0; index < result.count; index++) {
            NSString *object = result[index];
            [emoDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                if ([obj isEqual:object])
                {
                    [sysKeyEmoArr addObject:key];
                
                }
            }];
        }
         
        [sysKeyEmoArr setArray:sysKeyEmoArr];
    }
    else if (plistType == NSArrayType) {
        
        NSArray *emoArray = [NSArray arrayWithContentsOfFile:path];
        array = emoArray;
        //        sysEmoArr = [NSMutableArray arrayWithArray:emoArray];
        [sysEmoArr setArray:array];
        [sysKeyEmoArr setArray:emoArray];
    }
    
    //     NSLog(@"sysEmoArr------ %@", sysEmoArr);
    //如果每页的item个数是24的话，要插入删除按钮图标
    if (count == 24) {
        
        for (int index = 0; index < array.count+1; index++) {
            
            //取余，24代表一页的总的cell数
            if ((index+1)%count == 0) {
                [sysEmoArr insertObject:@"Delete_ios7" atIndex:index];
                [sysKeyEmoArr insertObject:@"Delete_ios7" atIndex:index];
            }
            if (index == array.count && (index+1)%count != 0) {
                [sysEmoArr addObject:@"Delete_ios7"];
                [sysKeyEmoArr addObject:@"Delete_ios7"];
            }
        }
    }
    
    [emotionDic setValue:sysKeyEmoArr forKey:@"keyEmotion"];
    [emotionDic setValue:sysEmoArr forKey:@"emotion"];
    //计算每一组的页码数
    NSInteger sysCount = (sysEmoArr.count / count == 0) ? sysEmoArr.count / count : sysEmoArr.count / count+1;
    [emotionDic setValue:@(sysCount) forKey:@"pageCount"];
    
    return emotionDic;
}


@end
