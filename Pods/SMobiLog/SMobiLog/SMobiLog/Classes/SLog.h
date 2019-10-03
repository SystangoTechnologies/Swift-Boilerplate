//
//  SLog.h
//  SMobiLogger
//
//  Created by Systango on 4/12/13.
//  Copyright (c) 2013 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLogRealm;

@interface SLog : NSObject

@property (nonatomic, copy) NSString *lDescription;
@property (nonatomic, strong) NSDate *lIssueDate;
@property (nonatomic, copy) NSString *lTitle;
@property (nonatomic, copy) NSString *lType;

- (id)initWithTitle:(NSString *)title description:(NSString *)description date:(NSDate *)date type:(NSString *)type;

- (id)initWithRealmModel:(SLogRealm *)sLogRealm;
@end
