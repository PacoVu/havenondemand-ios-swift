# IODClientForIOS-Swift
IDOL OnDemand for iOS - Swift. Release V1.0
IODClient for iOS - Swift is a utility class, which helps you easily integrate your iOS app with HP 
IDOL OnDemand Services.

IODClient class exposes source code so you can modify it as you wish.

************************************ IODClient class ************************************************
1. Integrate IODClient into iOS Swift project

a) Download the IODClient class for iOS.
b) Create a new or open an existing iOS Swift project
c) Add the IODClient.swift file to the project.
d) Browse to the folder where you saved the file and select the IODClient.swift.

2. Code Example

class MyAppClass : IODClientDelegate {
	var iodClient:IODClient = IODClient(apiKey: “your-api-key”);

	func useIODClient() {
		var iodApp = iodClient.iodApps.ENTITY_EXTRACTION;
		var params =  Dictionary<String,Object>()
		params[“url”] = “http://www.cnn.com”
		var arrays = Dictionary<String, String>()
		arrays[“entity_type”] = “people_eng,places_eng”
		params[“arrays”] = arrays

		iodClient.PostRequest(&params, iodApp:iodApp, requestMode:IODClient.REQ_MODE.ASYNC);
	}

	// implement delegated functions
	func iodClient_requestCompletedWithJobID(response:String){ 
	
	}
	func iodClient_requestCompletedWithContent(response:String){
	
	}
	func iodClient_onErrorOccurred(errorMessage:String){ 
	
	}
}
