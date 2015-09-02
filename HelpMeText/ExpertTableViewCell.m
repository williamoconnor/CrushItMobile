//
//  TableViewCell.m
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertTableViewCell.h"

@implementation ExpertTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height+10.0, 10.0, self.frame.size.width - (self.frame.size.height+10.0), 20.0)];
        self.ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height+20.0, 30.0, 150.0, 20.0)];
        self.costLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height+20.0, 50.0, 150.0, 20.0)];
        
        [self.nameLabel setTextColor:[UIColor whiteColor]];
        [self.ratingLabel setTextColor:[UIColor whiteColor]];
        [self.costLabel setTextColor:[UIColor whiteColor]];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.ratingLabel];
        [self addSubview:self.costLabel];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    }
    
    return self;


}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
