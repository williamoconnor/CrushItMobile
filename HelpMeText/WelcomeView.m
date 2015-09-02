//
//  WelcomeView.m
//  CrushIt
//
//  Created by William O'Connor on 8/6/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "WelcomeView.h"

@implementation WelcomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
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
        messageLabel.text = @"First things first, you’re going to Crush.it. \nGet advice, talk through next steps, or even draft the perfect text. Whatever the situation, our experts will help you Crush.it";
        [self addSubview:messageLabel];
    }
    
    return self;
}

@end
