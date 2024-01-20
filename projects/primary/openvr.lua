local ffi = require("ffi")

local openvr = ffi.load(ffi.os == "Windows" and "C:/Users/Volantarius/Documents/LOVE/openvr_api.dll")

ffi.cdef[[
typedef uint64_t PropertyContainerHandle_t;
typedef uint32_t PropertyTypeTag_t;
typedef uint64_t VRActionHandle_t;
typedef uint64_t VRActionSetHandle_t;
typedef uint64_t VRInputValueHandle_t;
typedef uint64_t PathHandle_t;


// OpenVR Constants

// NO STATIC and probably the other definitions are not C

/*
const unsigned long k_nDriverNone = 4294967295;
const unsigned long k_unMaxDriverDebugResponseSize = 32768;
const unsigned long k_unTrackedDeviceIndex_Hmd = 0;
const unsigned long k_unMaxTrackedDeviceCount = 64;
const unsigned long k_unTrackedDeviceIndexOther = 4294967294;
const unsigned long k_unTrackedDeviceIndexInvalid = 4294967295;
const unsigned long long k_ulInvalidPropertyContainer = 0;
const unsigned long k_unInvalidPropertyTag = 0;
const unsigned long long k_ulInvalidDriverHandle = 0;
const unsigned long k_unFloatPropertyTag = 1;
const unsigned long k_unInt32PropertyTag = 2;
const unsigned long k_unUint64PropertyTag = 3;
const unsigned long k_unBoolPropertyTag = 4;
const unsigned long k_unStringPropertyTag = 5;
const unsigned long k_unErrorPropertyTag = 6;
const unsigned long k_unDoublePropertyTag = 7;
const unsigned long k_unHmdMatrix34PropertyTag = 20;
const unsigned long k_unHmdMatrix44PropertyTag = 21;
const unsigned long k_unHmdVector3PropertyTag = 22;
const unsigned long k_unHmdVector4PropertyTag = 23;
const unsigned long k_unHmdVector2PropertyTag = 24;
const unsigned long k_unHmdQuadPropertyTag = 25;
const unsigned long k_unHiddenAreaPropertyTag = 30;
const unsigned long k_unPathHandleInfoTag = 31;
const unsigned long k_unActionPropertyTag = 32;
const unsigned long k_unInputValuePropertyTag = 33;
const unsigned long k_unWildcardPropertyTag = 34;
const unsigned long k_unHapticVibrationPropertyTag = 35;
const unsigned long k_unSkeletonPropertyTag = 36;
const unsigned long k_unSpatialAnchorPosePropertyTag = 40;
const unsigned long k_unJsonPropertyTag = 41;
const unsigned long k_unActiveActionSetPropertyTag = 42;
const unsigned long k_unOpenVRInternalReserved_Start = 1000;
const unsigned long k_unOpenVRInternalReserved_End = 10000;
const unsigned long k_unMaxPropertyStringSize = 32768;
const unsigned long long k_ulInvalidActionHandle = 0;
const unsigned long long k_ulInvalidActionSetHandle = 0;
const unsigned long long k_ulInvalidInputValueHandle = 0;
const unsigned long k_unControllerStateAxisCount = 5;
const unsigned long long k_ulOverlayHandleInvalid = 0;
const unsigned long k_unMaxDistortionFunctionParameters = 8;
const unsigned long k_unScreenshotHandleInvalid = 0;
const char * IVRSystem_Version = "IVRSystem_022";
const char * IVRExtendedDisplay_Version = "IVRExtendedDisplay_001";
const char * IVRTrackedCamera_Version = "IVRTrackedCamera_006";
const unsigned long k_unMaxApplicationKeyLength = 128;
const char * k_pch_MimeType_HomeApp = "vr/home";
const char * k_pch_MimeType_GameTheater = "vr/game_theater";
const char * IVRApplications_Version = "IVRApplications_007";
const char * IVRChaperone_Version = "IVRChaperone_004";
const char * IVRChaperoneSetup_Version = "IVRChaperoneSetup_006";
const char * IVRCompositor_Version = "IVRCompositor_027";
const unsigned long k_unVROverlayMaxKeyLength = 128;
const unsigned long k_unVROverlayMaxNameLength = 128;
const unsigned long k_unMaxOverlayCount = 128;
const unsigned long k_unMaxOverlayIntersectionMaskPrimitivesCount = 32;
const char * IVROverlay_Version = "IVROverlay_026";
const char * IVROverlayView_Version = "IVROverlayView_003";
const unsigned long k_unHeadsetViewMaxWidth = 3840;
const unsigned long k_unHeadsetViewMaxHeight = 2160;
const char * k_pchHeadsetViewOverlayKey = "system.HeadsetView";
const char * IVRHeadsetView_Version = "IVRHeadsetView_001";
const char * k_pch_Controller_Component_GDC2015 = "gdc2015";
const char * k_pch_Controller_Component_Base = "base";
const char * k_pch_Controller_Component_Tip = "tip";
const char * k_pch_Controller_Component_HandGrip = "handgrip";
const char * k_pch_Controller_Component_Status = "status";
const char * IVRRenderModels_Version = "IVRRenderModels_006";
const unsigned long k_unNotificationTextMaxSize = 256;
const char * IVRNotifications_Version = "IVRNotifications_002";
const unsigned long k_unMaxSettingsKeyLength = 128;
const char * IVRSettings_Version = "IVRSettings_003";
const char * k_pch_SteamVR_Section = "steamvr";
const char * k_pch_SteamVR_RequireHmd_String = "requireHmd";
const char * k_pch_SteamVR_ForcedDriverKey_String = "forcedDriver";
const char * k_pch_SteamVR_ForcedHmdKey_String = "forcedHmd";
const char * k_pch_SteamVR_DisplayDebug_Bool = "displayDebug";
const char * k_pch_SteamVR_DebugProcessPipe_String = "debugProcessPipe";
const char * k_pch_SteamVR_DisplayDebugX_Int32 = "displayDebugX";
const char * k_pch_SteamVR_DisplayDebugY_Int32 = "displayDebugY";
const char * k_pch_SteamVR_SendSystemButtonToAllApps_Bool = "sendSystemButtonToAllApps";
const char * k_pch_SteamVR_LogLevel_Int32 = "loglevel";
const char * k_pch_SteamVR_IPD_Float = "ipd";
const char * k_pch_SteamVR_Background_String = "background";
const char * k_pch_SteamVR_BackgroundUseDomeProjection_Bool = "backgroundUseDomeProjection";
const char * k_pch_SteamVR_BackgroundCameraHeight_Float = "backgroundCameraHeight";
const char * k_pch_SteamVR_BackgroundDomeRadius_Float = "backgroundDomeRadius";
const char * k_pch_SteamVR_GridColor_String = "gridColor";
const char * k_pch_SteamVR_PlayAreaColor_String = "playAreaColor";
const char * k_pch_SteamVR_TrackingLossColor_String = "trackingLossColor";
const char * k_pch_SteamVR_ShowStage_Bool = "showStage";
const char * k_pch_SteamVR_DrawTrackingReferences_Bool = "drawTrackingReferences";
const char * k_pch_SteamVR_ActivateMultipleDrivers_Bool = "activateMultipleDrivers";
const char * k_pch_SteamVR_UsingSpeakers_Bool = "usingSpeakers";
const char * k_pch_SteamVR_SpeakersForwardYawOffsetDegrees_Float = "speakersForwardYawOffsetDegrees";
const char * k_pch_SteamVR_BaseStationPowerManagement_Int32 = "basestationPowerManagement";
const char * k_pch_SteamVR_ShowBaseStationPowerManagementTip_Int32 = "ShowBaseStationPowerManagementTip";
const char * k_pch_SteamVR_NeverKillProcesses_Bool = "neverKillProcesses";
const char * k_pch_SteamVR_SupersampleScale_Float = "supersampleScale";
const char * k_pch_SteamVR_MaxRecommendedResolution_Int32 = "maxRecommendedResolution";
const char * k_pch_SteamVR_MotionSmoothing_Bool = "motionSmoothing";
const char * k_pch_SteamVR_MotionSmoothingOverride_Int32 = "motionSmoothingOverride";
const char * k_pch_SteamVR_FramesToThrottle_Int32 = "framesToThrottle";
const char * k_pch_SteamVR_AdditionalFramesToPredict_Int32 = "additionalFramesToPredict";
const char * k_pch_SteamVR_WorldScale_Float = "worldScale";
const char * k_pch_SteamVR_FovScale_Int32 = "fovScale";
const char * k_pch_SteamVR_DisableAsyncReprojection_Bool = "disableAsync";
const char * k_pch_SteamVR_ForceFadeOnBadTracking_Bool = "forceFadeOnBadTracking";
const char * k_pch_SteamVR_DefaultMirrorView_Int32 = "mirrorView";
const char * k_pch_SteamVR_ShowLegacyMirrorView_Bool = "showLegacyMirrorView";
const char * k_pch_SteamVR_MirrorViewVisibility_Bool = "showMirrorView";
const char * k_pch_SteamVR_MirrorViewDisplayMode_Int32 = "mirrorViewDisplayMode";
const char * k_pch_SteamVR_MirrorViewEye_Int32 = "mirrorViewEye";
const char * k_pch_SteamVR_MirrorViewGeometry_String = "mirrorViewGeometry";
const char * k_pch_SteamVR_MirrorViewGeometryMaximized_String = "mirrorViewGeometryMaximized";
const char * k_pch_SteamVR_PerfGraphVisibility_Bool = "showPerfGraph";
const char * k_pch_SteamVR_StartMonitorFromAppLaunch = "startMonitorFromAppLaunch";
const char * k_pch_SteamVR_StartCompositorFromAppLaunch_Bool = "startCompositorFromAppLaunch";
const char * k_pch_SteamVR_StartDashboardFromAppLaunch_Bool = "startDashboardFromAppLaunch";
const char * k_pch_SteamVR_StartOverlayAppsFromDashboard_Bool = "startOverlayAppsFromDashboard";
const char * k_pch_SteamVR_EnableHomeApp = "enableHomeApp";
const char * k_pch_SteamVR_CycleBackgroundImageTimeSec_Int32 = "CycleBackgroundImageTimeSec";
const char * k_pch_SteamVR_RetailDemo_Bool = "retailDemo";
const char * k_pch_SteamVR_IpdOffset_Float = "ipdOffset";
const char * k_pch_SteamVR_AllowSupersampleFiltering_Bool = "allowSupersampleFiltering";
const char * k_pch_SteamVR_SupersampleManualOverride_Bool = "supersampleManualOverride";
const char * k_pch_SteamVR_EnableLinuxVulkanAsync_Bool = "enableLinuxVulkanAsync";
const char * k_pch_SteamVR_AllowDisplayLockedMode_Bool = "allowDisplayLockedMode";
const char * k_pch_SteamVR_HaveStartedTutorialForNativeChaperoneDriver_Bool = "haveStartedTutorialForNativeChaperoneDriver";
const char * k_pch_SteamVR_ForceWindows32bitVRMonitor = "forceWindows32BitVRMonitor";
const char * k_pch_SteamVR_DebugInputBinding = "debugInputBinding";
const char * k_pch_SteamVR_DoNotFadeToGrid = "doNotFadeToGrid";
const char * k_pch_SteamVR_RenderCameraMode = "renderCameraMode";
const char * k_pch_SteamVR_EnableSharedResourceJournaling = "enableSharedResourceJournaling";
const char * k_pch_SteamVR_EnableSafeMode = "enableSafeMode";
const char * k_pch_SteamVR_PreferredRefreshRate = "preferredRefreshRate";
const char * k_pch_SteamVR_LastVersionNotice = "lastVersionNotice";
const char * k_pch_SteamVR_LastVersionNoticeDate = "lastVersionNoticeDate";
const char * k_pch_SteamVR_HmdDisplayColorGainR_Float = "hmdDisplayColorGainR";
const char * k_pch_SteamVR_HmdDisplayColorGainG_Float = "hmdDisplayColorGainG";
const char * k_pch_SteamVR_HmdDisplayColorGainB_Float = "hmdDisplayColorGainB";
const char * k_pch_SteamVR_CustomIconStyle_String = "customIconStyle";
const char * k_pch_SteamVR_CustomOffIconStyle_String = "customOffIconStyle";
const char * k_pch_SteamVR_CustomIconForceUpdate_String = "customIconForceUpdate";
const char * k_pch_SteamVR_AllowGlobalActionSetPriority = "globalActionSetPriority";
const char * k_pch_SteamVR_OverlayRenderQuality = "overlayRenderQuality_2";
const char * k_pch_SteamVR_BlockOculusSDKOnOpenVRLaunchOption_Bool = "blockOculusSDKOnOpenVRLaunchOption";
const char * k_pch_SteamVR_BlockOculusSDKOnAllLaunches_Bool = "blockOculusSDKOnAllLaunches";
const char * k_pch_SteamVR_HDCPLegacyCompatibility_Bool = "hdcp14legacyCompatibility";
const char * k_pch_SteamVR_DisplayPortTrainingMode_Int = "displayPortTrainingMode";
const char * k_pch_SteamVR_UsePrism_Bool = "usePrism";
const char * k_pch_DirectMode_Section = "direct_mode";
const char * k_pch_DirectMode_Enable_Bool = "enable";
const char * k_pch_DirectMode_Count_Int32 = "count";
const char * k_pch_DirectMode_EdidVid_Int32 = "edidVid";
const char * k_pch_DirectMode_EdidPid_Int32 = "edidPid";
const char * k_pch_Lighthouse_Section = "driver_lighthouse";
const char * k_pch_Lighthouse_DisableIMU_Bool = "disableimu";
const char * k_pch_Lighthouse_DisableIMUExceptHMD_Bool = "disableimuexcepthmd";
const char * k_pch_Lighthouse_UseDisambiguation_String = "usedisambiguation";
const char * k_pch_Lighthouse_DisambiguationDebug_Int32 = "disambiguationdebug";
const char * k_pch_Lighthouse_PrimaryBasestation_Int32 = "primarybasestation";
const char * k_pch_Lighthouse_DBHistory_Bool = "dbhistory";
const char * k_pch_Lighthouse_EnableBluetooth_Bool = "enableBluetooth";
const char * k_pch_Lighthouse_PowerManagedBaseStations_String = "PowerManagedBaseStations";
const char * k_pch_Lighthouse_PowerManagedBaseStations2_String = "PowerManagedBaseStations2";
const char * k_pch_Lighthouse_InactivityTimeoutForBaseStations_Int32 = "InactivityTimeoutForBaseStations";
const char * k_pch_Lighthouse_EnableImuFallback_Bool = "enableImuFallback";
const char * k_pch_Null_Section = "driver_null";
const char * k_pch_Null_SerialNumber_String = "serialNumber";
const char * k_pch_Null_ModelNumber_String = "modelNumber";
const char * k_pch_Null_WindowX_Int32 = "windowX";
const char * k_pch_Null_WindowY_Int32 = "windowY";
const char * k_pch_Null_WindowWidth_Int32 = "windowWidth";
const char * k_pch_Null_WindowHeight_Int32 = "windowHeight";
const char * k_pch_Null_RenderWidth_Int32 = "renderWidth";
const char * k_pch_Null_RenderHeight_Int32 = "renderHeight";
const char * k_pch_Null_SecondsFromVsyncToPhotons_Float = "secondsFromVsyncToPhotons";
const char * k_pch_Null_DisplayFrequency_Float = "displayFrequency";
const char * k_pch_WindowsMR_Section = "driver_holographic";
const char * k_pch_UserInterface_Section = "userinterface";
const char * k_pch_UserInterface_StatusAlwaysOnTop_Bool = "StatusAlwaysOnTop";
const char * k_pch_UserInterface_MinimizeToTray_Bool = "MinimizeToTray";
const char * k_pch_UserInterface_HidePopupsWhenStatusMinimized_Bool = "HidePopupsWhenStatusMinimized";
const char * k_pch_UserInterface_Screenshots_Bool = "screenshots";
const char * k_pch_UserInterface_ScreenshotType_Int = "screenshotType";
const char * k_pch_Notifications_Section = "notifications";
const char * k_pch_Notifications_DoNotDisturb_Bool = "DoNotDisturb";
const char * k_pch_Keyboard_Section = "keyboard";
const char * k_pch_Keyboard_TutorialCompletions = "TutorialCompletions";
const char * k_pch_Keyboard_ScaleX = "ScaleX";
const char * k_pch_Keyboard_ScaleY = "ScaleY";
const char * k_pch_Keyboard_OffsetLeftX = "OffsetLeftX";
const char * k_pch_Keyboard_OffsetRightX = "OffsetRightX";
const char * k_pch_Keyboard_OffsetY = "OffsetY";
const char * k_pch_Keyboard_Smoothing = "Smoothing";
const char * k_pch_Perf_Section = "perfcheck";
const char * k_pch_Perf_PerfGraphInHMD_Bool = "perfGraphInHMD";
const char * k_pch_Perf_AllowTimingStore_Bool = "allowTimingStore";
const char * k_pch_Perf_SaveTimingsOnExit_Bool = "saveTimingsOnExit";
const char * k_pch_Perf_TestData_Float = "perfTestData";
const char * k_pch_Perf_GPUProfiling_Bool = "GPUProfiling";
const char * k_pch_CollisionBounds_Section = "collisionBounds";
const char * k_pch_CollisionBounds_Style_Int32 = "CollisionBoundsStyle";
const char * k_pch_CollisionBounds_GroundPerimeterOn_Bool = "CollisionBoundsGroundPerimeterOn";
const char * k_pch_CollisionBounds_CenterMarkerOn_Bool = "CollisionBoundsCenterMarkerOn";
const char * k_pch_CollisionBounds_PlaySpaceOn_Bool = "CollisionBoundsPlaySpaceOn";
const char * k_pch_CollisionBounds_FadeDistance_Float = "CollisionBoundsFadeDistance";
const char * k_pch_CollisionBounds_WallHeight_Float = "CollisionBoundsWallHeight";
const char * k_pch_CollisionBounds_ColorGammaR_Int32 = "CollisionBoundsColorGammaR";
const char * k_pch_CollisionBounds_ColorGammaG_Int32 = "CollisionBoundsColorGammaG";
const char * k_pch_CollisionBounds_ColorGammaB_Int32 = "CollisionBoundsColorGammaB";
const char * k_pch_CollisionBounds_ColorGammaA_Int32 = "CollisionBoundsColorGammaA";
const char * k_pch_CollisionBounds_EnableDriverImport = "enableDriverBoundsImport";
const char * k_pch_Camera_Section = "camera";
const char * k_pch_Camera_EnableCamera_Bool = "enableCamera";
const char * k_pch_Camera_ShowOnController_Bool = "showOnController";
const char * k_pch_Camera_EnableCameraForCollisionBounds_Bool = "enableCameraForCollisionBounds";
const char * k_pch_Camera_RoomView_Int32 = "roomView";
const char * k_pch_Camera_BoundsColorGammaR_Int32 = "cameraBoundsColorGammaR";
const char * k_pch_Camera_BoundsColorGammaG_Int32 = "cameraBoundsColorGammaG";
const char * k_pch_Camera_BoundsColorGammaB_Int32 = "cameraBoundsColorGammaB";
const char * k_pch_Camera_BoundsColorGammaA_Int32 = "cameraBoundsColorGammaA";
const char * k_pch_Camera_BoundsStrength_Int32 = "cameraBoundsStrength";
const char * k_pch_Camera_RoomViewStyle_Int32 = "roomViewStyle";
const char * k_pch_audio_Section = "audio";
const char * k_pch_audio_SetOsDefaultPlaybackDevice_Bool = "setOsDefaultPlaybackDevice";
const char * k_pch_audio_EnablePlaybackDeviceOverride_Bool = "enablePlaybackDeviceOverride";
const char * k_pch_audio_PlaybackDeviceOverride_String = "playbackDeviceOverride";
const char * k_pch_audio_PlaybackDeviceOverrideName_String = "playbackDeviceOverrideName";
const char * k_pch_audio_SetOsDefaultRecordingDevice_Bool = "setOsDefaultRecordingDevice";
const char * k_pch_audio_EnableRecordingDeviceOverride_Bool = "enableRecordingDeviceOverride";
const char * k_pch_audio_RecordingDeviceOverride_String = "recordingDeviceOverride";
const char * k_pch_audio_RecordingDeviceOverrideName_String = "recordingDeviceOverrideName";
const char * k_pch_audio_EnablePlaybackMirror_Bool = "enablePlaybackMirror";
const char * k_pch_audio_PlaybackMirrorDevice_String = "playbackMirrorDevice";
const char * k_pch_audio_PlaybackMirrorDeviceName_String = "playbackMirrorDeviceName";
const char * k_pch_audio_OldPlaybackMirrorDevice_String = "onPlaybackMirrorDevice";
const char * k_pch_audio_ActiveMirrorDevice_String = "activePlaybackMirrorDevice";
const char * k_pch_audio_EnablePlaybackMirrorIndependentVolume_Bool = "enablePlaybackMirrorIndependentVolume";
const char * k_pch_audio_LastHmdPlaybackDeviceId_String = "lastHmdPlaybackDeviceId";
const char * k_pch_audio_VIVEHDMIGain = "viveHDMIGain";
const char * k_pch_audio_DualSpeakerAndJackOutput_Bool = "dualSpeakerAndJackOutput";
const char * k_pch_audio_MuteMicMonitor_Bool = "muteMicMonitor";
const char * k_pch_Power_Section = "power";
const char * k_pch_Power_PowerOffOnExit_Bool = "powerOffOnExit";
const char * k_pch_Power_TurnOffScreensTimeout_Float = "turnOffScreensTimeout";
const char * k_pch_Power_TurnOffControllersTimeout_Float = "turnOffControllersTimeout";
const char * k_pch_Power_ReturnToWatchdogTimeout_Float = "returnToWatchdogTimeout";
const char * k_pch_Power_AutoLaunchSteamVROnButtonPress = "autoLaunchSteamVROnButtonPress";
const char * k_pch_Power_PauseCompositorOnStandby_Bool = "pauseCompositorOnStandby";
const char * k_pch_Dashboard_Section = "dashboard";
const char * k_pch_Dashboard_EnableDashboard_Bool = "enableDashboard";
const char * k_pch_Dashboard_ArcadeMode_Bool = "arcadeMode";
const char * k_pch_Dashboard_Position = "position";
const char * k_pch_Dashboard_DesktopScale = "desktopScale";
const char * k_pch_Dashboard_DashboardScale = "dashboardScale";
const char * k_pch_Dashboard_UseStandaloneSystemLayer = "standaloneSystemLayer";
const char * k_pch_Dashboard_StickyDashboard = "stickyDashboard";
const char * k_pch_modelskin_Section = "modelskins";
const char * k_pch_Driver_Enable_Bool = "enable";
const char * k_pch_Driver_BlockedBySafemode_Bool = "blocked_by_safe_mode";
const char * k_pch_Driver_LoadPriority_Int32 = "loadPriority";
const char * k_pch_WebInterface_Section = "WebInterface";
const char * k_pch_VRWebHelper_Section = "VRWebHelper";
const char * k_pch_VRWebHelper_DebuggerEnabled_Bool = "DebuggerEnabled";
const char * k_pch_VRWebHelper_DebuggerPort_Int32 = "DebuggerPort";
const char * k_pch_TrackingOverride_Section = "TrackingOverrides";
const char * k_pch_App_BindingAutosaveURLSuffix_String = "AutosaveURL";
const char * k_pch_App_BindingLegacyAPISuffix_String = "_legacy";
const char * k_pch_App_BindingSteamVRInputAPISuffix_String = "_steamvrinput";
const char * k_pch_App_BindingCurrentURLSuffix_String = "CurrentURL";
const char * k_pch_App_BindingPreviousURLSuffix_String = "PreviousURL";
const char * k_pch_App_NeedToUpdateAutosaveSuffix_Bool = "NeedToUpdateAutosave";
const char * k_pch_App_DominantHand_Int32 = "DominantHand";
const char * k_pch_App_BlockOculusSDK_Bool = "blockOculusSDK";
const char * k_pch_Trackers_Section = "trackers";
const char * k_pch_DesktopUI_Section = "DesktopUI";
const char * k_pch_LastKnown_Section = "LastKnown";
const char * k_pch_LastKnown_HMDManufacturer_String = "HMDManufacturer";
const char * k_pch_LastKnown_HMDModel_String = "HMDModel";
const char * k_pch_DismissedWarnings_Section = "DismissedWarnings";
const char * k_pch_Input_Section = "input";
const char * k_pch_Input_LeftThumbstickRotation_Float = "leftThumbstickRotation";
const char * k_pch_Input_RightThumbstickRotation_Float = "rightThumbstickRotation";
const char * k_pch_Input_ThumbstickDeadzone_Float = "thumbstickDeadzone";
const char * k_pch_GpuSpeed_Section = "GpuSpeed";
const char * IVRScreenshots_Version = "IVRScreenshots_001";
const char * IVRResources_Version = "IVRResources_001";
const char * IVRDriverManager_Version = "IVRDriverManager_001";
const unsigned long k_unMaxActionNameLength = 64;
const unsigned long k_unMaxActionSetNameLength = 64;
const unsigned long k_unMaxActionOriginCount = 16;
const unsigned long k_unMaxBoneNameLength = 32;
const int k_nActionSetOverlayGlobalPriorityMin = 16777216;
const int k_nActionSetOverlayGlobalPriorityMax = 33554431;
const int k_nActionSetPriorityReservedMin = 33554432;
const char * IVRInput_Version = "IVRInput_010";
const unsigned long long k_ulInvalidIOBufferHandle = 0;
const char * IVRIOBuffer_Version = "IVRIOBuffer_002";
const unsigned long k_ulInvalidSpatialAnchorHandle = 0;
const char * IVRSpatialAnchors_Version = "IVRSpatialAnchors_001";
const char * IVRDebug_Version = "IVRDebug_001";
const unsigned long long k_ulDisplayRedirectContainer = 25769803779;
const char * IVRProperties_Version = "IVRProperties_001";
const char * k_pchPathUserHandRight = "/user/hand/right";
const char * k_pchPathUserHandLeft = "/user/hand/left";
const char * k_pchPathUserHandPrimary = "/user/hand/primary";
const char * k_pchPathUserHandSecondary = "/user/hand/secondary";
const char * k_pchPathUserHead = "/user/head";
const char * k_pchPathUserGamepad = "/user/gamepad";
const char * k_pchPathUserTreadmill = "/user/treadmill";
const char * k_pchPathUserStylus = "/user/stylus";
const char * k_pchPathDevices = "/devices";
const char * k_pchPathDevicePath = "/device_path";
const char * k_pchPathBestAliasPath = "/best_alias_path";
const char * k_pchPathBoundTrackerAliasPath = "/bound_tracker_path";
const char * k_pchPathBoundTrackerRole = "/bound_tracker_role";
const char * k_pchPathPoseRaw = "/pose/raw";
const char * k_pchPathPoseTip = "/pose/tip";
const char * k_pchPathPoseGrip = "/pose/grip";
const char * k_pchPathSystemButtonClick = "/input/system/click";
const char * k_pchPathProximity = "/proximity";
const char * k_pchPathControllerTypePrefix = "/controller_type/";
const char * k_pchPathInputProfileSuffix = "/input_profile";
const char * k_pchPathBindingNameSuffix = "/binding_name";
const char * k_pchPathBindingUrlSuffix = "/binding_url";
const char * k_pchPathBindingErrorSuffix = "/binding_error";
const char * k_pchPathActiveActionSets = "/active_action_sets";
const char * k_pchPathComponentUpdates = "/total_component_updates";
const char * k_pchPathUserFootLeft = "/user/foot/left";
const char * k_pchPathUserFootRight = "/user/foot/right";
const char * k_pchPathUserShoulderLeft = "/user/shoulder/left";
const char * k_pchPathUserShoulderRight = "/user/shoulder/right";
const char * k_pchPathUserElbowLeft = "/user/elbow/left";
const char * k_pchPathUserElbowRight = "/user/elbow/right";
const char * k_pchPathUserKneeLeft = "/user/knee/left";
const char * k_pchPathUserKneeRight = "/user/knee/right";
const char * k_pchPathUserWaist = "/user/waist";
const char * k_pchPathUserChest = "/user/chest";
const char * k_pchPathUserCamera = "/user/camera";
const char * k_pchPathUserKeyboard = "/user/keyboard";
const char * k_pchPathClientAppKey = "/client_info/app_key";
const unsigned long long k_ulInvalidPathHandle = 0;
const char * IVRPaths_Version = "IVRPaths_001";
const char * IVRBlockQueue_Version = "IVRBlockQueue_005";
*/

// OpenVR Enums

typedef enum EVREye
{
	EVREye_Eye_Left = 0,
	EVREye_Eye_Right = 1,
} EVREye;

typedef enum ETextureType
{
	ETextureType_TextureType_Invalid = -1,
	ETextureType_TextureType_DirectX = 0,
	ETextureType_TextureType_OpenGL = 1,
	ETextureType_TextureType_Vulkan = 2,
	ETextureType_TextureType_IOSurface = 3,
	ETextureType_TextureType_DirectX12 = 4,
	ETextureType_TextureType_DXGISharedHandle = 5,
	ETextureType_TextureType_Metal = 6,
} ETextureType;

typedef enum EColorSpace
{
	EColorSpace_ColorSpace_Auto = 0,
	EColorSpace_ColorSpace_Gamma = 1,
	EColorSpace_ColorSpace_Linear = 2,
} EColorSpace;

typedef enum ETrackingResult
{
	ETrackingResult_TrackingResult_Uninitialized = 1,
	ETrackingResult_TrackingResult_Calibrating_InProgress = 100,
	ETrackingResult_TrackingResult_Calibrating_OutOfRange = 101,
	ETrackingResult_TrackingResult_Running_OK = 200,
	ETrackingResult_TrackingResult_Running_OutOfRange = 201,
	ETrackingResult_TrackingResult_Fallback_RotationOnly = 300,
} ETrackingResult;

typedef enum ETrackedDeviceClass
{
	ETrackedDeviceClass_TrackedDeviceClass_Invalid = 0,
	ETrackedDeviceClass_TrackedDeviceClass_HMD = 1,
	ETrackedDeviceClass_TrackedDeviceClass_Controller = 2,
	ETrackedDeviceClass_TrackedDeviceClass_GenericTracker = 3,
	ETrackedDeviceClass_TrackedDeviceClass_TrackingReference = 4,
	ETrackedDeviceClass_TrackedDeviceClass_DisplayRedirect = 5,
	ETrackedDeviceClass_TrackedDeviceClass_Max = 6,
} ETrackedDeviceClass;

typedef enum ETrackedControllerRole
{
	ETrackedControllerRole_TrackedControllerRole_Invalid = 0,
	ETrackedControllerRole_TrackedControllerRole_LeftHand = 1,
	ETrackedControllerRole_TrackedControllerRole_RightHand = 2,
	ETrackedControllerRole_TrackedControllerRole_OptOut = 3,
	ETrackedControllerRole_TrackedControllerRole_Treadmill = 4,
	ETrackedControllerRole_TrackedControllerRole_Stylus = 5,
	ETrackedControllerRole_TrackedControllerRole_Max = 5,
} ETrackedControllerRole;

typedef enum ETrackingUniverseOrigin
{
	ETrackingUniverseOrigin_TrackingUniverseSeated = 0,
	ETrackingUniverseOrigin_TrackingUniverseStanding = 1,
	ETrackingUniverseOrigin_TrackingUniverseRawAndUncalibrated = 2,
} ETrackingUniverseOrigin;

typedef enum EAdditionalRadioFeatures
{
	EAdditionalRadioFeatures_AdditionalRadioFeatures_None = 0,
	EAdditionalRadioFeatures_AdditionalRadioFeatures_HTCLinkBox = 1,
	EAdditionalRadioFeatures_AdditionalRadioFeatures_InternalDongle = 2,
	EAdditionalRadioFeatures_AdditionalRadioFeatures_ExternalDongle = 4,
} EAdditionalRadioFeatures;

typedef enum ETrackedDeviceProperty
{
	ETrackedDeviceProperty_Prop_Invalid = 0,
	ETrackedDeviceProperty_Prop_TrackingSystemName_String = 1000,
	ETrackedDeviceProperty_Prop_ModelNumber_String = 1001,
	ETrackedDeviceProperty_Prop_SerialNumber_String = 1002,
	ETrackedDeviceProperty_Prop_RenderModelName_String = 1003,
	ETrackedDeviceProperty_Prop_WillDriftInYaw_Bool = 1004,
	ETrackedDeviceProperty_Prop_ManufacturerName_String = 1005,
	ETrackedDeviceProperty_Prop_TrackingFirmwareVersion_String = 1006,
	ETrackedDeviceProperty_Prop_HardwareRevision_String = 1007,
	ETrackedDeviceProperty_Prop_AllWirelessDongleDescriptions_String = 1008,
	ETrackedDeviceProperty_Prop_ConnectedWirelessDongle_String = 1009,
	ETrackedDeviceProperty_Prop_DeviceIsWireless_Bool = 1010,
	ETrackedDeviceProperty_Prop_DeviceIsCharging_Bool = 1011,
	ETrackedDeviceProperty_Prop_DeviceBatteryPercentage_Float = 1012,
	ETrackedDeviceProperty_Prop_StatusDisplayTransform_Matrix34 = 1013,
	ETrackedDeviceProperty_Prop_Firmware_UpdateAvailable_Bool = 1014,
	ETrackedDeviceProperty_Prop_Firmware_ManualUpdate_Bool = 1015,
	ETrackedDeviceProperty_Prop_Firmware_ManualUpdateURL_String = 1016,
	ETrackedDeviceProperty_Prop_HardwareRevision_Uint64 = 1017,
	ETrackedDeviceProperty_Prop_FirmwareVersion_Uint64 = 1018,
	ETrackedDeviceProperty_Prop_FPGAVersion_Uint64 = 1019,
	ETrackedDeviceProperty_Prop_VRCVersion_Uint64 = 1020,
	ETrackedDeviceProperty_Prop_RadioVersion_Uint64 = 1021,
	ETrackedDeviceProperty_Prop_DongleVersion_Uint64 = 1022,
	ETrackedDeviceProperty_Prop_BlockServerShutdown_Bool = 1023,
	ETrackedDeviceProperty_Prop_CanUnifyCoordinateSystemWithHmd_Bool = 1024,
	ETrackedDeviceProperty_Prop_ContainsProximitySensor_Bool = 1025,
	ETrackedDeviceProperty_Prop_DeviceProvidesBatteryStatus_Bool = 1026,
	ETrackedDeviceProperty_Prop_DeviceCanPowerOff_Bool = 1027,
	ETrackedDeviceProperty_Prop_Firmware_ProgrammingTarget_String = 1028,
	ETrackedDeviceProperty_Prop_DeviceClass_Int32 = 1029,
	ETrackedDeviceProperty_Prop_HasCamera_Bool = 1030,
	ETrackedDeviceProperty_Prop_DriverVersion_String = 1031,
	ETrackedDeviceProperty_Prop_Firmware_ForceUpdateRequired_Bool = 1032,
	ETrackedDeviceProperty_Prop_ViveSystemButtonFixRequired_Bool = 1033,
	ETrackedDeviceProperty_Prop_ParentDriver_Uint64 = 1034,
	ETrackedDeviceProperty_Prop_ResourceRoot_String = 1035,
	ETrackedDeviceProperty_Prop_RegisteredDeviceType_String = 1036,
	ETrackedDeviceProperty_Prop_InputProfilePath_String = 1037,
	ETrackedDeviceProperty_Prop_NeverTracked_Bool = 1038,
	ETrackedDeviceProperty_Prop_NumCameras_Int32 = 1039,
	ETrackedDeviceProperty_Prop_CameraFrameLayout_Int32 = 1040,
	ETrackedDeviceProperty_Prop_CameraStreamFormat_Int32 = 1041,
	ETrackedDeviceProperty_Prop_AdditionalDeviceSettingsPath_String = 1042,
	ETrackedDeviceProperty_Prop_Identifiable_Bool = 1043,
	ETrackedDeviceProperty_Prop_BootloaderVersion_Uint64 = 1044,
	ETrackedDeviceProperty_Prop_AdditionalSystemReportData_String = 1045,
	ETrackedDeviceProperty_Prop_CompositeFirmwareVersion_String = 1046,
	ETrackedDeviceProperty_Prop_Firmware_RemindUpdate_Bool = 1047,
	ETrackedDeviceProperty_Prop_PeripheralApplicationVersion_Uint64 = 1048,
	ETrackedDeviceProperty_Prop_ManufacturerSerialNumber_String = 1049,
	ETrackedDeviceProperty_Prop_ComputedSerialNumber_String = 1050,
	ETrackedDeviceProperty_Prop_EstimatedDeviceFirstUseTime_Int32 = 1051,
	ETrackedDeviceProperty_Prop_DevicePowerUsage_Float = 1052,
	ETrackedDeviceProperty_Prop_IgnoreMotionForStandby_Bool = 1053,
	ETrackedDeviceProperty_Prop_ReportsTimeSinceVSync_Bool = 2000,
	ETrackedDeviceProperty_Prop_SecondsFromVsyncToPhotons_Float = 2001,
	ETrackedDeviceProperty_Prop_DisplayFrequency_Float = 2002,
	ETrackedDeviceProperty_Prop_UserIpdMeters_Float = 2003,
	ETrackedDeviceProperty_Prop_CurrentUniverseId_Uint64 = 2004,
	ETrackedDeviceProperty_Prop_PreviousUniverseId_Uint64 = 2005,
	ETrackedDeviceProperty_Prop_DisplayFirmwareVersion_Uint64 = 2006,
	ETrackedDeviceProperty_Prop_IsOnDesktop_Bool = 2007,
	ETrackedDeviceProperty_Prop_DisplayMCType_Int32 = 2008,
	ETrackedDeviceProperty_Prop_DisplayMCOffset_Float = 2009,
	ETrackedDeviceProperty_Prop_DisplayMCScale_Float = 2010,
	ETrackedDeviceProperty_Prop_EdidVendorID_Int32 = 2011,
	ETrackedDeviceProperty_Prop_DisplayMCImageLeft_String = 2012,
	ETrackedDeviceProperty_Prop_DisplayMCImageRight_String = 2013,
	ETrackedDeviceProperty_Prop_DisplayGCBlackClamp_Float = 2014,
	ETrackedDeviceProperty_Prop_EdidProductID_Int32 = 2015,
	ETrackedDeviceProperty_Prop_CameraToHeadTransform_Matrix34 = 2016,
	ETrackedDeviceProperty_Prop_DisplayGCType_Int32 = 2017,
	ETrackedDeviceProperty_Prop_DisplayGCOffset_Float = 2018,
	ETrackedDeviceProperty_Prop_DisplayGCScale_Float = 2019,
	ETrackedDeviceProperty_Prop_DisplayGCPrescale_Float = 2020,
	ETrackedDeviceProperty_Prop_DisplayGCImage_String = 2021,
	ETrackedDeviceProperty_Prop_LensCenterLeftU_Float = 2022,
	ETrackedDeviceProperty_Prop_LensCenterLeftV_Float = 2023,
	ETrackedDeviceProperty_Prop_LensCenterRightU_Float = 2024,
	ETrackedDeviceProperty_Prop_LensCenterRightV_Float = 2025,
	ETrackedDeviceProperty_Prop_UserHeadToEyeDepthMeters_Float = 2026,
	ETrackedDeviceProperty_Prop_CameraFirmwareVersion_Uint64 = 2027,
	ETrackedDeviceProperty_Prop_CameraFirmwareDescription_String = 2028,
	ETrackedDeviceProperty_Prop_DisplayFPGAVersion_Uint64 = 2029,
	ETrackedDeviceProperty_Prop_DisplayBootloaderVersion_Uint64 = 2030,
	ETrackedDeviceProperty_Prop_DisplayHardwareVersion_Uint64 = 2031,
	ETrackedDeviceProperty_Prop_AudioFirmwareVersion_Uint64 = 2032,
	ETrackedDeviceProperty_Prop_CameraCompatibilityMode_Int32 = 2033,
	ETrackedDeviceProperty_Prop_ScreenshotHorizontalFieldOfViewDegrees_Float = 2034,
	ETrackedDeviceProperty_Prop_ScreenshotVerticalFieldOfViewDegrees_Float = 2035,
	ETrackedDeviceProperty_Prop_DisplaySuppressed_Bool = 2036,
	ETrackedDeviceProperty_Prop_DisplayAllowNightMode_Bool = 2037,
	ETrackedDeviceProperty_Prop_DisplayMCImageWidth_Int32 = 2038,
	ETrackedDeviceProperty_Prop_DisplayMCImageHeight_Int32 = 2039,
	ETrackedDeviceProperty_Prop_DisplayMCImageNumChannels_Int32 = 2040,
	ETrackedDeviceProperty_Prop_DisplayMCImageData_Binary = 2041,
	ETrackedDeviceProperty_Prop_SecondsFromPhotonsToVblank_Float = 2042,
	ETrackedDeviceProperty_Prop_DriverDirectModeSendsVsyncEvents_Bool = 2043,
	ETrackedDeviceProperty_Prop_DisplayDebugMode_Bool = 2044,
	ETrackedDeviceProperty_Prop_GraphicsAdapterLuid_Uint64 = 2045,
	ETrackedDeviceProperty_Prop_DriverProvidedChaperonePath_String = 2048,
	ETrackedDeviceProperty_Prop_ExpectedTrackingReferenceCount_Int32 = 2049,
	ETrackedDeviceProperty_Prop_ExpectedControllerCount_Int32 = 2050,
	ETrackedDeviceProperty_Prop_NamedIconPathControllerLeftDeviceOff_String = 2051,
	ETrackedDeviceProperty_Prop_NamedIconPathControllerRightDeviceOff_String = 2052,
	ETrackedDeviceProperty_Prop_NamedIconPathTrackingReferenceDeviceOff_String = 2053,
	ETrackedDeviceProperty_Prop_DoNotApplyPrediction_Bool = 2054,
	ETrackedDeviceProperty_Prop_CameraToHeadTransforms_Matrix34_Array = 2055,
	ETrackedDeviceProperty_Prop_DistortionMeshResolution_Int32 = 2056,
	ETrackedDeviceProperty_Prop_DriverIsDrawingControllers_Bool = 2057,
	ETrackedDeviceProperty_Prop_DriverRequestsApplicationPause_Bool = 2058,
	ETrackedDeviceProperty_Prop_DriverRequestsReducedRendering_Bool = 2059,
	ETrackedDeviceProperty_Prop_MinimumIpdStepMeters_Float = 2060,
	ETrackedDeviceProperty_Prop_AudioBridgeFirmwareVersion_Uint64 = 2061,
	ETrackedDeviceProperty_Prop_ImageBridgeFirmwareVersion_Uint64 = 2062,
	ETrackedDeviceProperty_Prop_ImuToHeadTransform_Matrix34 = 2063,
	ETrackedDeviceProperty_Prop_ImuFactoryGyroBias_Vector3 = 2064,
	ETrackedDeviceProperty_Prop_ImuFactoryGyroScale_Vector3 = 2065,
	ETrackedDeviceProperty_Prop_ImuFactoryAccelerometerBias_Vector3 = 2066,
	ETrackedDeviceProperty_Prop_ImuFactoryAccelerometerScale_Vector3 = 2067,
	ETrackedDeviceProperty_Prop_ConfigurationIncludesLighthouse20Features_Bool = 2069,
	ETrackedDeviceProperty_Prop_AdditionalRadioFeatures_Uint64 = 2070,
	ETrackedDeviceProperty_Prop_CameraWhiteBalance_Vector4_Array = 2071,
	ETrackedDeviceProperty_Prop_CameraDistortionFunction_Int32_Array = 2072,
	ETrackedDeviceProperty_Prop_CameraDistortionCoefficients_Float_Array = 2073,
	ETrackedDeviceProperty_Prop_ExpectedControllerType_String = 2074,
	ETrackedDeviceProperty_Prop_HmdTrackingStyle_Int32 = 2075,
	ETrackedDeviceProperty_Prop_DriverProvidedChaperoneVisibility_Bool = 2076,
	ETrackedDeviceProperty_Prop_HmdColumnCorrectionSettingPrefix_String = 2077,
	ETrackedDeviceProperty_Prop_CameraSupportsCompatibilityModes_Bool = 2078,
	ETrackedDeviceProperty_Prop_SupportsRoomViewDepthProjection_Bool = 2079,
	ETrackedDeviceProperty_Prop_DisplayAvailableFrameRates_Float_Array = 2080,
	ETrackedDeviceProperty_Prop_DisplaySupportsMultipleFramerates_Bool = 2081,
	ETrackedDeviceProperty_Prop_DisplayColorMultLeft_Vector3 = 2082,
	ETrackedDeviceProperty_Prop_DisplayColorMultRight_Vector3 = 2083,
	ETrackedDeviceProperty_Prop_DisplaySupportsRuntimeFramerateChange_Bool = 2084,
	ETrackedDeviceProperty_Prop_DisplaySupportsAnalogGain_Bool = 2085,
	ETrackedDeviceProperty_Prop_DisplayMinAnalogGain_Float = 2086,
	ETrackedDeviceProperty_Prop_DisplayMaxAnalogGain_Float = 2087,
	ETrackedDeviceProperty_Prop_CameraExposureTime_Float = 2088,
	ETrackedDeviceProperty_Prop_CameraGlobalGain_Float = 2089,
	ETrackedDeviceProperty_Prop_DashboardScale_Float = 2091,
	ETrackedDeviceProperty_Prop_PeerButtonInfo_String = 2092,
	ETrackedDeviceProperty_Prop_IpdUIRangeMinMeters_Float = 2100,
	ETrackedDeviceProperty_Prop_IpdUIRangeMaxMeters_Float = 2101,
	ETrackedDeviceProperty_Prop_Hmd_SupportsHDCP14LegacyCompat_Bool = 2102,
	ETrackedDeviceProperty_Prop_Hmd_SupportsMicMonitoring_Bool = 2103,
	ETrackedDeviceProperty_Prop_Hmd_SupportsDisplayPortTrainingMode_Bool = 2104,
	ETrackedDeviceProperty_Prop_SupportsRoomViewDirect_Bool = 2105,
	ETrackedDeviceProperty_Prop_SupportsAppThrottling_Bool = 2106,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraCorrectionMode_Int32 = 2200,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_InnerLeft_Int32 = 2201,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_InnerRight_Int32 = 2202,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_InnerTop_Int32 = 2203,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_InnerBottom_Int32 = 2204,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_OuterLeft_Int32 = 2205,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_OuterRight_Int32 = 2206,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_OuterTop_Int32 = 2207,
	ETrackedDeviceProperty_Prop_DriverRequestedMuraFeather_OuterBottom_Int32 = 2208,
	ETrackedDeviceProperty_Prop_Audio_DefaultPlaybackDeviceId_String = 2300,
	ETrackedDeviceProperty_Prop_Audio_DefaultRecordingDeviceId_String = 2301,
	ETrackedDeviceProperty_Prop_Audio_DefaultPlaybackDeviceVolume_Float = 2302,
	ETrackedDeviceProperty_Prop_Audio_SupportsDualSpeakerAndJackOutput_Bool = 2303,
	ETrackedDeviceProperty_Prop_AttachedDeviceId_String = 3000,
	ETrackedDeviceProperty_Prop_SupportedButtons_Uint64 = 3001,
	ETrackedDeviceProperty_Prop_Axis0Type_Int32 = 3002,
	ETrackedDeviceProperty_Prop_Axis1Type_Int32 = 3003,
	ETrackedDeviceProperty_Prop_Axis2Type_Int32 = 3004,
	ETrackedDeviceProperty_Prop_Axis3Type_Int32 = 3005,
	ETrackedDeviceProperty_Prop_Axis4Type_Int32 = 3006,
	ETrackedDeviceProperty_Prop_ControllerRoleHint_Int32 = 3007,
	ETrackedDeviceProperty_Prop_FieldOfViewLeftDegrees_Float = 4000,
	ETrackedDeviceProperty_Prop_FieldOfViewRightDegrees_Float = 4001,
	ETrackedDeviceProperty_Prop_FieldOfViewTopDegrees_Float = 4002,
	ETrackedDeviceProperty_Prop_FieldOfViewBottomDegrees_Float = 4003,
	ETrackedDeviceProperty_Prop_TrackingRangeMinimumMeters_Float = 4004,
	ETrackedDeviceProperty_Prop_TrackingRangeMaximumMeters_Float = 4005,
	ETrackedDeviceProperty_Prop_ModeLabel_String = 4006,
	ETrackedDeviceProperty_Prop_CanWirelessIdentify_Bool = 4007,
	ETrackedDeviceProperty_Prop_Nonce_Int32 = 4008,
	ETrackedDeviceProperty_Prop_IconPathName_String = 5000,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceOff_String = 5001,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceSearching_String = 5002,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceSearchingAlert_String = 5003,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceReady_String = 5004,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceReadyAlert_String = 5005,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceNotReady_String = 5006,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceStandby_String = 5007,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceAlertLow_String = 5008,
	ETrackedDeviceProperty_Prop_NamedIconPathDeviceStandbyAlert_String = 5009,
	ETrackedDeviceProperty_Prop_DisplayHiddenArea_Binary_Start = 5100,
	ETrackedDeviceProperty_Prop_DisplayHiddenArea_Binary_End = 5150,
	ETrackedDeviceProperty_Prop_ParentContainer = 5151,
	ETrackedDeviceProperty_Prop_OverrideContainer_Uint64 = 5152,
	ETrackedDeviceProperty_Prop_UserConfigPath_String = 6000,
	ETrackedDeviceProperty_Prop_InstallPath_String = 6001,
	ETrackedDeviceProperty_Prop_HasDisplayComponent_Bool = 6002,
	ETrackedDeviceProperty_Prop_HasControllerComponent_Bool = 6003,
	ETrackedDeviceProperty_Prop_HasCameraComponent_Bool = 6004,
	ETrackedDeviceProperty_Prop_HasDriverDirectModeComponent_Bool = 6005,
	ETrackedDeviceProperty_Prop_HasVirtualDisplayComponent_Bool = 6006,
	ETrackedDeviceProperty_Prop_HasSpatialAnchorsSupport_Bool = 6007,
	ETrackedDeviceProperty_Prop_ControllerType_String = 7000,
	ETrackedDeviceProperty_Prop_ControllerHandSelectionPriority_Int32 = 7002,
	ETrackedDeviceProperty_Prop_VendorSpecific_Reserved_Start = 10000,
	ETrackedDeviceProperty_Prop_VendorSpecific_Reserved_End = 10999,
	ETrackedDeviceProperty_Prop_TrackedDeviceProperty_Max = 1000000,
} ETrackedDeviceProperty;

typedef enum ETrackedPropertyError
{
	ETrackedPropertyError_TrackedProp_Success = 0,
	ETrackedPropertyError_TrackedProp_WrongDataType = 1,
	ETrackedPropertyError_TrackedProp_WrongDeviceClass = 2,
	ETrackedPropertyError_TrackedProp_BufferTooSmall = 3,
	ETrackedPropertyError_TrackedProp_UnknownProperty = 4,
	ETrackedPropertyError_TrackedProp_InvalidDevice = 5,
	ETrackedPropertyError_TrackedProp_CouldNotContactServer = 6,
	ETrackedPropertyError_TrackedProp_ValueNotProvidedByDevice = 7,
	ETrackedPropertyError_TrackedProp_StringExceedsMaximumLength = 8,
	ETrackedPropertyError_TrackedProp_NotYetAvailable = 9,
	ETrackedPropertyError_TrackedProp_PermissionDenied = 10,
	ETrackedPropertyError_TrackedProp_InvalidOperation = 11,
	ETrackedPropertyError_TrackedProp_CannotWriteToWildcards = 12,
	ETrackedPropertyError_TrackedProp_IPCReadFailure = 13,
	ETrackedPropertyError_TrackedProp_OutOfMemory = 14,
	ETrackedPropertyError_TrackedProp_InvalidContainer = 15,
} ETrackedPropertyError;

typedef enum EHmdTrackingStyle
{
	EHmdTrackingStyle_HmdTrackingStyle_Unknown = 0,
	EHmdTrackingStyle_HmdTrackingStyle_Lighthouse = 1,
	EHmdTrackingStyle_HmdTrackingStyle_OutsideInCameras = 2,
	EHmdTrackingStyle_HmdTrackingStyle_InsideOutCameras = 3,
} EHmdTrackingStyle;

typedef enum EVRSubmitFlags
{
	EVRSubmitFlags_Submit_Default = 0,
	EVRSubmitFlags_Submit_LensDistortionAlreadyApplied = 1,
	EVRSubmitFlags_Submit_GlRenderBuffer = 2,
	EVRSubmitFlags_Submit_Reserved = 4,
	EVRSubmitFlags_Submit_TextureWithPose = 8,
	EVRSubmitFlags_Submit_TextureWithDepth = 16,
	EVRSubmitFlags_Submit_FrameDiscontinuty = 32,
	EVRSubmitFlags_Submit_VulkanTextureWithArrayData = 64,
	EVRSubmitFlags_Submit_GlArrayTexture = 128,
	EVRSubmitFlags_Submit_Reserved2 = 32768,
	EVRSubmitFlags_Submit_Reserved3 = 65536,
} EVRSubmitFlags;

typedef enum EVRState
{
	EVRState_VRState_Undefined = -1,
	EVRState_VRState_Off = 0,
	EVRState_VRState_Searching = 1,
	EVRState_VRState_Searching_Alert = 2,
	EVRState_VRState_Ready = 3,
	EVRState_VRState_Ready_Alert = 4,
	EVRState_VRState_NotReady = 5,
	EVRState_VRState_Standby = 6,
	EVRState_VRState_Ready_Alert_Low = 7,
} EVRState;

typedef enum EVREventType
{
	EVREventType_VREvent_None = 0,
	EVREventType_VREvent_TrackedDeviceActivated = 100,
	EVREventType_VREvent_TrackedDeviceDeactivated = 101,
	EVREventType_VREvent_TrackedDeviceUpdated = 102,
	EVREventType_VREvent_TrackedDeviceUserInteractionStarted = 103,
	EVREventType_VREvent_TrackedDeviceUserInteractionEnded = 104,
	EVREventType_VREvent_IpdChanged = 105,
	EVREventType_VREvent_EnterStandbyMode = 106,
	EVREventType_VREvent_LeaveStandbyMode = 107,
	EVREventType_VREvent_TrackedDeviceRoleChanged = 108,
	EVREventType_VREvent_WatchdogWakeUpRequested = 109,
	EVREventType_VREvent_LensDistortionChanged = 110,
	EVREventType_VREvent_PropertyChanged = 111,
	EVREventType_VREvent_WirelessDisconnect = 112,
	EVREventType_VREvent_WirelessReconnect = 113,
	EVREventType_VREvent_ButtonPress = 200,
	EVREventType_VREvent_ButtonUnpress = 201,
	EVREventType_VREvent_ButtonTouch = 202,
	EVREventType_VREvent_ButtonUntouch = 203,
	EVREventType_VREvent_Modal_Cancel = 257,
	EVREventType_VREvent_MouseMove = 300,
	EVREventType_VREvent_MouseButtonDown = 301,
	EVREventType_VREvent_MouseButtonUp = 302,
	EVREventType_VREvent_FocusEnter = 303,
	EVREventType_VREvent_FocusLeave = 304,
	EVREventType_VREvent_ScrollDiscrete = 305,
	EVREventType_VREvent_TouchPadMove = 306,
	EVREventType_VREvent_OverlayFocusChanged = 307,
	EVREventType_VREvent_ReloadOverlays = 308,
	EVREventType_VREvent_ScrollSmooth = 309,
	EVREventType_VREvent_LockMousePosition = 310,
	EVREventType_VREvent_UnlockMousePosition = 311,
	EVREventType_VREvent_InputFocusCaptured = 400,
	EVREventType_VREvent_InputFocusReleased = 401,
	EVREventType_VREvent_SceneApplicationChanged = 404,
	EVREventType_VREvent_SceneFocusChanged = 405,
	EVREventType_VREvent_InputFocusChanged = 406,
	EVREventType_VREvent_SceneApplicationUsingWrongGraphicsAdapter = 408,
	EVREventType_VREvent_ActionBindingReloaded = 409,
	EVREventType_VREvent_HideRenderModels = 410,
	EVREventType_VREvent_ShowRenderModels = 411,
	EVREventType_VREvent_SceneApplicationStateChanged = 412,
	EVREventType_VREvent_ConsoleOpened = 420,
	EVREventType_VREvent_ConsoleClosed = 421,
	EVREventType_VREvent_OverlayShown = 500,
	EVREventType_VREvent_OverlayHidden = 501,
	EVREventType_VREvent_DashboardActivated = 502,
	EVREventType_VREvent_DashboardDeactivated = 503,
	EVREventType_VREvent_DashboardRequested = 505,
	EVREventType_VREvent_ResetDashboard = 506,
	EVREventType_VREvent_ImageLoaded = 508,
	EVREventType_VREvent_ShowKeyboard = 509,
	EVREventType_VREvent_HideKeyboard = 510,
	EVREventType_VREvent_OverlayGamepadFocusGained = 511,
	EVREventType_VREvent_OverlayGamepadFocusLost = 512,
	EVREventType_VREvent_OverlaySharedTextureChanged = 513,
	EVREventType_VREvent_ScreenshotTriggered = 516,
	EVREventType_VREvent_ImageFailed = 517,
	EVREventType_VREvent_DashboardOverlayCreated = 518,
	EVREventType_VREvent_SwitchGamepadFocus = 519,
	EVREventType_VREvent_RequestScreenshot = 520,
	EVREventType_VREvent_ScreenshotTaken = 521,
	EVREventType_VREvent_ScreenshotFailed = 522,
	EVREventType_VREvent_SubmitScreenshotToDashboard = 523,
	EVREventType_VREvent_ScreenshotProgressToDashboard = 524,
	EVREventType_VREvent_PrimaryDashboardDeviceChanged = 525,
	EVREventType_VREvent_RoomViewShown = 526,
	EVREventType_VREvent_RoomViewHidden = 527,
	EVREventType_VREvent_ShowUI = 528,
	EVREventType_VREvent_ShowDevTools = 529,
	EVREventType_VREvent_DesktopViewUpdating = 530,
	EVREventType_VREvent_DesktopViewReady = 531,
	EVREventType_VREvent_StartDashboard = 532,
	EVREventType_VREvent_ElevatePrism = 533,
	EVREventType_VREvent_OverlayClosed = 534,
	EVREventType_VREvent_Notification_Shown = 600,
	EVREventType_VREvent_Notification_Hidden = 601,
	EVREventType_VREvent_Notification_BeginInteraction = 602,
	EVREventType_VREvent_Notification_Destroyed = 603,
	EVREventType_VREvent_Quit = 700,
	EVREventType_VREvent_ProcessQuit = 701,
	EVREventType_VREvent_QuitAcknowledged = 703,
	EVREventType_VREvent_DriverRequestedQuit = 704,
	EVREventType_VREvent_RestartRequested = 705,
	EVREventType_VREvent_InvalidateSwapTextureSets = 706,
	EVREventType_VREvent_ChaperoneDataHasChanged = 800,
	EVREventType_VREvent_ChaperoneUniverseHasChanged = 801,
	EVREventType_VREvent_ChaperoneTempDataHasChanged = 802,
	EVREventType_VREvent_ChaperoneSettingsHaveChanged = 803,
	EVREventType_VREvent_SeatedZeroPoseReset = 804,
	EVREventType_VREvent_ChaperoneFlushCache = 805,
	EVREventType_VREvent_ChaperoneRoomSetupStarting = 806,
	EVREventType_VREvent_ChaperoneRoomSetupFinished = 807,
	EVREventType_VREvent_StandingZeroPoseReset = 808,
	EVREventType_VREvent_AudioSettingsHaveChanged = 820,
	EVREventType_VREvent_BackgroundSettingHasChanged = 850,
	EVREventType_VREvent_CameraSettingsHaveChanged = 851,
	EVREventType_VREvent_ReprojectionSettingHasChanged = 852,
	EVREventType_VREvent_ModelSkinSettingsHaveChanged = 853,
	EVREventType_VREvent_EnvironmentSettingsHaveChanged = 854,
	EVREventType_VREvent_PowerSettingsHaveChanged = 855,
	EVREventType_VREvent_EnableHomeAppSettingsHaveChanged = 856,
	EVREventType_VREvent_SteamVRSectionSettingChanged = 857,
	EVREventType_VREvent_LighthouseSectionSettingChanged = 858,
	EVREventType_VREvent_NullSectionSettingChanged = 859,
	EVREventType_VREvent_UserInterfaceSectionSettingChanged = 860,
	EVREventType_VREvent_NotificationsSectionSettingChanged = 861,
	EVREventType_VREvent_KeyboardSectionSettingChanged = 862,
	EVREventType_VREvent_PerfSectionSettingChanged = 863,
	EVREventType_VREvent_DashboardSectionSettingChanged = 864,
	EVREventType_VREvent_WebInterfaceSectionSettingChanged = 865,
	EVREventType_VREvent_TrackersSectionSettingChanged = 866,
	EVREventType_VREvent_LastKnownSectionSettingChanged = 867,
	EVREventType_VREvent_DismissedWarningsSectionSettingChanged = 868,
	EVREventType_VREvent_GpuSpeedSectionSettingChanged = 869,
	EVREventType_VREvent_WindowsMRSectionSettingChanged = 870,
	EVREventType_VREvent_OtherSectionSettingChanged = 871,
	EVREventType_VREvent_StatusUpdate = 900,
	EVREventType_VREvent_WebInterface_InstallDriverCompleted = 950,
	EVREventType_VREvent_MCImageUpdated = 1000,
	EVREventType_VREvent_FirmwareUpdateStarted = 1100,
	EVREventType_VREvent_FirmwareUpdateFinished = 1101,
	EVREventType_VREvent_KeyboardClosed = 1200,
	EVREventType_VREvent_KeyboardCharInput = 1201,
	EVREventType_VREvent_KeyboardDone = 1202,
	EVREventType_VREvent_ApplicationListUpdated = 1303,
	EVREventType_VREvent_ApplicationMimeTypeLoad = 1304,
	EVREventType_VREvent_ProcessConnected = 1306,
	EVREventType_VREvent_ProcessDisconnected = 1307,
	EVREventType_VREvent_Compositor_ChaperoneBoundsShown = 1410,
	EVREventType_VREvent_Compositor_ChaperoneBoundsHidden = 1411,
	EVREventType_VREvent_Compositor_DisplayDisconnected = 1412,
	EVREventType_VREvent_Compositor_DisplayReconnected = 1413,
	EVREventType_VREvent_Compositor_HDCPError = 1414,
	EVREventType_VREvent_Compositor_ApplicationNotResponding = 1415,
	EVREventType_VREvent_Compositor_ApplicationResumed = 1416,
	EVREventType_VREvent_Compositor_OutOfVideoMemory = 1417,
	EVREventType_VREvent_Compositor_DisplayModeNotSupported = 1418,
	EVREventType_VREvent_Compositor_StageOverrideReady = 1419,
	EVREventType_VREvent_Compositor_RequestDisconnectReconnect = 1420,
	EVREventType_VREvent_TrackedCamera_StartVideoStream = 1500,
	EVREventType_VREvent_TrackedCamera_StopVideoStream = 1501,
	EVREventType_VREvent_TrackedCamera_PauseVideoStream = 1502,
	EVREventType_VREvent_TrackedCamera_ResumeVideoStream = 1503,
	EVREventType_VREvent_TrackedCamera_EditingSurface = 1550,
	EVREventType_VREvent_PerformanceTest_EnableCapture = 1600,
	EVREventType_VREvent_PerformanceTest_DisableCapture = 1601,
	EVREventType_VREvent_PerformanceTest_FidelityLevel = 1602,
	EVREventType_VREvent_MessageOverlay_Closed = 1650,
	EVREventType_VREvent_MessageOverlayCloseRequested = 1651,
	EVREventType_VREvent_Input_HapticVibration = 1700,
	EVREventType_VREvent_Input_BindingLoadFailed = 1701,
	EVREventType_VREvent_Input_BindingLoadSuccessful = 1702,
	EVREventType_VREvent_Input_ActionManifestReloaded = 1703,
	EVREventType_VREvent_Input_ActionManifestLoadFailed = 1704,
	EVREventType_VREvent_Input_ProgressUpdate = 1705,
	EVREventType_VREvent_Input_TrackerActivated = 1706,
	EVREventType_VREvent_Input_BindingsUpdated = 1707,
	EVREventType_VREvent_Input_BindingSubscriptionChanged = 1708,
	EVREventType_VREvent_SpatialAnchors_PoseUpdated = 1800,
	EVREventType_VREvent_SpatialAnchors_DescriptorUpdated = 1801,
	EVREventType_VREvent_SpatialAnchors_RequestPoseUpdate = 1802,
	EVREventType_VREvent_SpatialAnchors_RequestDescriptorUpdate = 1803,
	EVREventType_VREvent_SystemReport_Started = 1900,
	EVREventType_VREvent_Monitor_ShowHeadsetView = 2000,
	EVREventType_VREvent_Monitor_HideHeadsetView = 2001,
	EVREventType_VREvent_VendorSpecific_Reserved_Start = 10000,
	EVREventType_VREvent_VendorSpecific_Reserved_End = 19999,
} EVREventType;

typedef enum EDeviceActivityLevel
{
	EDeviceActivityLevel_k_EDeviceActivityLevel_Unknown = -1,
	EDeviceActivityLevel_k_EDeviceActivityLevel_Idle = 0,
	EDeviceActivityLevel_k_EDeviceActivityLevel_UserInteraction = 1,
	EDeviceActivityLevel_k_EDeviceActivityLevel_UserInteraction_Timeout = 2,
	EDeviceActivityLevel_k_EDeviceActivityLevel_Standby = 3,
	EDeviceActivityLevel_k_EDeviceActivityLevel_Idle_Timeout = 4,
} EDeviceActivityLevel;

typedef enum EVRButtonId
{
	EVRButtonId_k_EButton_System = 0,
	EVRButtonId_k_EButton_ApplicationMenu = 1,
	EVRButtonId_k_EButton_Grip = 2,
	EVRButtonId_k_EButton_DPad_Left = 3,
	EVRButtonId_k_EButton_DPad_Up = 4,
	EVRButtonId_k_EButton_DPad_Right = 5,
	EVRButtonId_k_EButton_DPad_Down = 6,
	EVRButtonId_k_EButton_A = 7,
	EVRButtonId_k_EButton_ProximitySensor = 31,
	EVRButtonId_k_EButton_Axis0 = 32,
	EVRButtonId_k_EButton_Axis1 = 33,
	EVRButtonId_k_EButton_Axis2 = 34,
	EVRButtonId_k_EButton_Axis3 = 35,
	EVRButtonId_k_EButton_Axis4 = 36,
	EVRButtonId_k_EButton_SteamVR_Touchpad = 32,
	EVRButtonId_k_EButton_SteamVR_Trigger = 33,
	EVRButtonId_k_EButton_Dashboard_Back = 2,
	EVRButtonId_k_EButton_IndexController_A = 2,
	EVRButtonId_k_EButton_IndexController_B = 1,
	EVRButtonId_k_EButton_IndexController_JoyStick = 35,
	EVRButtonId_k_EButton_Max = 64,
} EVRButtonId;

typedef enum EVRMouseButton
{
	EVRMouseButton_VRMouseButton_Left = 1,
	EVRMouseButton_VRMouseButton_Right = 2,
	EVRMouseButton_VRMouseButton_Middle = 4,
} EVRMouseButton;

typedef enum EShowUIType
{
	EShowUIType_ShowUI_ControllerBinding = 0,
	EShowUIType_ShowUI_ManageTrackers = 1,
	EShowUIType_ShowUI_Pairing = 3,
	EShowUIType_ShowUI_Settings = 4,
	EShowUIType_ShowUI_DebugCommands = 5,
	EShowUIType_ShowUI_FullControllerBinding = 6,
	EShowUIType_ShowUI_ManageDrivers = 7,
} EShowUIType;

typedef enum EHDCPError
{
	EHDCPError_HDCPError_None = 0,
	EHDCPError_HDCPError_LinkLost = 1,
	EHDCPError_HDCPError_Tampered = 2,
	EHDCPError_HDCPError_DeviceRevoked = 3,
	EHDCPError_HDCPError_Unknown = 4,
} EHDCPError;

typedef enum EVRComponentProperty
{
	EVRComponentProperty_VRComponentProperty_IsStatic = 1,
	EVRComponentProperty_VRComponentProperty_IsVisible = 2,
	EVRComponentProperty_VRComponentProperty_IsTouched = 4,
	EVRComponentProperty_VRComponentProperty_IsPressed = 8,
	EVRComponentProperty_VRComponentProperty_IsScrolled = 16,
	EVRComponentProperty_VRComponentProperty_IsHighlighted = 32,
} EVRComponentProperty;

typedef enum EVRInputError
{
	EVRInputError_VRInputError_None = 0,
	EVRInputError_VRInputError_NameNotFound = 1,
	EVRInputError_VRInputError_WrongType = 2,
	EVRInputError_VRInputError_InvalidHandle = 3,
	EVRInputError_VRInputError_InvalidParam = 4,
	EVRInputError_VRInputError_NoSteam = 5,
	EVRInputError_VRInputError_MaxCapacityReached = 6,
	EVRInputError_VRInputError_IPCError = 7,
	EVRInputError_VRInputError_NoActiveActionSet = 8,
	EVRInputError_VRInputError_InvalidDevice = 9,
	EVRInputError_VRInputError_InvalidSkeleton = 10,
	EVRInputError_VRInputError_InvalidBoneCount = 11,
	EVRInputError_VRInputError_InvalidCompressedData = 12,
	EVRInputError_VRInputError_NoData = 13,
	EVRInputError_VRInputError_BufferTooSmall = 14,
	EVRInputError_VRInputError_MismatchedActionManifest = 15,
	EVRInputError_VRInputError_MissingSkeletonData = 16,
	EVRInputError_VRInputError_InvalidBoneIndex = 17,
	EVRInputError_VRInputError_InvalidPriority = 18,
	EVRInputError_VRInputError_PermissionDenied = 19,
	EVRInputError_VRInputError_InvalidRenderModel = 20,
} EVRInputError;

typedef enum EVRSpatialAnchorError
{
	EVRSpatialAnchorError_VRSpatialAnchorError_Success = 0,
	EVRSpatialAnchorError_VRSpatialAnchorError_Internal = 1,
	EVRSpatialAnchorError_VRSpatialAnchorError_UnknownHandle = 2,
	EVRSpatialAnchorError_VRSpatialAnchorError_ArrayTooSmall = 3,
	EVRSpatialAnchorError_VRSpatialAnchorError_InvalidDescriptorChar = 4,
	EVRSpatialAnchorError_VRSpatialAnchorError_NotYetAvailable = 5,
	EVRSpatialAnchorError_VRSpatialAnchorError_NotAvailableInThisUniverse = 6,
	EVRSpatialAnchorError_VRSpatialAnchorError_PermanentlyUnavailable = 7,
	EVRSpatialAnchorError_VRSpatialAnchorError_WrongDriver = 8,
	EVRSpatialAnchorError_VRSpatialAnchorError_DescriptorTooLong = 9,
	EVRSpatialAnchorError_VRSpatialAnchorError_Unknown = 10,
	EVRSpatialAnchorError_VRSpatialAnchorError_NoRoomCalibration = 11,
	EVRSpatialAnchorError_VRSpatialAnchorError_InvalidArgument = 12,
	EVRSpatialAnchorError_VRSpatialAnchorError_UnknownDriver = 13,
} EVRSpatialAnchorError;

typedef enum EHiddenAreaMeshType
{
	EHiddenAreaMeshType_k_eHiddenAreaMesh_Standard = 0,
	EHiddenAreaMeshType_k_eHiddenAreaMesh_Inverse = 1,
	EHiddenAreaMeshType_k_eHiddenAreaMesh_LineLoop = 2,
	EHiddenAreaMeshType_k_eHiddenAreaMesh_Max = 3,
} EHiddenAreaMeshType;

typedef enum EVRControllerAxisType
{
	EVRControllerAxisType_k_eControllerAxis_None = 0,
	EVRControllerAxisType_k_eControllerAxis_TrackPad = 1,
	EVRControllerAxisType_k_eControllerAxis_Joystick = 2,
	EVRControllerAxisType_k_eControllerAxis_Trigger = 3,
} EVRControllerAxisType;

typedef enum EVRControllerEventOutputType
{
	EVRControllerEventOutputType_ControllerEventOutput_OSEvents = 0,
	EVRControllerEventOutputType_ControllerEventOutput_VREvents = 1,
} EVRControllerEventOutputType;

typedef enum ECollisionBoundsStyle
{
	ECollisionBoundsStyle_COLLISION_BOUNDS_STYLE_BEGINNER = 0,
	ECollisionBoundsStyle_COLLISION_BOUNDS_STYLE_INTERMEDIATE = 1,
	ECollisionBoundsStyle_COLLISION_BOUNDS_STYLE_SQUARES = 2,
	ECollisionBoundsStyle_COLLISION_BOUNDS_STYLE_ADVANCED = 3,
	ECollisionBoundsStyle_COLLISION_BOUNDS_STYLE_NONE = 4,
	ECollisionBoundsStyle_COLLISION_BOUNDS_STYLE_COUNT = 5,
} ECollisionBoundsStyle;

typedef enum EVROverlayError
{
	EVROverlayError_VROverlayError_None = 0,
	EVROverlayError_VROverlayError_UnknownOverlay = 10,
	EVROverlayError_VROverlayError_InvalidHandle = 11,
	EVROverlayError_VROverlayError_PermissionDenied = 12,
	EVROverlayError_VROverlayError_OverlayLimitExceeded = 13,
	EVROverlayError_VROverlayError_WrongVisibilityType = 14,
	EVROverlayError_VROverlayError_KeyTooLong = 15,
	EVROverlayError_VROverlayError_NameTooLong = 16,
	EVROverlayError_VROverlayError_KeyInUse = 17,
	EVROverlayError_VROverlayError_WrongTransformType = 18,
	EVROverlayError_VROverlayError_InvalidTrackedDevice = 19,
	EVROverlayError_VROverlayError_InvalidParameter = 20,
	EVROverlayError_VROverlayError_ThumbnailCantBeDestroyed = 21,
	EVROverlayError_VROverlayError_ArrayTooSmall = 22,
	EVROverlayError_VROverlayError_RequestFailed = 23,
	EVROverlayError_VROverlayError_InvalidTexture = 24,
	EVROverlayError_VROverlayError_UnableToLoadFile = 25,
	EVROverlayError_VROverlayError_KeyboardAlreadyInUse = 26,
	EVROverlayError_VROverlayError_NoNeighbor = 27,
	EVROverlayError_VROverlayError_TooManyMaskPrimitives = 29,
	EVROverlayError_VROverlayError_BadMaskPrimitive = 30,
	EVROverlayError_VROverlayError_TextureAlreadyLocked = 31,
	EVROverlayError_VROverlayError_TextureLockCapacityReached = 32,
	EVROverlayError_VROverlayError_TextureNotLocked = 33,
	EVROverlayError_VROverlayError_TimedOut = 34,
} EVROverlayError;

typedef enum EVRApplicationType
{
	EVRApplicationType_VRApplication_Other = 0,
	EVRApplicationType_VRApplication_Scene = 1,
	EVRApplicationType_VRApplication_Overlay = 2,
	EVRApplicationType_VRApplication_Background = 3,
	EVRApplicationType_VRApplication_Utility = 4,
	EVRApplicationType_VRApplication_VRMonitor = 5,
	EVRApplicationType_VRApplication_SteamWatchdog = 6,
	EVRApplicationType_VRApplication_Bootstrapper = 7,
	EVRApplicationType_VRApplication_WebHelper = 8,
	EVRApplicationType_VRApplication_OpenXRInstance = 9,
	EVRApplicationType_VRApplication_OpenXRScene = 10,
	EVRApplicationType_VRApplication_OpenXROverlay = 11,
	EVRApplicationType_VRApplication_Prism = 12,
	EVRApplicationType_VRApplication_RoomView = 13,
	EVRApplicationType_VRApplication_Max = 14,
} EVRApplicationType;

typedef enum EVRFirmwareError
{
	EVRFirmwareError_VRFirmwareError_None = 0,
	EVRFirmwareError_VRFirmwareError_Success = 1,
	EVRFirmwareError_VRFirmwareError_Fail = 2,
} EVRFirmwareError;

typedef enum EVRNotificationError
{
	EVRNotificationError_VRNotificationError_OK = 0,
	EVRNotificationError_VRNotificationError_InvalidNotificationId = 100,
	EVRNotificationError_VRNotificationError_NotificationQueueFull = 101,
	EVRNotificationError_VRNotificationError_InvalidOverlayHandle = 102,
	EVRNotificationError_VRNotificationError_SystemWithUserValueAlreadyExists = 103,
} EVRNotificationError;

typedef enum EVRSkeletalMotionRange
{
	EVRSkeletalMotionRange_VRSkeletalMotionRange_WithController = 0,
	EVRSkeletalMotionRange_VRSkeletalMotionRange_WithoutController = 1,
} EVRSkeletalMotionRange;

typedef enum EVRSkeletalTrackingLevel
{
	EVRSkeletalTrackingLevel_VRSkeletalTracking_Estimated = 0,
	EVRSkeletalTrackingLevel_VRSkeletalTracking_Partial = 1,
	EVRSkeletalTrackingLevel_VRSkeletalTracking_Full = 2,
	EVRSkeletalTrackingLevel_VRSkeletalTrackingLevel_Count = 3,
	EVRSkeletalTrackingLevel_VRSkeletalTrackingLevel_Max = 2,
} EVRSkeletalTrackingLevel;

typedef enum EVRInitError
{
	EVRInitError_VRInitError_None = 0,
	EVRInitError_VRInitError_Unknown = 1,
	EVRInitError_VRInitError_Init_InstallationNotFound = 100,
	EVRInitError_VRInitError_Init_InstallationCorrupt = 101,
	EVRInitError_VRInitError_Init_VRClientDLLNotFound = 102,
	EVRInitError_VRInitError_Init_FileNotFound = 103,
	EVRInitError_VRInitError_Init_FactoryNotFound = 104,
	EVRInitError_VRInitError_Init_InterfaceNotFound = 105,
	EVRInitError_VRInitError_Init_InvalidInterface = 106,
	EVRInitError_VRInitError_Init_UserConfigDirectoryInvalid = 107,
	EVRInitError_VRInitError_Init_HmdNotFound = 108,
	EVRInitError_VRInitError_Init_NotInitialized = 109,
	EVRInitError_VRInitError_Init_PathRegistryNotFound = 110,
	EVRInitError_VRInitError_Init_NoConfigPath = 111,
	EVRInitError_VRInitError_Init_NoLogPath = 112,
	EVRInitError_VRInitError_Init_PathRegistryNotWritable = 113,
	EVRInitError_VRInitError_Init_AppInfoInitFailed = 114,
	EVRInitError_VRInitError_Init_Retry = 115,
	EVRInitError_VRInitError_Init_InitCanceledByUser = 116,
	EVRInitError_VRInitError_Init_AnotherAppLaunching = 117,
	EVRInitError_VRInitError_Init_SettingsInitFailed = 118,
	EVRInitError_VRInitError_Init_ShuttingDown = 119,
	EVRInitError_VRInitError_Init_TooManyObjects = 120,
	EVRInitError_VRInitError_Init_NoServerForBackgroundApp = 121,
	EVRInitError_VRInitError_Init_NotSupportedWithCompositor = 122,
	EVRInitError_VRInitError_Init_NotAvailableToUtilityApps = 123,
	EVRInitError_VRInitError_Init_Internal = 124,
	EVRInitError_VRInitError_Init_HmdDriverIdIsNone = 125,
	EVRInitError_VRInitError_Init_HmdNotFoundPresenceFailed = 126,
	EVRInitError_VRInitError_Init_VRMonitorNotFound = 127,
	EVRInitError_VRInitError_Init_VRMonitorStartupFailed = 128,
	EVRInitError_VRInitError_Init_LowPowerWatchdogNotSupported = 129,
	EVRInitError_VRInitError_Init_InvalidApplicationType = 130,
	EVRInitError_VRInitError_Init_NotAvailableToWatchdogApps = 131,
	EVRInitError_VRInitError_Init_WatchdogDisabledInSettings = 132,
	EVRInitError_VRInitError_Init_VRDashboardNotFound = 133,
	EVRInitError_VRInitError_Init_VRDashboardStartupFailed = 134,
	EVRInitError_VRInitError_Init_VRHomeNotFound = 135,
	EVRInitError_VRInitError_Init_VRHomeStartupFailed = 136,
	EVRInitError_VRInitError_Init_RebootingBusy = 137,
	EVRInitError_VRInitError_Init_FirmwareUpdateBusy = 138,
	EVRInitError_VRInitError_Init_FirmwareRecoveryBusy = 139,
	EVRInitError_VRInitError_Init_USBServiceBusy = 140,
	EVRInitError_VRInitError_Init_VRWebHelperStartupFailed = 141,
	EVRInitError_VRInitError_Init_TrackerManagerInitFailed = 142,
	EVRInitError_VRInitError_Init_AlreadyRunning = 143,
	EVRInitError_VRInitError_Init_FailedForVrMonitor = 144,
	EVRInitError_VRInitError_Init_PropertyManagerInitFailed = 145,
	EVRInitError_VRInitError_Init_WebServerFailed = 146,
	EVRInitError_VRInitError_Init_IllegalTypeTransition = 147,
	EVRInitError_VRInitError_Init_MismatchedRuntimes = 148,
	EVRInitError_VRInitError_Init_InvalidProcessId = 149,
	EVRInitError_VRInitError_Init_VRServiceStartupFailed = 150,
	EVRInitError_VRInitError_Init_PrismNeedsNewDrivers = 151,
	EVRInitError_VRInitError_Init_PrismStartupTimedOut = 152,
	EVRInitError_VRInitError_Init_CouldNotStartPrism = 153,
	EVRInitError_VRInitError_Init_PrismClientInitFailed = 154,
	EVRInitError_VRInitError_Init_PrismClientStartFailed = 155,
	EVRInitError_VRInitError_Init_PrismExitedUnexpectedly = 156,
	EVRInitError_VRInitError_Init_BadLuid = 157,
	EVRInitError_VRInitError_Init_NoServerForAppContainer = 158,
	EVRInitError_VRInitError_Init_DuplicateBootstrapper = 159,
	EVRInitError_VRInitError_Init_VRDashboardServicePending = 160,
	EVRInitError_VRInitError_Init_VRDashboardServiceTimeout = 161,
	EVRInitError_VRInitError_Init_VRDashboardServiceStopped = 162,
	EVRInitError_VRInitError_Init_VRDashboardAlreadyStarted = 163,
	EVRInitError_VRInitError_Init_VRDashboardCopyFailed = 164,
	EVRInitError_VRInitError_Init_VRDashboardTokenFailure = 165,
	EVRInitError_VRInitError_Init_VRDashboardEnvironmentFailure = 166,
	EVRInitError_VRInitError_Init_VRDashboardPathFailure = 167,
	EVRInitError_VRInitError_Driver_Failed = 200,
	EVRInitError_VRInitError_Driver_Unknown = 201,
	EVRInitError_VRInitError_Driver_HmdUnknown = 202,
	EVRInitError_VRInitError_Driver_NotLoaded = 203,
	EVRInitError_VRInitError_Driver_RuntimeOutOfDate = 204,
	EVRInitError_VRInitError_Driver_HmdInUse = 205,
	EVRInitError_VRInitError_Driver_NotCalibrated = 206,
	EVRInitError_VRInitError_Driver_CalibrationInvalid = 207,
	EVRInitError_VRInitError_Driver_HmdDisplayNotFound = 208,
	EVRInitError_VRInitError_Driver_TrackedDeviceInterfaceUnknown = 209,
	EVRInitError_VRInitError_Driver_HmdDriverIdOutOfBounds = 211,
	EVRInitError_VRInitError_Driver_HmdDisplayMirrored = 212,
	EVRInitError_VRInitError_Driver_HmdDisplayNotFoundLaptop = 213,
	EVRInitError_VRInitError_Driver_PeerDriverNotInstalled = 214,
	EVRInitError_VRInitError_Driver_WirelessHmdNotConnected = 215,
	EVRInitError_VRInitError_IPC_ServerInitFailed = 300,
	EVRInitError_VRInitError_IPC_ConnectFailed = 301,
	EVRInitError_VRInitError_IPC_SharedStateInitFailed = 302,
	EVRInitError_VRInitError_IPC_CompositorInitFailed = 303,
	EVRInitError_VRInitError_IPC_MutexInitFailed = 304,
	EVRInitError_VRInitError_IPC_Failed = 305,
	EVRInitError_VRInitError_IPC_CompositorConnectFailed = 306,
	EVRInitError_VRInitError_IPC_CompositorInvalidConnectResponse = 307,
	EVRInitError_VRInitError_IPC_ConnectFailedAfterMultipleAttempts = 308,
	EVRInitError_VRInitError_IPC_ConnectFailedAfterTargetExited = 309,
	EVRInitError_VRInitError_IPC_NamespaceUnavailable = 310,
	EVRInitError_VRInitError_Compositor_Failed = 400,
	EVRInitError_VRInitError_Compositor_D3D11HardwareRequired = 401,
	EVRInitError_VRInitError_Compositor_FirmwareRequiresUpdate = 402,
	EVRInitError_VRInitError_Compositor_OverlayInitFailed = 403,
	EVRInitError_VRInitError_Compositor_ScreenshotsInitFailed = 404,
	EVRInitError_VRInitError_Compositor_UnableToCreateDevice = 405,
	EVRInitError_VRInitError_Compositor_SharedStateIsNull = 406,
	EVRInitError_VRInitError_Compositor_NotificationManagerIsNull = 407,
	EVRInitError_VRInitError_Compositor_ResourceManagerClientIsNull = 408,
	EVRInitError_VRInitError_Compositor_MessageOverlaySharedStateInitFailure = 409,
	EVRInitError_VRInitError_Compositor_PropertiesInterfaceIsNull = 410,
	EVRInitError_VRInitError_Compositor_CreateFullscreenWindowFailed = 411,
	EVRInitError_VRInitError_Compositor_SettingsInterfaceIsNull = 412,
	EVRInitError_VRInitError_Compositor_FailedToShowWindow = 413,
	EVRInitError_VRInitError_Compositor_DistortInterfaceIsNull = 414,
	EVRInitError_VRInitError_Compositor_DisplayFrequencyFailure = 415,
	EVRInitError_VRInitError_Compositor_RendererInitializationFailed = 416,
	EVRInitError_VRInitError_Compositor_DXGIFactoryInterfaceIsNull = 417,
	EVRInitError_VRInitError_Compositor_DXGIFactoryCreateFailed = 418,
	EVRInitError_VRInitError_Compositor_DXGIFactoryQueryFailed = 419,
	EVRInitError_VRInitError_Compositor_InvalidAdapterDesktop = 420,
	EVRInitError_VRInitError_Compositor_InvalidHmdAttachment = 421,
	EVRInitError_VRInitError_Compositor_InvalidOutputDesktop = 422,
	EVRInitError_VRInitError_Compositor_InvalidDeviceProvided = 423,
	EVRInitError_VRInitError_Compositor_D3D11RendererInitializationFailed = 424,
	EVRInitError_VRInitError_Compositor_FailedToFindDisplayMode = 425,
	EVRInitError_VRInitError_Compositor_FailedToCreateSwapChain = 426,
	EVRInitError_VRInitError_Compositor_FailedToGetBackBuffer = 427,
	EVRInitError_VRInitError_Compositor_FailedToCreateRenderTarget = 428,
	EVRInitError_VRInitError_Compositor_FailedToCreateDXGI2SwapChain = 429,
	EVRInitError_VRInitError_Compositor_FailedtoGetDXGI2BackBuffer = 430,
	EVRInitError_VRInitError_Compositor_FailedToCreateDXGI2RenderTarget = 431,
	EVRInitError_VRInitError_Compositor_FailedToGetDXGIDeviceInterface = 432,
	EVRInitError_VRInitError_Compositor_SelectDisplayMode = 433,
	EVRInitError_VRInitError_Compositor_FailedToCreateNvAPIRenderTargets = 434,
	EVRInitError_VRInitError_Compositor_NvAPISetDisplayMode = 435,
	EVRInitError_VRInitError_Compositor_FailedToCreateDirectModeDisplay = 436,
	EVRInitError_VRInitError_Compositor_InvalidHmdPropertyContainer = 437,
	EVRInitError_VRInitError_Compositor_UpdateDisplayFrequency = 438,
	EVRInitError_VRInitError_Compositor_CreateRasterizerState = 439,
	EVRInitError_VRInitError_Compositor_CreateWireframeRasterizerState = 440,
	EVRInitError_VRInitError_Compositor_CreateSamplerState = 441,
	EVRInitError_VRInitError_Compositor_CreateClampToBorderSamplerState = 442,
	EVRInitError_VRInitError_Compositor_CreateAnisoSamplerState = 443,
	EVRInitError_VRInitError_Compositor_CreateOverlaySamplerState = 444,
	EVRInitError_VRInitError_Compositor_CreatePanoramaSamplerState = 445,
	EVRInitError_VRInitError_Compositor_CreateFontSamplerState = 446,
	EVRInitError_VRInitError_Compositor_CreateNoBlendState = 447,
	EVRInitError_VRInitError_Compositor_CreateBlendState = 448,
	EVRInitError_VRInitError_Compositor_CreateAlphaBlendState = 449,
	EVRInitError_VRInitError_Compositor_CreateBlendStateMaskR = 450,
	EVRInitError_VRInitError_Compositor_CreateBlendStateMaskG = 451,
	EVRInitError_VRInitError_Compositor_CreateBlendStateMaskB = 452,
	EVRInitError_VRInitError_Compositor_CreateDepthStencilState = 453,
	EVRInitError_VRInitError_Compositor_CreateDepthStencilStateNoWrite = 454,
	EVRInitError_VRInitError_Compositor_CreateDepthStencilStateNoDepth = 455,
	EVRInitError_VRInitError_Compositor_CreateFlushTexture = 456,
	EVRInitError_VRInitError_Compositor_CreateDistortionSurfaces = 457,
	EVRInitError_VRInitError_Compositor_CreateConstantBuffer = 458,
	EVRInitError_VRInitError_Compositor_CreateHmdPoseConstantBuffer = 459,
	EVRInitError_VRInitError_Compositor_CreateHmdPoseStagingConstantBuffer = 460,
	EVRInitError_VRInitError_Compositor_CreateSharedFrameInfoConstantBuffer = 461,
	EVRInitError_VRInitError_Compositor_CreateOverlayConstantBuffer = 462,
	EVRInitError_VRInitError_Compositor_CreateSceneTextureIndexConstantBuffer = 463,
	EVRInitError_VRInitError_Compositor_CreateReadableSceneTextureIndexConstantBuffer = 464,
	EVRInitError_VRInitError_Compositor_CreateLayerGraphicsTextureIndexConstantBuffer = 465,
	EVRInitError_VRInitError_Compositor_CreateLayerComputeTextureIndexConstantBuffer = 466,
	EVRInitError_VRInitError_Compositor_CreateLayerComputeSceneTextureIndexConstantBuffer = 467,
	EVRInitError_VRInitError_Compositor_CreateComputeHmdPoseConstantBuffer = 468,
	EVRInitError_VRInitError_Compositor_CreateGeomConstantBuffer = 469,
	EVRInitError_VRInitError_Compositor_CreatePanelMaskConstantBuffer = 470,
	EVRInitError_VRInitError_Compositor_CreatePixelSimUBO = 471,
	EVRInitError_VRInitError_Compositor_CreateMSAARenderTextures = 472,
	EVRInitError_VRInitError_Compositor_CreateResolveRenderTextures = 473,
	EVRInitError_VRInitError_Compositor_CreateComputeResolveRenderTextures = 474,
	EVRInitError_VRInitError_Compositor_CreateDriverDirectModeResolveTextures = 475,
	EVRInitError_VRInitError_Compositor_OpenDriverDirectModeResolveTextures = 476,
	EVRInitError_VRInitError_Compositor_CreateFallbackSyncTexture = 477,
	EVRInitError_VRInitError_Compositor_ShareFallbackSyncTexture = 478,
	EVRInitError_VRInitError_Compositor_CreateOverlayIndexBuffer = 479,
	EVRInitError_VRInitError_Compositor_CreateOverlayVertexBuffer = 480,
	EVRInitError_VRInitError_Compositor_CreateTextVertexBuffer = 481,
	EVRInitError_VRInitError_Compositor_CreateTextIndexBuffer = 482,
	EVRInitError_VRInitError_Compositor_CreateMirrorTextures = 483,
	EVRInitError_VRInitError_Compositor_CreateLastFrameRenderTexture = 484,
	EVRInitError_VRInitError_Compositor_CreateMirrorOverlay = 485,
	EVRInitError_VRInitError_Compositor_FailedToCreateVirtualDisplayBackbuffer = 486,
	EVRInitError_VRInitError_Compositor_DisplayModeNotSupported = 487,
	EVRInitError_VRInitError_Compositor_CreateOverlayInvalidCall = 488,
	EVRInitError_VRInitError_Compositor_CreateOverlayAlreadyInitialized = 489,
	EVRInitError_VRInitError_Compositor_FailedToCreateMailbox = 490,
	EVRInitError_VRInitError_Compositor_WindowInterfaceIsNull = 491,
	EVRInitError_VRInitError_Compositor_SystemLayerCreateInstance = 492,
	EVRInitError_VRInitError_Compositor_SystemLayerCreateSession = 493,
	EVRInitError_VRInitError_Compositor_CreateInverseDistortUVs = 494,
	EVRInitError_VRInitError_Compositor_CreateBackbufferDepth = 495,
	EVRInitError_VRInitError_VendorSpecific_UnableToConnectToOculusRuntime = 1000,
	EVRInitError_VRInitError_VendorSpecific_WindowsNotInDevMode = 1001,
	EVRInitError_VRInitError_VendorSpecific_OculusLinkNotEnabled = 1002,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_CantOpenDevice = 1101,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UnableToRequestConfigStart = 1102,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_NoStoredConfig = 1103,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_ConfigTooBig = 1104,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_ConfigTooSmall = 1105,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UnableToInitZLib = 1106,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_CantReadFirmwareVersion = 1107,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UnableToSendUserDataStart = 1108,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UnableToGetUserDataStart = 1109,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UnableToGetUserDataNext = 1110,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UserDataAddressRange = 1111,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UserDataError = 1112,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_ConfigFailedSanityCheck = 1113,
	EVRInitError_VRInitError_VendorSpecific_OculusRuntimeBadInstall = 1114,
	EVRInitError_VRInitError_VendorSpecific_HmdFound_UnexpectedConfiguration_1 = 1115,
	EVRInitError_VRInitError_Steam_SteamInstallationNotFound = 2000,
	EVRInitError_VRInitError_LastError = 2001,
} EVRInitError;

typedef enum EVRScreenshotType
{
	EVRScreenshotType_VRScreenshotType_None = 0,
	EVRScreenshotType_VRScreenshotType_Mono = 1,
	EVRScreenshotType_VRScreenshotType_Stereo = 2,
	EVRScreenshotType_VRScreenshotType_Cubemap = 3,
	EVRScreenshotType_VRScreenshotType_MonoPanorama = 4,
	EVRScreenshotType_VRScreenshotType_StereoPanorama = 5,
} EVRScreenshotType;

typedef enum EVRScreenshotPropertyFilenames
{
	EVRScreenshotPropertyFilenames_VRScreenshotPropertyFilenames_Preview = 0,
	EVRScreenshotPropertyFilenames_VRScreenshotPropertyFilenames_VR = 1,
} EVRScreenshotPropertyFilenames;

typedef enum EVRTrackedCameraError
{
	EVRTrackedCameraError_VRTrackedCameraError_None = 0,
	EVRTrackedCameraError_VRTrackedCameraError_OperationFailed = 100,
	EVRTrackedCameraError_VRTrackedCameraError_InvalidHandle = 101,
	EVRTrackedCameraError_VRTrackedCameraError_InvalidFrameHeaderVersion = 102,
	EVRTrackedCameraError_VRTrackedCameraError_OutOfHandles = 103,
	EVRTrackedCameraError_VRTrackedCameraError_IPCFailure = 104,
	EVRTrackedCameraError_VRTrackedCameraError_NotSupportedForThisDevice = 105,
	EVRTrackedCameraError_VRTrackedCameraError_SharedMemoryFailure = 106,
	EVRTrackedCameraError_VRTrackedCameraError_FrameBufferingFailure = 107,
	EVRTrackedCameraError_VRTrackedCameraError_StreamSetupFailure = 108,
	EVRTrackedCameraError_VRTrackedCameraError_InvalidGLTextureId = 109,
	EVRTrackedCameraError_VRTrackedCameraError_InvalidSharedTextureHandle = 110,
	EVRTrackedCameraError_VRTrackedCameraError_FailedToGetGLTextureId = 111,
	EVRTrackedCameraError_VRTrackedCameraError_SharedTextureFailure = 112,
	EVRTrackedCameraError_VRTrackedCameraError_NoFrameAvailable = 113,
	EVRTrackedCameraError_VRTrackedCameraError_InvalidArgument = 114,
	EVRTrackedCameraError_VRTrackedCameraError_InvalidFrameBufferSize = 115,
} EVRTrackedCameraError;

typedef enum EVRTrackedCameraFrameLayout
{
	EVRTrackedCameraFrameLayout_Mono = 1,
	EVRTrackedCameraFrameLayout_Stereo = 2,
	EVRTrackedCameraFrameLayout_VerticalLayout = 16,
	EVRTrackedCameraFrameLayout_HorizontalLayout = 32,
} EVRTrackedCameraFrameLayout;

typedef enum EVRTrackedCameraFrameType
{
	EVRTrackedCameraFrameType_VRTrackedCameraFrameType_Distorted = 0,
	EVRTrackedCameraFrameType_VRTrackedCameraFrameType_Undistorted = 1,
	EVRTrackedCameraFrameType_VRTrackedCameraFrameType_MaximumUndistorted = 2,
	EVRTrackedCameraFrameType_MAX_CAMERA_FRAME_TYPES = 3,
} EVRTrackedCameraFrameType;

typedef enum EVRDistortionFunctionType
{
	EVRDistortionFunctionType_VRDistortionFunctionType_None = 0,
	EVRDistortionFunctionType_VRDistortionFunctionType_FTheta = 1,
	EVRDistortionFunctionType_VRDistortionFunctionType_Extended_FTheta = 2,
	EVRDistortionFunctionType_MAX_DISTORTION_FUNCTION_TYPES = 3,
} EVRDistortionFunctionType;

typedef enum EVSync
{
	EVSync_VSync_None = 0,
	EVSync_VSync_WaitRender = 1,
	EVSync_VSync_NoWaitRender = 2,
} EVSync;

typedef enum EVRMuraCorrectionMode
{
	EVRMuraCorrectionMode_Default = 0,
	EVRMuraCorrectionMode_NoCorrection = 1,
} EVRMuraCorrectionMode;

typedef enum Imu_OffScaleFlags
{
	Imu_OffScaleFlags_OffScale_AccelX = 1,
	Imu_OffScaleFlags_OffScale_AccelY = 2,
	Imu_OffScaleFlags_OffScale_AccelZ = 4,
	Imu_OffScaleFlags_OffScale_GyroX = 8,
	Imu_OffScaleFlags_OffScale_GyroY = 16,
	Imu_OffScaleFlags_OffScale_GyroZ = 32,
} Imu_OffScaleFlags;

typedef enum EVRApplicationError
{
	EVRApplicationError_VRApplicationError_None = 0,
	EVRApplicationError_VRApplicationError_AppKeyAlreadyExists = 100,
	EVRApplicationError_VRApplicationError_NoManifest = 101,
	EVRApplicationError_VRApplicationError_NoApplication = 102,
	EVRApplicationError_VRApplicationError_InvalidIndex = 103,
	EVRApplicationError_VRApplicationError_UnknownApplication = 104,
	EVRApplicationError_VRApplicationError_IPCFailed = 105,
	EVRApplicationError_VRApplicationError_ApplicationAlreadyRunning = 106,
	EVRApplicationError_VRApplicationError_InvalidManifest = 107,
	EVRApplicationError_VRApplicationError_InvalidApplication = 108,
	EVRApplicationError_VRApplicationError_LaunchFailed = 109,
	EVRApplicationError_VRApplicationError_ApplicationAlreadyStarting = 110,
	EVRApplicationError_VRApplicationError_LaunchInProgress = 111,
	EVRApplicationError_VRApplicationError_OldApplicationQuitting = 112,
	EVRApplicationError_VRApplicationError_TransitionAborted = 113,
	EVRApplicationError_VRApplicationError_IsTemplate = 114,
	EVRApplicationError_VRApplicationError_SteamVRIsExiting = 115,
	EVRApplicationError_VRApplicationError_BufferTooSmall = 200,
	EVRApplicationError_VRApplicationError_PropertyNotSet = 201,
	EVRApplicationError_VRApplicationError_UnknownProperty = 202,
	EVRApplicationError_VRApplicationError_InvalidParameter = 203,
	EVRApplicationError_VRApplicationError_NotImplemented = 300,
} EVRApplicationError;

typedef enum EVRApplicationProperty
{
	EVRApplicationProperty_VRApplicationProperty_Name_String = 0,
	EVRApplicationProperty_VRApplicationProperty_LaunchType_String = 11,
	EVRApplicationProperty_VRApplicationProperty_WorkingDirectory_String = 12,
	EVRApplicationProperty_VRApplicationProperty_BinaryPath_String = 13,
	EVRApplicationProperty_VRApplicationProperty_Arguments_String = 14,
	EVRApplicationProperty_VRApplicationProperty_URL_String = 15,
	EVRApplicationProperty_VRApplicationProperty_Description_String = 50,
	EVRApplicationProperty_VRApplicationProperty_NewsURL_String = 51,
	EVRApplicationProperty_VRApplicationProperty_ImagePath_String = 52,
	EVRApplicationProperty_VRApplicationProperty_Source_String = 53,
	EVRApplicationProperty_VRApplicationProperty_ActionManifestURL_String = 54,
	EVRApplicationProperty_VRApplicationProperty_IsDashboardOverlay_Bool = 60,
	EVRApplicationProperty_VRApplicationProperty_IsTemplate_Bool = 61,
	EVRApplicationProperty_VRApplicationProperty_IsInstanced_Bool = 62,
	EVRApplicationProperty_VRApplicationProperty_IsInternal_Bool = 63,
	EVRApplicationProperty_VRApplicationProperty_WantsCompositorPauseInStandby_Bool = 64,
	EVRApplicationProperty_VRApplicationProperty_IsHidden_Bool = 65,
	EVRApplicationProperty_VRApplicationProperty_LastLaunchTime_Uint64 = 70,
} EVRApplicationProperty;

typedef enum EVRSceneApplicationState
{
	EVRSceneApplicationState_None = 0,
	EVRSceneApplicationState_Starting = 1,
	EVRSceneApplicationState_Quitting = 2,
	EVRSceneApplicationState_Running = 3,
	EVRSceneApplicationState_Waiting = 4,
} EVRSceneApplicationState;

typedef enum ChaperoneCalibrationState
{
	ChaperoneCalibrationState_OK = 1,
	ChaperoneCalibrationState_Warning = 100,
	ChaperoneCalibrationState_Warning_BaseStationMayHaveMoved = 101,
	ChaperoneCalibrationState_Warning_BaseStationRemoved = 102,
	ChaperoneCalibrationState_Warning_SeatedBoundsInvalid = 103,
	ChaperoneCalibrationState_Error = 200,
	ChaperoneCalibrationState_Error_BaseStationUninitialized = 201,
	ChaperoneCalibrationState_Error_BaseStationConflict = 202,
	ChaperoneCalibrationState_Error_PlayAreaInvalid = 203,
	ChaperoneCalibrationState_Error_CollisionBoundsInvalid = 204,
} ChaperoneCalibrationState;

typedef enum EChaperoneConfigFile
{
	EChaperoneConfigFile_Live = 1,
	EChaperoneConfigFile_Temp = 2,
} EChaperoneConfigFile;

typedef enum EChaperoneImportFlags
{
	EChaperoneImportFlags_EChaperoneImport_BoundsOnly = 1,
} EChaperoneImportFlags;

typedef enum EVRCompositorError
{
	EVRCompositorError_VRCompositorError_None = 0,
	EVRCompositorError_VRCompositorError_RequestFailed = 1,
	EVRCompositorError_VRCompositorError_IncompatibleVersion = 100,
	EVRCompositorError_VRCompositorError_DoNotHaveFocus = 101,
	EVRCompositorError_VRCompositorError_InvalidTexture = 102,
	EVRCompositorError_VRCompositorError_IsNotSceneApplication = 103,
	EVRCompositorError_VRCompositorError_TextureIsOnWrongDevice = 104,
	EVRCompositorError_VRCompositorError_TextureUsesUnsupportedFormat = 105,
	EVRCompositorError_VRCompositorError_SharedTexturesNotSupported = 106,
	EVRCompositorError_VRCompositorError_IndexOutOfRange = 107,
	EVRCompositorError_VRCompositorError_AlreadySubmitted = 108,
	EVRCompositorError_VRCompositorError_InvalidBounds = 109,
	EVRCompositorError_VRCompositorError_AlreadySet = 110,
} EVRCompositorError;

typedef enum EVRCompositorTimingMode
{
	EVRCompositorTimingMode_VRCompositorTimingMode_Implicit = 0,
	EVRCompositorTimingMode_VRCompositorTimingMode_Explicit_RuntimePerformsPostPresentHandoff = 1,
	EVRCompositorTimingMode_VRCompositorTimingMode_Explicit_ApplicationPerformsPostPresentHandoff = 2,
} EVRCompositorTimingMode;

typedef enum VROverlayInputMethod
{
	VROverlayInputMethod_None = 0,
	VROverlayInputMethod_Mouse = 1,
} VROverlayInputMethod;

typedef enum VROverlayTransformType
{
	VROverlayTransformType_VROverlayTransform_Invalid = -1,
	VROverlayTransformType_VROverlayTransform_Absolute = 0,
	VROverlayTransformType_VROverlayTransform_TrackedDeviceRelative = 1,
	VROverlayTransformType_VROverlayTransform_SystemOverlay = 2,
	VROverlayTransformType_VROverlayTransform_TrackedComponent = 3,
	VROverlayTransformType_VROverlayTransform_Cursor = 4,
	VROverlayTransformType_VROverlayTransform_DashboardTab = 5,
	VROverlayTransformType_VROverlayTransform_DashboardThumb = 6,
	VROverlayTransformType_VROverlayTransform_Mountable = 7,
	VROverlayTransformType_VROverlayTransform_Projection = 8,
} VROverlayTransformType;

typedef enum VROverlayFlags
{
	VROverlayFlags_NoDashboardTab = 8,
	VROverlayFlags_SendVRDiscreteScrollEvents = 64,
	VROverlayFlags_SendVRTouchpadEvents = 128,
	VROverlayFlags_ShowTouchPadScrollWheel = 256,
	VROverlayFlags_TransferOwnershipToInternalProcess = 512,
	VROverlayFlags_SideBySide_Parallel = 1024,
	VROverlayFlags_SideBySide_Crossed = 2048,
	VROverlayFlags_Panorama = 4096,
	VROverlayFlags_StereoPanorama = 8192,
	VROverlayFlags_SortWithNonSceneOverlays = 16384,
	VROverlayFlags_VisibleInDashboard = 32768,
	VROverlayFlags_MakeOverlaysInteractiveIfVisible = 65536,
	VROverlayFlags_SendVRSmoothScrollEvents = 131072,
	VROverlayFlags_ProtectedContent = 262144,
	VROverlayFlags_HideLaserIntersection = 524288,
	VROverlayFlags_WantsModalBehavior = 1048576,
	VROverlayFlags_IsPremultiplied = 2097152,
	VROverlayFlags_IgnoreTextureAlpha = 4194304,
} VROverlayFlags;

typedef enum VRMessageOverlayResponse
{
	VRMessageOverlayResponse_ButtonPress_0 = 0,
	VRMessageOverlayResponse_ButtonPress_1 = 1,
	VRMessageOverlayResponse_ButtonPress_2 = 2,
	VRMessageOverlayResponse_ButtonPress_3 = 3,
	VRMessageOverlayResponse_CouldntFindSystemOverlay = 4,
	VRMessageOverlayResponse_CouldntFindOrCreateClientOverlay = 5,
	VRMessageOverlayResponse_ApplicationQuit = 6,
} VRMessageOverlayResponse;

typedef enum EGamepadTextInputMode
{
	EGamepadTextInputMode_k_EGamepadTextInputModeNormal = 0,
	EGamepadTextInputMode_k_EGamepadTextInputModePassword = 1,
	EGamepadTextInputMode_k_EGamepadTextInputModeSubmit = 2,
} EGamepadTextInputMode;

typedef enum EGamepadTextInputLineMode
{
	EGamepadTextInputLineMode_k_EGamepadTextInputLineModeSingleLine = 0,
	EGamepadTextInputLineMode_k_EGamepadTextInputLineModeMultipleLines = 1,
} EGamepadTextInputLineMode;

typedef enum EVROverlayIntersectionMaskPrimitiveType
{
	EVROverlayIntersectionMaskPrimitiveType_OverlayIntersectionPrimitiveType_Rectangle = 0,
	EVROverlayIntersectionMaskPrimitiveType_OverlayIntersectionPrimitiveType_Circle = 1,
} EVROverlayIntersectionMaskPrimitiveType;

typedef enum EKeyboardFlags
{
	EKeyboardFlags_KeyboardFlag_Minimal = 1,
	EKeyboardFlags_KeyboardFlag_Modal = 2,
} EKeyboardFlags;

typedef enum EDeviceType
{
	EDeviceType_DeviceType_Invalid = -1,
	EDeviceType_DeviceType_DirectX11 = 0,
	EDeviceType_DeviceType_Vulkan = 1,
} EDeviceType;

typedef enum HeadsetViewMode_t
{
	HeadsetViewMode_t_HeadsetViewMode_Left = 0,
	HeadsetViewMode_t_HeadsetViewMode_Right = 1,
	HeadsetViewMode_t_HeadsetViewMode_Both = 2,
} HeadsetViewMode_t;

typedef enum EVRRenderModelError
{
	EVRRenderModelError_VRRenderModelError_None = 0,
	EVRRenderModelError_VRRenderModelError_Loading = 100,
	EVRRenderModelError_VRRenderModelError_NotSupported = 200,
	EVRRenderModelError_VRRenderModelError_InvalidArg = 300,
	EVRRenderModelError_VRRenderModelError_InvalidModel = 301,
	EVRRenderModelError_VRRenderModelError_NoShapes = 302,
	EVRRenderModelError_VRRenderModelError_MultipleShapes = 303,
	EVRRenderModelError_VRRenderModelError_TooManyVertices = 304,
	EVRRenderModelError_VRRenderModelError_MultipleTextures = 305,
	EVRRenderModelError_VRRenderModelError_BufferTooSmall = 306,
	EVRRenderModelError_VRRenderModelError_NotEnoughNormals = 307,
	EVRRenderModelError_VRRenderModelError_NotEnoughTexCoords = 308,
	EVRRenderModelError_VRRenderModelError_InvalidTexture = 400,
} EVRRenderModelError;

typedef enum EVRRenderModelTextureFormat
{
	EVRRenderModelTextureFormat_VRRenderModelTextureFormat_RGBA8_SRGB = 0,
	EVRRenderModelTextureFormat_VRRenderModelTextureFormat_BC2 = 1,
	EVRRenderModelTextureFormat_VRRenderModelTextureFormat_BC4 = 2,
	EVRRenderModelTextureFormat_VRRenderModelTextureFormat_BC7 = 3,
	EVRRenderModelTextureFormat_VRRenderModelTextureFormat_BC7_SRGB = 4,
	EVRRenderModelTextureFormat_VRRenderModelTextureFormat_RGBA16_FLOAT = 5,
} EVRRenderModelTextureFormat;

typedef enum EVRNotificationType
{
	EVRNotificationType_Transient = 0,
	EVRNotificationType_Persistent = 1,
	EVRNotificationType_Transient_SystemWithUserValue = 2,
} EVRNotificationType;

typedef enum EVRNotificationStyle
{
	EVRNotificationStyle_None = 0,
	EVRNotificationStyle_Application = 100,
	EVRNotificationStyle_Contact_Disabled = 200,
	EVRNotificationStyle_Contact_Enabled = 201,
	EVRNotificationStyle_Contact_Active = 202,
} EVRNotificationStyle;

typedef enum EVRSettingsError
{
	EVRSettingsError_VRSettingsError_None = 0,
	EVRSettingsError_VRSettingsError_IPCFailed = 1,
	EVRSettingsError_VRSettingsError_WriteFailed = 2,
	EVRSettingsError_VRSettingsError_ReadFailed = 3,
	EVRSettingsError_VRSettingsError_JsonParseFailed = 4,
	EVRSettingsError_VRSettingsError_UnsetSettingHasNoDefault = 5,
} EVRSettingsError;

typedef enum EVRScreenshotError
{
	EVRScreenshotError_VRScreenshotError_None = 0,
	EVRScreenshotError_VRScreenshotError_RequestFailed = 1,
	EVRScreenshotError_VRScreenshotError_IncompatibleVersion = 100,
	EVRScreenshotError_VRScreenshotError_NotFound = 101,
	EVRScreenshotError_VRScreenshotError_BufferTooSmall = 102,
	EVRScreenshotError_VRScreenshotError_ScreenshotAlreadyInProgress = 108,
} EVRScreenshotError;

typedef enum EVRSkeletalTransformSpace
{
	EVRSkeletalTransformSpace_VRSkeletalTransformSpace_Model = 0,
	EVRSkeletalTransformSpace_VRSkeletalTransformSpace_Parent = 1,
} EVRSkeletalTransformSpace;

typedef enum EVRSkeletalReferencePose
{
	EVRSkeletalReferencePose_VRSkeletalReferencePose_BindPose = 0,
	EVRSkeletalReferencePose_VRSkeletalReferencePose_OpenHand = 1,
	EVRSkeletalReferencePose_VRSkeletalReferencePose_Fist = 2,
	EVRSkeletalReferencePose_VRSkeletalReferencePose_GripLimit = 3,
} EVRSkeletalReferencePose;

typedef enum EVRFinger
{
	EVRFinger_VRFinger_Thumb = 0,
	EVRFinger_VRFinger_Index = 1,
	EVRFinger_VRFinger_Middle = 2,
	EVRFinger_VRFinger_Ring = 3,
	EVRFinger_VRFinger_Pinky = 4,
	EVRFinger_VRFinger_Count = 5,
} EVRFinger;

typedef enum EVRFingerSplay
{
	EVRFingerSplay_VRFingerSplay_Thumb_Index = 0,
	EVRFingerSplay_VRFingerSplay_Index_Middle = 1,
	EVRFingerSplay_VRFingerSplay_Middle_Ring = 2,
	EVRFingerSplay_VRFingerSplay_Ring_Pinky = 3,
	EVRFingerSplay_VRFingerSplay_Count = 4,
} EVRFingerSplay;

typedef enum EVRSummaryType
{
	EVRSummaryType_VRSummaryType_FromAnimation = 0,
	EVRSummaryType_VRSummaryType_FromDevice = 1,
} EVRSummaryType;

typedef enum EVRInputFilterCancelType
{
	EVRInputFilterCancelType_VRInputFilterCancel_Timers = 0,
	EVRInputFilterCancelType_VRInputFilterCancel_Momentum = 1,
} EVRInputFilterCancelType;

typedef enum EVRInputStringBits
{
	EVRInputStringBits_VRInputString_Hand = 1,
	EVRInputStringBits_VRInputString_ControllerType = 2,
	EVRInputStringBits_VRInputString_InputSource = 4,
	EVRInputStringBits_VRInputString_All = -1,
} EVRInputStringBits;

typedef enum EIOBufferError
{
	EIOBufferError_IOBuffer_Success = 0,
	EIOBufferError_IOBuffer_OperationFailed = 100,
	EIOBufferError_IOBuffer_InvalidHandle = 101,
	EIOBufferError_IOBuffer_InvalidArgument = 102,
	EIOBufferError_IOBuffer_PathExists = 103,
	EIOBufferError_IOBuffer_PathDoesNotExist = 104,
	EIOBufferError_IOBuffer_Permission = 105,
} EIOBufferError;

typedef enum EIOBufferMode
{
	EIOBufferMode_IOBufferMode_Read = 1,
	EIOBufferMode_IOBufferMode_Write = 2,
	EIOBufferMode_IOBufferMode_Create = 512,
} EIOBufferMode;

typedef enum EVRDebugError
{
	EVRDebugError_VRDebugError_Success = 0,
	EVRDebugError_VRDebugError_BadParameter = 1,
} EVRDebugError;

typedef enum EPropertyWriteType
{
	EPropertyWriteType_PropertyWrite_Set = 0,
	EPropertyWriteType_PropertyWrite_Erase = 1,
	EPropertyWriteType_PropertyWrite_SetError = 2,
} EPropertyWriteType;

typedef enum EBlockQueueError
{
	EBlockQueueError_BlockQueueError_None = 0,
	EBlockQueueError_BlockQueueError_QueueAlreadyExists = 1,
	EBlockQueueError_BlockQueueError_QueueNotFound = 2,
	EBlockQueueError_BlockQueueError_BlockNotAvailable = 3,
	EBlockQueueError_BlockQueueError_InvalidHandle = 4,
	EBlockQueueError_BlockQueueError_InvalidParam = 5,
	EBlockQueueError_BlockQueueError_ParamMismatch = 6,
	EBlockQueueError_BlockQueueError_InternalError = 7,
	EBlockQueueError_BlockQueueError_AlreadyInitialized = 8,
	EBlockQueueError_BlockQueueError_OperationIsServerOnly = 9,
	EBlockQueueError_BlockQueueError_TooManyConnections = 10,
} EBlockQueueError;

typedef enum EBlockQueueReadType
{
	EBlockQueueReadType_BlockQueueRead_Latest = 0,
	EBlockQueueReadType_BlockQueueRead_New = 1,
	EBlockQueueReadType_BlockQueueRead_Next = 2,
} EBlockQueueReadType;

typedef enum EBlockQueueCreationFlag
{
	EBlockQueueCreationFlag_BlockQueueFlag_OwnerIsReader = 1,
} EBlockQueueCreationFlag;


// OpenVR typedefs

typedef uint32_t TrackedDeviceIndex_t;
typedef uint32_t VRNotificationId;
typedef uint64_t VROverlayHandle_t;

typedef uint32_t PropertyTypeTag_t;
typedef uint32_t SpatialAnchorHandle_t;
typedef void * glSharedTextureHandle_t;
typedef int32_t glInt_t;
typedef uint32_t glUInt_t;
typedef uint64_t SharedTextureHandle_t;
typedef uint32_t DriverId_t;
typedef uint32_t TrackedDeviceIndex_t;
typedef uint64_t WebConsoleHandle_t;
typedef uint64_t PropertyContainerHandle_t;
typedef uint32_t PropertyTypeTag_t;
typedef PropertyContainerHandle_t DriverHandle_t;
typedef uint64_t VRActionHandle_t;
typedef uint64_t VRActionSetHandle_t;
typedef uint64_t VRInputValueHandle_t;
typedef uint32_t VRComponentProperties;
typedef uint64_t VROverlayHandle_t;
typedef int32_t BoneIndex_t;
typedef uint64_t TrackedCameraHandle_t;
typedef uint32_t ScreenshotHandle_t;
typedef int32_t TextureID_t;
typedef uint32_t VRNotificationId;
typedef uint64_t IOBufferHandle_t;
typedef uint64_t VrProfilerEventHandle_t;
typedef EVRInitError HmdError;
typedef EVREye Hmd_Eye;
typedef EColorSpace ColorSpace;
typedef ETrackingResult HmdTrackingResult;
typedef ETrackedDeviceClass TrackedDeviceClass;
typedef ETrackingUniverseOrigin TrackingUniverseOrigin;
typedef ETrackedDeviceProperty TrackedDeviceProperty;
typedef ETrackedPropertyError TrackedPropertyError;
typedef EVRSubmitFlags VRSubmitFlags_t;
typedef EVRState VRState_t;
typedef ECollisionBoundsStyle CollisionBoundsStyle_t;
typedef EVROverlayError VROverlayError;
typedef EVRFirmwareError VRFirmwareError;
typedef EVRCompositorError VRCompositorError;
typedef EVRScreenshotError VRScreenshotsError;
typedef uint64_t PathHandle_t;

// OpenVR Structs

typedef struct HmdMatrix34_t
{
	float m[3][4]; //float[3][4]
} HmdMatrix34_t;

typedef struct HmdMatrix33_t
{
	float m[3][3]; //float[3][3]
} HmdMatrix33_t;

typedef struct HmdMatrix44_t
{
	float m[4][4]; //float[4][4]
} HmdMatrix44_t;

typedef struct HmdVector3_t
{
	float v[3]; //float[3]
} HmdVector3_t;

typedef struct HmdVector4_t
{
	float v[4]; //float[4]
} HmdVector4_t;

typedef struct HmdVector3d_t
{
	double v[3]; //double[3]
} HmdVector3d_t;

typedef struct HmdVector2_t
{
	float v[2]; //float[2]
} HmdVector2_t;

typedef struct HmdQuaternion_t
{
	double w;
	double x;
	double y;
	double z;
} HmdQuaternion_t;

typedef struct HmdQuaternionf_t
{
	float w;
	float x;
	float y;
	float z;
} HmdQuaternionf_t;

typedef struct HmdColor_t
{
	float r;
	float g;
	float b;
	float a;
} HmdColor_t;

typedef struct HmdQuad_t
{
	struct HmdVector3_t vCorners[4]; //struct vr::HmdVector3_t[4]
} HmdQuad_t;

typedef struct HmdRect2_t
{
	struct HmdVector2_t vTopLeft;
	struct HmdVector2_t vBottomRight;
} HmdRect2_t;

typedef struct VRBoneTransform_t
{
	struct HmdVector4_t position;
	struct HmdQuaternionf_t orientation;
} VRBoneTransform_t;

typedef struct DistortionCoordinates_t
{
	float rfRed[2]; //float[2]
	float rfGreen[2]; //float[2]
	float rfBlue[2]; //float[2]
} DistortionCoordinates_t;

typedef struct Texture_t
{
	void * handle; // void *
	enum ETextureType eType;
	enum EColorSpace eColorSpace;
} Texture_t;

typedef struct TrackedDevicePose_t
{
	struct HmdMatrix34_t mDeviceToAbsoluteTracking;
	struct HmdVector3_t vVelocity;
	struct HmdVector3_t vAngularVelocity;
	enum ETrackingResult eTrackingResult;
	bool bPoseIsValid;
	bool bDeviceIsConnected;
} TrackedDevicePose_t;

typedef struct VRTextureBounds_t
{
	float uMin;
	float vMin;
	float uMax;
	float vMax;
} VRTextureBounds_t;

typedef struct VRTextureWithPose_t
{
	void * handle; // void *
	enum ETextureType eType;
	enum EColorSpace eColorSpace;
	struct HmdMatrix34_t mDeviceToAbsoluteTracking;
} VRTextureWithPose_t;

typedef struct VRTextureDepthInfo_t
{
	void * handle; // void *
	struct HmdMatrix44_t mProjection;
	struct HmdVector2_t vRange;
} VRTextureDepthInfo_t;

typedef struct VRTextureWithDepth_t
{
	void * handle; // void *
	enum ETextureType eType;
	enum EColorSpace eColorSpace;
	struct VRTextureDepthInfo_t depth;
} VRTextureWithDepth_t;

typedef struct VRTextureWithPoseAndDepth_t
{
	void * handle; // void *
	enum ETextureType eType;
	enum EColorSpace eColorSpace;
	struct HmdMatrix34_t mDeviceToAbsoluteTracking;
	struct VRTextureDepthInfo_t depth;
} VRTextureWithPoseAndDepth_t;

typedef struct VRVulkanTextureData_t
{
	uint64_t m_nImage;
	struct VkDevice_T * m_pDevice; // struct VkDevice_T *
	struct VkPhysicalDevice_T * m_pPhysicalDevice; // struct VkPhysicalDevice_T *
	struct VkInstance_T * m_pInstance; // struct VkInstance_T *
	struct VkQueue_T * m_pQueue; // struct VkQueue_T *
	uint32_t m_nQueueFamilyIndex;
	uint32_t m_nWidth;
	uint32_t m_nHeight;
	uint32_t m_nFormat;
	uint32_t m_nSampleCount;
} VRVulkanTextureData_t;

typedef struct VRVulkanTextureArrayData_t
{
	uint32_t m_unArrayIndex;
	uint32_t m_unArraySize;
} VRVulkanTextureArrayData_t;

typedef struct D3D12TextureData_t
{
	struct ID3D12Resource * m_pResource; // struct ID3D12Resource *
	struct ID3D12CommandQueue * m_pCommandQueue; // struct ID3D12CommandQueue *
	uint32_t m_nNodeMask;
} D3D12TextureData_t;

typedef struct VREvent_Controller_t
{
	uint32_t button;
} VREvent_Controller_t;

typedef struct VREvent_Mouse_t
{
	float x;
	float y;
	uint32_t button;
} VREvent_Mouse_t;

typedef struct VREvent_Scroll_t
{
	float xdelta;
	float ydelta;
	uint32_t unused;
	float viewportscale;
} VREvent_Scroll_t;

typedef struct VREvent_TouchPadMove_t
{
	bool bFingerDown;
	float flSecondsFingerDown;
	float fValueXFirst;
	float fValueYFirst;
	float fValueXRaw;
	float fValueYRaw;
} VREvent_TouchPadMove_t;

typedef struct VREvent_Notification_t
{
	uint64_t ulUserValue;
	uint32_t notificationId;
} VREvent_Notification_t;

typedef struct VREvent_Process_t
{
	uint32_t pid;
	uint32_t oldPid;
	bool bForced;
	bool bConnectionLost;
} VREvent_Process_t;

typedef struct VREvent_Overlay_t
{
	uint64_t overlayHandle;
	uint64_t devicePath;
	uint64_t memoryBlockId;
} VREvent_Overlay_t;

typedef struct VREvent_Status_t
{
	uint32_t statusState;
} VREvent_Status_t;

typedef struct VREvent_Keyboard_t
{
	char cNewInput[8]; //char[8]
	uint64_t uUserValue;
} VREvent_Keyboard_t;

typedef struct VREvent_Ipd_t
{
	float ipdMeters;
} VREvent_Ipd_t;

typedef struct VREvent_Chaperone_t
{
	uint64_t m_nPreviousUniverse;
	uint64_t m_nCurrentUniverse;
} VREvent_Chaperone_t;

typedef struct VREvent_Reserved_t
{
	uint64_t reserved0;
	uint64_t reserved1;
	uint64_t reserved2;
	uint64_t reserved3;
	uint64_t reserved4;
	uint64_t reserved5;
} VREvent_Reserved_t;

typedef struct VREvent_PerformanceTest_t
{
	uint32_t m_nFidelityLevel;
} VREvent_PerformanceTest_t;

typedef struct VREvent_SeatedZeroPoseReset_t
{
	bool bResetBySystemMenu;
} VREvent_SeatedZeroPoseReset_t;

typedef struct VREvent_Screenshot_t
{
	uint32_t handle;
	uint32_t type;
} VREvent_Screenshot_t;

typedef struct VREvent_ScreenshotProgress_t
{
	float progress;
} VREvent_ScreenshotProgress_t;

typedef struct VREvent_ApplicationLaunch_t
{
	uint32_t pid;
	uint32_t unArgsHandle;
} VREvent_ApplicationLaunch_t;

typedef struct VREvent_EditingCameraSurface_t
{
	uint64_t overlayHandle;
	uint32_t nVisualMode;
} VREvent_EditingCameraSurface_t;

typedef struct VREvent_MessageOverlay_t
{
	uint32_t unVRMessageOverlayResponse;
} VREvent_MessageOverlay_t;

typedef struct VREvent_Property_t
{
	PropertyContainerHandle_t container;
	enum ETrackedDeviceProperty prop;
} VREvent_Property_t;

typedef struct VREvent_HapticVibration_t
{
	uint64_t containerHandle;
	uint64_t componentHandle;
	float fDurationSeconds;
	float fFrequency;
	float fAmplitude;
} VREvent_HapticVibration_t;

typedef struct VREvent_WebConsole_t
{
	WebConsoleHandle_t webConsoleHandle;
} VREvent_WebConsole_t;

typedef struct VREvent_InputBindingLoad_t
{
	PropertyContainerHandle_t ulAppContainer;
	uint64_t pathMessage;
	uint64_t pathUrl;
	uint64_t pathControllerType;
} VREvent_InputBindingLoad_t;

typedef struct VREvent_InputActionManifestLoad_t
{
	uint64_t pathAppKey;
	uint64_t pathMessage;
	uint64_t pathMessageParam;
	uint64_t pathManifestPath;
} VREvent_InputActionManifestLoad_t;

typedef struct VREvent_SpatialAnchor_t
{
	SpatialAnchorHandle_t unHandle;
} VREvent_SpatialAnchor_t;

typedef struct VREvent_ProgressUpdate_t
{
	uint64_t ulApplicationPropertyContainer;
	uint64_t pathDevice;
	uint64_t pathInputSource;
	uint64_t pathProgressAction;
	uint64_t pathIcon;
	float fProgress;
} VREvent_ProgressUpdate_t;

typedef struct VREvent_ShowUI_t
{
	enum EShowUIType eType;
} VREvent_ShowUI_t;

typedef struct VREvent_ShowDevTools_t
{
	int32_t nBrowserIdentifier;
} VREvent_ShowDevTools_t;

typedef struct VREvent_HDCPError_t
{
	enum EHDCPError eCode;
} VREvent_HDCPError_t;

typedef struct RenderModel_ComponentState_t
{
	struct HmdMatrix34_t mTrackingToComponentRenderModel;
	struct HmdMatrix34_t mTrackingToComponentLocal;
	VRComponentProperties uProperties;
} RenderModel_ComponentState_t;

typedef struct HiddenAreaMesh_t
{
	struct HmdVector2_t * pVertexData; // const struct vr::HmdVector2_t *
	uint32_t unTriangleCount;
} HiddenAreaMesh_t;

typedef struct VRControllerAxis_t
{
	float x;
	float y;
} VRControllerAxis_t;

typedef struct VRControllerState_t
{
	uint32_t unPacketNum;
	uint64_t ulButtonPressed;
	uint64_t ulButtonTouched;
	struct VRControllerAxis_t rAxis[5]; //struct vr::VRControllerAxis_t[5]
} VRControllerState_t;

typedef struct CameraVideoStreamFrameHeader_t
{
	enum EVRTrackedCameraFrameType eFrameType;
	uint32_t nWidth;
	uint32_t nHeight;
	uint32_t nBytesPerPixel;
	uint32_t nFrameSequence;
	struct TrackedDevicePose_t trackedDevicePose;
	uint64_t ulFrameExposureTime;
} CameraVideoStreamFrameHeader_t;

typedef struct Compositor_FrameTiming
{
	uint32_t m_nSize;
	uint32_t m_nFrameIndex;
	uint32_t m_nNumFramePresents;
	uint32_t m_nNumMisPresented;
	uint32_t m_nNumDroppedFrames;
	uint32_t m_nReprojectionFlags;
	double m_flSystemTimeInSeconds;
	float m_flPreSubmitGpuMs;
	float m_flPostSubmitGpuMs;
	float m_flTotalRenderGpuMs;
	float m_flCompositorRenderGpuMs;
	float m_flCompositorRenderCpuMs;
	float m_flCompositorIdleCpuMs;
	float m_flClientFrameIntervalMs;
	float m_flPresentCallCpuMs;
	float m_flWaitForPresentCpuMs;
	float m_flSubmitFrameMs;
	float m_flWaitGetPosesCalledMs;
	float m_flNewPosesReadyMs;
	float m_flNewFrameReadyMs;
	float m_flCompositorUpdateStartMs;
	float m_flCompositorUpdateEndMs;
	float m_flCompositorRenderStartMs;
	TrackedDevicePose_t m_HmdPose;
	uint32_t m_nNumVSyncsReadyForUse;
	uint32_t m_nNumVSyncsToFirstView;
} Compositor_FrameTiming;

typedef struct Compositor_BenchmarkResults
{
	float m_flMegaPixelsPerSecond;
	float m_flHmdRecommendedMegaPixelsPerSecond;
} Compositor_BenchmarkResults;

typedef struct DriverDirectMode_FrameTiming
{
	uint32_t m_nSize;
	uint32_t m_nNumFramePresents;
	uint32_t m_nNumMisPresented;
	uint32_t m_nNumDroppedFrames;
	uint32_t m_nReprojectionFlags;
} DriverDirectMode_FrameTiming;

typedef struct ImuSample_t
{
	double fSampleTime;
	struct HmdVector3d_t vAccel;
	struct HmdVector3d_t vGyro;
	uint32_t unOffScaleFlags;
} ImuSample_t;

typedef struct AppOverrideKeys_t
{
	char * pchKey; // const char *
	char * pchValue; // const char *
} AppOverrideKeys_t;

typedef struct Compositor_CumulativeStats
{
	uint32_t m_nPid;
	uint32_t m_nNumFramePresents;
	uint32_t m_nNumDroppedFrames;
	uint32_t m_nNumReprojectedFrames;
	uint32_t m_nNumFramePresentsOnStartup;
	uint32_t m_nNumDroppedFramesOnStartup;
	uint32_t m_nNumReprojectedFramesOnStartup;
	uint32_t m_nNumLoading;
	uint32_t m_nNumFramePresentsLoading;
	uint32_t m_nNumDroppedFramesLoading;
	uint32_t m_nNumReprojectedFramesLoading;
	uint32_t m_nNumTimedOut;
	uint32_t m_nNumFramePresentsTimedOut;
	uint32_t m_nNumDroppedFramesTimedOut;
	uint32_t m_nNumReprojectedFramesTimedOut;
} Compositor_CumulativeStats;

typedef struct Compositor_StageRenderSettings
{
	struct HmdColor_t m_PrimaryColor;
	struct HmdColor_t m_SecondaryColor;
	float m_flVignetteInnerRadius;
	float m_flVignetteOuterRadius;
	float m_flFresnelStrength;
	bool m_bBackfaceCulling;
	bool m_bGreyscale;
	bool m_bWireframe;
} Compositor_StageRenderSettings;

typedef struct VROverlayIntersectionParams_t
{
	struct HmdVector3_t vSource;
	struct HmdVector3_t vDirection;
	enum ETrackingUniverseOrigin eOrigin;
} VROverlayIntersectionParams_t;

typedef struct VROverlayIntersectionResults_t
{
	struct HmdVector3_t vPoint;
	struct HmdVector3_t vNormal;
	struct HmdVector2_t vUVs;
	float fDistance;
} VROverlayIntersectionResults_t;

typedef struct IntersectionMaskRectangle_t
{
	float m_flTopLeftX;
	float m_flTopLeftY;
	float m_flWidth;
	float m_flHeight;
} IntersectionMaskRectangle_t;

typedef struct IntersectionMaskCircle_t
{
	float m_flCenterX;
	float m_flCenterY;
	float m_flRadius;
} IntersectionMaskCircle_t;

typedef struct VROverlayProjection_t
{
	float fLeft;
	float fRight;
	float fTop;
	float fBottom;
} VROverlayProjection_t;

typedef struct VROverlayView_t
{
	VROverlayHandle_t overlayHandle;
	struct Texture_t texture;
	struct VRTextureBounds_t textureBounds;
} VROverlayView_t;

typedef struct VRVulkanDevice_t
{
	struct VkInstance_T * m_pInstance; // struct VkInstance_T *
	struct VkDevice_T * m_pDevice; // struct VkDevice_T *
	struct VkPhysicalDevice_T * m_pPhysicalDevice; // struct VkPhysicalDevice_T *
	struct VkQueue_T * m_pQueue; // struct VkQueue_T *
	uint32_t m_uQueueFamilyIndex;
} VRVulkanDevice_t;

typedef struct VRNativeDevice_t
{
	void * handle; // void *
	enum EDeviceType eType;
} VRNativeDevice_t;

typedef struct RenderModel_Vertex_t
{
	struct HmdVector3_t vPosition;
	struct HmdVector3_t vNormal;
	float rfTextureCoord[2]; //float[2]
} RenderModel_Vertex_t;


typedef struct RenderModel_TextureMap_t
{
	uint16_t unWidth;
	uint16_t unHeight;
	uint8_t * rubTextureMapData; // const uint8_t *
	enum EVRRenderModelTextureFormat format;
	uint16_t unMipLevels;
} RenderModel_TextureMap_t;


typedef struct RenderModel_t
{
	struct RenderModel_Vertex_t * rVertexData; // const struct vr::RenderModel_Vertex_t *
	uint32_t unVertexCount;
	uint16_t * rIndexData; // const uint16_t *
	uint32_t unTriangleCount;
	TextureID_t diffuseTextureId;
} RenderModel_t;


typedef struct RenderModel_ControllerMode_State_t
{
	bool bScrollWheelVisible;
} RenderModel_ControllerMode_State_t;

typedef struct NotificationBitmap_t
{
	void * m_pImageData; // void *
	int32_t m_nWidth;
	int32_t m_nHeight;
	int32_t m_nBytesPerPixel;
} NotificationBitmap_t;

typedef struct CVRSettingHelper
{
	intptr_t m_pSettings; // class vr::IVRSettings *
} CVRSettingHelper;

typedef struct InputAnalogActionData_t
{
	bool bActive;
	VRInputValueHandle_t activeOrigin;
	float x;
	float y;
	float z;
	float deltaX;
	float deltaY;
	float deltaZ;
	float fUpdateTime;
} InputAnalogActionData_t;

typedef struct InputDigitalActionData_t
{
	bool bActive;
	VRInputValueHandle_t activeOrigin;
	bool bState;
	bool bChanged;
	float fUpdateTime;
} InputDigitalActionData_t;

typedef struct InputPoseActionData_t
{
	bool bActive;
	VRInputValueHandle_t activeOrigin;
	struct TrackedDevicePose_t pose;
} InputPoseActionData_t;

typedef struct InputSkeletalActionData_t
{
	bool bActive;
	VRInputValueHandle_t activeOrigin;
} InputSkeletalActionData_t;

typedef struct InputOriginInfo_t
{
	VRInputValueHandle_t devicePath;
	TrackedDeviceIndex_t trackedDeviceIndex;
	char rchRenderModelComponentName[128]; //char[128]
} InputOriginInfo_t;

typedef struct InputBindingInfo_t
{
	char rchDevicePathName[128]; //char[128]
	char rchInputPathName[128]; //char[128]
	char rchModeName[128]; //char[128]
	char rchSlotName[128]; //char[128]
	char rchInputSourceType[32]; //char[32]
} InputBindingInfo_t;

typedef struct VRActiveActionSet_t
{
	VRActionSetHandle_t ulActionSet;
	VRInputValueHandle_t ulRestrictedToDevice;
	VRActionSetHandle_t ulSecondaryActionSet;
	uint32_t unPadding;
	int32_t nPriority;
} VRActiveActionSet_t;

typedef struct VRSkeletalSummaryData_t
{
	float flFingerCurl[5]; //float[5]
	float flFingerSplay[4]; //float[4]
} VRSkeletalSummaryData_t;

typedef struct SpatialAnchorPose_t
{
	struct HmdMatrix34_t mAnchorToAbsoluteTracking;
} SpatialAnchorPose_t;

typedef struct COpenVRContext
{
	intptr_t m_pVRSystem; // class vr::IVRSystem *
	intptr_t m_pVRChaperone; // class vr::IVRChaperone *
	intptr_t m_pVRChaperoneSetup; // class vr::IVRChaperoneSetup *
	intptr_t m_pVRCompositor; // class vr::IVRCompositor *
	intptr_t m_pVRHeadsetView; // class vr::IVRHeadsetView *
	intptr_t m_pVROverlay; // class vr::IVROverlay *
	intptr_t m_pVROverlayView; // class vr::IVROverlayView *
	intptr_t m_pVRResources; // class vr::IVRResources *
	intptr_t m_pVRRenderModels; // class vr::IVRRenderModels *
	intptr_t m_pVRExtendedDisplay; // class vr::IVRExtendedDisplay *
	intptr_t m_pVRSettings; // class vr::IVRSettings *
	intptr_t m_pVRApplications; // class vr::IVRApplications *
	intptr_t m_pVRTrackedCamera; // class vr::IVRTrackedCamera *
	intptr_t m_pVRScreenshots; // class vr::IVRScreenshots *
	intptr_t m_pVRDriverManager; // class vr::IVRDriverManager *
	intptr_t m_pVRInput; // class vr::IVRInput *
	intptr_t m_pVRIOBuffer; // class vr::IVRIOBuffer *
	intptr_t m_pVRSpatialAnchors; // class vr::IVRSpatialAnchors *
	intptr_t m_pVRDebug; // class vr::IVRDebug *
	intptr_t m_pVRNotifications; // class vr::IVRNotifications *
} COpenVRContext;

typedef struct PropertyWrite_t
{
	enum ETrackedDeviceProperty prop;
	enum EPropertyWriteType writeType;
	enum ETrackedPropertyError eSetError;
	void * pvBuffer; // void *
	uint32_t unBufferSize;
	PropertyTypeTag_t unTag;
	enum ETrackedPropertyError eError;
} PropertyWrite_t;

typedef struct PropertyRead_t
{
	enum ETrackedDeviceProperty prop;
	void * pvBuffer; // void *
	uint32_t unBufferSize;
	PropertyTypeTag_t unTag;
	uint32_t unRequiredBufferSize;
	enum ETrackedPropertyError eError;
} PropertyRead_t;

typedef struct CVRPropertyHelpers
{
	intptr_t m_pProperties; // class vr::IVRProperties *
} CVRPropertyHelpers;

typedef struct PathWrite_t
{
	PathHandle_t ulPath;
	enum EPropertyWriteType writeType;
	enum ETrackedPropertyError eSetError;
	void * pvBuffer; // void *
	uint32_t unBufferSize;
	PropertyTypeTag_t unTag;
	enum ETrackedPropertyError eError;
	char * pszPath; // const char *
} PathWrite_t;

typedef struct PathRead_t
{
	PathHandle_t ulPath;
	void * pvBuffer; // void *
	uint32_t unBufferSize;
	PropertyTypeTag_t unTag;
	uint32_t unRequiredBufferSize;
	enum ETrackedPropertyError eError;
	char * pszPath; // const char *
} PathRead_t;


typedef union
{
	VREvent_Reserved_t reserved;
	VREvent_Controller_t controller;
	VREvent_Mouse_t mouse;
	VREvent_Scroll_t scroll;
	VREvent_Process_t process;
	VREvent_Notification_t notification;
	VREvent_Overlay_t overlay;
	VREvent_Status_t status;
	VREvent_Keyboard_t keyboard;
	VREvent_Ipd_t ipd;
	VREvent_Chaperone_t chaperone;
	VREvent_PerformanceTest_t performanceTest;
	VREvent_TouchPadMove_t touchPadMove;
	VREvent_SeatedZeroPoseReset_t seatedZeroPoseReset;
	VREvent_Screenshot_t screenshot;
	VREvent_ScreenshotProgress_t screenshotProgress;
	VREvent_ApplicationLaunch_t applicationLaunch;
	VREvent_EditingCameraSurface_t cameraSurface;
	VREvent_MessageOverlay_t messageOverlay;
	VREvent_Property_t property;
	VREvent_HapticVibration_t hapticVibration;
	VREvent_WebConsole_t webConsole;
	VREvent_InputBindingLoad_t inputBinding;
	VREvent_InputActionManifestLoad_t actionManifest;
	VREvent_SpatialAnchor_t spatialAnchor;
} VREvent_Data_t;


/** An event posted by the server to all running applications */
typedef struct VREvent_t
{
	uint32_t eventType; // EVREventType enum
	TrackedDeviceIndex_t trackedDeviceIndex;
	float eventAgeSeconds;
	// event data must be the end of the struct as its size is variable
	VREvent_Data_t data;
} VREvent_t;


typedef union
{
	IntersectionMaskRectangle_t m_Rectangle;
	IntersectionMaskCircle_t m_Circle;
} VROverlayIntersectionMaskPrimitive_Data_t;

typedef struct VROverlayIntersectionMaskPrimitive_t
{
	EVROverlayIntersectionMaskPrimitiveType m_nPrimitiveType;
	VROverlayIntersectionMaskPrimitive_Data_t m_Primitive;
} VROverlayIntersectionMaskPrimitive_t;


// OpenVR Function Pointer Tables

struct VR_IVRSystem_FnTable
{
	void (__stdcall *GetRecommendedRenderTargetSize)(uint32_t * pnWidth, uint32_t * pnHeight);
	struct HmdMatrix44_t (__stdcall *GetProjectionMatrix)(EVREye eEye, float fNearZ, float fFarZ);
	void (__stdcall *GetProjectionRaw)(EVREye eEye, float * pfLeft, float * pfRight, float * pfTop, float * pfBottom);
	bool (__stdcall *ComputeDistortion)(EVREye eEye, float fU, float fV, struct DistortionCoordinates_t * pDistortionCoordinates);
	struct HmdMatrix34_t (__stdcall *GetEyeToHeadTransform)(EVREye eEye);
	bool (__stdcall *GetTimeSinceLastVsync)(float * pfSecondsSinceLastVsync, uint64_t * pulFrameCounter);
	int32_t (__stdcall *GetD3D9AdapterIndex)();
	void (__stdcall *GetDXGIOutputInfo)(int32_t * pnAdapterIndex);
	void (__stdcall *GetOutputDevice)(uint64_t * pnDevice, ETextureType textureType, struct VkInstance_T * pInstance);
	bool (__stdcall *IsDisplayOnDesktop)();
	bool (__stdcall *SetDisplayVisibility)(bool bIsVisibleOnDesktop);
	void (__stdcall *GetDeviceToAbsoluteTrackingPose)(ETrackingUniverseOrigin eOrigin, float fPredictedSecondsToPhotonsFromNow, struct TrackedDevicePose_t * pTrackedDevicePoseArray, uint32_t unTrackedDevicePoseArrayCount);
	struct HmdMatrix34_t (__stdcall *GetSeatedZeroPoseToStandingAbsoluteTrackingPose)();
	struct HmdMatrix34_t (__stdcall *GetRawZeroPoseToStandingAbsoluteTrackingPose)();
	uint32_t (__stdcall *GetSortedTrackedDeviceIndicesOfClass)(ETrackedDeviceClass eTrackedDeviceClass, TrackedDeviceIndex_t * punTrackedDeviceIndexArray, uint32_t unTrackedDeviceIndexArrayCount, TrackedDeviceIndex_t unRelativeToTrackedDeviceIndex);
	EDeviceActivityLevel (__stdcall *GetTrackedDeviceActivityLevel)(TrackedDeviceIndex_t unDeviceId);
	void (__stdcall *ApplyTransform)(struct TrackedDevicePose_t * pOutputPose, struct TrackedDevicePose_t * pTrackedDevicePose, struct HmdMatrix34_t * pTransform);
	TrackedDeviceIndex_t (__stdcall *GetTrackedDeviceIndexForControllerRole)(ETrackedControllerRole unDeviceType);
	ETrackedControllerRole (__stdcall *GetControllerRoleForTrackedDeviceIndex)(TrackedDeviceIndex_t unDeviceIndex);
	ETrackedDeviceClass (__stdcall *GetTrackedDeviceClass)(TrackedDeviceIndex_t unDeviceIndex);
	bool (__stdcall *IsTrackedDeviceConnected)(TrackedDeviceIndex_t unDeviceIndex);
	bool (__stdcall *GetBoolTrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, ETrackedPropertyError * pError);
	float (__stdcall *GetFloatTrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, ETrackedPropertyError * pError);
	int32_t (__stdcall *GetInt32TrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, ETrackedPropertyError * pError);
	uint64_t (__stdcall *GetUint64TrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, ETrackedPropertyError * pError);
	struct HmdMatrix34_t (__stdcall *GetMatrix34TrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, ETrackedPropertyError * pError);
	uint32_t (__stdcall *GetArrayTrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, PropertyTypeTag_t propType, void * pBuffer, uint32_t unBufferSize, ETrackedPropertyError * pError);
	uint32_t (__stdcall *GetStringTrackedDeviceProperty)(TrackedDeviceIndex_t unDeviceIndex, ETrackedDeviceProperty prop, char * pchValue, uint32_t unBufferSize, ETrackedPropertyError * pError);
	char * (__stdcall *GetPropErrorNameFromEnum)(ETrackedPropertyError error);
	bool (__stdcall *PollNextEvent)(struct VREvent_t * pEvent, uint32_t uncbVREvent);
	bool (__stdcall *PollNextEventWithPose)(ETrackingUniverseOrigin eOrigin, struct VREvent_t * pEvent, uint32_t uncbVREvent, TrackedDevicePose_t * pTrackedDevicePose);
	char * (__stdcall *GetEventTypeNameFromEnum)(EVREventType eType);
	struct HiddenAreaMesh_t (__stdcall *GetHiddenAreaMesh)(EVREye eEye, EHiddenAreaMeshType type);
	bool (__stdcall *GetControllerState)(TrackedDeviceIndex_t unControllerDeviceIndex, VRControllerState_t * pControllerState, uint32_t unControllerStateSize);
	bool (__stdcall *GetControllerStateWithPose)(ETrackingUniverseOrigin eOrigin, TrackedDeviceIndex_t unControllerDeviceIndex, VRControllerState_t * pControllerState, uint32_t unControllerStateSize, struct TrackedDevicePose_t * pTrackedDevicePose);
	void (__stdcall *TriggerHapticPulse)(TrackedDeviceIndex_t unControllerDeviceIndex, uint32_t unAxisId, unsigned short usDurationMicroSec);
	char * (__stdcall *GetButtonIdNameFromEnum)(EVRButtonId eButtonId);
	char * (__stdcall *GetControllerAxisTypeNameFromEnum)(EVRControllerAxisType eAxisType);
	bool (__stdcall *IsInputAvailable)();
	bool (__stdcall *IsSteamVRDrawingControllers)();
	bool (__stdcall *ShouldApplicationPause)();
	bool (__stdcall *ShouldApplicationReduceRenderingWork)();
	EVRFirmwareError (__stdcall *PerformFirmwareUpdate)(TrackedDeviceIndex_t unDeviceIndex);
	void (__stdcall *AcknowledgeQuit_Exiting)();
	uint32_t (__stdcall *GetAppContainerFilePaths)(char * pchBuffer, uint32_t unBufferSize);
	char * (__stdcall *GetRuntimeVersion)();
};

typedef struct VR_IVRExtendedDisplay_FnTable
{
	void (__stdcall *GetWindowBounds)(int32_t * pnX, int32_t * pnY, uint32_t * pnWidth, uint32_t * pnHeight);
	void (__stdcall *GetEyeOutputViewport)(EVREye eEye, uint32_t * pnX, uint32_t * pnY, uint32_t * pnWidth, uint32_t * pnHeight);
	void (__stdcall *GetDXGIOutputInfo)(int32_t * pnAdapterIndex, int32_t * pnAdapterOutputIndex);
} VR_IVRExtendedDisplay_FnTable;

typedef struct VR_IVRTrackedCamera_FnTable
{
	char * (__stdcall *GetCameraErrorNameFromEnum)(EVRTrackedCameraError eCameraError);
	EVRTrackedCameraError (__stdcall *HasCamera)(TrackedDeviceIndex_t nDeviceIndex, bool * pHasCamera);
	EVRTrackedCameraError (__stdcall *GetCameraFrameSize)(TrackedDeviceIndex_t nDeviceIndex, EVRTrackedCameraFrameType eFrameType, uint32_t * pnWidth, uint32_t * pnHeight, uint32_t * pnFrameBufferSize);
	EVRTrackedCameraError (__stdcall *GetCameraIntrinsics)(TrackedDeviceIndex_t nDeviceIndex, uint32_t nCameraIndex, EVRTrackedCameraFrameType eFrameType, HmdVector2_t * pFocalLength, HmdVector2_t * pCenter);
	EVRTrackedCameraError (__stdcall *GetCameraProjection)(TrackedDeviceIndex_t nDeviceIndex, uint32_t nCameraIndex, EVRTrackedCameraFrameType eFrameType, float flZNear, float flZFar, HmdMatrix44_t * pProjection);
	EVRTrackedCameraError (__stdcall *AcquireVideoStreamingService)(TrackedDeviceIndex_t nDeviceIndex, TrackedCameraHandle_t * pHandle);
	EVRTrackedCameraError (__stdcall *ReleaseVideoStreamingService)(TrackedCameraHandle_t hTrackedCamera);
	EVRTrackedCameraError (__stdcall *GetVideoStreamFrameBuffer)(TrackedCameraHandle_t hTrackedCamera, EVRTrackedCameraFrameType eFrameType, void * pFrameBuffer, uint32_t nFrameBufferSize, CameraVideoStreamFrameHeader_t * pFrameHeader, uint32_t nFrameHeaderSize);
	EVRTrackedCameraError (__stdcall *GetVideoStreamTextureSize)(TrackedDeviceIndex_t nDeviceIndex, EVRTrackedCameraFrameType eFrameType, VRTextureBounds_t * pTextureBounds, uint32_t * pnWidth, uint32_t * pnHeight);
	EVRTrackedCameraError (__stdcall *GetVideoStreamTextureD3D11)(TrackedCameraHandle_t hTrackedCamera, EVRTrackedCameraFrameType eFrameType, void * pD3D11DeviceOrResource, void ** ppD3D11ShaderResourceView, CameraVideoStreamFrameHeader_t * pFrameHeader, uint32_t nFrameHeaderSize);
	EVRTrackedCameraError (__stdcall *GetVideoStreamTextureGL)(TrackedCameraHandle_t hTrackedCamera, EVRTrackedCameraFrameType eFrameType, glUInt_t * pglTextureId, CameraVideoStreamFrameHeader_t * pFrameHeader, uint32_t nFrameHeaderSize);
	EVRTrackedCameraError (__stdcall *ReleaseVideoStreamTextureGL)(TrackedCameraHandle_t hTrackedCamera, glUInt_t glTextureId);
	void (__stdcall *SetCameraTrackingSpace)(ETrackingUniverseOrigin eUniverse);
	ETrackingUniverseOrigin (__stdcall *GetCameraTrackingSpace)();
} VR_IVRTrackedCamera_FnTable;

typedef struct VR_IVRApplications_FnTable
{
	EVRApplicationError (__stdcall *AddApplicationManifest)(char * pchApplicationManifestFullPath, bool bTemporary);
	EVRApplicationError (__stdcall *RemoveApplicationManifest)(char * pchApplicationManifestFullPath);
	bool (__stdcall *IsApplicationInstalled)(char * pchAppKey);
	uint32_t (__stdcall *GetApplicationCount)();
	EVRApplicationError (__stdcall *GetApplicationKeyByIndex)(uint32_t unApplicationIndex, char * pchAppKeyBuffer, uint32_t unAppKeyBufferLen);
	EVRApplicationError (__stdcall *GetApplicationKeyByProcessId)(uint32_t unProcessId, char * pchAppKeyBuffer, uint32_t unAppKeyBufferLen);
	EVRApplicationError (__stdcall *LaunchApplication)(char * pchAppKey);
	EVRApplicationError (__stdcall *LaunchTemplateApplication)(char * pchTemplateAppKey, char * pchNewAppKey, struct AppOverrideKeys_t * pKeys, uint32_t unKeys);
	EVRApplicationError (__stdcall *LaunchApplicationFromMimeType)(char * pchMimeType, char * pchArgs);
	EVRApplicationError (__stdcall *LaunchDashboardOverlay)(char * pchAppKey);
	bool (__stdcall *CancelApplicationLaunch)(char * pchAppKey);
	EVRApplicationError (__stdcall *IdentifyApplication)(uint32_t unProcessId, char * pchAppKey);
	uint32_t (__stdcall *GetApplicationProcessId)(char * pchAppKey);
	char * (__stdcall *GetApplicationsErrorNameFromEnum)(EVRApplicationError error);
	uint32_t (__stdcall *GetApplicationPropertyString)(char * pchAppKey, EVRApplicationProperty eProperty, char * pchPropertyValueBuffer, uint32_t unPropertyValueBufferLen, EVRApplicationError * peError);
	bool (__stdcall *GetApplicationPropertyBool)(char * pchAppKey, EVRApplicationProperty eProperty, EVRApplicationError * peError);
	uint64_t (__stdcall *GetApplicationPropertyUint64)(char * pchAppKey, EVRApplicationProperty eProperty, EVRApplicationError * peError);
	EVRApplicationError (__stdcall *SetApplicationAutoLaunch)(char * pchAppKey, bool bAutoLaunch);
	bool (__stdcall *GetApplicationAutoLaunch)(char * pchAppKey);
	EVRApplicationError (__stdcall *SetDefaultApplicationForMimeType)(char * pchAppKey, char * pchMimeType);
	bool (__stdcall *GetDefaultApplicationForMimeType)(char * pchMimeType, char * pchAppKeyBuffer, uint32_t unAppKeyBufferLen);
	bool (__stdcall *GetApplicationSupportedMimeTypes)(char * pchAppKey, char * pchMimeTypesBuffer, uint32_t unMimeTypesBuffer);
	uint32_t (__stdcall *GetApplicationsThatSupportMimeType)(char * pchMimeType, char * pchAppKeysThatSupportBuffer, uint32_t unAppKeysThatSupportBuffer);
	uint32_t (__stdcall *GetApplicationLaunchArguments)(uint32_t unHandle, char * pchArgs, uint32_t unArgs);
	EVRApplicationError (__stdcall *GetStartingApplication)(char * pchAppKeyBuffer, uint32_t unAppKeyBufferLen);
	EVRSceneApplicationState (__stdcall *GetSceneApplicationState)();
	EVRApplicationError (__stdcall *PerformApplicationPrelaunchCheck)(char * pchAppKey);
	char * (__stdcall *GetSceneApplicationStateNameFromEnum)(EVRSceneApplicationState state);
	EVRApplicationError (__stdcall *LaunchInternalProcess)(char * pchBinaryPath, char * pchArguments, char * pchWorkingDirectory);
	uint32_t (__stdcall *GetCurrentSceneProcessId)();
} VR_IVRApplications_FnTable;

typedef struct VR_IVRChaperone_FnTable
{
	ChaperoneCalibrationState (__stdcall *GetCalibrationState)();
	bool (__stdcall *GetPlayAreaSize)(float * pSizeX, float * pSizeZ);
	bool (__stdcall *GetPlayAreaRect)(struct HmdQuad_t * rect);
	void (__stdcall *ReloadInfo)();
	void (__stdcall *SetSceneColor)(struct HmdColor_t color);
	void (__stdcall *GetBoundsColor)(struct HmdColor_t * pOutputColorArray, int nNumOutputColors, float flCollisionBoundsFadeDistance, struct HmdColor_t * pOutputCameraColor);
	bool (__stdcall *AreBoundsVisible)();
	void (__stdcall *ForceBoundsVisible)(bool bForce);
	void (__stdcall *ResetZeroPose)(ETrackingUniverseOrigin eTrackingUniverseOrigin);
} VR_IVRChaperone_FnTable;

typedef struct VR_IVRChaperoneSetup_FnTable
{
	bool (__stdcall *CommitWorkingCopy)(EChaperoneConfigFile configFile);
	void (__stdcall *RevertWorkingCopy)();
	bool (__stdcall *GetWorkingPlayAreaSize)(float * pSizeX, float * pSizeZ);
	bool (__stdcall *GetWorkingPlayAreaRect)(struct HmdQuad_t * rect);
	bool (__stdcall *GetWorkingCollisionBoundsInfo)(struct HmdQuad_t * pQuadsBuffer, uint32_t * punQuadsCount);
	bool (__stdcall *GetLiveCollisionBoundsInfo)(struct HmdQuad_t * pQuadsBuffer, uint32_t * punQuadsCount);
	bool (__stdcall *GetWorkingSeatedZeroPoseToRawTrackingPose)(struct HmdMatrix34_t * pmatSeatedZeroPoseToRawTrackingPose);
	bool (__stdcall *GetWorkingStandingZeroPoseToRawTrackingPose)(struct HmdMatrix34_t * pmatStandingZeroPoseToRawTrackingPose);
	void (__stdcall *SetWorkingPlayAreaSize)(float sizeX, float sizeZ);
	void (__stdcall *SetWorkingCollisionBoundsInfo)(struct HmdQuad_t * pQuadsBuffer, uint32_t unQuadsCount);
	void (__stdcall *SetWorkingPerimeter)(struct HmdVector2_t * pPointBuffer, uint32_t unPointCount);
	void (__stdcall *SetWorkingSeatedZeroPoseToRawTrackingPose)(struct HmdMatrix34_t * pMatSeatedZeroPoseToRawTrackingPose);
	void (__stdcall *SetWorkingStandingZeroPoseToRawTrackingPose)(struct HmdMatrix34_t * pMatStandingZeroPoseToRawTrackingPose);
	void (__stdcall *ReloadFromDisk)(EChaperoneConfigFile configFile);
	bool (__stdcall *GetLiveSeatedZeroPoseToRawTrackingPose)(struct HmdMatrix34_t * pmatSeatedZeroPoseToRawTrackingPose);
	bool (__stdcall *ExportLiveToBuffer)(char * pBuffer, uint32_t * pnBufferLength);
	bool (__stdcall *ImportFromBufferToWorking)(char * pBuffer, uint32_t nImportFlags);
	void (__stdcall *ShowWorkingSetPreview)();
	void (__stdcall *HideWorkingSetPreview)();
	void (__stdcall *RoomSetupStarting)();
} VR_IVRChaperoneSetup_FnTable;

typedef struct VR_IVRCompositor_FnTable
{
	void (__stdcall *SetTrackingSpace)(ETrackingUniverseOrigin eOrigin);
	ETrackingUniverseOrigin (__stdcall *GetTrackingSpace)();
	EVRCompositorError (__stdcall *WaitGetPoses)(struct TrackedDevicePose_t * pRenderPoseArray, uint32_t unRenderPoseArrayCount, struct TrackedDevicePose_t * pGamePoseArray, uint32_t unGamePoseArrayCount);
	EVRCompositorError (__stdcall *GetLastPoses)(struct TrackedDevicePose_t * pRenderPoseArray, uint32_t unRenderPoseArrayCount, struct TrackedDevicePose_t * pGamePoseArray, uint32_t unGamePoseArrayCount);
	EVRCompositorError (__stdcall *GetLastPoseForTrackedDeviceIndex)(TrackedDeviceIndex_t unDeviceIndex, struct TrackedDevicePose_t * pOutputPose, struct TrackedDevicePose_t * pOutputGamePose);
	EVRCompositorError (__stdcall *Submit)(EVREye eEye, struct Texture_t * pTexture, struct VRTextureBounds_t * pBounds, EVRSubmitFlags nSubmitFlags);
	void (__stdcall *ClearLastSubmittedFrame)();
	void (__stdcall *PostPresentHandoff)();
	bool (__stdcall *GetFrameTiming)(struct Compositor_FrameTiming * pTiming, uint32_t unFramesAgo);
	uint32_t (__stdcall *GetFrameTimings)(struct Compositor_FrameTiming * pTiming, uint32_t nFrames);
	float (__stdcall *GetFrameTimeRemaining)();
	void (__stdcall *GetCumulativeStats)(struct Compositor_CumulativeStats * pStats, uint32_t nStatsSizeInBytes);
	void (__stdcall *FadeToColor)(float fSeconds, float fRed, float fGreen, float fBlue, float fAlpha, bool bBackground);
	struct HmdColor_t (__stdcall *GetCurrentFadeColor)(bool bBackground);
	void (__stdcall *FadeGrid)(float fSeconds, bool bFadeGridIn);
	float (__stdcall *GetCurrentGridAlpha)();
	EVRCompositorError (__stdcall *SetSkyboxOverride)(struct Texture_t * pTextures, uint32_t unTextureCount);
	void (__stdcall *ClearSkyboxOverride)();
	void (__stdcall *CompositorBringToFront)();
	void (__stdcall *CompositorGoToBack)();
	void (__stdcall *CompositorQuit)();
	bool (__stdcall *IsFullscreen)();
	uint32_t (__stdcall *GetCurrentSceneFocusProcess)();
	uint32_t (__stdcall *GetLastFrameRenderer)();
	bool (__stdcall *CanRenderScene)();
	void (__stdcall *ShowMirrorWindow)();
	void (__stdcall *HideMirrorWindow)();
	bool (__stdcall *IsMirrorWindowVisible)();
	void (__stdcall *CompositorDumpImages)();
	bool (__stdcall *ShouldAppRenderWithLowResources)();
	void (__stdcall *ForceInterleavedReprojectionOn)(bool bOverride);
	void (__stdcall *ForceReconnectProcess)();
	void (__stdcall *SuspendRendering)(bool bSuspend);
	EVRCompositorError (__stdcall *GetMirrorTextureD3D11)(EVREye eEye, void * pD3D11DeviceOrResource, void ** ppD3D11ShaderResourceView);
	void (__stdcall *ReleaseMirrorTextureD3D11)(void * pD3D11ShaderResourceView);
	EVRCompositorError (__stdcall *GetMirrorTextureGL)(EVREye eEye, glUInt_t * pglTextureId, glSharedTextureHandle_t * pglSharedTextureHandle);
	bool (__stdcall *ReleaseSharedGLTexture)(glUInt_t glTextureId, glSharedTextureHandle_t glSharedTextureHandle);
	void (__stdcall *LockGLSharedTextureForAccess)(glSharedTextureHandle_t glSharedTextureHandle);
	void (__stdcall *UnlockGLSharedTextureForAccess)(glSharedTextureHandle_t glSharedTextureHandle);
	uint32_t (__stdcall *GetVulkanInstanceExtensionsRequired)(char * pchValue, uint32_t unBufferSize);
	uint32_t (__stdcall *GetVulkanDeviceExtensionsRequired)(struct VkPhysicalDevice_T * pPhysicalDevice, char * pchValue, uint32_t unBufferSize);
	void (__stdcall *SetExplicitTimingMode)(EVRCompositorTimingMode eTimingMode);
	EVRCompositorError (__stdcall *SubmitExplicitTimingData)();
	bool (__stdcall *IsMotionSmoothingEnabled)();
	bool (__stdcall *IsMotionSmoothingSupported)();
	bool (__stdcall *IsCurrentSceneFocusAppLoading)();
	EVRCompositorError (__stdcall *SetStageOverride_Async)(char * pchRenderModelPath, struct HmdMatrix34_t * pTransform, struct Compositor_StageRenderSettings * pRenderSettings, uint32_t nSizeOfRenderSettings);
	void (__stdcall *ClearStageOverride)();
	bool (__stdcall *GetCompositorBenchmarkResults)(struct Compositor_BenchmarkResults * pBenchmarkResults, uint32_t nSizeOfBenchmarkResults);
	EVRCompositorError (__stdcall *GetLastPosePredictionIDs)(uint32_t * pRenderPosePredictionID, uint32_t * pGamePosePredictionID);
	EVRCompositorError (__stdcall *GetPosesForFrame)(uint32_t unPosePredictionID, struct TrackedDevicePose_t * pPoseArray, uint32_t unPoseArrayCount);
} VR_IVRCompositor_FnTable;

typedef struct VR_IVROverlay_FnTable
{
	EVROverlayError (__stdcall *FindOverlay)(char * pchOverlayKey, VROverlayHandle_t * pOverlayHandle);
	EVROverlayError (__stdcall *CreateOverlay)(char * pchOverlayKey, char * pchOverlayName, VROverlayHandle_t * pOverlayHandle);
	EVROverlayError (__stdcall *DestroyOverlay)(VROverlayHandle_t ulOverlayHandle);
	uint32_t (__stdcall *GetOverlayKey)(VROverlayHandle_t ulOverlayHandle, char * pchValue, uint32_t unBufferSize, EVROverlayError * pError);
	uint32_t (__stdcall *GetOverlayName)(VROverlayHandle_t ulOverlayHandle, char * pchValue, uint32_t unBufferSize, EVROverlayError * pError);
	EVROverlayError (__stdcall *SetOverlayName)(VROverlayHandle_t ulOverlayHandle, char * pchName);
	EVROverlayError (__stdcall *GetOverlayImageData)(VROverlayHandle_t ulOverlayHandle, void * pvBuffer, uint32_t unBufferSize, uint32_t * punWidth, uint32_t * punHeight);
	char * (__stdcall *GetOverlayErrorNameFromEnum)(EVROverlayError error);
	EVROverlayError (__stdcall *SetOverlayRenderingPid)(VROverlayHandle_t ulOverlayHandle, uint32_t unPID);
	uint32_t (__stdcall *GetOverlayRenderingPid)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *SetOverlayFlag)(VROverlayHandle_t ulOverlayHandle, VROverlayFlags eOverlayFlag, bool bEnabled);
	EVROverlayError (__stdcall *GetOverlayFlag)(VROverlayHandle_t ulOverlayHandle, VROverlayFlags eOverlayFlag, bool * pbEnabled);
	EVROverlayError (__stdcall *GetOverlayFlags)(VROverlayHandle_t ulOverlayHandle, uint32_t * pFlags);
	EVROverlayError (__stdcall *SetOverlayColor)(VROverlayHandle_t ulOverlayHandle, float fRed, float fGreen, float fBlue);
	EVROverlayError (__stdcall *GetOverlayColor)(VROverlayHandle_t ulOverlayHandle, float * pfRed, float * pfGreen, float * pfBlue);
	EVROverlayError (__stdcall *SetOverlayAlpha)(VROverlayHandle_t ulOverlayHandle, float fAlpha);
	EVROverlayError (__stdcall *GetOverlayAlpha)(VROverlayHandle_t ulOverlayHandle, float * pfAlpha);
	EVROverlayError (__stdcall *SetOverlayTexelAspect)(VROverlayHandle_t ulOverlayHandle, float fTexelAspect);
	EVROverlayError (__stdcall *GetOverlayTexelAspect)(VROverlayHandle_t ulOverlayHandle, float * pfTexelAspect);
	EVROverlayError (__stdcall *SetOverlaySortOrder)(VROverlayHandle_t ulOverlayHandle, uint32_t unSortOrder);
	EVROverlayError (__stdcall *GetOverlaySortOrder)(VROverlayHandle_t ulOverlayHandle, uint32_t * punSortOrder);
	EVROverlayError (__stdcall *SetOverlayWidthInMeters)(VROverlayHandle_t ulOverlayHandle, float fWidthInMeters);
	EVROverlayError (__stdcall *GetOverlayWidthInMeters)(VROverlayHandle_t ulOverlayHandle, float * pfWidthInMeters);
	EVROverlayError (__stdcall *SetOverlayCurvature)(VROverlayHandle_t ulOverlayHandle, float fCurvature);
	EVROverlayError (__stdcall *GetOverlayCurvature)(VROverlayHandle_t ulOverlayHandle, float * pfCurvature);
	EVROverlayError (__stdcall *SetOverlayPreCurvePitch)(VROverlayHandle_t ulOverlayHandle, float fRadians);
	EVROverlayError (__stdcall *GetOverlayPreCurvePitch)(VROverlayHandle_t ulOverlayHandle, float * pfRadians);
	EVROverlayError (__stdcall *SetOverlayTextureColorSpace)(VROverlayHandle_t ulOverlayHandle, EColorSpace eTextureColorSpace);
	EVROverlayError (__stdcall *GetOverlayTextureColorSpace)(VROverlayHandle_t ulOverlayHandle, EColorSpace * peTextureColorSpace);
	EVROverlayError (__stdcall *SetOverlayTextureBounds)(VROverlayHandle_t ulOverlayHandle, struct VRTextureBounds_t * pOverlayTextureBounds);
	EVROverlayError (__stdcall *GetOverlayTextureBounds)(VROverlayHandle_t ulOverlayHandle, struct VRTextureBounds_t * pOverlayTextureBounds);
	EVROverlayError (__stdcall *GetOverlayTransformType)(VROverlayHandle_t ulOverlayHandle, VROverlayTransformType * peTransformType);
	EVROverlayError (__stdcall *SetOverlayTransformAbsolute)(VROverlayHandle_t ulOverlayHandle, ETrackingUniverseOrigin eTrackingOrigin, struct HmdMatrix34_t * pmatTrackingOriginToOverlayTransform);
	EVROverlayError (__stdcall *GetOverlayTransformAbsolute)(VROverlayHandle_t ulOverlayHandle, ETrackingUniverseOrigin * peTrackingOrigin, struct HmdMatrix34_t * pmatTrackingOriginToOverlayTransform);
	EVROverlayError (__stdcall *SetOverlayTransformTrackedDeviceRelative)(VROverlayHandle_t ulOverlayHandle, TrackedDeviceIndex_t unTrackedDevice, struct HmdMatrix34_t * pmatTrackedDeviceToOverlayTransform);
	EVROverlayError (__stdcall *GetOverlayTransformTrackedDeviceRelative)(VROverlayHandle_t ulOverlayHandle, TrackedDeviceIndex_t * punTrackedDevice, struct HmdMatrix34_t * pmatTrackedDeviceToOverlayTransform);
	EVROverlayError (__stdcall *SetOverlayTransformTrackedDeviceComponent)(VROverlayHandle_t ulOverlayHandle, TrackedDeviceIndex_t unDeviceIndex, char * pchComponentName);
	EVROverlayError (__stdcall *GetOverlayTransformTrackedDeviceComponent)(VROverlayHandle_t ulOverlayHandle, TrackedDeviceIndex_t * punDeviceIndex, char * pchComponentName, uint32_t unComponentNameSize);
	EVROverlayError (__stdcall *GetOverlayTransformOverlayRelative)(VROverlayHandle_t ulOverlayHandle, VROverlayHandle_t * ulOverlayHandleParent, struct HmdMatrix34_t * pmatParentOverlayToOverlayTransform);
	EVROverlayError (__stdcall *SetOverlayTransformOverlayRelative)(VROverlayHandle_t ulOverlayHandle, VROverlayHandle_t ulOverlayHandleParent, struct HmdMatrix34_t * pmatParentOverlayToOverlayTransform);
	EVROverlayError (__stdcall *SetOverlayTransformCursor)(VROverlayHandle_t ulCursorOverlayHandle, struct HmdVector2_t * pvHotspot);
	EVROverlayError (__stdcall *GetOverlayTransformCursor)(VROverlayHandle_t ulOverlayHandle, struct HmdVector2_t * pvHotspot);
	EVROverlayError (__stdcall *SetOverlayTransformProjection)(VROverlayHandle_t ulOverlayHandle, ETrackingUniverseOrigin eTrackingOrigin, struct HmdMatrix34_t * pmatTrackingOriginToOverlayTransform, struct VROverlayProjection_t * pProjection, EVREye eEye);
	EVROverlayError (__stdcall *ShowOverlay)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *HideOverlay)(VROverlayHandle_t ulOverlayHandle);
	bool (__stdcall *IsOverlayVisible)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *GetTransformForOverlayCoordinates)(VROverlayHandle_t ulOverlayHandle, ETrackingUniverseOrigin eTrackingOrigin, struct HmdVector2_t coordinatesInOverlay, struct HmdMatrix34_t * pmatTransform);
	EVROverlayError (__stdcall *WaitFrameSync)(uint32_t nTimeoutMs);
	bool (__stdcall *PollNextOverlayEvent)(VROverlayHandle_t ulOverlayHandle, struct VREvent_t * pEvent, uint32_t uncbVREvent);
	EVROverlayError (__stdcall *GetOverlayInputMethod)(VROverlayHandle_t ulOverlayHandle, VROverlayInputMethod * peInputMethod);
	EVROverlayError (__stdcall *SetOverlayInputMethod)(VROverlayHandle_t ulOverlayHandle, VROverlayInputMethod eInputMethod);
	EVROverlayError (__stdcall *GetOverlayMouseScale)(VROverlayHandle_t ulOverlayHandle, struct HmdVector2_t * pvecMouseScale);
	EVROverlayError (__stdcall *SetOverlayMouseScale)(VROverlayHandle_t ulOverlayHandle, struct HmdVector2_t * pvecMouseScale);
	bool (__stdcall *ComputeOverlayIntersection)(VROverlayHandle_t ulOverlayHandle, struct VROverlayIntersectionParams_t * pParams, struct VROverlayIntersectionResults_t * pResults);
	bool (__stdcall *IsHoverTargetOverlay)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *SetOverlayIntersectionMask)(VROverlayHandle_t ulOverlayHandle, struct VROverlayIntersectionMaskPrimitive_t * pMaskPrimitives, uint32_t unNumMaskPrimitives, uint32_t unPrimitiveSize);
	EVROverlayError (__stdcall *TriggerLaserMouseHapticVibration)(VROverlayHandle_t ulOverlayHandle, float fDurationSeconds, float fFrequency, float fAmplitude);
	EVROverlayError (__stdcall *SetOverlayCursor)(VROverlayHandle_t ulOverlayHandle, VROverlayHandle_t ulCursorHandle);
	EVROverlayError (__stdcall *SetOverlayCursorPositionOverride)(VROverlayHandle_t ulOverlayHandle, struct HmdVector2_t * pvCursor);
	EVROverlayError (__stdcall *ClearOverlayCursorPositionOverride)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *SetOverlayTexture)(VROverlayHandle_t ulOverlayHandle, struct Texture_t * pTexture);
	EVROverlayError (__stdcall *ClearOverlayTexture)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *SetOverlayRaw)(VROverlayHandle_t ulOverlayHandle, void * pvBuffer, uint32_t unWidth, uint32_t unHeight, uint32_t unBytesPerPixel);
	EVROverlayError (__stdcall *SetOverlayFromFile)(VROverlayHandle_t ulOverlayHandle, char * pchFilePath);
	EVROverlayError (__stdcall *GetOverlayTexture)(VROverlayHandle_t ulOverlayHandle, void ** pNativeTextureHandle, void * pNativeTextureRef, uint32_t * pWidth, uint32_t * pHeight, uint32_t * pNativeFormat, ETextureType * pAPIType, EColorSpace * pColorSpace, struct VRTextureBounds_t * pTextureBounds);
	EVROverlayError (__stdcall *ReleaseNativeOverlayHandle)(VROverlayHandle_t ulOverlayHandle, void * pNativeTextureHandle);
	EVROverlayError (__stdcall *GetOverlayTextureSize)(VROverlayHandle_t ulOverlayHandle, uint32_t * pWidth, uint32_t * pHeight);
	EVROverlayError (__stdcall *CreateDashboardOverlay)(char * pchOverlayKey, char * pchOverlayFriendlyName, VROverlayHandle_t * pMainHandle, VROverlayHandle_t * pThumbnailHandle);
	bool (__stdcall *IsDashboardVisible)();
	bool (__stdcall *IsActiveDashboardOverlay)(VROverlayHandle_t ulOverlayHandle);
	EVROverlayError (__stdcall *SetDashboardOverlaySceneProcess)(VROverlayHandle_t ulOverlayHandle, uint32_t unProcessId);
	EVROverlayError (__stdcall *GetDashboardOverlaySceneProcess)(VROverlayHandle_t ulOverlayHandle, uint32_t * punProcessId);
	void (__stdcall *ShowDashboard)(char * pchOverlayToShow);
	TrackedDeviceIndex_t (__stdcall *GetPrimaryDashboardDevice)();
	EVROverlayError (__stdcall *ShowKeyboard)(EGamepadTextInputMode eInputMode, EGamepadTextInputLineMode eLineInputMode, uint32_t unFlags, char * pchDescription, uint32_t unCharMax, char * pchExistingText, uint64_t uUserValue);
	EVROverlayError (__stdcall *ShowKeyboardForOverlay)(VROverlayHandle_t ulOverlayHandle, EGamepadTextInputMode eInputMode, EGamepadTextInputLineMode eLineInputMode, uint32_t unFlags, char * pchDescription, uint32_t unCharMax, char * pchExistingText, uint64_t uUserValue);
	uint32_t (__stdcall *GetKeyboardText)(char * pchText, uint32_t cchText);
	void (__stdcall *HideKeyboard)();
	void (__stdcall *SetKeyboardTransformAbsolute)(ETrackingUniverseOrigin eTrackingOrigin, struct HmdMatrix34_t * pmatTrackingOriginToKeyboardTransform);
	void (__stdcall *SetKeyboardPositionForOverlay)(VROverlayHandle_t ulOverlayHandle, struct HmdRect2_t avoidRect);
	VRMessageOverlayResponse (__stdcall *ShowMessageOverlay)(char * pchText, char * pchCaption, char * pchButton0Text, char * pchButton1Text, char * pchButton2Text, char * pchButton3Text);
	void (__stdcall *CloseMessageOverlay)();
} VR_IVROverlay_FnTable;

