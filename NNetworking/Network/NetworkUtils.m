//
//  NetworkUtils.m
//  HoikuHiroba
//
//  Created by Livepassvn on 4/5/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

#import "NetworkUtils.h"

@implementation NetworkUtils

static int httpRequestType = REQUEST_TYPE_POST;
static NSTimeInterval network_timeout = 30;
static NSMutableDictionary *defaultHeader = nil;

static NetworkUtils* sharedManager = nil;

static NSMutableDictionary *aFHTTPRequestOperation;

+ (instancetype)sharedManager {
    @synchronized(self)
    {
        if (sharedManager && [sharedManager isKindOfClass:[self class]]){
            return sharedManager;
        }else{
            sharedManager = [[self alloc] init];
            return sharedManager;
        }
    }
}


+(void)setTimeOut:(int)second{
    network_timeout = second;
}

+(void)setDefaultRequestType:(int)requestType{
    httpRequestType = requestType;
}

+(void)setDefaultHeader:(NSString*)key value:(NSString*)value{
    if (defaultHeader == nil) {
        defaultHeader = [[NSMutableDictionary alloc] init];
    }
    [defaultHeader setValue:value forKey:key];
}

+(void)reset
{
    httpRequestType = REQUEST_TYPE_POST;
//    [self removeAllDefaultHeader];
    AFHTTPRequestOperationManager *manager= [[self sharedManager] oManager];
    [[manager operationQueue] cancelAllOperations];
    [aFHTTPRequestOperation removeAllObjects];
    aFHTTPRequestOperation = nil;
    manager = nil;
}

#pragma mark Api requestor
+(AFHTTPRequestOperationManager*)getRequestOperationManager{
    return [[self sharedManager] oManager];
}

-(void)addTask:(AFHTTPRequestOperation*)requestOperation taskName:(NSString*)taskName{
    [aFHTTPRequestOperation setObject:requestOperation forKey:taskName];
}
+ (void)cancelAllRequest{
    [[[[self sharedManager] oManager] operationQueue] cancelAllOperations];
    [aFHTTPRequestOperation removeAllObjects];
}

+ (void)cancelRequest:(NSString*)taskId{
    AFHTTPRequestOperation *requestOperation = [aFHTTPRequestOperation objectForKey:taskId];
    if (requestOperation) {
        [requestOperation cancel];
        [aFHTTPRequestOperation removeObjectForKey:taskId];
    }
}

#pragma mark https

+ (void)request:(NSString*)url
         params:(NSDictionary*)params
         taskId:(NSString*)taskId
      onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
        onError:(void (^)(NSError *error))failedBlock{
    [self request:url params:params headers:nil taskId:taskId onSuccess:sucessBlock onError:failedBlock];
}

+ (void)request:(NSString*)url
         params:(NSDictionary*)params
      onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
        onError:(void (^)(NSError *error))failedBlock{
    [self request:url params:params headers:nil taskId:nil onSuccess:sucessBlock onError:failedBlock];
}

