//
//  RestaurantInfoTableViewCell.m
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import "RestaurantInfoTableViewCell.h"
#import "Restaurant.h"
#import "Address.h"
#import "Hours.h"


@interface RestaurantInfoTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantGenreLabel;
@property (strong, nonatomic) IBOutlet UIButton *mainWebsiteButton;
@property (strong, nonatomic) IBOutlet UIButton *menuWebsiteButton;
@property (strong, nonatomic) IBOutlet UIButton *blogWebsiteButton;
@property (strong, nonatomic) IBOutlet UILabel *restaurantPhoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantHoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *recommendedItemLabel;

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSString *restaurantPrice;
@property (strong, nonatomic) NSArray *restaurantGenre;
@property (strong, nonatomic) NSURL *mainWebsiteURL;
@property (strong, nonatomic) NSURL *menuWebsiteURL;
@property (strong, nonatomic) NSURL *blogWebsiteURL;
@property (strong, nonatomic) NSString *restaurantPhone;
@property (strong, nonatomic) Address *restaurantAddress;
@property (strong, nonatomic) Hours *restaurantHours;

@end

@implementation RestaurantInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
  
  self.restaurantNameLabel.text = nil;
  self.restaurantGenreLabel.text = nil;
  self.restaurantPhoneLabel.text = nil;
  self.restaurantAddressLabel.text = nil;
  self.restaurantHoursLabel.text = nil;
  self.recommendedItemLabel.text = nil;
  
  //enable interaction for phone number label
  self.restaurantPhoneLabel.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
  [self.restaurantPhoneLabel addGestureRecognizer:tapGesture];
}

-(IBAction)callPhone:(id)sender {
  NSString *formattedPhoneNumberStringPrefix = @"tel:";
  //format self.restaurantPhone string here for use below
  //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRestaurantToDisplay:(Restaurant *)restaurantToDisplay {
  _restaurantToDisplay = restaurantToDisplay;
  
  self.restaurantName = restaurantToDisplay.name;
  self.restaurantPrice = restaurantToDisplay.pricePoint;
  self.restaurantGenre = restaurantToDisplay.genres;
  self.mainWebsiteURL = restaurantToDisplay.mainURL;
  self.menuWebsiteURL = restaurantToDisplay.menuURL;
  self.blogWebsiteURL = restaurantToDisplay.blogURL;
  self.restaurantPhone = restaurantToDisplay.phone;
  self.restaurantAddress = restaurantToDisplay.address;
  self.restaurantHours = restaurantToDisplay.hours;
  
  self.restaurantGenreLabel.text = [NSString stringWithFormat:@"%@, %@", [self constructGenreLabelForGenres:self.restaurantGenre], self.restaurantPrice];
  self.recommendedItemLabel.text = [self constructRecommendedItemsLabelForItems:restaurantToDisplay.recipes];
  
  [self setupWebsiteButtons];
  
  
}

-(void)setRestaurantName:(NSString *)restaurantName {
  _restaurantName = restaurantName;
  self.restaurantNameLabel.text = restaurantName;
}

-(void)setRestaurantPrice:(NSString *)restaurantPrice {
  
  NSInteger price = restaurantPrice.integerValue;
  NSString *priceRepresentation = [NSString string];
  
  switch (price) {
    case 1:
      priceRepresentation = @"$";
      break;
    case 2:
      priceRepresentation = @"$$";
      break;
    case 3:
      priceRepresentation = @"$$$";
      break;
    case 4:
      priceRepresentation = @"$$$$";
      break;
      
    default:
      priceRepresentation = @"Variable Pricing";
      break;
  }
  
  _restaurantPrice = priceRepresentation;
}

-(void)setRestaurantGenre:(NSArray *)restaurantGenre {
  _restaurantGenre = restaurantGenre;
}

-(void)setMainWebsiteURL:(NSURL *)mainWebsiteURL {
  _mainWebsiteURL = mainWebsiteURL;
}

-(void)setMenuWebsiteURL:(NSURL *)menuWebsiteURL {
  _menuWebsiteURL = menuWebsiteURL;
}

-(void)setBlogWebsiteURL:(NSURL *)blogWebsiteURL {
  _blogWebsiteURL = blogWebsiteURL;
}

-(void)setRestaurantPhone:(NSString *)restaurantPhone {
  _restaurantPhone = restaurantPhone;
  self.restaurantPhoneLabel.text = restaurantPhone;
}