typedef struct VR_IVROverlayView_FnTable
{
	EVROverlayError (__stdcall *AcquireOverlayView)(VROverlayHandle_t ulOverlayHandle, struct VRNativeDevice_t * pNativeDevice, struct VROverlayView_t * pOverlayView, uint32_t unOverlayViewSize);
	EVROverlayError (__stdcall *ReleaseOverlayView)(struct VROverlayView_t * pOverlayView);
	void (__stdcall *PostOverlayEvent)(VROverlayHandle_t ulOverlayHandle, struct VREvent_t * pvrEvent);
	bool (__stdcall *IsViewingPermitted)(VROverlayHandle_t ulOverlayHandle);
} VR_IVROverlayView_FnTable;

typedef struct VR_IVRHeadsetView_FnTable
{
	void (__stdcall *SetHeadsetViewSize)(uint32_t nWidth, uint32_t nHeight);
	void (__stdcall *GetHeadsetViewSize)(uint32_t * pnWidth, uint32_t * pnHeight);
	void (__stdcall *SetHeadsetViewMode)(HeadsetViewMode_t eHeadsetViewMode);
	HeadsetViewMode_t (__stdcall *GetHeadsetViewMode)();
	void (__stdcall *SetHeadsetViewCropped)(bool bCropped);
	bool (__stdcall *GetHeadsetViewCropped)();
	float (__stdcall *GetHeadsetViewAspectRatio)();
	void (__stdcall *SetHeadsetViewBlendRange)(float flStartPct, float flEndPct);
	void (__stdcall *GetHeadsetViewBlendRange)(float * pStartPct, float * pEndPct);
} VR_IVRHeadsetView_FnTable;

