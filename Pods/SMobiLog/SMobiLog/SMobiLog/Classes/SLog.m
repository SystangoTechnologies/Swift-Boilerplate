//
//  SLog.m
//  SMobiLogger
//
//  Created by Systango on 4/12/13.
//  Copyright (c) 2013 Systango. All rights reserved.
//

#import "SLog.h"
#import "SLogRealm.h"

@implementation SLog

- (id)initWithTitle:(NSString *)title description:(NSString *)description date:(NSDate *)date type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        _lTitle = title;
        _lDescription = description;
        _lIssueDate = date;
        _lType = type;
    }
    
    return self;
}

- (id)initWithRealmModel:(SLogRealm *)sLogRealm
{
    self = [super init];
    if(!self) return nil;
    
    self.lDescription = sLogRealm.lDescription;
    self.lIssueDate = sLogRealm.lIssueDate;
    self.lTitle = sLogRealm.lTitle;
    self.lType = sLogRealm.lType;
    
    return self;
}

@end
