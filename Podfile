platform :ios, "8.0"
use_frameworks!

target :Fhood do
    xcodeproj 'Fhood.xcodeproj'

    pod 'Alamofire'             , :git => "https://github.com/Alamofire/Alamofire.git"
    pod 'ClosureKit'            , :git => "https://github.com/Reflejo/ClosureKit"
    pod 'FBSDKCoreKit'          , :git => "https://github.com/facebook/facebook-ios-sdk.git", :branch => "release-4.9.0-beta"
    pod 'FBSDKLoginKit'         , :git => "https://github.com/facebook/facebook-ios-sdk.git", :branch => "release-4.9.0-beta"
    pod 'JGProgressHUD'	  , :git => “https://github.com/JonasGessner/JGProgressHUD.git”
    pod 'Parse'			  , :git => “https://github.com/ParsePlatform/Parse-SDK-iOS-OSX.git”
    pod 'ParseFacebookUtilsV4'	  , :git => “https://github.com/ParsePlatform/ParseFacebookUtils-iOS.git”
    pod 'SWRevealViewController', :git => "https://github.com/John-Lluch/SWRevealViewController.git", :branch => "master", :inhibit_warnings => true
    pod 'SnapKit'               , :git => "https://github.com/SnapKit/SnapKit.git", :branch => "swift-2.0"
    pod 'SMCalloutView'         , :git => "https://github.com/nfarina/calloutview.git", :branch => "master"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Fix DEBUG flag which is not included by cocoapods for swift projects
      if config.name == "Debug"
          config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) "-DDEBUG"'
      else
          config.build_settings['SWIFT_WHOLE_MODULE_OPTIMIZATION'] = 'YES'
      end

      # We don't want frameworks to export Objective-C headers (we lose polymorphism)
      config.build_settings['SWIFT_INSTALL_OBJC_HEADER'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
