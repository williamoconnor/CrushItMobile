//
//  UserInfoTableViewCell.m
// CrushIt
//
//  Created by William O'Connor on 6/23/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    // Initialization code
    if (self) {
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 100.0, 20.0)];
        self.interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30.0, 100.0, 20.0)];
        self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 50.0, 100.0, 20.0)];
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 70.0, 100.0, 20.0)];
        
        self.userNameLabel.textColor = [UIColor whiteColor];
        self.interestLabel.textColor = [UIColor whiteColor];
        self.genderLabel.textColor = [UIColor whiteColor];
        self.ageLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.interestLabel];
        [self.contentView addSubview:self.genderLabel];
        [self.contentView addSubview:self.ageLabel];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTextValues
{
    self.userNameLabel.text = self.profileInfo[@"username"];
    self.interestLabel.text = self.profileInfo[@"interest"];
    self.genderLabel.text = self.profileInfo[@"gender"];
    self.ageLabel.text = self.profileInfo[@"age"];
}

@end
