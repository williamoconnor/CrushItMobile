//
//  GetCorrespondencesView.h
//  CrushIt
//
//  Created by William O'Connor on 8/11/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyCorrespondencesDelegate <NSObject>

- (BOOL) buyCorrespondences:(NSNumber*)amount andCost:(NSNumber*)cost;

@end

@interface GetCorrespondencesView : UIView

@property (nonatomic) id <BuyCorrespondencesDelegate> delegate;

@property (strong, nonatomic) UIButton* oneCorrButton;
@property (strong, nonatomic) UIButton* twoCorrButton;
@property (strong, nonatomic) UIButton* fiveCorrButton;
@property (strong, nonatomic) UIButton* tenCorrButton;

@end
