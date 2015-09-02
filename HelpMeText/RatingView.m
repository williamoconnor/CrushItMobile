//
//  RatingView.m
// CrushIt
//
//  Created by William O'Connor on 7/19/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame andExpert:(NSDictionary*) expert andChat:(NSDictionary*)chat
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // initialization code
        self.expert = expert;
        self.chat = chat;
        
        //prompt label
        UILabel* promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, frame.size.width - 20.0, 60.0)];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.font = [UIFont systemFontOfSize:12];
        promptLabel.numberOfLines = 0;
        promptLabel.text = [NSString stringWithFormat:@"Please rate the helpfulness of your conversation with %@. 5 is best, 1 is worst.", expert[@"user"][@"username"]];
        [self addSubview:promptLabel];
        
        //slider view
        self.ratingSlider = [[UISlider alloc] initWithFrame:CGRectMake(10.0, frame.size.height/2, frame.size.width - 20.0, 10.0)];
        [self.ratingSlider setBackgroundColor:[UIColor clearColor]];
        self.ratingSlider.minimumValue = 1.0;
        self.ratingSlider.maximumValue = 5.0;
        self.ratingSlider.value = 3.0;
        [self addSubview:self.ratingSlider];
        
        //slider view value label
        self.ratingSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, (frame.size.height/2) + 15.0, self.frame.size.width - 20.0, 40.0)];
        self.ratingSliderLabel.textAlignment = NSTextAlignmentCenter;
        self.ratingSliderLabel.font = [UIFont systemFontOfSize:14];
        self.ratingSliderLabel.numberOfLines = 1;
        self.ratingSliderLabel.text = @"3 Stars";
        [self addSubview:self.ratingSliderLabel];
        
        
    }
    
    return self;
}

@end
