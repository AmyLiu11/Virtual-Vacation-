//
//  Place+create.m
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Place+create.h"
#import "FlickrFetcher.h"

@implementation Place (create)
+(Place*)placeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place*place = nil;
    NSFetchRequest *fetchRequest  = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"placeName = %@",name];
    NSSortDescriptor *sortByPlaceName = [NSSortDescriptor sortDescriptorWithKey:@"placeName" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortByPlaceName];//返回符合要求的managedObjects
    NSError *error = nil;
    NSArray*matches = [context executeFetchRequest:fetchRequest error:&error];
    if (!matches||[matches count]>1) {
        //handle the error here
    }
    else if([matches count] == 0)
    {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.placeName = name;
        place.addtime = [NSDate date];
        NSLog(@"time = %@",place.addtime);
        NSLog(@"place = %@",place.placeName);
        //place.photos 不用再设定了，因为在photo中已经设定好了，这是一个inverse relationship，所以在此处不用设定了
    }
   else
   {
       place = [matches lastObject];
   }
   return place;
}
@end
