# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RoadDogg' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RoadDogg
  
  pod 'Alamofire', '~> 4.5.1'
  pod "PromiseKit", '~> 4.4'
  pod "PromiseKit/MapKit"          # MKDirections().promise().then { /*…*/ }
  pod "PromiseKit/CoreLocation"    # CLLocationManager.promise().then { /*…*/ }

  target 'RoadDoggTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RoadDoggUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end