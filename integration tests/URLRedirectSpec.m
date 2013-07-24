/*
 * Copyright 2012-2013 StackMob
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Kiwi/Kiwi.h>
#import "SMIntegrationTestHelpers.h"

SPEC_BEGIN(URLRedirectSpec)

describe(@"URLRedirect datastore api", ^{
    __block SMClient *client = nil;
    beforeEach(^{
        NSURL *credentialsURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"StackMobCredentials" withExtension:@"plist"];
        NSDictionary *credentials = [NSDictionary dictionaryWithContentsOfURL:credentialsURL];
        NSString *publicKey = [credentials objectForKey:@"PublicKeyClusterRedirect"];
        client = [[SMClient alloc] initWithAPIVersion:@"0" apiHost:@"api.stackmob.com" publicKey:publicKey userSchema:@"user" userPrimaryKeyField:@"username" userPasswordField:@"password"];
    });
    afterEach(^{
        
    });
    it(@"redicrects successfully on read", ^{
        dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
        dispatch_group_t group = dispatch_group_create();
        
        //NSDictionary *todo = [NSDictionary dictionaryWithObjectsAndKeys:@"todo", @"title", @"1234", @"todo_id", nil];
        SMQuery *todo = [[SMQuery alloc] initWithSchema:@"todo"];
        dispatch_group_enter(group);
        [[[SMClient defaultClient] dataStore] performQuery:todo options:[SMRequestOptions options] successCallbackQueue:queue failureCallbackQueue:queue onSuccess:^(NSArray *results) {
            dispatch_group_leave(group);
        } onFailure:^(NSError *error) {
            dispatch_group_leave(group);
        }];
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    });
});

SPEC_END