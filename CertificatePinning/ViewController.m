//
//  ViewController.m
//  CertificatePinning
//
//  Created by Anton Tugolukov on 05/01/2017.
//  Copyright © 2017 Anton Tugolukov. All rights reserved.
//

#import "ViewController.h"
#import "SGSessionDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURLRequest* demoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/SiberianGeek/CertificatePinning.git"]];
    
    NSURLResponse* demoResponse = nil;
    NSError* error = nil;
    
    NSData* responseData = [self sendSynchronousRequest:demoRequest
                                      returningResponse:&demoResponse
                                                  error:&error];
    
    NSLog(@"Request:%@\nResponse:%@\nError:%@\nData:%@\n", demoRequest, demoResponse, error, responseData);
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSData *)sendSynchronousRequest:(NSURLRequest *)request
                 returningResponse:(NSURLResponse **)response
                             error:(NSError **)error
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    
    NSError __block *err = NULL;
    NSData __block *data;
    NSURLResponse __block *resp;
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    SGSessionDelegate* sessionDelegate = [[SGSessionDelegate alloc] init];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:sessionDelegate
                                                     delegateQueue:nil];
    
    
    NSURLSessionTask* task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData* _data, NSURLResponse* _response, NSError* _error) {
                                            resp = _response;
                                            err = _error;
                                            data = _data;
                                            dispatch_group_leave(group);
                                            
                                        }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    if (err)
    {
        NSLog(@"Request failed:%@\nError:%@", request, err);
        if (error) {
            *error = err;
        }
        
    }
    
    if (response)
    {
        *response = resp;
    }
    
    return data;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
