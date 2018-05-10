//
//  AppDelegate.m
//  TutorialMacOsBatteryMonitorApp
//
//  Created by Nick Saxelby on 10/05/2018.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(PollPercentage)
                                   userInfo:nil
                                    repeats:YES];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)PollPercentage
{
    // Obtain blob data
    CFTypeRef powerSourceInfo = IOPSCopyPowerSourcesInfo();
    CFArrayRef powerSources = IOPSCopyPowerSourcesList(powerSourceInfo);
    
    CFDictionaryRef powerSource = NULL;

    
    long numberOfSources = CFArrayGetCount(powerSources);
    if(numberOfSources == 0)
    {
        NSLog(@"Problem, no power sources detected");
    }
    else
    {
        if(numberOfSources == 1)
        {
            NSLog(@"One power source detected");
            powerSource = IOPSGetPowerSourceDescription(powerSourceInfo, CFArrayGetValueAtIndex(powerSources, 0));
        }
        else
        {
            NSLog(@"More than one power source detected, using first one available");
            powerSource = IOPSGetPowerSourceDescription(powerSourceInfo, CFArrayGetValueAtIndex(powerSources, 0));
        }
        
        const void *psValue;
        int curCapacity = 0;
        int maxCapacity = 0;
        int percentage;
        
        // Work out percentage based on capacity current/max
        psValue = CFDictionaryGetValue(powerSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        
        psValue = CFDictionaryGetValue(powerSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        percentage = (int)((double)curCapacity/(double)maxCapacity * 100);
        NSLog(@"Perentage of battery: %i", percentage);
        
        // TODO do whatever you want here code-wise with the percentage
    }
}


@end
