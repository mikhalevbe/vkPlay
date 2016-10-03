//
//  VKRequestsScheduleCategory.m
//  vkPlay
//
//  Created by Admin on 09.06.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import "VKRequestsScheduleCategory.h"

@implementation VKRequestsScheduler (cat)

- (dispatch_queue_t) queue {
    return _schedulerQueue;
}

@end
