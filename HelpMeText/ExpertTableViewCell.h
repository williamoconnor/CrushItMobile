//
//  TableViewCell.h
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView* profileImageView;
@property (strong, nonatomic) UILabel* ratingLabel;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* costLabel;
@property (strong, nonatomic) NSDictionary* expert;

@end