typedef struct VR_IVRRenderModels_FnTable
{
	EVRRenderModelError (__stdcall *LoadRenderModel_Async)(char * pchRenderModelName, struct RenderModel_t ** ppRenderModel);
	void (__stdcall *FreeRenderModel)(struct RenderModel_t * pRenderModel);
	EVRRenderModelError (__stdcall *LoadTexture_Async)(TextureID_t textureId, struct RenderModel_TextureMap_t ** ppTexture);
	void (__stdcall *FreeTexture)(struct RenderModel_TextureMap_t * pTexture);
	EVRRenderModelError (__stdcall *LoadTextureD3D11_Async)(TextureID_t textureId, void * pD3D11Device, void ** ppD3D11Texture2D);
	EVRRenderModelError (__stdcall *LoadIntoTextureD3D11_Async)(TextureID_t textureId, void * pDstTexture);
	void (__stdcall *FreeTextureD3D11)(void * pD3D11Texture2D);
	uint32_t (__stdcall *GetRenderModelName)(uint32_t unRenderModelIndex, char * pchRenderModelName, uint32_t unRenderModelNameLen);
	uint32_t (__stdcall *GetRenderModelCount)();
	uint32_t (__stdcall *GetComponentCount)(char * pchRenderModelName);
	uint32_t (__stdcall *GetComponentName)(char * pchRenderModelName, uint32_t unComponentIndex, char * pchComponentName, uint32_t unComponentNameLen);
	uint64_t (__stdcall *GetComponentButtonMask)(char * pchRenderModelName, char * pchComponentName);
	uint32_t (__stdcall *GetComponentRenderModelName)(char * pchRenderModelName, char * pchComponentName, char * pchComponentRenderModelName, uint32_t unComponentRenderModelNameLen);
	bool (__stdcall *GetComponentStateForDevicePath)(char * pchRenderModelName, char * pchComponentName, VRInputValueHandle_t devicePath, RenderModel_ControllerMode_State_t * pState, RenderModel_ComponentState_t * pComponentState);
	bool (__stdcall *GetComponentState)(char * pchRenderModelName, char * pchComponentName, VRControllerState_t * pControllerState, struct RenderModel_ControllerMode_State_t * pState, struct RenderModel_ComponentState_t * pComponentState);
	bool (__stdcall *RenderModelHasComponent)(char * pchRenderModelName, char * pchComponentName);
	uint32_t (__stdcall *GetRenderModelThumbnailURL)(char * pchRenderModelName, char * pchThumbnailURL, uint32_t unThumbnailURLLen, EVRRenderModelError * peError);
	uint32_t (__stdcall *GetRenderModelOriginalPath)(char * pchRenderModelName, char * pchOriginalPath, uint32_t unOriginalPathLen, EVRRenderModelError * peError);
	char * (__stdcall *GetRenderModelErrorNameFromEnum)(EVRRenderModelError error);
} VR_IVRRenderModels_FnTable;

