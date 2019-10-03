#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LoggerConstants.h"
#import "SLog.h"
#import "SLogCollectionRealm.h"
#import "SLogRealm.h"
#import "SMobiLogger.h"
#import "SUtil.h"

FOUNDATION_EXPORT double SMobiLogVersionNumber;
FOUNDATION_EXPORT const unsigned char SMobiLogVersionString[];

