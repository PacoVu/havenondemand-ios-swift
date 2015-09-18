# IODClient Library for iOS – SWIFT. V1.0

----
## Overview
IODClient for iOS - Swift is a utility class, which helps you easily integrate your iOS app with HP IDOL OnDemand Services.

IODClient class exposes source code so you can modify it as you wish.

----
## Integrate IODClient into iOS Swift project
1. Download the IODClient library for iOS.
2. Create a new or open an existing iOS Swift project
3. Add the IODClient.swift file to the project. 
4. Browse to the folder where you saved the library and select the IODClient.swift file.

----

## Demo code 1: 

**Use the Entity Extraction API to extract people and places from cnn.com website with a GET request**

    class MyAppClass : IODClientDelegate { 
        var iodClient:IODClient = IODClient(apiKey: "your-api-key")
        
	func useIODClient() {
            var iodApp = iodClient.iodApps.ENTITY_EXTRACTION
            var params =  Dictionary<String,Object>()
            params["url"] = "http://www.cnn.com"
            var arrays = Dictionary<String, String>()
            arrays["entity_type"] = "people_eng,places_eng"
            params["arrays"] = arrays

            iodClient.GetRequest(&params, iodApp:iodApp, requestMode:IODClient.REQ_MODE.ASYNC);
        }

        // implement delegated functions
        func iodClient_requestCompletedWithContent(response:String){
            // response is a json string from server
	    // use the NSJSONSerialization to parse the response.

	    var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var jsonError: NSError?
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
	    ...
        }
        func iodClient_onErrorOccurred(errorMessage:String){ 
            // handle error if any
        }
    }

 ----

 ## Demo code 2:
 
 **Use the OCR Document API to recognize text from an image with a POST request**

    class MyAppClass : IODClientDelegate { 
        var iodClient:IODClient = IODClient(apiKey: "your-api-key");
        
	func useIODClient() {
            var iodApp = iodClient.iodApps.OCR_DOCUMENT
            var params =  Dictionary<String,Object>()
            params["file"] = "full/path/filename.jpg"
            params["mode"] = "document_photo"

            iodClient.PostRequest(&params, iodApp:iodApp, requestMode:IODClient.REQ_MODE.ASYNC);
        }

        // implement delegated functions
        func iodClient_requestCompletedWithJobID(response:String){ 
            // response is a json string from server
	    var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var jsonError: NSError?
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
        
            if let unwrappedError = jsonError {
                println("json error: \(unwrappedError)")
            } else {
                var jobId = json.valueForKey("jobID") as! String;
		// get the actual content by this jobID
                iodClient.GetJobResult(jobId);
            }
        }
        func iodClient_requestCompletedWithContent(response:String){
            // response is a json string from server
	    // use the NSJSONSerialization to parse the response.

	    var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var jsonError: NSError?
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
	    ...
        }
        func iodClient_onErrorOccurred(errorMessage:String){ 
            // handle error if any
        }
    }

----
## License
Licensed under the MIT License.