typedef struct VR_IVRNotifications_FnTable
{
	EVRNotificationError (__stdcall *CreateNotification)(VROverlayHandle_t ulOverlayHandle, uint64_t ulUserValue, EVRNotificationType type, char * pchText, EVRNotificationStyle style, struct NotificationBitmap_t * pImage, VRNotificationId * pNotificationId);
	EVRNotificationError (__stdcall *RemoveNotification)(VRNotificationId notificationId);
} VR_IVRNotifications_FnTable;

typedef struct VR_IVRSettings_FnTable
{
	char * (__stdcall *GetSettingsErrorNameFromEnum)(EVRSettingsError eError);
	void (__stdcall *SetBool)(char * pchSection, char * pchSettingsKey, bool bValue, EVRSettingsError * peError);
	void (__stdcall *SetInt32)(char * pchSection, char * pchSettingsKey, int32_t nValue, EVRSettingsError * peError);
	void (__stdcall *SetFloat)(char * pchSection, char * pchSettingsKey, float flValue, EVRSettingsError * peError);
	void (__stdcall *SetString)(char * pchSection, char * pchSettingsKey, char * pchValue, EVRSettingsError * peError);
	bool (__stdcall *GetBool)(char * pchSection, char * pchSettingsKey, EVRSettingsError * peError);
	int32_t (__stdcall *GetInt32)(char * pchSection, char * pchSettingsKey, EVRSettingsError * peError);
	float (__stdcall *GetFloat)(char * pchSection, char * pchSettingsKey, EVRSettingsError * peError);
	void (__stdcall *GetString)(char * pchSection, char * pchSettingsKey, char * pchValue, uint32_t unValueLen, EVRSettingsError * peError);
	void (__stdcall *RemoveSection)(char * pchSection, EVRSettingsError * peError);
	void (__stdcall *RemoveKeyInSection)(char * pchSection, char * pchSettingsKey, EVRSettingsError * peError);
} VR_IVRSettings_FnTable;

