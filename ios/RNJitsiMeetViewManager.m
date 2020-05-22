#import "RNJitsiMeetViewManager.h"
#import "RNJitsiMeetView.h"
#import <JitsiMeet/JitsiMeetUserInfo.h>

@implementation RNJitsiMeetViewManager{
    RNJitsiMeetView *jitsiMeetView;
}

RCT_EXPORT_MODULE(RNJitsiMeetView)
RCT_EXPORT_VIEW_PROPERTY(onConferenceJoined, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onConferenceTerminated, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onConferenceWillJoin, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEnteredPip, RCTBubblingEventBlock)

- (UIView *)view
{
  jitsiMeetView = [[RNJitsiMeetView alloc] init];
  jitsiMeetView.delegate = self;
  return jitsiMeetView;
}

RCT_EXPORT_METHOD(initialize)
{
    RCTLogInfo(@"Initialize is deprecated in v2");
}

RCT_EXPORT_METHOD(call:(NSString *)urlString userInfo:(NSDictionary *)userInfo)
{
    RCTLogInfo(@"Load URL %@", urlString);
    JitsiMeetUserInfo * _userInfo = [[JitsiMeetUserInfo alloc] init];
    if (userInfo != NULL) {
      if (userInfo[@"displayName"] != NULL) {
        _userInfo.displayName = userInfo[@"displayName"];
      }
      if (userInfo[@"email"] != NULL) {
        _userInfo.email = userInfo[@"email"];
      }
      if (userInfo[@"avatar"] != NULL) {
        NSURL *url = [NSURL URLWithString:[userInfo[@"avatar"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        _userInfo.avatar = url;
      }
    
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        JitsiMeetConferenceOptions *options = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {        
            builder.room = urlString;
            builder.userInfo = _userInfo;
            if (userInfo != NULL) {
                if (userInfo[@"audioOnly"] != NULL) {
                    builder.audioOnly = userInfo[@"audioOnly"];
                }
                if (userInfo[@"audioMuted"] != NULL) {
                    builder.audioMuted = userInfo[@"audioMuted"];
                    RCTLogInfo(@"Audio Muted By parameter");
                }
                if (userInfo[@"videoMuted"] != NULL) {
                    builder.videoMuted = userInfo[@"videoMuted"];
                }
                if (userInfo[@"welcomePage"] != NULL) {
                    builder.welcomePageEnabled = YES;
                }
                
                if (userInfo[@"addPeople"] != NULL) {
                    [builder setFeatureFlag:@"add-people.enabled" withBoolean:userInfo[@"addPeople"] ];
                }
                if (userInfo[@"calendar"] != NULL) {
                    [builder setFeatureFlag:@"calendar.enabled" withBoolean:userInfo[@"calendar"] ];
                }
                if (userInfo[@"callIntegration"] != NULL) {
                    [builder setFeatureFlag:@"call-integration.enabled" withBoolean:userInfo[@"callIntegration"] ];
                }
                if (userInfo[@"closeCaptions"] != NULL) {
                    [builder setFeatureFlag:@"close-captions.enabled" withBoolean:userInfo[@"closeCaptions"] ];
                }
                if (userInfo[@"chat"] != NULL) {
                    RCTLogInfo(@"Chat flag received");
                    [builder setFeatureFlag:@"chat.enabled" withBoolean:userInfo[@"chat"] ];
                }
                if (userInfo[@"invite"] != NULL) {
                    [builder setFeatureFlag:@"invite.enabled" withBoolean:userInfo[@"invite"] ];
                }
                if (userInfo[@"liveStreaming"] != NULL) {
                    [builder setFeatureFlag:@"live-streaming" withBoolean:userInfo[@"liveStreaming"] ];
                }
                if (userInfo[@"meetingName"] != NULL) {
                    [builder setFeatureFlag:@"meeting-name.enabled" withBoolean:userInfo[@"meetingName"] ];
                }
                if (userInfo[@"meetingPassword"] != NULL) {
                    [builder setFeatureFlag:@"meeting-password.enabled" withBoolean:userInfo[@"meetingPassword"] ];
                }
                if (userInfo[@"pip"] != NULL) {
                    [builder setFeatureFlag:@"pip.enabled" withBoolean:userInfo[@"pip"] ];
                }
                if (userInfo[@"raiseHand"] != NULL) {
                    [builder setFeatureFlag:@"raise-hand.enabled" withBoolean:userInfo[@"raiseHand"] ];
                }
                if (userInfo[@"recording"] != NULL) {
                    [builder setFeatureFlag:@"recording.enabled" withBoolean:userInfo[@"recording"] ];
                }
                if (userInfo[@"tileView"] != NULL) {
                    [builder setFeatureFlag:@"tile-view.enabled" withBoolean:userInfo[@"tileView"] ];
                }
                if (userInfo[@"toolboxAwaysVisible"] != NULL) {
                    [builder setFeatureFlag:@"toolbox.alwaysVisible" withBoolean:userInfo[@"toolboxAwaysVisible"] ];
                }
                
            }
        }];
        [jitsiMeetView join:options];
    });
}

RCT_EXPORT_METHOD(audioCall:(NSString *)urlString userInfo:(NSDictionary *)userInfo)
{
    RCTLogInfo(@"Load Audio only URL %@", urlString);
    JitsiMeetUserInfo * _userInfo = [[JitsiMeetUserInfo alloc] init];
    if (userInfo != NULL) {
      if (userInfo[@"displayName"] != NULL) {
        _userInfo.displayName = userInfo[@"displayName"];
      }
      if (userInfo[@"email"] != NULL) {
        _userInfo.email = userInfo[@"email"];
      }
      if (userInfo[@"avatar"] != NULL) {
        NSURL *url = [NSURL URLWithString:[userInfo[@"avatar"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        _userInfo.avatar = url;
      }
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        JitsiMeetConferenceOptions *options = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {        
            builder.room = urlString;
            builder.userInfo = _userInfo;
            builder.audioOnly = YES;
        }];
        [jitsiMeetView join:options];
    });
}

RCT_EXPORT_METHOD(endCall)
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [jitsiMeetView leave];
    });
}

#pragma mark JitsiMeetViewDelegate

- (void)conferenceJoined:(NSDictionary *)data {
    RCTLogInfo(@"Conference joined");
    if (!jitsiMeetView.onConferenceJoined) {
        return;
    }

    jitsiMeetView.onConferenceJoined(data);
}

- (void)conferenceTerminated:(NSDictionary *)data {
    RCTLogInfo(@"Conference terminated");
    if (!jitsiMeetView.onConferenceTerminated) {
        return;
    }

    jitsiMeetView.onConferenceTerminated(data);
}

- (void)conferenceWillJoin:(NSDictionary *)data {
    RCTLogInfo(@"Conference will join");
    if (!jitsiMeetView.onConferenceWillJoin) {
        return;
    }

    jitsiMeetView.onConferenceWillJoin(data);
}

- (void)enterPictureInPicture:(NSDictionary *)data {
    RCTLogInfo(@"Enter Picture in Picture");
    if (!jitsiMeetView.onEnteredPip) {
        return;
    }

    jitsiMeetView.onEnteredPip(data);
}

@end
