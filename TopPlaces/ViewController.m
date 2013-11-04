//
//  ViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-11.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ViewController.h"
#import "FlickrFetcher.h"
#import "AnnotationOfPlaces.h"
#import "SecViewController.h"
#import "AnnotationOfPhotos.h"

@interface ViewController () <ViewControllerDelegate>
@property(nonatomic,strong) NSString * annotationTitle;
@end

@implementation ViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize places = _places;
@synthesize annotationValue = _annotationValue;
@synthesize annotationTitle = _annotationTitle;
@synthesize backItem = _backItem;

-(NSArray*)mapAnnotations
{
    NSMutableArray*annotations = [NSMutableArray array];
    for (NSDictionary * place in self.places) {
        [annotations addObject:[AnnotationOfPlaces annotationForPlace:place]];
    }
    return annotations;
}

- (IBAction)refreshOnMap:(id)sender
{
    UIActivityIndicatorView * xiaoJuHua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [xiaoJuHua startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:xiaoJuHua];
    dispatch_queue_t downloadQueue = dispatch_queue_create("places downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *places = [FlickrFetcher  topPlaces];//Return the top 100 most geotagged places for a day.
        dispatch_async(dispatch_get_main_queue(),^{
            self.places = places;
            self.annotations = [self mapAnnotations];
            self.navigationItem.rightBarButtonItem = self.backItem;// [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self   action:@selector(refreshOnMap:)];//target:The object that receives the action message.肯定是由controller来完成更新视的工作，所以target应该是controller
        });
    });
    dispatch_release(downloadQueue);//important!
}

-(void)updateMapView
{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    } 
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];
    }//此处的annotation指的是model而非mapView的annotation属性
}

-(void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}//同步地图

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
 //   self.backItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshOnMap:)];
    self.backItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshOnMap:)];
    self.navigationItem.rightBarButtonItem= self.backItem;
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"woodnavbarbackground"] forBarMetrics:UIBarMetricsDefault];
//    UITabBar *tabbar = self.tabBarController.tabBar;
//    [tabbar setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]];
   // [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]  resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *tabbarView = [UIImage imageNamed:@"tabbar.png"];
     [[UITabBar appearance] setBackgroundImage:tabbarView];
}*/

-(MKAnnotationView*)mapView:(MKMapView*)sender  viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView* aView =(MKPinAnnotationView*) [sender dequeueReusableAnnotationViewWithIdentifier:@"mapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapVC"];
        aView.canShowCallout = YES;
        aView.pinColor = MKPinAnnotationColorPurple;
    }
    aView.annotation = annotation;
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return aView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView*)aView
{
    self.annotationValue = (NSInteger*)[self.annotations indexOfObject:aView.annotation] ;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)aView calloutAccessoryControlTapped:(UIControl *)control
{
    NSString *str = aView.annotation.title;
    self.annotationTitle = str;
    NSLog(@"annotation %@ is selected",str);
    [self performSegueWithIdentifier:@"photoMap" sender:self];//sender:sth causes this segue
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoMap"]) 
    {
          //NSLog(@"the value is %i",(int)self.annotationValue);
          SecViewController *newVC = segue.destinationViewController;
           [newVC setAnnotationValue:self.annotationValue];
           [newVC setPlaces:self.places];
           [newVC setTitle:self.annotationTitle];
           newVC.delegate = self;
    }
}

-(UIImage*)SecViewController:(SecViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    AnnotationOfPhotos *aop = (AnnotationOfPhotos*)annotation;
    NSURL * url = [FlickrFetcher urlForPhoto:aop.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;//safe
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
