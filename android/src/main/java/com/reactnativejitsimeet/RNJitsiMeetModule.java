package com.reactnativejitsimeet;

import android.util.Log;
import java.net.URL;
import java.net.MalformedURLException;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.ReadableMap;

@ReactModule(name = RNJitsiMeetModule.MODULE_NAME)
public class RNJitsiMeetModule extends ReactContextBaseJavaModule {
    public static final String MODULE_NAME = "RNJitsiMeetModule";
    private IRNJitsiMeetViewReference mJitsiMeetViewReference;

    public RNJitsiMeetModule(ReactApplicationContext reactContext, IRNJitsiMeetViewReference jitsiMeetViewReference) {
        super(reactContext);
        mJitsiMeetViewReference = jitsiMeetViewReference;
    }

    @Override
    public String getName() {
        return MODULE_NAME;
    }

    @ReactMethod
    public void initialize() {
        Log.d("JitsiMeet", "Initialize is deprecated in v2");
    }

    @ReactMethod
    public void call(String url, ReadableMap userInfo) {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mJitsiMeetViewReference.getJitsiMeetView() != null) {
                    RNJitsiMeetUserInfo _userInfo = new RNJitsiMeetUserInfo();
                    if (userInfo != null) {
                        if (userInfo.hasKey("displayName")) {
                            _userInfo.setDisplayName(userInfo.getString("displayName"));
                          }
                          if (userInfo.hasKey("email")) {
                            _userInfo.setEmail(userInfo.getString("email"));
                          }
                          if (userInfo.hasKey("avatar")) {
                            String avatarURL = userInfo.getString("avatar");
                            try {
                                _userInfo.setAvatar(new URL(avatarURL));
                            } catch (MalformedURLException e) {
                            }
                          }
                    }

                    RNJitsiMeetConferenceOptions.Builder builder = new RNJitsiMeetConferenceOptions.Builder();
                    builder.setRoom(url)
                            .setUserInfo(_userInfo);

                    if (userInfo.hasKey("audioOnly")) {
                        builder.setAudioOnly(userInfo.getBoolean("audioOnly"));
                    }
                    if (userInfo.hasKey("audioMuted")) {
                        builder.setAudioMuted(userInfo.getBoolean("audioMuted"));
                    }
                    if (userInfo.hasKey("colorScheme")) {
                        //builder.setColorScheme(userInfo.getArray("audioMuted"));
                    }
                    if (userInfo.hasKey("videoMuted")) {
                        builder.setVideoMuted(userInfo.getBoolean("videoMuted"));
                    }
                    if (userInfo.hasKey("welcomePageEnabled")) {
                        builder.setWelcomePageEnabled(userInfo.getBoolean("welcomePageEnabled"));
                    }
                    if (userInfo.hasKey("addPeople")) {
                        builder.setFeatureFlag("add-people.enabled",userInfo.getBoolean("addPeople"));
                    }
                    if (userInfo.hasKey("calendar")) {
                        builder.setFeatureFlag("calendar.enabled",userInfo.getBoolean("addPeople"));
                    }
                    if (userInfo.hasKey("callIntegration")) {
                        builder.setFeatureFlag("call-integration.enabled",userInfo.getBoolean("callIntegration"));
                    }
                    if (userInfo.hasKey("closeCaptions")) {
                        builder.setFeatureFlag("close-captions.enabled",userInfo.getBoolean("closeCaptions"));
                    }
                    if (userInfo.hasKey("chat")) {
                        builder.setFeatureFlag("chat.enabled",userInfo.getBoolean("chat"));
                    }
                    if (userInfo.hasKey("invite")) {
                        builder.setFeatureFlag("invite.enabled'",userInfo.getBoolean("invite"));
                    }
                    if (userInfo.hasKey("liveStreaming")) {
                        builder.setFeatureFlag("live-streaming",userInfo.getBoolean("liveStreaming"));
                    }
                    if (userInfo.hasKey("meetingName")) {
                        builder.setFeatureFlag("meeting-name.enabled",userInfo.getBoolean("meetingName"));
                    }
                    if (userInfo.hasKey("meetingPassword")) {
                        builder.setFeatureFlag("meeting-password.enabled",userInfo.getBoolean("meetingPassword"));
                    }
                    if (userInfo.hasKey("pip")) {
                        builder.setFeatureFlag("pip.enabled",userInfo.getBoolean("pip"));
                    }
                    if (userInfo.hasKey("raiseHand")) {
                        builder.setFeatureFlag("raise-hand.enabled",userInfo.getBoolean("raiseHand"));
                    }
                    if (userInfo.hasKey("recording")) {
                        builder.setFeatureFlag("recording.enabled",userInfo.getBoolean("recording"));
                    }
                    if (userInfo.hasKey("tileView")) {
                        builder.setFeatureFlag("tile-view.enabled'",userInfo.getBoolean("tileView"));
                    }
                    if (userInfo.hasKey("toolboxAwaysVisible")) {
                        builder.setFeatureFlag("toolbox.alwaysVisible",userInfo.getBoolean("toolboxAwaysVisible"));
                    }
                    

                    RNJitsiMeetConferenceOptions options =
                            builder
                            .build();
                    mJitsiMeetViewReference.getJitsiMeetView().join(options);
                }
            }
        });
    }

    @ReactMethod
    public void audioCall(String url, ReadableMap userInfo) {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mJitsiMeetViewReference.getJitsiMeetView() != null) {
                    RNJitsiMeetUserInfo _userInfo = new RNJitsiMeetUserInfo();
                    if (userInfo != null) {
                        if (userInfo.hasKey("displayName")) {
                            _userInfo.setDisplayName(userInfo.getString("displayName"));
                          }
                          if (userInfo.hasKey("email")) {
                            _userInfo.setEmail(userInfo.getString("email"));
                          }
                          if (userInfo.hasKey("avatar")) {
                            String avatarURL = userInfo.getString("avatar");
                            try {
                                _userInfo.setAvatar(new URL(avatarURL));
                            } catch (MalformedURLException e) {
                            }
                          }
                    }
                    RNJitsiMeetConferenceOptions options = new RNJitsiMeetConferenceOptions.Builder()
                            .setRoom(url)
                            .setAudioOnly(true)
                            .setUserInfo(_userInfo)
                            .build();
                    mJitsiMeetViewReference.getJitsiMeetView().join(options);
                }
            }
        });
    }

    @ReactMethod
    public void endCall() {
        UiThreadUtil.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mJitsiMeetViewReference.getJitsiMeetView() != null) {
                    mJitsiMeetViewReference.getJitsiMeetView().leave();
                }
            }
        });
    }
}
