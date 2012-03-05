//
//  ShowPhotoViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-2-27.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "FlickrFetcher.h"

@interface ShowPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ShowPhotoViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize photo = _photo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadImage
{
    if (self.imageView) 
    {
        self.imageView.backgroundColor = [UIColor blackColor];
        self.scrollView.backgroundColor = [UIColor blackColor];
      //  [self.view sizeToFit];// if a view does not have a superview, it may size itself to the screen bounds.
        CGRect frame = CGRectMake((self.imageView.frame.size.width/2)-25, (self.imageView.frame.size.height/2)-25, 50, 50);
        UIActivityIndicatorView *xjh = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [xjh startAnimating];
       // UIImage *blackback = [[UIImage alloc] initWithContentsOfFile:@"blackbackground.png"];
      // self.imageView.image  = blackback;
        //self.imageView.center = xjh.center;
        xjh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.imageView addSubview:xjh];
        dispatch_queue_t downloadPhotoQueue = dispatch_queue_create("photos downloader", NULL);
        dispatch_async(downloadPhotoQueue, ^{
            NSURL * photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
            NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
            UIImage *img = [UIImage imageWithData:imageData];
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

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}//return which subview inside the content area we want to zoom,we only have one subview ,that is imageView,so return it


-(void)setPhoto:(NSDictionary *)photo
{
    if (_photo!=photo) {
        _photo =photo;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *recentArr = [[defaults objectForKey:RECENT_PHOTO_KEY] mutableCopy];
        if (!recentArr) 
        {
            recentArr = [NSMutableArray array];
        }
        [recentArr addObject:self.photo];//还要设不少于20张的限
        if ([recentArr count]>20) {
            [recentArr  removeAllObjects];
        }
        [defaults setObject:recentArr forKey:RECENT_PHOTO_KEY];
        [defaults synchronize];
        if (self.imageView.window) {//@property(nonatomic, readonly) UIWindow *window;(The receiver’s window object, or nil if it has none. ),UIWindow is at the top of View hierarchy,是最基本的view;This property is nil if the view has not yet been added to a window.
            [self loadImage];//we are on the screen ,so load the view
        }
        else {
            self.imageView.image = nil; //imageView haven't been added to window
        }
    }
}//延迟加载

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.imageView.image&&self.photo) {
        [self loadImage];
    }
  //  self.tabBarController.tabBar.hidden = YES;
  //  self.navigationController.navigationBar.hidden = YES;    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.scrollView.delegate = self;
 //   self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.hidden = YES; 
  //  self.scrollView.contentSize = self.imageView.image.size;//first set the ScrollView's contentSize
  //  self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width,self.imageView.image.size.height);//set the frame of the imageView ,so it's in the right spot in the content area,在content中的位置，upperleft  corner
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
