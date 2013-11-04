//
//  VactionHelper.h
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSMutableDictionary *vacationDocumentDictionary = nil;// add global variable here,so it can be used everywhere in the app .extra credit#1,增加多个vacation
//This is a dictionary where the keys are "Vacations" and the objects are URLs to UIManagedDocument
typedef void (^completion_block_t) (UIManagedDocument *vacation);
@interface VactionHelper : NSObject

+(void)openVacation:(NSString*)vacationName  usingBlock:(completion_block_t)completionBlock;

@end
