# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Brisk iOS' do
  use_frameworks!
  
  pod 'InterfaceBacked'
  pod 'Sonar', :git => 'https://github.com/florianbuerger/sonar'
  pod 'SVProgressHUD'
  pod 'AcknowList'
  pod 'SwiftLint'
 
  target 'Brisk iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.2'
    end
  end
end
