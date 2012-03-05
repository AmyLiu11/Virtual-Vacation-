//
//  NSDictionary+NSDictionaryMutableDeepCopy.h
//  TopPlaces
//
//  Created by apple apple on 12-2-25.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionaryMutableDeepCopy)
-(NSMutableDictionary*)mutableCopyDeep;
@end
