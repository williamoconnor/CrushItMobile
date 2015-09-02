//
//  ExpertSpecialtyTile.m
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "ExpertSpecialtyTile.h"

@implementation ExpertSpecialtyTile

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame andName:(NSString*)name/* andImage:(UIImage*)image*/
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //all the shit
        //NAME
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.frame.size.height-60.0, self.frame.size.width-10.0, 40.0)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.text = name;
        [self addSubview:self.nameLabel];
        self.name = name;

        //IMAGE
//        self.tileImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, self.frame.size.width-20.0, self.frame.size.height-70.0)];
//        self.tileImageView.image = image;
//        self.tileImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:self.tileImageView];
        
        //WHOLE THING
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
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
