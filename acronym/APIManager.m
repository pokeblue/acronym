//
//  APIManager.m
//  
//
//  Created by Michael Oh on 11/12/15.
//
//

#import "APIManager.h"
#import "AFNetworking.h"

NSString* const kAPIEndPointSearchAcronym = @"/software/acromine/dictionary.py?sf=";
NSString* const kAPIBaseURLStaging = @"http://www.nactem.ac.uk";

@implementation APIManager


+ (APIManager*)sharedInstance{
    static dispatch_once_t pred;
    static APIManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[APIManager alloc] init];
    });
    
    return shared;
}

- (id)init{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

-(void)searchAcronym:(NSString*)acronym completion:(APIManagerRequestCompletionBlock)completion {
    NSString* endPoint = [NSString stringWithFormat:@"%@%@",kAPIEndPointSearchAcronym,acronym];
    NSURL *URL = [NSURL URLWithString:[self finalURL:endPoint]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self request:request completion:completion];
}

#pragma mark - request

-(void)request:(NSURLRequest*)request completion:(APIManagerRequestCompletionBlock)completion {
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(operation.response.statusCode == 200){
            [weakSelf requestDidComplete:operation.request];
            completion(responseObject, nil);
        } else {
            NSError* error=[self customError:@""];
            [self requestDidFail:operation.request error:error];
            completion(nil, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data =error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        //NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if(operation.response.statusCode == 200){
            [weakSelf requestDidComplete:operation.request];
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(responseObject, nil);
        } else {
            NSError* error=[self customError:@""];
            [self requestDidFail:operation.request error:error];
            completion(nil, error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}

#pragma mark - endPoints

-(NSString*)finalURL:(NSString *)endPoint{
    return [NSString stringWithFormat:@"%@%@",[self baseURL],endPoint];
}

-(NSString *)baseURL{
    return kAPIBaseURLStaging;
}

-(NSError*)customError:(NSString*)endPoint{
    return [NSError errorWithDomain:endPoint code:204 userInfo:[NSDictionary dictionaryWithObject:@"Error" forKey:@"error"]];
}

#pragma mark Standard Request Response Handlers

- (void)requestDidComplete:(NSURLRequest*)request{

}

- (void)requestDidFail:(NSURLRequest*)request error:(NSError*)error{
    
}



@end