+ (void)request:(NSString*)url
         params:(NSDictionary*)params
        headers:(NSDictionary*)headers
         taskId:(NSString*)taskId
      onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
        onError:(void (^)(NSError *error))failedBlock
{
    AFHTTPRequestOperationManager *manager= [[self sharedManager] oManager];
    
    if (manager == nil) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer.timeoutInterval = network_timeout;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/x-www-form-urlencoded", nil];
    }
    
    if (headers) {
        for( NSString *key in headers )
        {
            [manager.requestSerializer setValue:[headers valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if (defaultHeader) {
        NSArray *allKeys = [defaultHeader allKeys];
        for( NSString *key in allKeys)
        {
            [manager.requestSerializer setValue:[defaultHeader valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    AFHTTPRequestOperation *requestOperation;
    switch (httpRequestType) {
        case REQUEST_TYPE_GET:
        {
            requestOperation = [manager GET:url
                                 parameters:params
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if (sucessBlock) {
                                            sucessBlock(responseObject, (int)[operation.response statusCode]);
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failedBlock)
                                        {
                                            failedBlock(error);
                                        }
                                    }];
        }
            break;
        case REQUEST_TYPE_POST:
        {
            requestOperation = [manager POST:url
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         if (sucessBlock) {
                                             sucessBlock(responseObject, (int)[operation.response statusCode]);
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failedBlock)
                                         {
                                             failedBlock(error);
                                         }
                                     }];
        }
            break;
        case REQUEST_TYPE_HEAD:{
            requestOperation = [manager HEAD:url
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation) {
                                         if (sucessBlock) {
                                             sucessBlock(nil, (int)[operation.response statusCode]);
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failedBlock) {
                                             failedBlock(error);
                                         }
                                     }];
        }
            break;
        case REQUEST_TYPE_PUT:
        {
            requestOperation = [manager PUT:url
                                 parameters:params
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if (sucessBlock) {
                                            sucessBlock(responseObject, (int)[operation.response statusCode]);
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failedBlock) {
                                            failedBlock(error);
                                        }
                                    }];
        }
            break;
        case REQUEST_TYPE_PATCH:
        {
            requestOperation = [manager PATCH:url
                                   parameters:params
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          if (sucessBlock) {
                                              sucessBlock(responseObject, (int)[operation.response statusCode]);
                                          }
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          if (failedBlock) {
                                              failedBlock(error);
                                          }
                                      }];
        }
            break;
        case REQUEST_TYPE_DELETE:
        {
            requestOperation = [manager DELETE:url
                                    parameters:params
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           if (sucessBlock) {
                                               sucessBlock(responseObject, (int)[operation.response statusCode]);
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           if (failedBlock) {
                                               failedBlock(error);
                                           }
                                       }];
        }
            break;
            
        default:
            break;
    }
    
    //Add task to queue for canceling if necessary
    if (taskId) {
        [aFHTTPRequestOperation setObject:requestOperation forKey:taskId];
    }
}

+(AFHTTPRequestOperation*)uploadFile:(NSString*)url
                            filePath:(NSString*)filePath
                           serverKey:(NSString*)serverKey
                           onSuccess:(void (^)(int statusCode))sucessBlock
                             onError:(void (^)(NSError *error))failedBlock
                        onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock
{
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    AFHTTPRequestOperation *operation = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:fileData name:serverKey fileName:[[NSURL URLWithString:filePath] lastPathComponent] mimeType:@"application/octet-stream"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        sucessBlock(200);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //float processing = [[NSString stringWithFormat:@"%.2f", (float)totalBytesWritten/totalBytesExpectedToWrite] floatValue];
        processingBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    return operation;
}



+(void)uploadImage:(NSString*)url
            params:(NSDictionary*)params
             image:(UIImage*)image
         serverKey:(NSString*)serverKey
          fileName:(NSString*)fileName
         onSuccess:(void (^)(NSDictionary *responseDict, int statusCode))sucessBlock
           onError:(void (^)(NSError *error))failedBlock
      onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:serverKey fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucessBlock) {
            sucessBlock(responseObject, (int)[operation.response statusCode]);
        }
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
}


+(AFHTTPRequestOperation*)download:(NSString*)url
                         onSuccess:(void (^)(NSData *data))sucessBlock
                           onError:(void (^)(NSError *error))failedBlock
                      onProcessing:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))processingBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        sucessBlock(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];
    
    [downloadRequest setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        processingBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
    
    [downloadRequest start];
    
    return downloadRequest;
}

+(void)soapRequest:(NSString *)url
       soapMessage:(NSString*)soapMessage
         onSuccess:(void (^)(NSXMLParser *responseDict, int statusCode))sucessBlock
           onError:(void (^)(NSError *error))failedBlock{
    /*
     NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<Body>"
     "<requestCommand xmlns=\"http://mobilegateway.viettel.com/\">"
     "<arg0 xmlns=\"\">8990db4bc2b2777cb770ae98006d8fa5a9d3e3cdf82b89b64aa3ee29fca30812</arg0>"
     "<arg1 xmlns=\"\">1961</arg1>"
     "<arg2 xmlns=\"\">341</arg2>"
     "<arg3 xmlns=\"\">1</arg3>"
     "<arg4 xmlns=\"\"></arg4>"
     "</requestCommand>"
     "</Body>"
     "</Envelope>"];
     
     
     NSURL *url1 = [NSURL URLWithString:@"https://10.60.15.196:9101/mgw/mobilegw"];
     */
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"requestCommand" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:theRequest];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml",@"application/json",@"application/x-www-form-urlencoded",@"application/xml", nil];
    operation.securityPolicy.allowInvalidCertificates = YES;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //parse NSXMLParser object here if request successfull
        if ([responseObject isKindOfClass:[NSXMLParser class]]) {
            sucessBlock(responseObject,200);
            
            /*
             NSXMLParser *xmlParser = (NSXMLParser *)responseObject;
             
             [xmlParser setDelegate: self];
             
             [xmlParser setShouldResolveExternalEntities: NO];
             [xmlParser setShouldProcessNamespaces:NO];
             [xmlParser setShouldReportNamespacePrefixes:NO];
             [xmlParser setShouldResolveExternalEntities:NO];
             [xmlParser parse];
             */
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName

   attributes: (NSDictionary *)attributeDict

{
    //NSLog(@"%@",elementName);
}

+(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

{
    //NSLog(@"%@",elementName);
}

+(void)parserDidEndDocument:(NSXMLParser *)parser

{
    
}

@end
