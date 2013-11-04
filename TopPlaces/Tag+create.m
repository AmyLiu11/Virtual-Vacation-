//
//  Tag+create.m
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Tag+create.h"
#import "FlickrFetcher.h"
#import "Photo+create.h"

@implementation Tag (create)

+(Tag*)tagWithName:(NSString*)name   inManagedObjectContext:(NSManagedObjectContext*)context
{
    Tag *tag=nil;
    NSFetchRequest*fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title = %@",name];//此处的字符串有语义，相当于数据库中的条件语句
    NSLog(@"Tag = %@",name);
    NSSortDescriptor *sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortByTitle];//返回符合要求的managedObjects
    NSArray*matches = [context executeFetchRequest:fetchRequest error:nil];
    if (!matches||[matches count]>1) {
        //handle the error here
    }
    else if([matches  count]== 0)
    {
        tag= [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.title = name;
        //tag.numOfPhoto
    }
    else {
        tag = [matches lastObject];
    }
    return tag;
}
@end
