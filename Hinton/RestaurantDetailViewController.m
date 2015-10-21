//
//  RestaurantDetailViewController.m
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "BackendService.h"
#import "Restaurant.h"
#import "MapPoint.h"
#import "RestaurantMapTableViewCell.h"
#import "RestaurantInfoTableViewCell.h"
#import "RestaurantImageTableViewCell.h"
#import "ImageFetcher.h"

@interface RestaurantDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) ImageFetcher *imageFetcher;
@property (nonatomic) CGSize cellImageSize;
- (IBAction)getDirectionsButtonPressed:(UIButton *)sender;


@property (strong, nonatomic) Restaurant *restaurantToDisplay;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  
  self.imageFetcher = [[ImageFetcher alloc] init];
  self.cellImageSize = CGSizeMake(600, 400);
  self.view.tintColor = [UIColor darkGrayColor];
//  self.photos = @[[UIImage imageNamed:@"food_1.jpg"], [UIImage imageNamed:@"food_2.jpeg"]];
//  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self computeNumberOfRows];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.row) {
    case 0:
      return [self configureInfoCell:[self.tableView dequeueReusableCellWithIdentifier:@"InfoCell"]];
      break;
      
    case 1: {
      return [self configureMapCell:[self.tableView dequeueReusableCellWithIdentifier:@"MapCell"]];
      break;
    }
      
    case 2:
      return [self configureImageCell:[self.tableView dequeueReusableCellWithIdentifier:@"ImageCell"] forImageArrayIndex:0];
      break;
      
    case 3:
      return [self configureImageCell:[self.tableView dequeueReusableCellWithIdentifier:@"ImageCell"] forImageArrayIndex:1];
      break;
      
    default:
      return [UITableViewCell new];
      break;
  }
  
}

- (IBAction)closeButtonTapped:(id)sender {
  if ([self.delegate respondsToSelector:@selector(userDidTapCloseButton)]) {
    [self.delegate userDidTapCloseButton];
  }
}

#pragma mark - Custom Methods

-(NSInteger)computeNumberOfRows {
  return 2 + self.photos.count;
}

-(RestaurantInfoTableViewCell *)configureInfoCell:(RestaurantInfoTableViewCell *)infoCell {
  infoCell.restaurantToDisplay = self.restaurantToDisplay;
  return infoCell;
}

-(RestaurantMapTableViewCell *)configureMapCell:(RestaurantMapTableViewCell *)mapCell {
  [mapCell setMapPoint: self.annotation];
  return mapCell;
}

-(RestaurantImageTableViewCell *)configureImageCell:(RestaurantImageTableViewCell *)imageCell forImageArrayIndex:(NSInteger)index {
  
  imageCell.imageToDisplay = nil;
  
  if (index < self.photos.count) {
    
    imageCell.imageToDisplay = self.photos[index];
    
//    [self.imageFetcher fetchImageAtURL:self.photoURLs[index] size:self.cellImageSize completionHandler:^(UIImage *fetchedImage, NSError *error) {
//      if (!error) {
//        imageCell.imageToDisplay = fetchedImage;
//      } else {
//        NSLog(@"ImageError: %@", error.localizedDescription);
//      }
//    }];
  }
  
  return imageCell;
  
}

-(void)setAnnotation:(MapPoint *)annotation {
  _annotation = annotation;
  
  [BackendService fetchRestaurantForID:annotation.restaurantId completionHandler:^(Restaurant *restaurant, NSError *error) {
    if (restaurant) {
      NSLog(@"this restr's price tier: %@", restaurant.pricePoint);
      self.restaurantToDisplay = restaurant;
      self.tableView.delegate = self;
      self.tableView.dataSource = self;
      [self.tableView reloadData];
    } else {
      NSLog(@"Error: %@", error);
    }
  }];
}


- (IBAction)getDirectionsButtonPressed:(UIButton *)sender {
  Class mapItemClass = [MKMapItem class];
  if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
  {
    // Create an MKMapItem to pass to the Maps app
    CLLocationCoordinate2D coordinate =
    CLLocationCoordinate2DMake(_annotation.coordinate.latitude, _annotation.coordinate.longitude);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:_restaurantToDisplay.name];
    // Pass the map item to the Maps app
    [mapItem openInMapsWithLaunchOptions:nil];
  }
}
@end
