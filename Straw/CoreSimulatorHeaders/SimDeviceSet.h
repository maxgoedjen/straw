/* Generated by RuntimeBrowser
   Image: /Library/Developer/PrivateFrameworks/CoreSimulator.framework/Versions/A/CoreSimulator
 */
/* And then heavily stripped and annotated by me 🌈
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SimDevice;

@interface SimDeviceSet : NSObject

@property (nonatomic, readonly) NSArray <SimDevice *>*devices;

- (unsigned long long)registerNotificationHandler:(id)arg1;
- (BOOL)subscribeToNotificationsWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
