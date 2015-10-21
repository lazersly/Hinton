//
//  BackendService.m
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import "BackendService.h"
#import "MapPointParser.h"
#import "RestaurantParser.h"
#import "GenreParser.h"
#import "AFNetworking.h"

@implementation BackendService

+(void)fetchMapPointsForArea:(CGRect)area completionHandler:(void (^)(NSArray *mapPoints, NSError *error))completionHandler {

  NSURL *fetchAllURLString = [NSURL URLWithString: @"http://52.88.209.205:2121/api/restaurant/all"];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:fetchAllURLString.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *mapPoints = [MapPointParser mapPointsFromJSONDictionary:responseObject];
    completionHandler(mapPoints, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error.localizedDescription);
    completionHandler(nil, error);
  }];
  
}

+(void)fetchRestaurantForID:(NSString *)restaurantID completionHandler:(void (^)(Restaurant *restaurant, NSError *error))completionHandler {
//  NSURL *url = [[NSBundle mainBundle] URLForResource:@"sample_restaurant_json" withExtension:@"json"];
//  NSData *jsonData = [NSData dataWithContentsOfURL:url];
  
  NSURL *fetchRestaurantURLString = [NSURL URLWithString: @"http://52.88.209.205:2121/api/restaurant/"];
  fetchRestaurantURLString = [fetchRestaurantURLString URLByAppendingPathComponent:restaurantID];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:fetchRestaurantURLString.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    Restaurant *restaurant = [RestaurantParser restaurantFromJSONDictionary:responseObject];
    completionHandler(restaurant, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error.localizedDescription);
    completionHandler(nil, error);
  }];

}

+(void)fetchGenresList:(void(^)(NSArray *genresList, NSError *error))completion {
  
  NSURL *genresURL = [NSURL URLWithString: @"http://52.88.209.205:2121/api/restaurant/genre/all"];

  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:genresURL.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *genres = [GenreParser genresFromJSONArray:responseObject];
    completion(genres, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error.localizedDescription);
    completion(nil, error);
  }];

  
}

+(void)fetchMapPointsForGenre:(NSString *)genre completionHandler:(void (^)(NSArray *mapPoints, NSError *error))completionHandler {

  NSURL *mapPointforGenreURL = [NSURL URLWithString:@"http://52.88.209.205:2121/api/restaurant/genre/"];
  mapPointforGenreURL = [mapPointforGenreURL URLByAppendingPathComponent:genre];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:mapPointforGenreURL.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *mapPoints = [MapPointParser mapPointsFromJSONDictionary:responseObject];
    completionHandler(mapPoints, nil);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error.localizedDescription);
    completionHandler(nil, error);
  }];
}

@end
