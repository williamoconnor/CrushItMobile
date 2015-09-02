//
//  DataManager.m
// CrushIt
//
//  Created by William O'Connor on 7/15/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "DataManager.h"
#import "Strings.h"

@implementation DataManager

+ (NSDictionary *) signUp:(NSMutableDictionary*)data
{
    return [REST_API postPath:[kRootURL stringByAppendingString:kSignUp] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) signIn:(NSMutableDictionary*)data
{
    /*
     wants: {email: String, password: String}
     */
    return [REST_API postPath:[kRootURL stringByAppendingString:kSignIn] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) getUser:(NSString*)data
{
    return [REST_API getPath:[kRootURL stringByAppendingString:[kGetUser stringByAppendingString:data]]];
}

+ (NSDictionary *) getQBUser:(NSString*)data
{
    return [REST_API getPath:[kRootURL stringByAppendingString:[kDeleteQBUser stringByAppendingString:[@"/" stringByAppendingString: data]]]];
}

+ (NSDictionary *) deleteQBUser:(NSString*)data
{
    return [REST_API getPath:[kRootURL stringByAppendingString:[kGetUser stringByAppendingString:[@"/" stringByAppendingString: data]]]];
}

+ (NSDictionary *) getUsers:(NSString*)data
{
    return [REST_API getPath:[kRootURL stringByAppendingString:[kGetUsers stringByAppendingString:[@"/" stringByAppendingString: data]]]];
}

+ (NSDictionary *) purchaseCorrespondence:(NSMutableDictionary*)data
{
    return [REST_API postPath:[kRootURL stringByAppendingString:kPurchaseCorrespondence] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) getArticle:(NSString*)data
{
    return [REST_API getPath:[kRootURL stringByAppendingString:[kGetArticle stringByAppendingString:[@"/" stringByAppendingString: data]]]];
}

+ (NSDictionary *) getArticles
{
    return [REST_API getPath:[kRootURL stringByAppendingString:kGetArticles]];
}

+ (NSDictionary *) getExperts:(NSString*)data
{
    return [REST_API getPath:[[kRootURL stringByAppendingString:kGetExperts] stringByAppendingString:data]];
}

+ (NSDictionary *) getAllFeaturedExperts
{
    return [REST_API getPath:[kRootURL stringByAppendingString:kGetAllFeaturedExperts]];
}

+(NSDictionary *) getQualifiedExperts:(NSMutableDictionary*)data
{
    /*
     Wants an array of experts of those who are online
     onlineExperts: []
     */
    return [REST_API getPath:[kRootURL stringByAppendingString:kGetAllQualifiedExperts]];
}

+ (NSDictionary *) getExpert:(NSString*)data
{
    return [REST_API getPath:[[kRootURL stringByAppendingString:kGetExpert] stringByAppendingString:data]];
}

+ (NSDictionary *) getQualifiedExpert
{
    return [REST_API getPath:[kRootURL stringByAppendingString:kGetQualifiedExpert]];
}

+ (NSDictionary *) updateExpert:(NSMutableDictionary*)data
{
    return [REST_API putPath:[kRootURL stringByAppendingString:kUpdateExpert] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) endChat:(NSMutableDictionary *)data
{
/*
 wants {chatID: String}
 */
    return [REST_API putPath:[kRootURL stringByAppendingString:kEndChat] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) renewChat:(NSMutableDictionary *) data
{
    /*
     wants {chatID: String}
     */
    return [REST_API putPath:[kRootURL stringByAppendingString:kRenewChat] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) renewChatRequest:(NSMutableDictionary *)data
{
    /*
     wants {chatID: String, setting: Bool}
     */
    return [REST_API putPath:[kRootURL stringByAppendingString:kRenewChat] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) submitRating:(NSMutableDictionary *)data
{
/*
 wants {rating: {chatID: int, rating: int}}
 */
    return [REST_API postPath:[kRootURL stringByAppendingString:kSubmitRating] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary*) setExpertAvailability:(NSMutableDictionary*)data
{
    /*
     wants {expertID: string, available: bool}
     */
    return [REST_API putPath:[kRootURL stringByAppendingString:kUpdateExpertAvailability] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary*) startCorrespondence:(NSMutableDictionary *)data
{
    /*
     wants {correspondence: {userID: int, expertID: int}}
     */
    return [REST_API postPath:[kRootURL stringByAppendingString:kStartCorrespondece] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary*) getActiveUserChats:(NSString *)data
{
    // data is the user id
    return [REST_API getPath:[[kRootURL stringByAppendingString:kGetActiveUserChats] stringByAppendingString:data]];
    // returns two arrays: one list of the active chats, one parallel list of the experts for those chats
}

+ (NSDictionary*) getActiveExpertChats:(NSString *)data
{
    // data is the expert id
    return [REST_API getPath:[[kRootURL stringByAppendingString:kGetActiveExpertChats] stringByAppendingString:data]];
    // returns two arrays: one list of the active chats, one parallel list of the users for those chats
}

+ (NSDictionary *) addDialogIdToChat:(NSMutableDictionary*)data
{
    /*
     wants {chatID: int, dialogID: int}
     */
    return [REST_API postPath:[kRootURL stringByAppendingString:kAddDialogIdToChat] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary *) getUnratedChats:(NSString*)data
{
    // data is the user id
    return [REST_API getPath:[[kRootURL stringByAppendingString:kUnratedChats] stringByAppendingString:data]];
}

+ (NSDictionary*) getChatWithDialogID:(NSString *)data
{
    // data is the expert id
    return [REST_API getPath:[[kRootURL stringByAppendingString:kGetChatWithDialog] stringByAppendingString:data]];
    // returns two arrays: one list of the active chats, one parallel list of the users for those chats
}

+ (NSDictionary*) changePassword:(NSMutableDictionary *)data
{
    /*
     wants {email: string, password: string}
     */
    return [REST_API putPath:[kRootURL stringByAppendingString:kChangePassword] data:[JSONConverter convertNSMutableDictionaryToJSON:data]];
}

+ (NSDictionary*) getProfilePicture:(NSString*)data
{
    return [REST_API getPath:[[[kRootURL stringByAppendingString:kGetExpert] stringByAppendingString:data] stringByAppendingString:@"/profile-picture"]];
}

@end
