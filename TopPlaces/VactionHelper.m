//
//  VactionHelper.m
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "VactionHelper.h"

@implementation VactionHelper
+(void)openVacation:(NSString*)vacationName  usingBlock:(completion_block_t)completionBlock//typedef void (^completion_block_t) (UIManagedDocument *vacation);将block作为参数传递
{
    UIManagedDocument *doc = [vacationDocumentDictionary objectForKey:vacationName];//get the vacation that the User selected in the vacation Table
    NSURL *url = [[[NSFileManager defaultManager]  URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:vacationName];
    // url is now "<Documents Directory>/vacationName".....filepath
    NSLog(@"URL = %@",[url path]);
    NSLog(@"num = %d",[vacationDocumentDictionary count]);
    if (!doc)
    {
        doc = [[UIManagedDocument alloc] initWithFileURL:url];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:doc forKey:vacationName];//开始假期为空，在此创建
          vacationDocumentDictionary = dic;
          NSLog(@"num = %d",[vacationDocumentDictionary count]);
    }
    //if the document exists on disk
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            completionBlock(doc);//hand the UIManagedDocument to the caller using a block
        }];//YES if save operation succeed,then go excute the code in the block
    }//completionHandler is just a block of code to execute when the open/save completes,because open/save take time to happen,they call your block when they are done,then you can use the document(create or open for you).here is creating a document ,so it takes time
    else if(doc.documentState == UIDocumentStateClosed)
    {
        [doc  openWithCompletionHandler:^(BOOL success){
            completionBlock(doc);  //after the document  is opened,call the block,do things you want to do in the UIManagedDocument
        }];
    }//open a document takes time
    else if(doc.documentState ==UIDocumentStateNormal)
    {
          completionBlock(doc);
    }//document has opened for you,so you don't have to use block to wait until it's opened or created
}//此方法避免了在app中任何地方打开doc都要先检查docmentState的情况
@end