typedef struct VR_IVRScreenshots_FnTable
{
	EVRScreenshotError (__stdcall *RequestScreenshot)(ScreenshotHandle_t * pOutScreenshotHandle, EVRScreenshotType type, char * pchPreviewFilename, char * pchVRFilename);
	EVRScreenshotError (__stdcall *HookScreenshot)(EVRScreenshotType * pSupportedTypes, int numTypes);
	EVRScreenshotType (__stdcall *GetScreenshotPropertyType)(ScreenshotHandle_t screenshotHandle, EVRScreenshotError * pError);
	uint32_t (__stdcall *GetScreenshotPropertyFilename)(ScreenshotHandle_t screenshotHandle, EVRScreenshotPropertyFilenames filenameType, char * pchFilename, uint32_t cchFilename, EVRScreenshotError * pError);
	EVRScreenshotError (__stdcall *UpdateScreenshotProgress)(ScreenshotHandle_t screenshotHandle, float flProgress);
	EVRScreenshotError (__stdcall *TakeStereoScreenshot)(ScreenshotHandle_t * pOutScreenshotHandle, char * pchPreviewFilename, char * pchVRFilename);
	EVRScreenshotError (__stdcall *SubmitScreenshot)(ScreenshotHandle_t screenshotHandle, EVRScreenshotType type, char * pchSourcePreviewFilename, char * pchSourceVRFilename);
} VR_IVRScreenshots_FnTable;

