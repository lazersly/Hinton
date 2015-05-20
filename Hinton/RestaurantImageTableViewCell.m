//
//  RestaurantImageTableViewCell.m
//  Hinton
//
//  Created by Brandon Roberts on 5/19/15.
//  Copyright (c) 2015 BR World. All rights reserved.
//

#import "RestaurantImageTableViewCell.h"

@interface RestaurantImageTableViewCell ()
@property (strong, nonatomic, readonly) IBOutlet UIImageView *imageView;

@end

@implementation RestaurantImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageToDisplay:(UIImage *)imageToDisplay {
  _imageToDisplay = imageToDisplay;
  self.imageView.image = imageToDisplay;
}

@end
