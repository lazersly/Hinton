//
//  RestaurantParser.h
//  Hinton
//
//  Created by Brandon Roberts on 5/18/15.
//  Copyright © 2015 Gina Hinton. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Restaurant;

@interface RestaurantParser : NSObject

+(Restaurant *)restaurantFromJSONDictionary:(NSDictionary *)jsonDictionary;

@end
