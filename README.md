# HODClient Library for iOS - SWIFT. V1.0

----
## Overview
HODClient for iOS - Swift is a utility class, which helps you easily integrate your iOS app with HP Haven OnDemand Services.

HODClient class exposes source code so you can modify it as you wish.

----
## Integrate HODClient into iOS Swift project
1. Download the HODClient library for iOS.
2. Create a new or open an existing iOS Swift project
3. Add the HODClient.swift file to the project. 
>![](/images/importlibrary1.jpg)
4. Browse to the folder where you saved the library and select the HODClient.swift file.

----
## API References
**Constructor**

    HODClient(apiKey:String, version:String = "v1")

*Description:*

* Creates and initializes an HODClient object.

*Parameters:*

* apiKey: your developer apikey.
* version: Haven OnDemand API version. Currently it only supports version 1. Thus, the default value is "v1".

*Example code:*

    var hodClient:HODClient = HODClient(apiKey: "your-api-key");

----
**Function GetRequest**

    GetRequest(inout params:Dictionary<String, AnyObject>, hodApp:String, requestMode:REQ_MODE = .ASYNC)

*Description:* 

* Sends a HTTP GET request to call a Haven OnDemand API.

*Parameters:* 

* params: a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand API, where the keys are the parameters of that API.

>Note: 

>In the case of a parameter type is an array<>, the key must be defined as "arrays" and the value must be a Dictionary\<String,String\> object with the key is the parameter name and the values separated by commas ",". 

>E.g.:
## 
    var arrays = Dictionary<String, String>()
    arrays["entity_type"] = "people_eng,places_eng"
    params["arrays"] = arrays
    
* hodApp: a string to identify a Haven OnDemand API. E.g. "extractentities". Current supported apps are listed in the HODApps object.
* mode [REQ_MODE.SYNC | REQ_MODE.ASYNC]: specifies API call as Asynchronous or Synchronous. The default mode is .ASYNC.

*Return: void.*

*Response:*

* If the mode is "ASYNC", response will be returned via the requestCompletedWithJobID(String response) callback function.
* If the mode is "SYNC", response will be returned via the requestCompletedWithContent(String response) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(String errorMessage) callback function.

*Example code:*
## 
    // Call the Entity Extraction API to find people and places from CNN website

    var hodApp = hodClient.hodApps.ENTITY_EXTRACTION;
    var arrays = Dictionary<String, String>()
    arrays["entity_type"] = "people_eng,places_eng"
    var params = Dictionary<String, AnyObject>() 
    params["url"] = "http://www.cnn.com"
    params["arrays"] = arrays
    hodClient.GetRequest(&params, hodApp:hodApp, requestMode: HODClient.REQ_MODE.SYNC);

----
**Function PostRequest**
 
    PostRequest(inout params:Dictionary<String, Object>, hodApp:String, requestMode:REQ_MODE = .ASYNC)

*Description:* 

* Sends a HTTP POST request to call a Haven OnDemand API.

*Parameters:*

* params: a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand API, where the keys are the parameters of that API. 

>Note: 

>In the case of a parameter type is an array<>, the key must be defined as “arrays” and the value must be a Map\<String,String\> object with the key is the parameter name and the values separated by commas ",".

>E.g.:
## 
    var arrays = Dictionary<String, String>()
    arrays["entity_type"] = "people_eng,places_eng"
    params["arrays"] = arrays

* hodApp: a string to identify a Haven OnDemand API. E.g. "ocrdocument". Current supported apps are listed in the HODApps object.
* mode [REQ_MODE.SYNC | REQ_MODE.ASYNC]: specifies API call as Asynchronous or Synchronous. The default mode is .ASYNC.

*Return: void.*

*Response:*

* If the mode is "ASYNC", response will be returned via the requestCompletedWithJobID(String response) callback function.
* If the mode is "SYNC", response will be returned via the requestCompletedWithContent(String response) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(String errorMessage) callback function.

*Example code:*
## 
    // Call the OCR Document API to scan text from an image file

    var hodApp = hodClient.hodApps.OCR_DOCUMENT;
    var params =  Dictionary<String,Object>()
    params["file"] = "full/path/filename.jpg"
    params["mode"] = "document_photo"
    hodClient.PostRequest(&params, hodApp:hodApp, requestMode: HODClient.REQ_MODE.ASYNC);

----
**Function GetJobResult**

    GetJobResult(jobID:String)

*Description:*

* Sends a request to Haven OnDemand to retrieve content identified by the jobID.

*Parameter:*

* jobID: the job ID returned from a Haven OnDemand API upon an asynchronous call.

*Response:* 

* Response will be returned via the requestCompletedWithContent(String response)

