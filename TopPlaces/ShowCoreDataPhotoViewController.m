//
//  ShowCoreDataPhotoViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-22.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ShowCoreDataPhotoViewController.h"
#import "FlickrFetcher.h"
#import "VactionHelper.h"
#import "Photo+deletion.h"
#import "Photo+create.h"

@implementation ShowCoreDataPhotoViewController
@synthesize imageURL = _imageURL;

-(void)loadImage
{
    if (self.imageView) 
    {
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.imageView.backgroundColor = [UIColor blackColor];
        //  [self.view sizeToFit];// if a view does not have a superview, it may size itself to the screen bounds.
           CGRect frame = CGRectMake((self.imageView.frame.size.width/2)-25, (self.imageView.frame.size.height/2)-25, 50, 50);
            UIActivityIndicatorView *xjh = [[UIActivityIndicatorView alloc] initWithFrame:frame];
            [xjh startAnimating];
            xjh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [self.imageView addSubview:xjh];
            dispatch_queue_t downloadPhotoQueue = dispatch_queue_create("photos downloader", NULL);
            dispatch_async(downloadPhotoQueue, ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString*)self.imageURL]];//very expensive 
                UIImage *img = [UIImage imageWithData:imageData];
                NSLog(@"test %@",[self.photo  objectForKey:FLICKR_PHOTO_ID]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //self.imageView.image = nil;
                    [xjh stopAnimating];
                    [xjh hidesWhenStopped];
                    self.imageView.image = img;
                    self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);//make imageView stick to the upperleft corner of its super view by setting(0,0)
                    self.scrollView.contentSize = self.imageView.image.size;//这两步对scrollView很重要
                });//view is about框架和内容
            });
            dispatch_release(downloadPhotoQueue);//it matters!!!!
        }
      else {
        self.imageView.image = nil;
    }
}

-(void)deleteFlickrDataOutOfDocument:(UIManagedDocument*)doc
{
    NSLog(@"name = %@",[self.photo valueForKey:FLICKR_PHOTO_TITLE]);
    Photo *photo  =  [Photo photoWithFlickrInfo:self.photo inManagedObjectContext:doc.managedObjectContext];
    [Photo prepareForDeletion:doc.managedObjectContext  with:photo];
}

-(void)openVacation:(UIManagedDocument*)vacation
{
    [self deleteFlickrDataOutOfDocument:vacation];
}

- (IBAction)unvisitPressed:(id)sender {
    [VactionHelper openVacation:@"Vacation1" usingBlock:^(UIManagedDocument*doc){
        [self openVacation:doc];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.imageView.image&&self.imageURL)
    {
            [self loadImage];
    }
}
@end
