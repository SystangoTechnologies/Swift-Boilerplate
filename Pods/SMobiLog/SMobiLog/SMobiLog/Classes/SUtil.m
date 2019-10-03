//
//  SUtil.m
//  SMobiLogger
//
//  Created by Systango on 26/04/17.
//  Copyright © 2017 Systango. All rights reserved.
//

#import "SUtil.h"
#import "SLogCollectionRealm.h"

@implementation SUtil

#pragma mark - Realm Operations

+ (void)initializeRealm
{
    if(![SLogCollectionRealm objectForPrimaryKey:[SLogCollectionRealm className]])
    {
        SLogCollectionRealm  *sLogCollectionRealm = [[SLogCollectionRealm alloc] initWithClassName:[SLogCollectionRealm className]];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject: sLogCollectionRealm];
        [realm commitWriteTransaction];
    }
}

+ (void)cleanRealm
{
    // Clean Realm db
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

@end
