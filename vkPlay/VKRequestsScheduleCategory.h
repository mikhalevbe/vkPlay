//
//  VKRequestsScheduleCategory.h
//  vkPlay
//
//  Created by Admin on 09.06.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequestsScheduler.h"

@interface VKRequestsScheduler (cat)

@property (readonly) dispatch_queue_t queue;

@end
