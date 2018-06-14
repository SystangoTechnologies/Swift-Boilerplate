//
//  SMobiLogger.m
//  SMobiLogger
//
//  Created by Systango on 4/12/13.
//  Copyright (c) 2013 Systango. All rights reserved.
//

#import "SMobiLogger.h"
#import "SLog.h"
#import "LoggerConstants.h"
#import <MessageUI/MFMailComposeViewController.h>
#include <sys/sysctl.h>
#import <Realm/Realm.h>
#import "SUtil.h"
#import "SLogCollectionRealm.h"

@interface SMobiLogger() <MFMailComposeViewControllerDelegate>
@property(nonatomic,readwrite,retain) UIViewController* dummyVC;

@end

@implementation SMobiLogger

+ (SMobiLogger *)sharedInterface
{
    static SMobiLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark init

- (id)init {
    self = [super init];
    convertintoC(self);
    
    if (self) {
        queue_ = dispatch_queue_create("com.Systango.SMobiLogger", NULL);
    }
    
    return self;
}

#pragma mark - Public methods

//To delete old logs from db
- (void)refreshLogs:(NSNumber*)fromDaysOrNil{
    if(![fromDaysOrNil isKindOfClass:[NSNumber class]])
        fromDaysOrNil = nil;
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init] ;
    dateFormat.dateStyle = NSDateFormatterShortStyle;
    dateFormat.timeStyle = NSDateFormatterNoStyle;
    NSDate* today = [dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]];
    
    
    NSDate *earlierDate = [NSDate dateWithTimeInterval:-(60 * 60 * 24 * (fromDaysOrNil == nil?[self readDateRangeFromPlist]:[fromDaysOrNil intValue])) sinceDate:today];
    
    //Delete old data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool
        {
            //Setting condition
            RLMResults <SLogRealm *> *sLogsToDelete = [SLogRealm objectsWhere:@"lIssueDate < %@", earlierDate];
            if(sLogsToDelete.count)
            {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteObjects:sLogsToDelete];
                [realm commitWriteTransaction];
            }
        }
    });
}

//To Fetch all the logs from db
- (NSString *)fetchLogs{
    NSMutableString *logString = [[NSMutableString alloc] init];
    
    //Get device info
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    //Get App Appversion
    NSString * appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    //Get build build
    NSString *buildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    //Get device's UUID
    NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];
    
    if(deviceToken && deviceToken.length > 0)
    {
        [logString appendString:[NSString stringWithFormat:@"Issue raised by %@/%@, \nversion:%@, \nbuild:%@,\nDevice UUID:%@, \ndevice Token:%@ \n \n", [self deviceName], systemVersion, appVersion, buildString, identifier, deviceToken]];
    }
    else
    {
        [logString appendString:[NSString stringWithFormat:@"Issue raised by %@/%@, \nversion:%@, \nbuild:%@,\nDevice UUID:%@ \n \n", [self deviceName], systemVersion, appVersion, buildString, identifier]];
    }
    
    // Fetch logs
    @autoreleasepool
    {
        SLogCollectionRealm *sLogCollection = [SLogCollectionRealm objectForPrimaryKey:[SLogCollectionRealm className]];
        
        if(sLogCollection)
        {
            for (SLogRealm *sLogRealm in sLogCollection.sLogs)
            {
                SLog *sLog = [[SLog alloc] initWithRealmModel:sLogRealm];
                [logString appendString:[NSString stringWithFormat:@"%@- %@: %@- %@%@", sLog.lIssueDate,sLog.lType, sLog.lTitle, sLog.lDescription, @"\n"]];
            }
            
            return logString;
        }
        
        return logString;
    }
}

//To send logs via email
- (void)sendEmailLogsWithRecipients:(NSArray *)recipients
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = (id)self;
        [mailViewController setSubject:[NSString stringWithFormat:@"Support Issue (%@)", bundleName]];
        [mailViewController setToRecipients:recipients];
        [mailViewController setMessageBody:@"" isHTML:NO];
        
        NSString *fetchLogString = [self fetchLogs];
        NSData *textFileContentsData = [fetchLogString dataUsingEncoding:NSUTF8StringEncoding];
        
        [mailViewController addAttachmentData:textFileContentsData mimeType:@"binary" fileName:[NSString stringWithFormat:@"support-issue-%@-%%d.txt.gz", bundleName]];
        
        [self presentModalVC:mailViewController];
    });
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissModalVC];
        
        if (error != nil) {
            NSLog(@"Log report sending email fail with error= %@", error);
            return;
        }
        
        if(result == MFMailComposeResultSent)
        {
            NSLog(@"Log report sent successfully.");
        }
    });
}

