//
//  DataManager.h
// CrushIt
//
//  Created by William O'Connor on 7/15/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REST_API.h"
#import "Strings.h"

@interface DataManager : NSObject

+ (NSDictionary *) signUp:(NSMutableDictionary*)data;
+ (NSDictionary *) signIn:(NSMutableDictionary*)data;
+ (NSDictionary *) getUser:(NSString*)data;
+ (NSDictionary *) getQBUser:(NSString*)data;
+ (NSDictionary *) deleteQBUser:(NSString*)data;
+ (NSDictionary *) getUsers:(NSString*)data;
+ (NSDictionary *) purchaseCorrespondence:(NSMutableDictionary*)data;
+ (NSDictionary *) startCorrespondence:(NSMutableDictionary*)data;
+ (NSDictionary *) getArticle:(NSString*)data;
+ (NSDictionary *) getArticles;
+ (NSDictionary *) getExperts:(NSString*)data;
+ (NSDictionary *) getAllFeaturedExperts;
+ (NSDictionary *) getQualifiedExperts:(NSMutableDictionary*)data;
+ (NSDictionary *) getExpert:(NSString*)data;
+ (NSDictionary *) getQualifiedExpert;
+ (NSDictionary *) updateExpert:(NSMutableDictionary*)data;
+ (NSDictionary *) getProfilePicture:(NSString*)data;
+ (NSDictionary *) submitRating:(NSMutableDictionary*)data;
+ (NSDictionary *) endChat:(NSMutableDictionary*)data;
+ (NSDictionary *) setExpertAvailability:(NSMutableDictionary*)data;
+ (NSDictionary *) getActiveUserChats:(NSString*)data;
+ (NSDictionary *) getActiveExpertChats:(NSString*)data;
+ (NSDictionary *) addDialogIdToChat:(NSMutableDictionary*)data;
+ (NSDictionary *) getUnratedChats:(NSString*)data;
+ (NSDictionary *) renewChat:(NSMutableDictionary *) data;
+ (NSDictionary *) renewChatRequest:(NSMutableDictionary *) data;
+ (NSDictionary *) getChatWithDialogID:(NSString *)data;
+ (NSDictionary *) changePassword:(NSMutableDictionary *)data;


@end
