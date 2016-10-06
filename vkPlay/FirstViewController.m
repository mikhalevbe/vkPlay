//
//  loginViewController.m
//  vkPlay
//
//  Created by Admin on 07.03.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

- (void)viewDidLoad {
    if (self.navigationController) {
        UIImage *image = [UIImage imageNamed:@"vkplay30x30.png"];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    }
    
    SCOPE = @[VK_PER_AUDIO];
    [[VKSdk initializeWithAppId:@"5254588"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (state == VKAuthorizationInitialized) {
            [VKSdk authorize:SCOPE];
        } else if (state == VKAuthorizationError) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self startWorking];
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)startWorking {
    [self performSegueWithIdentifier:@"toPlayList" sender:self];
}

- (IBAction)authorize:(id)sender {
    [VKSdk authorize:SCOPE];
}

- (IBAction)logout:(UIButton *)sender {
    [VKSdk forceLogout];
}


- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [VKSdk authorize:SCOPE];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self presentViewController:controller animated:YES completion:nil];
}



@end