typedef struct VR_IVRResources_FnTable
{
	uint32_t (__stdcall *LoadSharedResource)(char * pchResourceName, char * pchBuffer, uint32_t unBufferLen);
	uint32_t (__stdcall *GetResourceFullPath)(char * pchResourceName, char * pchResourceTypeDirectory, char * pchPathBuffer, uint32_t unBufferLen);
} VR_IVRResources_FnTable;

typedef struct VR_IVRDriverManager_FnTable
{
	uint32_t (__stdcall *GetDriverCount)();
	uint32_t (__stdcall *GetDriverName)(DriverId_t nDriver, char * pchValue, uint32_t unBufferSize);
	DriverHandle_t (__stdcall *GetDriverHandle)(char * pchDriverName);
	bool (__stdcall *IsEnabled)(DriverId_t nDriver);
} VR_IVRDriverManager_FnTable;

typedef struct VR_IVRInput_FnTable
{
	EVRInputError (__stdcall *SetActionManifestPath)(char * pchActionManifestPath);
	EVRInputError (__stdcall *GetActionSetHandle)(char * pchActionSetName, VRActionSetHandle_t * pHandle);
	EVRInputError (__stdcall *GetActionHandle)(char * pchActionName, VRActionHandle_t * pHandle);
	EVRInputError (__stdcall *GetInputSourceHandle)(char * pchInputSourcePath, VRInputValueHandle_t * pHandle);
	EVRInputError (__stdcall *UpdateActionState)(struct VRActiveActionSet_t * pSets, uint32_t unSizeOfVRSelectedActionSet_t, uint32_t unSetCount);
	EVRInputError (__stdcall *GetDigitalActionData)(VRActionHandle_t action, struct InputDigitalActionData_t * pActionData, uint32_t unActionDataSize, VRInputValueHandle_t ulRestrictToDevice);
	EVRInputError (__stdcall *GetAnalogActionData)(VRActionHandle_t action, struct InputAnalogActionData_t * pActionData, uint32_t unActionDataSize, VRInputValueHandle_t ulRestrictToDevice);
	EVRInputError (__stdcall *GetPoseActionDataRelativeToNow)(VRActionHandle_t action, ETrackingUniverseOrigin eOrigin, float fPredictedSecondsFromNow, struct InputPoseActionData_t * pActionData, uint32_t unActionDataSize, VRInputValueHandle_t ulRestrictToDevice);
	EVRInputError (__stdcall *GetPoseActionDataForNextFrame)(VRActionHandle_t action, ETrackingUniverseOrigin eOrigin, struct InputPoseActionData_t * pActionData, uint32_t unActionDataSize, VRInputValueHandle_t ulRestrictToDevice);
	EVRInputError (__stdcall *GetSkeletalActionData)(VRActionHandle_t action, struct InputSkeletalActionData_t * pActionData, uint32_t unActionDataSize);
	EVRInputError (__stdcall *GetDominantHand)(ETrackedControllerRole * peDominantHand);
	EVRInputError (__stdcall *SetDominantHand)(ETrackedControllerRole eDominantHand);
	EVRInputError (__stdcall *GetBoneCount)(VRActionHandle_t action, uint32_t * pBoneCount);
	EVRInputError (__stdcall *GetBoneHierarchy)(VRActionHandle_t action, BoneIndex_t * pParentIndices, uint32_t unIndexArayCount);
	EVRInputError (__stdcall *GetBoneName)(VRActionHandle_t action, BoneIndex_t nBoneIndex, char * pchBoneName, uint32_t unNameBufferSize);
	EVRInputError (__stdcall *GetSkeletalReferenceTransforms)(VRActionHandle_t action, EVRSkeletalTransformSpace eTransformSpace, EVRSkeletalReferencePose eReferencePose, struct VRBoneTransform_t * pTransformArray, uint32_t unTransformArrayCount);
	EVRInputError (__stdcall *GetSkeletalTrackingLevel)(VRActionHandle_t action, EVRSkeletalTrackingLevel * pSkeletalTrackingLevel);
	EVRInputError (__stdcall *GetSkeletalBoneData)(VRActionHandle_t action, EVRSkeletalTransformSpace eTransformSpace, EVRSkeletalMotionRange eMotionRange, struct VRBoneTransform_t * pTransformArray, uint32_t unTransformArrayCount);
	EVRInputError (__stdcall *GetSkeletalSummaryData)(VRActionHandle_t action, EVRSummaryType eSummaryType, struct VRSkeletalSummaryData_t * pSkeletalSummaryData);
	EVRInputError (__stdcall *GetSkeletalBoneDataCompressed)(VRActionHandle_t action, EVRSkeletalMotionRange eMotionRange, void * pvCompressedData, uint32_t unCompressedSize, uint32_t * punRequiredCompressedSize);
	EVRInputError (__stdcall *DecompressSkeletalBoneData)(void * pvCompressedBuffer, uint32_t unCompressedBufferSize, EVRSkeletalTransformSpace eTransformSpace, struct VRBoneTransform_t * pTransformArray, uint32_t unTransformArrayCount);
	EVRInputError (__stdcall *TriggerHapticVibrationAction)(VRActionHandle_t action, float fStartSecondsFromNow, float fDurationSeconds, float fFrequency, float fAmplitude, VRInputValueHandle_t ulRestrictToDevice);
	EVRInputError (__stdcall *GetActionOrigins)(VRActionSetHandle_t actionSetHandle, VRActionHandle_t digitalActionHandle, VRInputValueHandle_t * originsOut, uint32_t originOutCount);
	EVRInputError (__stdcall *GetOriginLocalizedName)(VRInputValueHandle_t origin, char * pchNameArray, uint32_t unNameArraySize, int32_t unStringSectionsToInclude);
	EVRInputError (__stdcall *GetOriginTrackedDeviceInfo)(VRInputValueHandle_t origin, struct InputOriginInfo_t * pOriginInfo, uint32_t unOriginInfoSize);
	EVRInputError (__stdcall *GetActionBindingInfo)(VRActionHandle_t action, struct InputBindingInfo_t * pOriginInfo, uint32_t unBindingInfoSize, uint32_t unBindingInfoCount, uint32_t * punReturnedBindingInfoCount);
	EVRInputError (__stdcall *ShowActionOrigins)(VRActionSetHandle_t actionSetHandle, VRActionHandle_t ulActionHandle);
	EVRInputError (__stdcall *ShowBindingsForActionSet)(struct VRActiveActionSet_t * pSets, uint32_t unSizeOfVRSelectedActionSet_t, uint32_t unSetCount, VRInputValueHandle_t originToHighlight);
	EVRInputError (__stdcall *GetComponentStateForBinding)(char * pchRenderModelName, char * pchComponentName, struct InputBindingInfo_t * pOriginInfo, uint32_t unBindingInfoSize, uint32_t unBindingInfoCount, RenderModel_ComponentState_t * pComponentState);
	bool (__stdcall *IsUsingLegacyInput)();
	EVRInputError (__stdcall *OpenBindingUI)(char * pchAppKey, VRActionSetHandle_t ulActionSetHandle, VRInputValueHandle_t ulDeviceHandle, bool bShowOnDesktop);
	EVRInputError (__stdcall *GetBindingVariant)(VRInputValueHandle_t ulDevicePath, char * pchVariantArray, uint32_t unVariantArraySize);
} VR_IVRInput_FnTable;

