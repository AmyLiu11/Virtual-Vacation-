//
//  Photo+create.m
//  TopPlaces
//
//  Created by apple apple on 12-3-21.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Photo+create.h"
#import "FlickrFetcher.h"
#import "Place+create.h"
#import "Tag+create.h"

@implementation Photo (create)
+(Photo*)photoWithFlickrInfo:(NSDictionary*)FlickrInfo
      inManagedObjectContext:(NSManagedObjectContext*)context
{
    Photo*photo = nil;
    NSFetchRequest *fetchRequest  = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    NSLog(@"name = %@",[FlickrInfo objectForKey:FLICKR_PHOTO_TITLE]);
     NSLog(@"id = %@",[FlickrInfo objectForKey:FLICKR_PHOTO_ID]);
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[FlickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSSortDescriptor*sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
   fetchRequest.sortDescriptors =[NSArray arrayWithObject:sortByTitle];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"num = %d",[matches count]);
    if (!matches||[matches count]>1) {
        //handle the error
    }
    else if([matches count] == 0)
    {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];//Creates, configures, and returns an instance of the class for the entity with a given name.insert a row(managed object) in the table(entity)
        if([FlickrInfo objectForKey:FLICKR_PHOTO_TITLE])
        {
             photo.title = [FlickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        }
        else {
            photo.title = @"Unknown";
        }
        photo.unique  = [FlickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.imageURL = [[FlickrFetcher urlForPhoto:FlickrInfo format:FlickrPhotoFormatLarge] absoluteString];//Returns the string for the receiver as if it were an absolute URL.
        NSLog(@"placename = %@",[FlickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] );
        photo.tookPhotoAt = [Place  placeWithName:[FlickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context]; 
        NSArray *tags = [(NSString*)[FlickrInfo objectForKey:FLICKR_TAGS]  componentsSeparatedByString:@" "];
        for(NSString *t in tags)
        {
            if([t rangeOfString:@":"].location == NSNotFound&&[t stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)//第一个条件表示t不是：，第二个条件表示去除tag中的空格和换行符号之后t不为空，说明此t就是符合条件的标签
            {
                Tag*tag = [Tag tagWithName:[t capitalizedString] inManagedObjectContext:context];
                [photo addHasATagObject:tag];
            }
        }
    }
    else {
        photo = [matches lastObject];
        NSLog(@"name = %@",photo.title);
    }
    return photo;   
}
@end