- (void) presentModalVC:(UIViewController*) vc
{
    self.dummyVC = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    self.dummyVC.view = [[UIView alloc] init];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.dummyVC.view];
    
    if([self.dummyVC respondsToSelector:@selector(presentViewController:animated:completion:)])
    {
        [self.dummyVC presentViewController:vc animated:YES completion:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.dummyVC presentModalViewController:vc animated:YES];
#pragma clang diagnostic pop
    }
}

- (void) dismissModalVC
{
    if([self.dummyVC respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self.dummyVC dismissViewControllerAnimated:YES completion:^
         {
             [self.dummyVC.view removeFromSuperview];
             self.dummyVC = nil;
         }];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.dummyVC dismissModalViewControllerAnimated:NO];
#pragma clang diagnostic pop
        [self.dummyVC.view removeFromSuperview];
        self.dummyVC = nil;
    }
}

//Save debug logs
- (void)debug:(NSString*)title withDescription:(NSString*)description{
    dispatch_async(queue_, ^{
        [self saveLogWithTitle:title description:description logType:kDebug logDate:[NSDate date]];
    });
}

//Save error logs
- (void)error:(NSString*)title withDescription:(NSString*)description{
    dispatch_async(queue_, ^{
        [self saveLogWithTitle:title description:description logType:kError logDate:[NSDate date]];
    });
}

//Save info logs
- (void)info:(NSString*)title withDescription:(NSString*)description{
    dispatch_async(queue_, ^{
        [self saveLogWithTitle:title description:description logType:kInformation logDate:[NSDate date]];
    });
}

//Save other logs
- (void)other:(NSString*)title withDescription:(NSString*)description{
    dispatch_async(queue_, ^{
        [self saveLogWithTitle:title description:description logType:kOther logDate:[NSDate date]];
    });
}

//Save warnings logs
- (void)warn:(NSString*)title withDescription:(NSString*)description{
    dispatch_async(queue_, ^{
        [self saveLogWithTitle:title description:description logType:kWarning logDate:[NSDate date]];
    });
}

//Save logs without Queue
- (void)unCaughtExceptionWithDescription:(NSString*)description{
    [self saveLogWithTitle:@"Crashed!" description:description logType:kCrash logDate:[NSDate date]];
}

#pragma mark - Private methods

