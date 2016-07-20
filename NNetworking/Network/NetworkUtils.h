//
//  NetworkUtils.h
//  HoikuHiroba
//
//  Created by Livepassvn on 4/5/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Network.h"
#import "NetworkUtils.h"
@import AFNetworking;

@interface NetworkUtils : Network

@property(nonatomic,strong) AFHTTPRequestOperationManager* oManager;

#pragma mark http

/**Set timeout of request.
 @author    Nhan Nguyen
 @code
 [NetworkUtils setTimeOut:30];
 @endcode
 @param     second
 */
+(void)setTimeOut:(int)second;

/**Set default request type POST, GET...
 @author    Nhan Nguyen
 @code
 [NetworkUtils setDefaultRequestType:REQUEST_TYPE_GET];
 @endcode
 @param     requestType REQUEST_TYPE_POST, REQUEST_TYPE_GET....
 */
+(void)setDefaultRequestType:(int)requestType;

/**Set default headerof request.
 @author    Nhan Nguyen
 @code
 [NetworkUtils setDefaultHeader:@"key" value:@"..."];
 @endcode
 @param     key The key of header. (Ex: @"Content-Type")
 @param     value The value by key. (Ex: @"application/json")
 */
+(void)setDefaultHeader:(NSString*)key value:(NSString*)value;

/**Remove default headerof request.
 @author    Nhan Nguyen
 @code
 [NetworkUtils removeDefaultHeader:@"key"];
 @endcode
 @param     key The key of header. (Ex: @"Content-Type")
 */
//+(void)removeDefaultHeader:(NSString*)key;

/**Remove all default headerof request.
 @author    Nhan Nguyen
 @code
 [NetworkUtils removeAllDefaultHeader];
 @endcode
 */
//+(void)removeAllDefaultHeader;

/**Reset all setting to default.
 @author    Nhan Nguyen
 @code
 [NetworkUtils reset];
 @endcode
 */
+(void)reset;

#pragma mark api

/**Request to HTTP, HTTPS service.
 @author    Nhan Nguyen
 @code
 [NetworkUtils request:@"https://xxx.com/api" params:nil taskId:@"YourManagerTasKid" onSuccess:^(NSDictionary *responseDict, int statusCode) {
 
 } onError:^(NSError *error) {
 
 }];
 @endcode
 @param     params Parameters will be include with request.
 @param     taskId The string id to manager request task. Its necessary to cancel a task.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 */
+(void)request:(NSString*)url
        params:(NSDictionary*)params
        taskId:(NSString*)taskId
     onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
       onError:(void (^)(NSError *error))failedBlock;

/**Request to HTTP, HTTPS service.
 @author    Nhan Nguyen
 @code
 [NetworkUtils request:@"https://xxx.com/api" params:nil onSuccess:^(NSDictionary *responseDict, int statusCode) {
 
 } onError:^(NSError *error) {
 
 }];
 @endcode
 @param     params Parameters will be include with request.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 */
+(void)request:(NSString*)url
        params:(NSDictionary*)params
     onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
       onError:(void (^)(NSError *error))failedBlock;

/**Request to HTTP, HTTPS service.
 @author    Nhan Nguyen
 @code
 [NetworkUtils request:@"https://xxx.com/api" params:nil headers:nil taskId:@"YourManagerTasKid" onSuccess:^(NSDictionary *responseDict, int statusCode) {
 
 } onError:^(NSError *error) {
 
 }];
 @endcode
 @param     params Parameters will be include with request.
 @param     headers Headers value will be include with request.
 @param     taskId The string id to manager request task. Its necessary to cancel a task.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 */
+(void)request:(NSString*)url
        params:(NSDictionary*)params
       headers:(NSDictionary*)headers
        taskId:(NSString*)taskId
     onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
       onError:(void (^)(NSError *error))failedBlock;


/**Upload multipart a file to server.
 @author    Nhan Nguyen
 @code
 [NetworkUtils httpUploadFile:@"https://xxx.com/api" filePath:@"your file path" serverKey:@"file" onSuccess:^(int statusCode) {
 
 } onError:^(NSError *error) {
 
 } onProcessing:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 
 }];
 @endcode
 @param     url The api URL.
 @param     filePath The path of file need to be uploaded.
 @param     serverKey The key will be used to get file's stream.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 @return AFHTTPRequestOperation
 */
+(AFHTTPRequestOperation*)uploadFile:(NSString*)url
                            filePath:(NSString*)filePath
                           serverKey:(NSString*)serverKey
                           onSuccess:(void (^)(int statusCode))sucessBlock
                             onError:(void (^)(NSError *error))failedBlock
                        onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock;

/**Upload multipart a file to server.
 @author    Nhan Nguyen
 @code
 [NetworkUtils httpUploadImage:@"https://xxx.com/api" image:<#(UIImage *)#> serverKey:@"file" fileName:@"file.png" onSuccess:^(int statusCode) {
 
 } onError:^(NSError *error) {
 
 } onProcessing:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 
 }];
 @endcode
 @param     url The api URL.
 @param     filePath The path of file need to be uploaded.
 @param     serverKey The key will be used to get file's stream.
 @param     fileName The file name will be store on server.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 @return AFHTTPRequestOperation
 */
//+(AFHTTPRequestOperation*)uploadImage:(NSString*)url
//                               params:(NSDictionary*)params
//                                image:(UIImage*)image
//                            serverKey:(NSString*)serverKey
//                             fileName:(NSString*)fileName
//                            onSuccess:(void (^)(int statusCode))sucessBlock
//                              onError:(void (^)(NSError *error))failedBlock
//                         onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock;



+(void)uploadImage:(NSString*)url
            params:(NSDictionary*)params
             image:(UIImage*)image
         serverKey:(NSString*)serverKey
          fileName:(NSString*)fileName
         onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
           onError:(void (^)(NSError *error))failedBlock
      onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock;
/**Download file.
 @author    Nhan Nguyen
 @code
 [NetworkUtils download:@"url to file" onSuccess:^(NSData *data) {
 
 } onError:^(NSError *error) {
 
 } onProcessing:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
 
 }];
 @endcode
 @param     url The api URL.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 @return AFHTTPRequestOperation
 */
+(AFHTTPRequestOperation*)download:(NSString*)url
                         onSuccess:(void (^)(NSData *data))sucessBlock
                           onError:(void (^)(NSError *error))failedBlock
                      onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock;

/**Request to HTTP, HTTPS SOAP service.
 @author    Nhan Nguyen
 @code
 [NetworkUtils soapRequest:@"url" soapMessage:@"soap body message" onSuccess:^(NSXMLParser *responseDict, int statusCode) {
 
 } onError:^(NSError *error) {
 
 }];
 @endcode
 @param     soapMessage The body params of SOAP request.
 @param     onSuccess The block will be call when requesting success.
 @param     onError The block will be call when requesting fail.
 */
+(void)soapRequest:(NSString *)url
       soapMessage:(NSString*)soapMessage
         onSuccess:(void (^)(NSXMLParser *responseDict, int statusCode))sucessBlock
           onError:(void (^)(NSError *error))failedBlock;
@end
