# HODClient Library for iOS - SWIFT. V2.0

----
## Overview
HODClient for iOS - Swift is a utility class, which helps you easily integrate your iOS app with HP Haven OnDemand Services.

HODClient V2.0 supports bulk input (source inputs can be an array) where an HOD API is capable of doing so.

Version 2.0 also includes a HODResponseParser library.

HODClient class exposes source code so you can modify it as you wish.

----
## Integrate HODClient into iOS Swift project
1. Download the HODClient library for iOS.
2. Create a new or open an existing iOS Swift project
3. Add the HODClient.swift file to the project. 
>![](/images/importlibrary1.jpg)
4. Browse to the folder where you saved the library and select the HODClient.swift file.
5. If you want to use the HODResponseParser library, follow the step 4 to add also the HODResponseParser.swift and HODResponseObjects files.

----
## HODClient API References
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
>In the case of a parameter type is an array<>, the value must be defined as an array []. 

>E.g.:
## 
    var params = Dictionary<String,AnyObject>()
    var urls = [String]()
    urls.append("http://www.cnn.com")
    urls.append("http://www.bbc.com")
    params["entity_type"] = ["people_eng","places_eng"]
    params["url"] = urls
    
* hodApp: a string to identify a Haven OnDemand API. E.g. "extractentities". Current supported apps are listed in the HODApps object.
* mode [REQ_MODE.SYNC | REQ_MODE.ASYNC]: specifies API call as Asynchronous or Synchronous. The default mode is .ASYNC.

*Return: void.*

*Response:*

* If the mode is "ASYNC", response will be returned via the requestCompletedWithJobID(response:String) callback function.
* If the mode is "SYNC", response will be returned via the requestCompletedWithContent(response:String) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(errorMessage:String) callback function.

*Example code:*
## 
    // Call the Entity Extraction API to find people and places from CNN website

    var hodApp = hodClient.hodApps.ENTITY_EXTRACTION;
    var entities = ["people_eng","places_eng"]
    var params = Dictionary<String, AnyObject>() 
    params["url"] = "http://www.cnn.com"
    params["entity_type"] = entities
    hodClient.GetRequest(&params, hodApp:hodApp, requestMode: HODClient.REQ_MODE.SYNC);

----
**Function PostRequest**
 
    PostRequest(inout params:Dictionary<String, Object>, hodApp:String, requestMode:REQ_MODE = .ASYNC)

*Description:* 

* Sends a HTTP POST request to call a Haven OnDemand API.

*Parameters:*

* params: a Dictionary object containing key/value pair parameters to be sent to a Haven OnDemand API, where the keys are the parameters of that API. 

>Note: 
>In the case of a parameter type is an array<>, the value must be defined as an array []. 

>E.g.:
## 
    var params = Dictionary<String,AnyObject>()
    var urls = [String]()
    urls.append("http://www.cnn.com")
    urls.append("http://www.bbc.com")
    params["entity_type"] = ["people_eng","places_eng"]
    params["url"] = urls

* hodApp: a string to identify a Haven OnDemand API. E.g. "ocrdocument". Current supported apps are listed in the HODApps object.
* mode [REQ_MODE.SYNC | REQ_MODE.ASYNC]: specifies API call as Asynchronous or Synchronous. The default mode is .ASYNC.

*Return: void.*

*Response:*

* If the mode is "ASYNC", response will be returned via the requestCompletedWithJobID(response:String) callback function.
* If the mode is "SYNC", response will be returned via the requestCompletedWithContent(response:String) callback function.
* If there is an error occurred, the error message will be sent via the onErrorOccurred(errorMessage:String) callback function.

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

* Response will be returned via the requestCompletedWithContent(response:String)

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
**Function GetJobStatus**

    GetJobStatus(jobID:String)

*Description:*

* Sends a request to Haven OnDemand to retrieve status of a job identified by a job ID. If the job is completed, the response will be the result of that job. Otherwise, the response will contain the current status of the job.

*Parameter:*

* jobID: the job ID returned from a Haven OnDemand API upon an asynchronous call.

*Response:* 

* Response will be returned via the requestCompletedWithContent(response:String)

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
## HODResponseParser API References
**Constructor**

    HODResponseParser()

*Description:*

* Creates and initializes an HODResponseParser object.

*Parameters:*

* None.

*Example code:*

    var hodParser:HODResponseParser = HODResponseParser()

----
**Function ParseJobID**

    ParseJobID(jsonStr:String) -> String

*Description:* 

* Parses a jobID from a json string returned from an asynchronous API call.

*Parameters:* 

* jsonStr: a json string returned from an asynchronous API call.

*Returned value*

* The jobID or an empty string if not found.

*Example code:*
## 
    func requestCompletedWithJobID(response:String) {
        var jobId:String = hodParser.ParseJobID(response)
        if jobId.characters.count > 0 {
            hodClient.GetJobStatus(jobId)
        }
    }

