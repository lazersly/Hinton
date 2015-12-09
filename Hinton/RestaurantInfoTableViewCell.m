//
//  RestaurantInfoTableViewCell.m
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import "RestaurantInfoTableViewCell.h"
#import "Restaurant.h"
#import "Address.h"
#import "Hours.h"


@interface RestaurantInfoTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantGenreLabel;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *price4;
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

@property (strong, nonatomic) UIColor * grayColor;
@property (strong, nonatomic) UIColor * greenColor;

@end


@implementation RestaurantInfoTableViewCell


- (void)awakeFromNib {
    // Initialization code

  self.greenColor = [UIColor colorWithRed: 0.0 green: 0.5 blue: 0.0 alpha: 1.0];
  self.grayColor = [UIColor colorWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0];

  self.restaurantNameLabel.text = nil;
  self.restaurantGenreLabel.text = nil;
  self.restaurantPhoneLabel.text = nil;
  self.restaurantAddressLabel.text = nil;
  self.restaurantHoursLabel.text = nil;
  self.recommendedItemLabel.text = nil;

  // Initialize the price indicators to gray.
  self.price1.textColor = self.grayColor;
  self.price2.textColor = self.grayColor;
  self.price3.textColor = self.grayColor;
  self.price4.textColor = self.grayColor;

  // Initialize the price indicators with the local currency symbol.
  // This code isn't correct - we should use the locale of the restaurant, not the phone.
  // (i.e. if a British user is looking at a restaurant in France, he should see € not £)
  NSLocale * myLocale = [NSLocale currentLocale];
  NSString * currencySymbol = [myLocale objectForKey:NSLocaleCurrencySymbol];
  self.price1.text = currencySymbol;
  self.price2.text = currencySymbol;
  self.price3.text = currencySymbol;
  self.price4.text = currencySymbol;


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
  
  self.recommendedItemLabel.text = [self constructRecommendedItemsLabelForItems:restaurantToDisplay.recipes];
  
  [self setupWebsiteButtons];
  
  
}

-(void)setRestaurantName:(NSString *)restaurantName {
  _restaurantName = restaurantName;
  self.restaurantNameLabel.text = restaurantName;
}

-(void)setRestaurantPrice:(NSString *)restaurantPrice {
  
  _restaurantPrice = restaurantPrice;
  NSInteger price = restaurantPrice.integerValue;

  if (price >= 1) { self.price1.textColor = self.greenColor; } else { self.price1.textColor = self.grayColor; }
  if (price >= 2) { self.price2.textColor = self.greenColor; } else { self.price2.textColor = self.grayColor; }
  if (price >= 3) { self.price3.textColor = self.greenColor; } else { self.price3.textColor = self.grayColor; }
  if (price >= 4) { self.price4.textColor = self.greenColor; } else { self.price4.textColor = self.grayColor; }

}

-(void)setRestaurantGenre:(NSArray *)restaurantGenre {
  _restaurantGenre = restaurantGenre;
  self.restaurantGenreLabel.text = [self constructGenreLabelForGenres:self.restaurantGenre];
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
