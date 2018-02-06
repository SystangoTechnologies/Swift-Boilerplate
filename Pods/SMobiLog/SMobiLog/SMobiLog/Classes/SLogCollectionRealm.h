//
//  SLogCollectionRealm.h
//  SMobiLogger
//
//  Created by Systango on 26/04/17.
//  Copyright © 2017 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLogRealm.h"

@interface SLogCollectionRealm : RLMObject

@property NSString *primaryKey;

@property RLMArray<SLogRealm *><SLogRealm> *sLogs;

- (id)initWithClassName:(NSString *)className;

- (void)insertSLog:(SLogRealm *)sLogRealm;

@end
