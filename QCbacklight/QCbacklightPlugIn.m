//
//  QCbacklightPlugIn.m
//  QCbacklight
//
//  Created by Geordie Millar on 19/03/08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>

#include <mach/mach.h>
#include <IOKit/IOKitLib.h>
#include <CoreFoundation/CoreFoundation.h>


#import "QCbacklightPlugIn.h"

#define	kQCPlugIn_Name				@"Keyboard Backlight"
#define	kQCPlugIn_Description		@"A plugin to control the backlit keyboard brightness on the MacBookPro. Expects a number between 0 (off) and 1 (full). Written by gm@stackunderflow.com"

@implementation QCbacklightPlugIn
/*
Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
*/

@dynamic inputValue;

+ (NSDictionary*) attributes
{
	/*
	Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
	*/
	
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	/*
	Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).
	*/
			return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Keyboard Brightness", QCPortAttributeNameKey,
            [NSNumber numberWithFloat:0.0f],  QCPortAttributeDefaultValueKey,
            nil];
}

+ (QCPlugInExecutionMode) executionMode
{
	/*
	Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	*/
	
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode) timeMode
{
	/*
	Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	*/
	
	return kQCPlugInTimeModeNone;
}

- (id) init
{
	if(self = [super init]) {
		/*
		Allocate any permanent resource required by the plug-in.
		*/
	}
	
	return self;
}

- (void) finalize
{
	/*
	Release any non garbage collected resources created in -init.
	*/
	
	[super finalize];
}

- (void) dealloc
{
	/*
	Release any resources created in -init.
	*/
	
	[super dealloc];
}

@end

@implementation QCbacklightPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	Return NO in case of fatal failure (this will prevent rendering of the composition to start).
	*/
	
	io_service_t      serviceObject;

	  serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleLMUController"));
	  if (!serviceObject) {
		NSLog(@"failed to find ambient light sensor\n");
		return NO;
	  }

	  // Create a connection to the IOService object
	  kr = IOServiceOpen(serviceObject, mach_task_self(), 0, &dataPort);
	  IOObjectRelease(serviceObject);
	  if (kr != KERN_SUCCESS) {
		NSLog(@"IOServiceOpen: %i", kr);
		return NO;
		}
		
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
	*/
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	/*
	Called by Quartz Composer whenever the plug-in instance needs to execute.
	Only read from the plug-in inputs and produce a result (by writing to the plug-in outputs or rendering to the destination OpenGL context) within that method and nowhere else.
	Return NO in case of failure during the execution (this will prevent rendering of the current frame to complete).
	
	The OpenGL context for rendering can be accessed and defined for CGL macros using:
	CGLContextObj cgl_ctx = [context CGLContextObj];
	*/
	
	in_brightness = (int)(self.inputValue * 4095.0f);
	
	if (in_brightness > 4095) {
		in_brightness = 4095;
	}
	
	kr = IOConnectMethodScalarIScalarO(dataPort, 2, 2, 1, 0, in_brightness, &out_brightness);	
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
	*/
	
	kr = IOConnectMethodScalarIScalarO(dataPort, 2, 2, 1, 0, 0, &out_brightness);
}

- (void) stopExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
	*/
	
	kr = IOConnectMethodScalarIScalarO(dataPort, 2, 2, 1, 0, 0, &out_brightness);
}

@end