*Example code:*
## 
    // Parse a JSON string contained a jobID and call the function to get the actual content from Haven OnDemand server

    func requestCompletedWithJobID(response:String)
    {
        var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var jsonError: NSError?
        let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
        let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
        
        if let unwrappedError = jsonError {
            println("json error: \(unwrappedError)")
        } else {
            var jobId = json.valueForKey("jobID") as! String;
            hodClient.GetJobResult(jobId);
        }  
    }

----
## API callback functions
In your class, you will need to inherit the HODClientDelegate protocol and implement delegated functions to receive responses from the server

    class MyAppClass : HODClientDelegate { 
        
        hodClient.delegate = self
    
        func requestCompletedWithJobID(response:String){ }
    
        func requestCompletedWithContent(response:String){ }
    
        func onErrorOccurred(errorMessage:String){ }
    
    }
# 
When you call the GetRequest() or PostRequest() with the ASYNC mode, the response will be returned to this callback function. The response is a JSON string containing the jobID.

    func requestCompletedWithJobID(response:String)
    { 
    
    }
# 
When you call the GetRequest() or PostRequest() with the SYNC mode or call the GetJobResult() function, the response will be returned to this callback function. The response is a JSON string containing the actual result of the service.

    func requestCompletedWithContent(response:String)
    { 
    
    }
# 
If there is an error occurred, the error message will be returned to this callback function.

    func onErrorOccurred(errorMessage:String)
    { 
    
    }

----
## Demo code 1: 

**Use the Entity Extraction API to extract people and places from cnn.com website with a synchronous GET request**

    class MyAppClass : HODClientDelegate { 
        var hodClient:HODClient = HODClient(apiKey: "your-api-key")
        hodClient.delegate = self

        func useHODClient() {
            var hodApp = hodClient.hodApps.ENTITY_EXTRACTION
            var params =  Dictionary<String,Object>()
            params["url"] = "http://www.cnn.com"
            var arrays = Dictionary<String, String>()
            arrays["entity_type"] = "people_eng,places_eng"
            params["arrays"] = arrays

            hodClient.GetRequest(&params, hodApp:hodApp, requestMode:HODClient.REQ_MODE.SYNC);
        }

        // implement delegated functions
        func requestCompletedWithContent(response:String){
            var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var jsonError: NSError?
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
            
            var people = ""
            var places = ""
            if let entities = json["entities"] as? NSArray {
                for entity in entities {
                    var type = entity.valueForKey("type") as! String
                    if type == "people_eng" {
                        var normalizedText = entity.valueForKey("normalized_text") as! String
                        people += normalizedText + "\n"
                        // parse any other interested information about this person ...
                    }
                    else if type == "places_eng" {
                        var normalizedText = entity.valueForKey("normalized_text") as! String
                        places += normalizedText + "\n"
                        // parse any other interested information about this place ...
                    }
                }
            }
        }

        func onErrorOccurred(errorMessage:String){ 
            // handle error if any
        }
    }

----

## Demo code 2:
 
**Use the OCR Document API to scan text from an image with an asynchronous POST request**

    class MyAppClass : HODClientDelegate { 
        var hodClient:HODClient = HODClient(apiKey: "your-api-key");
        hodClient.delegate = self

        func useHODClient() {
            var hodApp = hodClient.hodApps.OCR_DOCUMENT
            var params =  Dictionary<String,Object>()
            params["file"] = "full/path/filename.jpg"
            params["mode"] = "document_photo"

            hodClient.PostRequest(&params, hodApp:hodApp, requestMode:HODClient.REQ_MODE.ASYNC);
        }

        // implement delegated functions

        /**************************************************************************************
        * An async request will result in a response with a jobID. We parse the response to get
        * the jobID and send a request for the actual content identified by the jobID.
        **************************************************************************************/ 
        func requestCompletedWithJobID(response:String){ 
            var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var jsonError: NSError?
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
        
            if let unwrappedError = jsonError {
                println("json error: \(unwrappedError)")
            } else {
                var jobId = json.valueForKey("jobID") as! String
                // get the actual content by this jobID
                iodClient.GetJobResult(jobId);
            }
        }

        func requestCompletedWithContent(response:String){
            var resStr = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var jsonError: NSError?
            let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError) as! NSDictionary
            
            if let unwrappedError = jsonError {
                println("json error: \(unwrappedError)")
            } else {
                if let actions = json["actions"] as? NSArray {
                    var recognizedText = ""
                    let action = actions[0].valueForKey("action") as? String
                    if let result = actions[0].valueForKey("result") as? NSDictionary {
                        var textBlocks: NSArray = result.valueForKey("text_block") as! NSArray
                        for block in textBlocks {
                            recognizedText += block.valueForKey("text") as! String  
                        }
                    }
                }
            } 
        }
        func onErrorOccurred(errorMessage:String){ 
            // handle error if any
        }
    }

----
## License
Licensed under the MIT License.