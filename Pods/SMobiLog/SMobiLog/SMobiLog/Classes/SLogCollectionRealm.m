//
//  SLogCollectionRealm.m
//  SMobiLogger
//
//  Created by Systango on 26/04/17.
//  Copyright © 2017 Systango. All rights reserved.
//

#import "SLogCollectionRealm.h"

@implementation SLogCollectionRealm

- (id)initWithClassName:(NSString *)className
{
    self = [super init];
    if(self)
    {
        _primaryKey = className;
    }
    
    return self;
}
+ (NSString *)primaryKey {
    return @"primaryKey";
}

- (void)insertSLog:(SLogRealm *)sLogRealm;
{
    [self.sLogs addObject:sLogRealm];
}

@end