typedef struct VR_IVRIOBuffer_FnTable
{
	EIOBufferError (__stdcall *Open)(char * pchPath, EIOBufferMode mode, uint32_t unElementSize, uint32_t unElements, IOBufferHandle_t * pulBuffer);
	EIOBufferError (__stdcall *Close)(IOBufferHandle_t ulBuffer);
	EIOBufferError (__stdcall *Read)(IOBufferHandle_t ulBuffer, void * pDst, uint32_t unBytes, uint32_t * punRead);
	EIOBufferError (__stdcall *Write)(IOBufferHandle_t ulBuffer, void * pSrc, uint32_t unBytes);
	PropertyContainerHandle_t (__stdcall *PropertyContainer)(IOBufferHandle_t ulBuffer);
	bool (__stdcall *HasReaders)(IOBufferHandle_t ulBuffer);
} VR_IVRIOBuffer_FnTable;

typedef struct VR_IVRSpatialAnchors_FnTable
{
	EVRSpatialAnchorError (__stdcall *CreateSpatialAnchorFromDescriptor)(char * pchDescriptor, SpatialAnchorHandle_t * pHandleOut);
	EVRSpatialAnchorError (__stdcall *CreateSpatialAnchorFromPose)(TrackedDeviceIndex_t unDeviceIndex, ETrackingUniverseOrigin eOrigin, struct SpatialAnchorPose_t * pPose, SpatialAnchorHandle_t * pHandleOut);
	EVRSpatialAnchorError (__stdcall *GetSpatialAnchorPose)(SpatialAnchorHandle_t unHandle, ETrackingUniverseOrigin eOrigin, struct SpatialAnchorPose_t * pPoseOut);
	EVRSpatialAnchorError (__stdcall *GetSpatialAnchorDescriptor)(SpatialAnchorHandle_t unHandle, char * pchDescriptorOut, uint32_t * punDescriptorBufferLenInOut);
} VR_IVRSpatialAnchors_FnTable;

