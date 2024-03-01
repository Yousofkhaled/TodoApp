//
//  task.h
//  ios_workshop
//
//  Created by Admin on 30/08/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface task : NSObject<NSCoding, NSSecureCoding>

@property NSString * name;
@property NSString * desc;
@property NSString * priority;
@property NSString * state;
@property NSDate * date;

- (void) encodeWithCoder:(NSCoder *)coder;
- (void) print_task;

@end

NS_ASSUME_NONNULL_END
