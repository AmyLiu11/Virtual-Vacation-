//
//  FlickrFetcher.m
//
//  Created for Stanford CS193p Fall 2011.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"


@implementation FlickrFetcher

+ (NSDictionary *)executeFlickrFetch:(NSString *)query
{
    //format=json&nojsoncallback: request the results to be returned as JSON
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FlickrAPIKey];// return JSON,JSON is(JavaScript Object Notation) 是一种轻量级的数据交换格式
    //Returns a representation of the receiver using a given encoding to determine the percent escapes necessary to convert the receiver into a legal URL string.通过NSUTF8StringEncoding编码方式使请求变为合法的URL
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//The encoding to use for the returned string. If you are uncertain of the correct encoding you should use NSUTF8StringEncoding, which is the encoding designated by RFC 2396 as the correct encoding, /* for use in URLs.
    NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;//Returns a Foundation object from given JSON data.
    //如果jsonData存在，返回JSONObjectWithData:options:error:方法的dictionary值，将json data转为NSDictionary值，若其不存在，返回nil
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}//for example:
 //The full URL we’ll pass to Flickr will look as follows:
 //NSString *urlString = [NSString stringWithFormat: @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=25&format=json&nojsoncallback=1", FlickrAPIKey, text];

+ (NSArray *)topPlaces
{
    NSString *request = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"places.place"];
   //相当于 return [[[self executeFlickrFetch:request] valueForKey:@"places"]  valueForKey:@"place"];
}//returns the dictionary(place) of dictionary(places)多层取值，也可用valueForKey不断嵌套使用，places and place都可以当成键


/*valueForKeyPath:
 Returns the value for the derived property identified by a given key path.
 
 - (id)valueForKeyPath:(NSString *)keyPath
 Parameters
 keyPath
 A key path of the form relationship.property (with one or more relationships); for example “department.name” or “department.manager.lastName”.
 Return Value
 The value for the derived property identified by keyPath.
 
 Discussion
 The default implementation gets the destination object for each relationship using valueForKey: and returns the result of a valueForKey: message to the final object.*/
/*flickr.places.getTopPlacesList
 
 Return the top 100 most geotagged places for a day.
 place_type_id （必需的）
 The numeric ID for a specific place type to cluster photos by. 
 
 Valid place type IDs are :
 22: neighbourhood
 7: locality
 8: region
 12: country
 29: continent
*/
+ (NSArray *)stanfordPhotos
{
    NSString *request = @"http://api.flickr.com/services/rest/?user_id=48247111@N07&format=json&nojsoncallback=1&extras=original_format,tags,description,geo,date_upload,owner_name&page=1&method=flickr.photos.search";
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSArray *)photosInPlace:(NSDictionary *)place maxResults:(int)maxResults
{
    NSArray *photos = nil;
    NSString *placeId = [place objectForKey:FLICKR_PLACE_ID];
    if (placeId) {
        NSString *request = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=%@&per_page=%d&extras=original_format,tags,description,geo,date_upload,owner_name,place_url", placeId, maxResults];
        NSString *placeName = [place objectForKey:FLICKR_PLACE_NAME];
        photos = [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
        for (NSMutableDictionary *photo in photos) {
            [photo setObject:placeName forKey:FLICKR_PHOTO_PLACE_NAME];
        }
    }
    return photos;//返回NSArray
}/*The parameters to the query are:
  
  api_key: your specific developer key
  tags: the search text
  per_page: the number of images to return
  format=json&nojsoncallback: request the results to be returned as JSON*/

+ (NSArray *)recentGeoreferencedPhotos
{
    NSString *request = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&per_page=500&license=1,2,4,7&has_geo=1&extras=original_format,tags,description,geo,date_upload,owner_name,place_url"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}/*    flickr.photos.search
  
        Return a list of photos matching some criteria. Only photos visible to the calling user will be returned. To return private or semi-private photos the caller must be authenticated with 'read' permissions, and have permission to view the photos. Unauthenticated calls will only return public photos.
        license:The license id for photos (for possible values see the flickr.photos.licenses.getInfo method). Multiple licenses may be comma-separated.
  has_geo （可選的）
  Any photo that has been geotagged, or if the value is "0" any photo that has not been geotagged. 
  
  Geo queries require some sort of limiting agent in order to prevent the database from crying. This is basically like the check against "parameterless searches" for queries without a geo component. 
  
  A tag, for instance, is considered a limiting agent as are user defined min_date_taken and min_date_upload parameters — If no limiting factor is passed we return only photos added in the last 12 hours (though we may extend the limit in the future).
  */

+ (NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
	id farm = [photo objectForKey:@"farm"];
	id server = [photo objectForKey:@"server"];
	id photo_id = [photo objectForKey:@"id"];
	id secret = [photo objectForKey:@"secret"];
	if (format == FlickrPhotoFormatOriginal) secret = [photo objectForKey:@"originalsecret"];
    
	NSString *fileType = @"jpg";
	if (format == FlickrPhotoFormatOriginal) fileType = [photo objectForKey:@"originalformat"];
	
	if (!farm || !server || !photo_id || !secret) return nil;
	
	NSString *formatString = @"s";
	switch (format) {
		case FlickrPhotoFormatSquare:    formatString = @"s"; break;
		case FlickrPhotoFormatLarge:     formatString = @"b"; break;
		// case FlickrPhotoFormatThumbnail: formatString = @"t"; break;
		// case FlickrPhotoFormatSmall:     formatString = @"m"; break;
		// case FlickrPhotoFormatMedium500: formatString = @"-"; break;
		// case FlickrPhotoFormatMedium640: formatString = @"z"; break;
		case FlickrPhotoFormatOriginal:  formatString = @"o"; break;
	}
    
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}

+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
    NSString * str = [self urlStringForPhoto:photo format:format];
    NSLog(@"str = %@",str);
    return [NSURL URLWithString:str];
}

@end
