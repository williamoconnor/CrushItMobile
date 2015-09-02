//
//  RenewalView.m
// CrushIt
//
//  Created by William O'Connor on 7/19/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "RenewalView.h"

@implementation RenewalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame andChat:(NSDictionary*)chat andExpert:(NSDictionary*)expert
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // initialization code
        
        //nslog(@"params: %@ :: %@", chat, expert);
        //nslog(@"%@", expert[@"user"][@"username"]);
        // message label
        UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, frame.size.height/5, frame.size.width - 20.0, frame.size.height*0.6)];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:12];
        messageLabel.numberOfLines = 0;
        messageLabel.text = [NSString stringWithFormat: @"This conversation has changed course and needs to be considered an additional correspondence. Please accept an additional charge by agreeing to Renew below, or you may end the correspondence with %@", expert[@"user"][@"username"]];
        [self addSubview:messageLabel];
    }
    
    return self;
}

@end
