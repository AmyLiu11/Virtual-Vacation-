//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-2-24.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "NSDictionary+NSDictionaryMutableDeepCopy.h"
#import "PhotoOfPlacesTableViewController.h"
#import "AnnotationsOfPlaces.h"
#import "MapKitViewController.h"


@implementation TopPlacesTableViewController
@synthesize places = _places;
@synthesize photos = _photos;


- (IBAction)refresh:(id)sender
{
    
    UIActivityIndicatorView * xiaoJuHua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [xiaoJuHua startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:xiaoJuHua];
    dispatch_queue_t downloadQueue = dispatch_queue_create("places downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *places = [FlickrFetcher  topPlaces];//Return the top 100 most geotagged places for a day.
        NSMutableArray*pplace = [[NSMutableArray alloc] initWithArray:places];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:[self.places count]];
            for (int i = 0; i<[places count]; i++)
            {
                NSString * placeName = [[places objectAtIndex:i] objectForKey:FLICKR_PLACE_NAME];
                [arr addObject:placeName];
            }
            [arr sortUsingSelector:@selector(caseInsensitiveCompare:)];//按字母排序
            for (int j = 0; j<[places count]; j++) 
            {
                NSString*oneObj = [arr objectAtIndex:j];
                for (int k = 0; k<[places count]; k++) 
                {
                    if ([oneObj isEqualToString:[[places objectAtIndex:k] objectForKey:FLICKR_PLACE_NAME]])
                    {
                        [pplace replaceObjectAtIndex:j withObject:[places objectAtIndex:k]];
                    }
                }
            }
            self.navigationItem.rightBarButtonItem = sender;
            self.places = pplace;//reload the data of table
        });
    });

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Show Photo"]) 
    {
        UIActivityIndicatorView *xiaoJuHua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         [xiaoJuHua startAnimating];
         UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];//get a new cell
         newCell.accessoryView =xiaoJuHua; 
         dispatch_queue_t downloadPhotoQueue = dispatch_queue_create("photos downloader", NULL);
         dispatch_async(downloadPhotoQueue, ^{
         NSArray *photos = [FlickrFetcher photosInPlace:[self.places objectAtIndex:indexPath.row] maxResults:50];
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.photos = photos;
                 [segue.destinationViewController setPhotoList:self.photos];
                 [segue.destinationViewController setTitle:newCell.textLabel.text];
                 newCell.accessoryView = nil;
             });
        });
    }
}

-(NSArray*)mapAnnotations
{
    NSMutableArray*annotations = [NSMutableArray arrayWithCapacity:[self.places count]];
    if (self.places) {
        for (NSDictionary * place in self.places) {
            [annotations addObject:[AnnotationsOfPlacesAndPhoto annotationForPlace:place]];
        }
    }
    return annotations;
/*    else {
        for (NSDictionary*photo in self.photos) {
            [annotations addObject:[AnnotationsOfPlacesAndPhoto annotationForPhoto:photo]];
        }
        return annotations;
    }*/
}

-(void)updateSplitViewDetail
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[MapKitViewController class]]) {
        MapKitViewController *mapVC = (MapKitViewController*)mapVC;
 //       mapVC.annotations = [self mapAnnotations];
    }
}

-(void)setPlaces:(NSArray *)places
{
    if (_places!= places) {
        _places =places;
     //   [self updateSplitViewDetail];
        [self.tableView reloadData];
    }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITabBarItem * item1;
   item1 = [self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
    self.tabBarItem = item1;
   self.tabBarController.tabBar.tintColor = [[UIColor alloc] initWithRed:0.53 green:0.81 blue:0.98 alpha:0.2]; //135 206 250
    self.navigationController.navigationBar.tintColor =[[UIColor alloc] initWithRed:0.53 green:0.81 blue:0.98 alpha:0.5];//设置tabbar和navbar的颜色
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    NSRange range = [[place  objectForKey:FLICKR_PLACE_NAME] rangeOfString:@","];//return strings like "New York,NY,United States"
    cell.textLabel.text = [[place objectForKey:FLICKR_PLACE_NAME] substringToIndex:range.location];
    //从制定范围内返回子字符串
    cell.detailTextLabel.text =[[place objectForKey:FLICKR_PLACE_NAME] substringFromIndex:range.location+1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//扩展指示器，她用于告知用户触摸这一行将切换到另一个表视图
    // Configure the cell...
    
    return cell;
}

@end

