//
//  ShowPhotoViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-2-27.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "FlickrFetcher.h"
#import "imageCacher.h"
#import "VactionHelper.h"
#import "Place+create.h"
#import "Tag+create.h"
#import "Photo+create.h"

@interface ShowPhotoViewController ()
@end

@implementation ShowPhotoViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize photo = _photo;
@synthesize tag = _tag;
@synthesize tab = _tab;



-(void)openVacation:(UIManagedDocument*)vacation
{
    [self fetchFlickrDataIntoDocument:vacation];
}


-(void) fetchFlickrDataIntoDocument:(UIManagedDocument*)doc
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [doc.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
            [Photo  photoWithFlickrInfo:self.photo inManagedObjectContext:doc.managedObjectContext];
            [Place  placeWithName:[self.photo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:doc.managedObjectContext] ;
          NSArray *tags = [[self.photo objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
            for(NSString*t in tags)
            {
                if([t rangeOfString:@":"].location==NSNotFound&&[t stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)//筛选tag
                {
                    [Tag tagWithName:t inManagedObjectContext:doc.managedObjectContext];
                }
            }
            [doc saveToURL:doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];//you don't have to do anything with the document,so completion handler is NULL
        }];//serial queue,excute task(the block) behind the scenes
    });
    dispatch_release(fetchQ);
}


- (IBAction)visitPressed:(id)sender
{
        [VactionHelper openVacation:@"Vacation1" usingBlock:^(UIManagedDocument*doc){
                    [self openVacation:doc];
        }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/*-(void)setImageURL:(NSURL *)imageURL
{
    if (_imageURL != imageURL) {
        _imageURL  = imageURL;
}*/
    
-(void)loadImage
{
    if (self.imageView) 
    {
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.imageView.backgroundColor = [UIColor blackColor];
      //  [self.view sizeToFit];// if a view does not have a superview, it may size itself to the screen bounds.
        if (self.tag == 0)//从地图segue至这里，需要下载图片 
        {
        CGRect frame = CGRectMake((self.imageView.frame.size.width/2)-25, (self.imageView.frame.size.height/2)-25, 50, 50);
        UIActivityIndicatorView *xjh = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [xjh startAnimating];
        xjh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.imageView addSubview:xjh];
        dispatch_queue_t downloadPhotoQueue = dispatch_queue_create("photos downloader", NULL);
        dispatch_async(downloadPhotoQueue, ^{
            NSURL * photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
            NSData *imageData = [NSData dataWithContentsOfURL:photoURL];//very expensive 
            UIImage *img = [UIImage imageWithData:imageData];
            NSLog(@"test %@",[self.photo  objectForKey:FLICKR_PHOTO_ID]);
            [imageCacher  cacheImg:img withImgInfo:[self.photo  objectForKey:FLICKR_PHOTO_ID]];
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
        else  if(self.tag == 1){//从recent segue至这里，不需要下载图片，直接取缓存就行
            UIImage * img = [imageCacher   getCachedImg:[self.photo objectForKey:FLICKR_PHOTO_ID]];
            self.imageView.image = img;
            self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);//make imageView stick to the upperleft corner of its super view by setting(0,0)
            self.scrollView.contentSize = self.imageView.image.size;//这两步对scrollView很重要
        }
    } 
    else {
        self.imageView.image = nil;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}//return which subview inside the content area we want to zoom,we only have one subview ,that is imageView,so return it


-(void)setPhoto:(NSDictionary *)photo
{
    if (_photo!=photo) 
    {
        _photo =photo;
        if(self.tag == 0)
        {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSMutableArray *recentArr = [[defaults objectForKey:RECENT_PHOTO_KEY] mutableCopy];
             if (!recentArr) 
             {
                 recentArr = [NSMutableArray array];
             }
             [recentArr addObject:self.photo];//还要设不少于20张的限
            //这里存储的只是照片信息而非照片，所以很小，可以用NSUserDefaults
             if ([recentArr count]>20) {
                 [recentArr  removeAllObjects];
             }
            [defaults setObject:recentArr forKey:RECENT_PHOTO_KEY];
            [defaults synchronize];
            if (self.imageView.window)
            {//@property(nonatomic, readonly) UIWindow *window;(The receiver’s window object, or nil if it has none. ),UIWindow is at the top of View hierarchy,是最基本的view;This property is nil if the view has not yet been added to a window.YES:imageView has been added to a window
                [self loadImage];//we are on the screen ,so load the view
            }
           else 
           {
            self.imageView.image = nil; //imageView haven't been added to window yet
           }
        }
    }
}//延迟加载

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.tabBarController.tabBar.alpha = 0.5;

    if (self.tag ==1) {
        [self loadImage];
    }
    else
    {
        if (!self.imageView.image&&self.photo)
        {
              [self loadImage];
        }
   }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.scrollView.delegate = self;
  // self.tabBarController.tabBar.hidden = YES;
  // self.navigationController.navigationBar.hidden = YES; 
  //  self.scrollView.contentSize = self.imageView.image.size;//first set the ScrollView's contentSize
	// Do any additional setup after loading the view, typically from a nib.
}//Setting frames in viewDidLoad

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else {
        return  YES;
    }
}

@end
