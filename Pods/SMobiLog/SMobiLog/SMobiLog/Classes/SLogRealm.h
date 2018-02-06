//
//  SLogRealm.h
//  SMobiLogger
//
//  Created by Systango on 26/04/17.
//  Copyright © 2017 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "SLog.h"


@interface SLogRealm : RLMObject

@property NSString *lDescription;
@property NSDate *lIssueDate;
@property NSString *lTitle;
@property NSString *lType;

- (id)initWithSLogModel:(SLog *)sLog;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<SLogRealm>
RLM_ARRAY_TYPE(SLogRealm)
