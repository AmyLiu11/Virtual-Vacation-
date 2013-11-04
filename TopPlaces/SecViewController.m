//
//  SecViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-10.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "SecViewController.h"
#import "AnnotationOfPhotos.h"
#import "FlickrFetcher.h"
#import "GIDAAlertView.h"

@implementation SecViewController
@synthesize photos = _photos;
@synthesize delegate = _delegate;

-(NSArray*)mapAnnotations
{
    NSMutableArray*annotations = [NSMutableArray array];
    for(NSDictionary *photo in self.photos){
        [annotations addObject:[AnnotationOfPhotos annotationForPhoto:photo]];
    }
    return annotations;
}


-(MKCoordinateRegion)regionIncludesAnnotations:(NSArray*)annotations
{
    CLLocationCoordinate2D topLeftCood;
    NSDictionary *somePlace = [self.places  objectAtIndex:(NSInteger)self.annotationValue];
    NSLog(@"the value is %i",(int)self.annotationValue);
    topLeftCood.latitude = (CLLocationDegrees)[[somePlace objectForKey:FLICKR_LATITUDE] doubleValue];
    topLeftCood.longitude = (CLLocationDegrees) [[somePlace objectForKey:FLICKR_LONGITUDE] doubleValue];
    NSLog(@"the lat is %g,the long is %g",(double)topLeftCood.latitude,(double)topLeftCood.longitude);
    CLLocationCoordinate2D bottomRightCood;
    bottomRightCood.latitude =  (CLLocationDegrees)[[somePlace objectForKey:FLICKR_LATITUDE] doubleValue];
    bottomRightCood.longitude = (CLLocationDegrees) [[somePlace objectForKey:FLICKR_LONGITUDE] doubleValue];
    
    for (id<MKAnnotation> annotation in annotations)
    {
        topLeftCood.longitude = fmin(topLeftCood.longitude, annotation.coordinate.longitude);//越往西经度越小
        topLeftCood.latitude = fmax(topLeftCood.latitude, annotation.coordinate.latitude);//越往上纬度越高
        
        bottomRightCood.longitude = fmax(bottomRightCood.longitude,annotation.coordinate.longitude);
        bottomRightCood.latitude = fmin(bottomRightCood.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion  regionIncludesAnnotations;
    regionIncludesAnnotations.center.latitude = topLeftCood.latitude - (topLeftCood.latitude - bottomRightCood.latitude)*0.5;
    regionIncludesAnnotations.center.longitude = bottomRightCood.longitude - (bottomRightCood.longitude - topLeftCood.longitude)*0.5;
    
    regionIncludesAnnotations.span.latitudeDelta =fabs(topLeftCood.latitude - bottomRightCood.latitude)*0.7;
    regionIncludesAnnotations.span.longitudeDelta = fabs(bottomRightCood.longitude - topLeftCood.longitude)*0.7;
    
    return [self.mapView regionThatFits:regionIncludesAnnotations];//Adjusts the aspect ratio of the specified region to ensure that it fits in the map view’s frame.
}//required Task #6

-(void)loadMapView
{
    GIDAAlertView *spinner = [[GIDAAlertView alloc] initAlertWithSpinnerAndMessage:@"Loading image...."];
    [spinner presentAlertWithSpinner];
    dispatch_queue_t downloadPhotoQueue = dispatch_queue_create("photo downloader", NULL);
    dispatch_async(downloadPhotoQueue, ^{
        self.photos = [FlickrFetcher  photosInPlace:[self.places objectAtIndex:(NSUInteger)self.annotationValue] maxResults:50];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.annotations = [self mapAnnotations];//crucial!
            [self.mapView setRegion:[self regionIncludesAnnotations: self.annotations]];
            [self updateMapView];
            [spinner hideAlertWithSpinner];
        });
    });
    dispatch_release(downloadPhotoQueue);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.mapView.hidden =YES;
    [self loadMapView];
 /*   self.annotations = [self mapAnnotations];//crucial!
    [self.mapView setRegion:[self regionIncludesAnnotations: self.annotations]];
    [self updateMapView];*/
}//因为要重复使用view，所以不用viewDidLoad,因为viewDidLoad只在加载其视图时得到调用


-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView* aView =(MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"photo"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"photo"];
        aView.canShowCallout = YES;
        aView.pinColor = MKPinAnnotationColorRed;
        aView.leftCalloutAccessoryView = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    [(UIImageView*)aView.leftCalloutAccessoryView setImage:nil];//lazy initialization,the pin is reused,and we don't want to have the image in here,put the image back when someone touches in the pin
    aView.annotation = annotation;
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return aView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
     [self performSegueWithIdentifier:@"Show Detail" sender:self];//这里sender是self是因为在storyboard中直接由controller push至showPhotoViewController
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Detail"]) {
        [segue.destinationViewController setPhoto:[self.photos objectAtIndex:(NSUInteger)self.annotationValue]];
        [segue.destinationViewController setTitle:[[self.photos  objectAtIndex:(NSUInteger)self.annotationValue]  objectForKey:FLICKR_PHOTO_TITLE]];
        [segue.destinationViewController setTag:0];//将secViewController标记为0
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    self.annotationValue = (NSInteger*)[self.annotations indexOfObject:aView.annotation] ;
    dispatch_queue_t thunbnailImage = dispatch_queue_create("downloadThumbnail", NULL);
    dispatch_async(thunbnailImage, ^{
        UIImage *image = [self.delegate SecViewController:self imageForAnnotation:aView.annotation] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView*)aView.leftCalloutAccessoryView setImage:image];//lazy loading
        });
    });
    dispatch_release(thunbnailImage);
}

@end
