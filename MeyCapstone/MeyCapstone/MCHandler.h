//
//  MCHandler.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/21/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCHandler : NSObject <MCSessionDelegate>
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

- (void)setupPeerWithDisplayName:(NSString *)displayName;
- (void)setupSession;
- (void)setupBrowser;
- (void)advertiseSelf:(BOOL)advertise;

@end
