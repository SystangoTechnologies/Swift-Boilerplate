//
//  SLogRealm.m
//  SMobiLogger
//
//  Created by Systango on 26/04/17.
//  Copyright © 2017 Systango. All rights reserved.
//

#import "SLogRealm.h"

@implementation SLogRealm

- (id)initWithSLogModel:(SLog *)sLog
{
    self = [super init];
    if(!self) return nil;
    
    self.lDescription = sLog.lDescription;
    self.lIssueDate = sLog.lIssueDate;
    self.lTitle = sLog.lTitle;
    self.lType = sLog.lType;
    
    return self;
}

@end