//Get device info
- (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSString *) deviceName{
    NSString *platform = [self platform];
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"3rd Generation iPad (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"3rd Generation iPad (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"3rd Generation iPad (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"4th Generation iPad (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"4th Generation iPad (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"4th Generation iPad (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"5th Generation iPad (iPad Air) - Wifi";
    if ([platform isEqualToString:@"iPad4,2"])      return @"5th Generation iPad (iPad Air) - Cellular";
    if ([platform isEqualToString:@"iPad4,4"])      return @"2nd Generation iPad Mini - Wifi";
    if ([platform isEqualToString:@"iPad4,5"])      return @"2nd Generation iPad Mini - Cellular";
    if ([platform isEqualToString:@"iPad4,7"])      return @"3rd Generation iPad Mini - Wifi (model A1599)";
    if ([platform isEqualToString:@"iPad4,7"])      return @"3rd Generation iPad Mini (model A1599)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"3rd Generation iPad Mini (model A1600)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"3rd Generation iPad Mini (model A1601)";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA/Verizon/Sprint)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (model A1456, A1532 | GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (model A1433, A1533 | GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (model A1660, A1779, A1780)";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (model A1778)";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (model A1661, A1785, A1786)";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (model A1784)";
    
    if ([platform isEqualToString:@"i386"])
        return @"Simulator 32 bit";
    if ([platform isEqualToString:@"x86_64"])
        return @"Simulator 64 bit";
    
    return platform;
}

- (void)refresh {
    dispatch_async(queue_, ^{
        [self refreshLogs:nil];
    });
    
}

- (void)startMobiLogger{
    [SUtil initializeRealm];
    [self refresh];
}

//To save logs in db with all required info
- (void)saveLogWithTitle:(NSString *)title description:(NSString *)description logType:(NSString *)logType logDate:(NSDate *)logDate
{
    SLog *sLogModel = [[SLog alloc] initWithTitle:title description:description date:logDate type:logType];
    
    @autoreleasepool
    {
        RLMRealm *realm = [RLMRealm defaultRealm];
        SLogCollectionRealm *sLogCollection = [SLogCollectionRealm objectForPrimaryKey:[SLogCollectionRealm className]];
        
        if(sLogCollection)
        {
            [realm beginWriteTransaction];
            
            [sLogCollection insertSLog:[[SLogRealm alloc] initWithSLogModel:sLogModel]];
            
            [realm commitWriteTransaction];
        }
    }
}

- (int)readDateRangeFromPlist
{
    NSString *bundlePathofPlist = [[NSBundle mainBundle]pathForResource:@"Lib" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePathofPlist];
    NSNumber *dateRange = [dict valueForKey:@"dateRange"];
    return [dateRange intValue];
}

// =================================================================
// =================================================================
// =================================================================

#pragma mark - Extended log -

id object;
id detailDescriptionMessage;

void convertintoC(id self)
{
    object = self;
}

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...)
{
    // Type to hold information about variable arguments.
    va_list ap;
    
    // Initialize a variable argument list.
    va_start (ap, format);
    
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }
    //    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    // End using variable argument list.
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    NSString *detailedMessage = [NSString stringWithFormat:@"\n %s Function Name ->(%s) Controller ->(%s:%d) ", getTime(),functionName, [fileName UTF8String],lineNumber];
    detailDescriptionMessage = detailedMessage;
    fprintf(stderr, "%s (%s) (%s:%d) %s", getTime(),
            functionName, [fileName UTF8String],
            lineNumber, [format UTF8String]);
}

char * getTime()
{
    time_t rawtime;
    struct tm * timeinfo;
    char buffer[80];
    
    time (&rawtime);
    timeinfo = localtime (&rawtime);
    
    // see format strings above - YYYY-MM-DD HH:MM:SS
    strftime(buffer, sizeof(buffer), "%F %T", timeinfo);
    
    char *time;
    time=(char *)malloc(64);
    strcpy(time, buffer);
    
    return time;
}

void ExtendNSLogError(const char *file, int lineNumber, const char *functionName, NSString *message, ...)
{
    ExtendNSLog(file, lineNumber, functionName, message);
    [object error:message withDescription:detailDescriptionMessage];
}

void ExtendNSLogWarning(const char *file, int lineNumber, const char *functionName, NSString *message, ...)
{
    ExtendNSLog(file, lineNumber, functionName, message);
    [object warn:message withDescription:detailDescriptionMessage];
}

void ExtendNSLogInfo(const char *file, int lineNumber, const char *functionName, NSString *message, ...)
{
    ExtendNSLog(file, lineNumber, functionName, message);
    [object info:message withDescription:detailDescriptionMessage];
}

#pragma mark - KSCrash

- (KSCrashInstallation *)installKSCrashConsoleWithCompletionBlock:(smobiCompletionBlock)block
{
    return [self installKSCrashConsoleWithAlert:NO withCompletionBlock:block];
}

- (KSCrashInstallation *)installKSCrashWithURLString:(NSString *)urlPath withCompletionBlock:(smobiCompletionBlock)block
{
    return [self installKSCrashWithURLString:urlPath withAlert:NO withCompletionBlock:block];
}

- (KSCrashInstallation *)installKSCrashWithEmails:(NSArray *)emails withCompletionBlock:(smobiCompletionBlock)block
{
    return [self installKSCrashWithEmails:emails withAlert:YES withCompletionBlock:block];
}

- (KSCrashInstallation *)installKSCrashConsoleWithAlert:(BOOL)showAlert withCompletionBlock:(smobiCompletionBlock)block
{
    KSCrashInstallationConsole* installation = [KSCrashInstallationConsole sharedInstance];
    return [self installKSCrashWithInstallation:installation withAlert:showAlert withCompletionBlock:block];
}

- (KSCrashInstallation *)installKSCrashWithURLString:(NSString *)urlPath withAlert:(BOOL)showAlert withCompletionBlock:(smobiCompletionBlock)block
{
    KSCrashInstallationStandard* installation = [KSCrashInstallationStandard sharedInstance];
    installation.url = [NSURL URLWithString:urlPath];
    return [self installKSCrashWithInstallation:installation withAlert:showAlert withCompletionBlock:block];
}

- (KSCrashInstallation *)installKSCrashWithEmails:(NSArray *)emails withAlert:(BOOL)showAlert withCompletionBlock:(smobiCompletionBlock)block
{
    KSCrashInstallationEmail* installation = [KSCrashInstallationEmail sharedInstance];
    installation.recipients = emails;
    
    // Optional (Email): Send Apple-style reports instead of JSON
    [installation setReportStyle:KSCrashEmailReportStyleApple useDefaultFilenameFormat:YES];
    return [self installKSCrashWithInstallation:installation withAlert:showAlert withCompletionBlock:block];
}

- (KSCrashInstallation *)installKSCrashWithInstallation:(KSCrashInstallation *)installation withAlert:(BOOL)showAlert withCompletionBlock:(smobiCompletionBlock)block
{
    if(showAlert)
    {
        // Optional: Add an alert confirmation (recommended for email installation)
        [installation addConditionalAlertWithTitle:@"Crash Detected"
                                           message:@"The app crashed last time it was launched. Send a crash report?"
                                         yesAnswer:@"Sure!"
                                          noAnswer:@"No thanks"];
    }
    
    [installation install];
    
    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        if(filteredReports.count)
        {
            [self unCaughtExceptionWithDescription:[NSString stringWithFormat:@"Reports:%@/n Error:%@", filteredReports, error]];
            block(completed, filteredReports);
        }
    }];
    
    return installation;
}

@end