typedef struct VR_IVRDebug_FnTable
{
	EVRDebugError (__stdcall *EmitVrProfilerEvent)(char * pchMessage);
	EVRDebugError (__stdcall *BeginVrProfilerEvent)(VrProfilerEventHandle_t * pHandleOut);
	EVRDebugError (__stdcall *FinishVrProfilerEvent)(VrProfilerEventHandle_t hHandle, char * pchMessage);
	uint32_t (__stdcall *DriverDebugRequest)(TrackedDeviceIndex_t unDeviceIndex, char * pchRequest, char * pchResponseBuffer, uint32_t unResponseBufferSize);
} VR_IVRDebug_FnTable;

typedef struct VR_IVRProperties_FnTable
{
	ETrackedPropertyError (__stdcall *ReadPropertyBatch)(PropertyContainerHandle_t ulContainerHandle, struct PropertyRead_t * pBatch, uint32_t unBatchEntryCount);
	ETrackedPropertyError (__stdcall *WritePropertyBatch)(PropertyContainerHandle_t ulContainerHandle, struct PropertyWrite_t * pBatch, uint32_t unBatchEntryCount);
	char * (__stdcall *GetPropErrorNameFromEnum)(ETrackedPropertyError error);
	PropertyContainerHandle_t (__stdcall *TrackedDeviceToPropertyContainer)(TrackedDeviceIndex_t nDevice);
} VR_IVRProperties_FnTable;

typedef struct VR_IVRPaths_FnTable
{
	ETrackedPropertyError (__stdcall *ReadPathBatch)(PropertyContainerHandle_t ulRootHandle, struct PathRead_t * pBatch, uint32_t unBatchEntryCount);
	ETrackedPropertyError (__stdcall *WritePathBatch)(PropertyContainerHandle_t ulRootHandle, struct PathWrite_t * pBatch, uint32_t unBatchEntryCount);
	ETrackedPropertyError (__stdcall *StringToHandle)(PathHandle_t * pHandle, char * pchPath);
	ETrackedPropertyError (__stdcall *HandleToString)(PathHandle_t pHandle, char * pchBuffer, uint32_t unBufferSize, uint32_t * punBufferSizeUsed);
} VR_IVRPaths_FnTable;

typedef struct VR_IVRBlockQueue_FnTable
{
	EBlockQueueError (__stdcall *Create)(PropertyContainerHandle_t * pulQueueHandle, char * pchPath, uint32_t unBlockDataSize, uint32_t unBlockHeaderSize, uint32_t unBlockCount, uint32_t unFlags);
	EBlockQueueError (__stdcall *Connect)(PropertyContainerHandle_t * pulQueueHandle, char * pchPath);
	EBlockQueueError (__stdcall *Destroy)(PropertyContainerHandle_t ulQueueHandle);
	EBlockQueueError (__stdcall *AcquireWriteOnlyBlock)(PropertyContainerHandle_t ulQueueHandle, PropertyContainerHandle_t * pulBlockHandle, void ** ppvBuffer);
	EBlockQueueError (__stdcall *ReleaseWriteOnlyBlock)(PropertyContainerHandle_t ulQueueHandle, PropertyContainerHandle_t ulBlockHandle);
	EBlockQueueError (__stdcall *WaitAndAcquireReadOnlyBlock)(PropertyContainerHandle_t ulQueueHandle, PropertyContainerHandle_t * pulBlockHandle, void ** ppvBuffer, EBlockQueueReadType eReadType, uint32_t unTimeoutMs);
	EBlockQueueError (__stdcall *AcquireReadOnlyBlock)(PropertyContainerHandle_t ulQueueHandle, PropertyContainerHandle_t * pulBlockHandle, void ** ppvBuffer, EBlockQueueReadType eReadType);
	EBlockQueueError (__stdcall *ReleaseReadOnlyBlock)(PropertyContainerHandle_t ulQueueHandle, PropertyContainerHandle_t ulBlockHandle);
	EBlockQueueError (__stdcall *QueueHasReader)(PropertyContainerHandle_t ulQueueHandle, bool * pbHasReaders);
} VR_IVRBlockQueue_FnTable;


// Global entry points
intptr_t VR_InitInternal( EVRInitError *peError, EVRApplicationType eType );
void VR_ShutdownInternal();
bool VR_IsHmdPresent();
intptr_t VR_GetGenericInterface( const char *pchInterfaceVersion, EVRInitError *peError );
bool VR_IsRuntimeInstalled();
const char * VR_GetVRInitErrorAsSymbol( EVRInitError error );
const char * VR_GetVRInitErrorAsEnglishDescription( EVRInitError error );
]]

return openvr