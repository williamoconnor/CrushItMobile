//
//  GetCorrespondencesView.m
//  CrushIt
//
//  Created by William O'Connor on 8/11/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "GetCorrespondencesView.h"

@implementation GetCorrespondencesView

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
        //Get CORRESPONDENCES
        self.oneCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.oneCorrButton.frame = CGRectMake(frame.size.width/2 - 120, 20.0, 240.0, 40.0);
        [self.oneCorrButton setTitle:@"Get 1 Correspondence - $2.00" forState:UIControlStateNormal];
        self.oneCorrButton.backgroundColor = [UIColor whiteColor];
        [self.oneCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.oneCorrButton];
        
        self.twoCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.twoCorrButton.frame = CGRectMake(frame.size.width/2 - 120, 100.0, 240.0, 40.0);
        [self.twoCorrButton setTitle:@"Get 2 Correspondences - $4.00" forState:UIControlStateNormal];
        self.twoCorrButton.backgroundColor = [UIColor whiteColor];
        [self.twoCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.twoCorrButton];
        
        self.fiveCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.fiveCorrButton.frame = CGRectMake(frame.size.width/2 - 120, 180.0, 240.0, 40.0);
        [self.fiveCorrButton setTitle:@"Get 5 Correspondences - $12.00" forState:UIControlStateNormal];
        self.fiveCorrButton.backgroundColor = [UIColor whiteColor];
        [self.fiveCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.fiveCorrButton];
        
        self.tenCorrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.tenCorrButton.frame = CGRectMake(frame.size.width/2 - 120, 260.0, 240.0, 40.0);
        [self.tenCorrButton setTitle:@"Get 10 Correspondences - $22.00" forState:UIControlStateNormal];
        self.tenCorrButton.backgroundColor = [UIColor whiteColor];
        [self.tenCorrButton addTarget:self action:@selector(buyCorrespondence:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.tenCorrButton];
    }
    
    return self;
}

-(void) buyCorrespondence:(id) sender
{
    NSNumber* amount = @0;
    NSNumber* cost = @0;
    UIButton* button = sender;
    if (button.frame.origin.y == 20.0) {
        amount = @1;
        cost = @2.00;
    }
    else if (button.frame.origin.y == 100.0) {
        amount = @2;
        cost = @4.00;
    }
    else if (button.frame.origin.y == 180.0) {
        amount = @5;
        cost = @12.00;
    }
    else if (button.frame.origin.y == 260.0) {
        amount = @10;
        cost = @22.00;
    }
    
    BOOL result = [self.delegate buyCorrespondences:amount andCost:cost];
    if (result) {
        [self addResultMessage:YES];
    }
    else {
        [self addResultMessage:NO];
    }
}

-(void) addResultMessage:(BOOL)success
{
    NSString* message = [[NSString alloc] init];
    if (success) {
        message = @"Successfully added correspondences";
    }
    else {
        message = @"Failed to add correspondences";
    }
    
    // remove buttons
    [self.oneCorrButton removeFromSuperview];
    [self.twoCorrButton removeFromSuperview];
    [self.fiveCorrButton removeFromSuperview];
    [self.tenCorrButton removeFromSuperview];
    
    //shrink frame
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 80.0);
    self.frame = newFrame;
    
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.frame.size.height/5, self.frame.size.width - 20.0, self.frame.size.height*0.6)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:12];
    messageLabel.numberOfLines = 0;
    messageLabel.text = message;
    [self addSubview:messageLabel];
}

@end
