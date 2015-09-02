//
//  QualifiedExpertLoadingView.m
//  CrushIt
//
//  Created by William O'Connor on 8/11/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "QualifiedExpertLoadingView.h"

@implementation QualifiedExpertLoadingView

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
        self.loadingTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, frame.size.width - 20.0, 60.0)];
        self.loadingTextLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingTextLabel.font = [UIFont systemFontOfSize:12];
        self.loadingTextLabel.numberOfLines = 0;
        self.loadingTextLabel.text = @"Please wait while we pair you with a qualified expert";
        [self addSubview:self.loadingTextLabel];
        
        
        self.continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.continueButton.frame = CGRectMake(frame.size.width/2 - 50, 120.0, 100.0, 40);
        [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
        self.continueButton.titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
        self.continueButton.backgroundColor = [UIColor whiteColor];
        [self.continueButton addTarget:self action:@selector(continueButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.continueButton.enabled = NO;
        [self addSubview: self.continueButton];
    }
    
    [self addObserver:self forKeyPath:@"viewLoaded" options:NSKeyValueObservingOptionInitial context:NULL];
    return self;
}

- (void) continueButtonPressed
{
    [self.delegate continueToQualifiedChat];
}

- (void) noExpertsAvailable
{
    [self.continueButton removeFromSuperview];
    
    UILabel* noExpertsAvailableLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 180.0, 60.0)];
    noExpertsAvailableLabel.textAlignment = NSTextAlignmentCenter;
    noExpertsAvailableLabel.font = [UIFont systemFontOfSize:12];
    noExpertsAvailableLabel.numberOfLines = 0;
    noExpertsAvailableLabel.adjustsFontSizeToFitWidth = YES;
    noExpertsAvailableLabel.text = @"There are no qualified experts available at this time. Please try again later.";
    [self addSubview:noExpertsAvailableLabel];
    
    [self.loadingTextLabel removeFromSuperview];
}

- (void) findExpert
{
    NSDictionary* expert = [self.delegate findExpert];
    if (expert) {
        self.continueButton.enabled = YES;
    }
    else {
        [self noExpertsAvailable];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"viewLoaded"]) {
        [self findExpert];
    }
}

@end
