//
//  APIManager.h
//  
//
//  Created by Michael Oh on 11/12/15.
//
//

#import <Foundation/Foundation.h>

typedef void (^APIManagerRequestCompletionBlock)(NSURLResponse *result, NSError *error);

@interface APIManager : NSObject

+ (APIManager*)sharedInstance;

/*
 @brief : Return a acronym search result.
 */
-(void)searchAcronym:(NSString*)acronym completion:(APIManagerRequestCompletionBlock)completion;


@end