----
**Function ParseStandardResponse**

    ParseStandardResponse(hodApp:String, jsonStr:String) -> AnyObject?

*Description:* 

* Parses a json string and returns an object type based on the hodApp name.

>Note: Only APIs which return standard responses can be parsed by using this function. A list of supported APIs can be found from the StandardResponse class.

*Parameters:* 

* hodApp: a string identify an HOD API. Supported APIs' standard responses are defined in the StandardResponse class. E.g. StandardResponse.RECOGNIZE_SPEECH.
* jsonStr: a json string returned from a synchronous API call or from the GetJobResult() or GetJobStatus() function.

*Returned value*

* An object containing API's response values. If there is an error or if the job is not completed (callback from a GetJobStatus call), the returned object is nil and the error or job status can be accessed by calling the GetLastError() function.

*Example code:*
## 
    func requestCompletedWithContent(response:String) {
        if let resp = (hodParser.ParseStandardResponse(StandardResponse.ANALYZE_SENTIMENT, jsonStr: response) as? SentimentAnalysisResponse) {
            var result = "Positive:\n"
            for item in resp.positive {
                let i  = item as! SentimentAnalysisResponse.Entity
                result += "Sentiment: " + i.sentiment + "\n"
                result += "Score: " + String(format:"%.6f",i.score) + "\n"
                result += "Topic: " + i.topic + "\n"
                result += "Statement: " + i.original_text + "\n"
                result += "Length: " + String(format:"%d",i.original_length) + "\n"
                result += "------\n"
            }
            result += "Negative:\n"
            for item in resp.negative {
                let i  = item as! SentimentAnalysisResponse.Entity
                result += "Sentiment: " + i.sentiment + "\n"
                result += "Score: " + String(format:"%.6f",i.score) + "\n"
                result += "Topic: " + i.topic + "\n"
                result += "Statement: " + i.original_text + "\n"
                result += "Length: " + String(format:"%d",i.original_length) + "\n"
                result += "------\n"
            }
            result += "Aggregate:\n"
            result += "Sentiment: " + resp.aggregate.sentiment + "\n"
            result += "Score: " + String(format:"%.6f",resp.aggregate.score)
            // print or consume result
        } else {
            let errors = hodParser.GetLastError()
            var errorStr = ""
            for error in errors {
                let err = error as! HODErrorObject
                errorStr = "Error code: " + String(format: "%d", err.error) + "\n"
                errorStr += "Error reason: " + err.reason + "\n"
                errorStr += "Error detail: " + err.detail + "\n"
                errorStr += "Error jobID: " + err.jobID + "\n"
                if err.error == HODErrorCode.QUEUED { // queues
                    // sleep for a few seconds then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                } else if err.error == HODErrorCode.IN_PROGRESS { // in progress
                    // sleep for for a while then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                }
            }
        }        
    }
    
----
**Function ParseCustomResponse**

    ParseCustomResponse(jsonStr:String) -> NSDictionary?

*Description:* 

* Parses a json string and returns the result as an NSDictionary object. You will need to define a custom class and parse the result into that class. See example below for more details. 

*Parameters:* 

* jsonStr: a json string returned from a synchronous API call or from the GetJobResult() or GetJobStatus() function.

*Returned value*

* A NSDictionary object containing API's result values. If there is an error or if the job is not completed (callback from a GetJobStatus call), the returned object is nil and the error or job status can be accessed by calling the GetLastError() function.

*Example code:*
## 
    // Define a custom class to hold entity extraction API's response
    public class EntityExtractionResponse:NSObject {
        var entities:NSMutableArray = [];
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "entities" {
                        for item in keyValue {
                            let p = Entity(json: item as! NSDictionary)
                            self.entities.addObject(p)
                        }
                    }
                }
            }
        }
        public class AdditionalInformation:NSObject {
            var person_profession:NSMutableArray = []
            var person_date_of_birth:String = ""
            var wikidata_id:Int = 0
            var wikipedia_eng:String = ""
            var image:String = ""
            var person_date_of_death:String = ""
            var lon:Double = 0.0
            var lat:Double = 0.0
            var place_population:Int = 0
            var place_country_code:String = ""
            var place_region1:String = ""
            var place_region2:String = ""
            var place_elevation:Double = 0.0
            init(json:NSDictionary) {
                super.init()
                for (key, value) in json {
                    var isDictionary = false
                    let keyName:String = (key as? String)!
                    var keyValue:AnyObject?
                    if let _ = value as? String {
                        keyValue = (value as? String)!
                    } else if let _ = value as? Double {
                        keyValue = (value as? Double)!
                    } else if let _ = value as? Int {
                        keyValue = (value as? Int)!
                    } else if let _ = value as? NSArray {
                        let keyValue:NSArray = (value as? NSArray)!
                        isDictionary = true
                        for item in keyValue {
                            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                                let c = item as! String
                                self.person_profession.addObject(c)
                            }
                        }
                    }
                    if !isDictionary {
                        if keyValue != nil {
                            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                                self.setValue(keyValue, forKey: keyName)
                            }
                        }
                    }
                }
            }
        }
        public class Components:NSObject {
            var original_length: Int64 = 0
            var original_text: String = ""
            var type: String = ""
            init(json:NSDictionary) {
                super.init()
                for (key, value) in json {
                    let keyName:String = (key as? String)!
                    var keyValue:AnyObject?
                    if let _ = value as? String {
                        keyValue = (value as? String)!
                    } else if let _ = value as? Int64 {
                        keyValue = (value as? Int)!
                    }
                    if keyValue != nil {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(keyValue, forKey: keyName)
                        }
                    }
                }
            }
        }
        public class Entity:NSObject {
            var normalized_text:String = ""
            var original_text:String = ""
            var type:String = ""
            var normalized_length:Int = 0
            var original_length:Int = 0
            var score:Double = 0.0
            var additional_information:AdditionalInformation?
            var components:NSMutableArray = []
            init(json: NSDictionary) {
                super.init()
                for (key, value) in json {
                    var isDictionary = false
                    let keyName:String = (key as? String)!
                    var keyValue:AnyObject?
                    if let _ = value as? String {
                        keyValue = (value as? String)!
                    } else if let _ = value as? Int {
                        keyValue = (value as? Int)!
                    } else if let _ = value as? NSDictionary {
                        let keyValue:NSDictionary = (value as? NSDictionary)!
                        isDictionary = true
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.additional_information = AdditionalInformation(json:keyValue)
                        }
                    } else if let _ = value as? NSArray {
                        let keyValue:NSArray = (value as? NSArray)!
                        isDictionary = true
                        for item in keyValue {
                            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                                let c = Components(json:item as! NSDictionary)
                                self.components.addObject(c)
                            }
                        }
                    }
                    if !isDictionary {
                        if keyValue != nil {
                            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                                self.setValue(keyValue, forKey: keyName)
                            }
                        }
                    }
                }
            }
        }
    }
    // parse json string to a custom data object
    func requestCompletedWithContent(response:String) {
        if let dic = hodParser.ParseCustomResponse(jsonData) {
            let obj = EntityExtractionResponse(json:dic)
            var result: String = ""
            for ent in obj.entities as NSArray as! [EntityExtractionResponse.Entity] {
                result += ent.normalized_text + "\n"
                result += ent.type + "\n"
                // access any other fields
            }
            // print or consume result
        } else {
            let errors = hodParser.GetLastError()
            var errorMsg = ""
            for error in errors {
                let err = error as! HODErrorObject
                errorMsg = "Error code: " + String(format: "%d", err.error) + "\n"
                errorMsg += "Error reason: " + err.reason + "\n"
                errorMsg += "Error detail: " + err.detail + "\n"
                errorMsg += "Error jobID: " + err.jobID + "\n"
                print(errorMsg)
                if err.error == HODErrorCode.QUEUED { // queues
                    // sleep for a few seconds then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                } else if err.error == HODErrorCode.IN_PROGRESS { // in progress
                    // sleep for for a while then check the job status again
                    hodClient.GetJobStatus(err.jobID)
                    break
                }
            }
        }
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
            params["entity_type"] = ["people_eng","places_eng"]
            params["unique_entities"] = "true"

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
            var jobID:String = hodParser.ParseJobID(response)
            if jobID.characters.count > 0 {
                hodClient.GetJobStatus(jobID)
            }
        }

        func requestCompletedWithContent(response:String){
            if let resp = (hodParser.ParseStandardResponse(app!, jsonStr: response) as? OCRDocumentResponse) {
                var result = "Scanned text:\n"
                for item in resp.text_block {
                    let i  = item as! OCRDocumentResponse.TextBlock
                    result += "Text: " + i.text + "\n"
                    result += "Top/Left: " + String(format: "%d/%d", i.top, i.left) + "\n"
                    result += "------\n"
                }
                // print or consume result
            } else {
                let errors = hodParser.GetLastError()
                var errorMsg = ""
                for error in errors {
                    let err = error as! HODErrorObject
                    errorMsg = "Error code: " + String(format: "%d", err.error) + "\n"
                    errorMsg += "Error reason: " + err.reason + "\n"
                    errorMsg += "Error detail: " + err.detail + "\n"
                    errorMsg += "Error jobID: " + err.jobID + "\n"
                    print(errorMsg)
                    if err.error == HODErrorCode.QUEUED { // queues
                        // sleep for a few seconds then check the job status again
                        hodClient.GetJobStatus(err.jobID)
                        break
                    } else if err.error == HODErrorCode.IN_PROGRESS { // in progress
                        // sleep for for a while then check the job status again
                        hodClient.GetJobStatus(err.jobID)
                        break
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