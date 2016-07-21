//
//  MCHandler.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/21/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "MCHandler.h"

@implementation MCHandler

- (void)setupPeerWithDisplayName:(NSString *)displayName{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)setupSession {
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

- (void)setupBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"my-game" session:_session];
}

- (void)advertiseSelf:(BOOL)advertise{
    if (advertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"my-game" discoveryInfo:nil session:_session];
        [_advertiser start];
    } else {
        [_advertiser stop];
        _advertiser = nil;
    }
}

// MCSessionDelegate Methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *userInfo = @{@"peerID" : peerID,
                               @"state" : @(state)};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidChangeStateNotification" object:nil userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *userInfo = @{@"data" : data,
                               @"peerID" : peerID};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveDataNotification" object:nil userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}
@end