-(void)setRestaurantAddress:(Address *)restaurantAddress {
  _restaurantAddress = restaurantAddress;
  
  NSString *addressString = @"";
  
  addressString = [addressString stringByAppendingString:restaurantAddress.streetNumber];
  addressString = [addressString stringByAppendingString:@" "];
  addressString = [addressString stringByAppendingString:restaurantAddress.streetName];
  addressString = [addressString stringByAppendingString:@", "];
  addressString = [addressString stringByAppendingString:restaurantAddress.city];
  addressString = [addressString stringByAppendingString:@", "];
  addressString = [addressString stringByAppendingString:restaurantAddress.state];
  addressString = [addressString stringByAppendingString:@" "];
  addressString = [addressString stringByAppendingString:restaurantAddress.zip];
  
  self.restaurantAddressLabel.text = addressString;
}

-(void)setRestaurantHours:(Hours *)restaurantHours {
  _restaurantHours = restaurantHours;
#warning Incomplete
  //needs something to detect what day of the week it is and show that day's hours
  //get current day
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
  long weekday = [comps weekday];
  
  NSLog(@"today's day num: %ld", weekday);
  
  switch (weekday) {
    case 0:
      self.restaurantHoursLabel.text = restaurantHours.sundayHours;
      break;
      
    case 1:
     self.restaurantHoursLabel.text = restaurantHours.mondayHours;
      break;
      
    case 2:
      self.restaurantHoursLabel.text = restaurantHours.tuesdayHours;
      break;
      
    case 3:
      self.restaurantHoursLabel.text = restaurantHours.wednesdayHours;
      break;
      
    case 4:
      self.restaurantHoursLabel.text = restaurantHours.thursdayHours;
      break;
      
    case 5:
      self.restaurantHoursLabel.text = restaurantHours.fridayHours;
      break;
      
    case 6:
      self.restaurantHoursLabel.text = restaurantHours.saturdayHours;
      break;
      
    default:
      break;
  }
  
}

- (IBAction)mainWebsiteButtonPressed:(id)sender {
  [[UIApplication sharedApplication] openURL:self.restaurantToDisplay.mainURL];
}
- (IBAction)menuWebsiteButtonPressed:(id)sender {
  [[UIApplication sharedApplication] openURL:self.restaurantToDisplay.menuURL];
}
- (IBAction)blogWebsiteButtonPressed:(id)sender {
  [[UIApplication sharedApplication] openURL:self.restaurantToDisplay.blogURL];
}

-(NSString *)constructGenreLabelForGenres:(NSArray *)genres {
  
  NSString *genreLabel;
  
  for (NSString *genre in genres) {
    if (!genreLabel || [genre isEqualToString:@""]) {
      genreLabel = genre;
    } else {
      genreLabel = [genreLabel stringByAppendingString:[NSString stringWithFormat:@", %@", genre]];
    }
  }
  
  if (!genreLabel) {
    return @"Unknown Genre";
  } else {
    return genreLabel;
  }
}

-(NSString *)constructRecommendedItemsLabelForItems:(NSArray *)menuItems {
  
  NSString *itemsLabel;
  
  for (NSString *item in menuItems) {
    if (!itemsLabel) {
      if (![item isEqualToString:@""]) {
        itemsLabel = item;
      }
    } else {
      itemsLabel = [itemsLabel stringByAppendingString:[NSString stringWithFormat:@", %@", item]];
    }
  }
  
  if (!itemsLabel) {
    return @"Recommended menu items coming soon!";
  } else {
    return itemsLabel;
  }
}

-(void)setupWebsiteButtons {
  if ([self.menuWebsiteURL.absoluteString isEqualToString:@""] || !self.menuWebsiteURL) {
    self.menuWebsiteButton.enabled = NO;
  } else {
    self.menuWebsiteButton.enabled = YES;
  }
  
  if ([self.mainWebsiteURL.absoluteString isEqualToString:@""] || !self.mainWebsiteURL) {
    self.mainWebsiteButton.enabled = NO;
  } else {
    self.mainWebsiteButton.enabled = YES;
  }
  
  if ([self.blogWebsiteURL.absoluteString isEqualToString:@""] || !self.blogWebsiteURL) {
    self.blogWebsiteButton.enabled = NO;
  } else {
    self.blogWebsiteButton.enabled = YES;
  }
}

@end
