//
//  ExpertTileView.m
// CrushIt
//
//  Created by William O'Connor on 7/24/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertTileView.h"
#import "Strings.h"

@implementation ExpertTileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id) initWithFrame:(CGRect)frame andExpert:(NSDictionary *)expert
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.expert = expert;
        //all the shit
        //NAME
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.frame.size.height-40.0, self.frame.size.width-20.0, 40.0)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.text = expert[@"user"][@"username"];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.nameLabel];
        
        //IMAGE
        self.tileImageView =[[UIImageView alloc] initWithFrame:CGRectMake(25.0, 10.0, self.frame.size.width-50.0, self.frame.size.height-50.0)];
        NSString* urlString = [[[kRootURL stringByAppendingString:kGetExpert] stringByAppendingString:[NSString stringWithFormat:@"%@", self.expert[@"expert"][@"id"]]] stringByAppendingString:@"/profile-picture"];
        NSURL* url = [NSURL URLWithString: urlString];
        self.tileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        self.tileImageView.image = self.tileImage;
        [self addSubview:self.tileImageView];
        
        //WHOLE THING
        self.layer.borderWidth = 1.0f;
        if (expert[@"expert"][@"availability"]) {
            self.layer.borderColor = [[UIColor greenColor] CGColor];
        }
        else {
            self.layer.borderColor = [[UIColor redColor] CGColor];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        [self setBackgroundImage:[self backgroundColorImage] forState:UIControlStateHighlighted];
        
    }
    
    return self;
}

-(UIImage*) backgroundColorImage
{
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    colorView.backgroundColor = [UIColor lightGrayColor];
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

@end
