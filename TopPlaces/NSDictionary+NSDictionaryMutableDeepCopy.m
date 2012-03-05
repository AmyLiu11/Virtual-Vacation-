//
//  NSDictionary+NSDictionaryMutableDeepCopy.m
//  TopPlaces
//
//  Created by apple apple on 12-2-25.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "NSDictionary+NSDictionaryMutableDeepCopy.h"

@implementation NSDictionary (NSDictionaryMutableDeepCopy)
-(NSMutableDictionary*)mutableCopyDeep
{
    NSMutableDictionary * returnDict = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for (id key in keys) {
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(mutableCopyDeep)]) {
            oneCopy = [oneValue mutableCopyDeep];//此处应用递归，表明oneValue仍然是是一个字典类型，需要执行mutableCopyDeep来进行深复制，直到他不是字典，可以执行别的复制方法
        }
        else if([oneValue respondsToSelector:@selector(mutableCopy)])
        {
            oneCopy = [oneValue mutableCopy];
        }
        if (oneCopy == nil) {
            oneCopy = [oneValue copy];
        }
        [returnDict setValue:oneCopy forKey:key];//此处完成创建深复制可变副本
    }
    return returnDict;
}
@end
