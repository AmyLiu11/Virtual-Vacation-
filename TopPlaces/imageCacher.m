//
//  imageCacher.m
//  TopPlaces
//
//  Created by apple apple on 12-3-13.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "imageCacher.h"
#import "FlickrFetcher.h"
#define TEN_MB 10485760 //1024*1024*10

@implementation imageCacher

+(void)cacheImg:(UIImage*)img   withImgInfo:(NSString*)info
{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSURL * url = [[fileManager  URLsForDirectory:NSCachesDirectory inDomains:NSUserDirectory] lastObject];//获得存储缓存图片的路径,后面还要后缀图片名才是完整路径
    NSString * filePath = url.path;
    filePath = [filePath stringByAppendingFormat:@"/%@.jpg",info];
    NSLog(@"the filepath is %@",filePath);
    [UIImageJPEGRepresentation(img, 1)  writeToFile:filePath atomically:NO];
    //压缩照片，存入照片，待会改成yes试试
    
    NSArray *cachedFiles = [fileManager contentsOfDirectoryAtPath:filePath error:nil];//performs a shallow search of the specified directory and returns the paths of any contained items
    //returns an array of NSString objects返回每个item的文件名
    int sizeOfCachedImages = 0;
    for(NSString*fileName in cachedFiles)
    {
        NSLog(@"the file name is %@",fileName);
        sizeOfCachedImages+=[[[fileManager attributesOfItemAtPath:[url.path stringByAppendingFormat:@"/%@",fileName]  error:nil] objectForKey:NSFileSize] intValue];//attributeOfItemAtPath返回的是NSDictionary of File Attribute Keys
    }
     
    if (sizeOfCachedImages > TEN_MB) 
    {
        sizeOfCachedImages = 0;
        NSString *lastItemName;
        
        for(NSString*fileName in cachedFiles)
        {
            NSLog(@"the file name is %@",fileName);
            if ([[fileManager attributesOfItemAtPath:[url.path stringByAppendingFormat:@"/%@",lastItemName] error:nil] objectForKey:NSFileCreationDate] <[[fileManager attributesOfItemAtPath:[url.path stringByAppendingFormat:@"/%@",fileName] error:nil] objectForKey:NSFileCreationDate]) 
               {
                         lastItemName = fileName;//开始lastItemName为0,所以必然要赋值
               }
             sizeOfCachedImages+=[[[fileManager attributesOfItemAtPath:[url.path stringByAppendingFormat:@"/%@",fileName]  error:nil] objectForKey:NSFileSize] intValue];//大于10mb 清零后重新计数
        }//此for循环遍历整个数组，是为了从cachedFiles的最后一个文件删除，当遍历结束跳出循环时，lastItemName就是cachedFile中的最后一张图片（最早加入的图片），此时删除lastItem，再进行下一轮，此循环的真正目的在于每次超出容量时删除最后一张照片
        [fileManager removeItemAtPath:[url.path stringByAppendingFormat:@"/%@",lastItemName] error:nil];
    }
                                   
}
+(UIImage*)getCachedImg:(NSString*)info
{
    NSFileManager *fileManager =[[NSFileManager alloc] init];
    NSURL * url = [[fileManager  URLsForDirectory:NSCachesDirectory inDomains:NSUserDirectory] lastObject];
    NSString * filePath = url.path;
    filePath = [filePath stringByAppendingFormat:@"/%@.jpg",info];
    NSLog(@"the path is %@",filePath);
  //  if ([fileManager isReadableFileAtPath:filePath])
   // {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
   /* }
   else
    {
        return nil;
    }*/
}
@end
