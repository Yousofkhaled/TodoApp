//
//  task.m
//  ios_workshop
//
//  Created by Admin on 30/08/2023.
//

#import "task.h"

@implementation task
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeObject:_priority forKey:@"priority"];
    [coder encodeObject:_state forKey:@"state"];
    [coder encodeObject:_date forKey:@"date"];
}

- (id) initWithCoder:(NSCoder *)coder {
    if ((self = [super init])) {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _desc = [coder decodeObjectOfClass:[NSString class] forKey:@"desc"];
        _priority = [coder decodeObjectOfClass:[NSString class] forKey:@"priority"];
        _state = [coder decodeObjectOfClass:[NSString class] forKey:@"state"];
        _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    }
    return self;
}

- (void) print_task {
    NSLog(@"%@", _name);
   NSLog(@"%@", _desc);
   NSLog(@"%@", _priority);
   NSLog(@"%@", _state);
   NSLog(@"%@", _date);

}

+ (BOOL)supportsSecureCoding {
    return TRUE;
}

@end
