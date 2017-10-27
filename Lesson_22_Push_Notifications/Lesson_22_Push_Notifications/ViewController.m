//
//  ViewController.m
//  Lesson_22_Push_Notifications
//
//  Created by Andrey Proskurin on 27.10.17.
//  Copyright © 2017 Andrey Proskurin. All rights reserved.
//

#import "ViewController.h"

static NSString *const kRepeatLocalNotificationIdentifier = @"Local notification";

@interface ViewController () <UNUserNotificationCenterDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController

- (IBAction)sendNotificationButton:(UIButton *)sender {
    [self sendLocalNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendLocalNotification];
    
}

- (void)sendLocalNotification {
    //-----------------------------
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    localNotification.title = [NSString localizedUserNotificationStringForKey:kRepeatLocalNotificationIdentifier arguments:nil];
    localNotification.body = [NSString localizedUserNotificationStringForKey:@"Some text wich user can see..." arguments:nil];
    localNotification.sound = [UNNotificationSound defaultSound];
    //-----------------------------
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10.0f repeats:NO];
    //-----------------------------
    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1); // бейдж на иконке
    //-----------------------------
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:kRepeatLocalNotificationIdentifier 
                                                                          content:localNotification trigger:trigger];
    //-----------------------------------
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    //----------------------------------
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Notification created");
    }];
    
}

#pragma mark - delegate

- (void)actionWithLocalNotification:(UNNotification *)localNotification {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localNotification.request.content.title message:localNotification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok");
    }];
    [alertController addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:^{
        }];
    });
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSString *message = @"This app just sent you a notification, do you want to see it?";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification alert"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"IGNORE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ignore");
    }];
    UIAlertAction *see = [UIAlertAction actionWithTitle:@"SEE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionWithLocalNotification:notification];
    }];
    
    [alertController addAction:ignore];
    [alertController addAction:see];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [self actionWithLocalNotification:response.notification];
}

@end
