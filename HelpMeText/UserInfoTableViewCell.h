//
//  UserInfoTableViewCell.h
// CrushIt
//
//  Created by William O'Connor on 6/23/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary* profileInfo;
@property (strong, nonatomic) UILabel* userNameLabel;
@property (strong, nonatomic) UILabel* interestLabel;
@property (strong, nonatomic) UILabel* genderLabel;
@property (strong, nonatomic) UILabel* ageLabel;

- (void) setTextValues;

@end
