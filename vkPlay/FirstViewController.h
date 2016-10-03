//
//  FirstViewController.h
//  vkPlay
//
//  Created by Admin on 07.03.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
//#import "playlistViewController.h"

@interface FirstViewController : UIViewController <VKSdkDelegate, VKSdkUIDelegate>
{
    NSArray *SCOPE;
}


@end

