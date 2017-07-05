# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Brisk iOS' do
  use_frameworks!
  
  pod 'InterfaceBacked'
  pod 'Sonar', :path => '/Users/florian/Code/Personal/Sonar'
  pod 'SVProgressHUD'
 
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
