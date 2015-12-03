//
//  HODClient.swift
//
//  Created by MAC_USER on 2/12/15.
//  Copyright (c) 2015 Paco Vu. All rights reserved.
//

import Foundation
import MobileCoreServices

protocol HODClientDelegate {
    func requestCompletedWithContent(response:String);
    func requestCompletedWithJobID(response:String);
    func onErrorOccurred(errorMessage:String);
}



class HODClient : NSObject
{
    enum REQ_MODE { case SYNC, ASYNC }
    
    var delegate: HODClientDelegate?;
    private var apikey : String = "";

    private let havenBase : String = "https://api.havenondemand.com/1/api/";
    private let havenJobResult : String = "https://api.havenondemand.com/1/job/result/";
    private var getJobID = true;
    private var isBusy = false;
    private var version = "v1";
    
    private var session = NSURLSession.sharedSession();
    var hodApps = HODApps();
    
    init(apiKey:String, version:String = "v1") {
        apikey = apiKey;
        self.version = version;
        session.configuration.timeoutIntervalForRequest = 600;
    }
    internal func GetJobResult(jobID:String)
    {
        if !isBusy {
            let queryStr:String = String(format: "%@%@?apikey=%@", arguments: [havenJobResult,jobID,apikey])
            getJobID = false;
            let uri = NSURL(string: queryStr);
            let request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET";
            isBusy = true;
            sendRequest(request);
        }
    }
    internal func GetRequest(inout params:Dictionary<String, AnyObject>, hodApp:String, requestMode:REQ_MODE = .ASYNC)
    {
        if !isBusy {
            var endPoint:String = havenBase;
            if requestMode == .SYNC {
                endPoint += String(format: "sync/%@/%@?apikey=%@", arguments: [hodApp,version,apikey])
                getJobID = false;
            } else {
                endPoint += String(format: "async/%@/%@?apikey=%@", arguments: [hodApp,version,apikey])
                getJobID = true;
            }
            var queryStr:String = ""
            if params.count > 0 {
                for (key, value) in params {
                    if (key == "file") {
                        self.delegate?.onErrorOccurred("Failed. File upload must be used with PostRequest function.")
                        return
                    }
                    if let arr = value as? Array<String> {
                        for item in arr {
                            queryStr += String(format: "&%@=%@", arguments: [key,item])
                        }
                    } else if let _ = value as? String {
                        queryStr += String(format: "&%@=%@", arguments: [key,value as! String])
                    }
                }
            }
            
            let encodedUrl = queryStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            endPoint = endPoint.stringByAppendingString(encodedUrl!)
            let uri = NSURL(string: endPoint);
            let request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET";
            isBusy = true;
            sendRequest(request);
        }
    }
    internal func PostRequest(inout params : Dictionary<String, AnyObject>, hodApp:String, requestMode:REQ_MODE = .ASYNC)
    {
        if !isBusy {
            var queryStr:String = havenBase;
            if requestMode == .SYNC {
                queryStr += String(format: "sync/%@/%@", arguments: [hodApp,version])
                getJobID = false;
            } else {
                queryStr += String(format: "async/%@/%@", arguments: [hodApp,version])
                getJobID = true;
            }
            let appUrl = NSURL(string: queryStr);
            let request = NSMutableURLRequest();
            request.URL = appUrl!;
            
            let boundary = generateBoundaryString();
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
            let postData = createBodyWithParameters(&params, boundary: boundary)
            if postData != nil {
                request.HTTPBody = postData;
                request.setValue("\(postData!.length)", forHTTPHeaderField: "Content-Length")
                request.HTTPMethod = "POST";
                isBusy = true;
                sendRequest(request);
            }
        }
    }
    
    /********
    // private functions
    ********/
    private func createBodyWithParameters(inout parameters: Dictionary<String, AnyObject>, boundary: String) -> NSData? {
        let body = NSMutableData();
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"apikey\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(apikey)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        if parameters.count > 0 {
            for (key, value) in parameters {
                if let arr = value as? Array<String> {
                    if (key == "file") {
                        for file in arr {
                            let fullFileNameWithPath = file
                            let fileUrl = NSURL(fileURLWithPath: fullFileNameWithPath)
                            do {
                                let data = try NSData(contentsOfURL: fileUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                                var index = fullFileNameWithPath.rangeOfString("/", options: .BackwardsSearch)?.endIndex
                                let fileName = fullFileNameWithPath.substringFromIndex(index!)
                                index = fileName.rangeOfString(".", options: .BackwardsSearch)?.endIndex
                                let fileExtension = fileName.substringFromIndex(index!)
                            
                                let mimeType = DetermineMIMEType(fileExtension)!
                            
                                body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                                body.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                                body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                                body.appendData(data)
                                body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            
                            } catch let error as NSError {
                                self.delegate!.onErrorOccurred(error.localizedDescription as String)
                                return nil
                            }
                        }
                    } else {
                        for item in arr {
                            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("\(item )\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        }
                    }
                } else if let _ = value as? String {
                    if (key == "file") {
                        let fullFileNameWithPath = value as! String
                        let fileUrl = NSURL(fileURLWithPath: fullFileNameWithPath)
                        do {
                            let data = try NSData(contentsOfURL: fileUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                            var index = fullFileNameWithPath.rangeOfString("/", options: .BackwardsSearch)?.endIndex
                            let fileName = fullFileNameWithPath.substringFromIndex(index!)
                            index = fileName.rangeOfString(".", options: .BackwardsSearch)?.endIndex
                            let fileExtension = fileName.substringFromIndex(index!)
                            
                            let mimeType = DetermineMIMEType(fileExtension)!
                            
                            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData(data)
                            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            
                        } catch let error as NSError {
                            self.delegate!.onErrorOccurred(error.localizedDescription as String)
                            return nil
                        }
                    } else {
                        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        body.appendData("\(value as! String)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    }
                }
            }
        }
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        return body;
    }
    // util funcs
    private func generateBoundaryString() -> String {
        return "Boundary--\(NSUUID().UUIDString)"
    }
    private func DetermineMIMEType(fileExtension: String) -> String? {
        if !fileExtension.isEmpty {
            let UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
            let UTI = UTIRef!.takeUnretainedValue()
            UTIRef!.release()
            
            let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)
            if MIMETypeRef != nil
            {
                let MIMEType = MIMETypeRef!.takeUnretainedValue()
                MIMETypeRef!.release()
                return MIMEType as String
            }
        }
        return "application/octet-stream"
    }
    private func sendRequest(request: NSMutableURLRequest)
    {
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            self.isBusy = false;
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    let errorStr = error!.localizedDescription;
                    self.delegate!.onErrorOccurred(errorStr);
                })
            } else {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(), {
                    if (self.getJobID) {
                        self.delegate!.requestCompletedWithJobID(strData! as String);
                    } else {
                        self.delegate!.requestCompletedWithContent(strData! as String);
                    }
                })
            }
        })
        task.resume()
    }
}
extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
struct HODApps {
    let RECOGNIZE_SPEECH = "recognizespeech";
    
    let CANCEL_CONNECTOR_SCHEDULE = "cancelconnectorschedule";
    let CONNECTOR_HISTORY = "connectorhistory";
    let CONNECTOR_STATUS = "connectorstatus";
    let CREATE_CONNECTOR = "createconnector";
    let DELETE_CONNECTOR = "deleteconnector";
    let RETRIEVE_CONFIG = "retrieveconfig";
    let START_CONNECTOR = "startconnector";
    let STOP_CONNECTOR = "stopconnector";
    let UPDATE_CONNECTOR = "updateconnector";
    
    let EXPAND_CONTAINER = "expandcontainer";
    let STORE_OBJECT = "storeobject";
    let EXTRACT_TEXT = "extracttext";
    let VIEW_DOCUMENT = "viewdocument";
    
    let OCR_DOCUMENT = "ocrdocument";
    let RECOGNIZE_BARCODES = "recognizebarcodes";
    let DETECT_FACES = "detectfaces";
    let RECOGNIZE_IMAGES = "recognizeimages";
    
    let GET_COMMON_NEIGHBORS = "getcommonneighbors";
    let GET_NEIGHBORS = "getneighbors";
    let GET_NODES = "getnodes";
    let GET_SHORTEST_PATH = "getshortestpath";
    let GET_SUB_GRAPH = "getsubgraph";
    let SUGGEST_LINKS = "suggestlinks";
    let SUMMARIZE_GRAPH = "summarizegraph";
    
    let CREATE_CLASSIFICATION_OBJECTS = "createclassificationobjects";
    let CREATE_POLICY_OBJECTS = "createpolicyobjects";
    let DELETE_CLASSIFICATION_OBJECTS = "deleteclassificationobjects";
    let DELETE_POLICY_OBJECTS = "deletepolicyobjects";
    let RETRIEVE_CLASSIFICATION_OBJECTS = "retrieveclassificationobjects";
    let RETRIEVE_POLICY_OBJECTS = "retrievepolicyobjects";
    let UPDATE_CLASSIFICATION_OBJECTS = "updateclassificationobjects";
    let UPDATE_POLICY_OBJECTS = "updatepolicyobjects";
    
    let PREDICT = "predict";
    let RECOMMEND = "recommend";
    let TRAIN_PREDICTOR = "trainpredictor";
    
    let CREATE_QUERY_PROFILE = "createqueryprofile";
    let DELETE_QUERY_PROFILE = "deletequeryprofile";
    let RETRIEVE_QUERY_PROFILE = "retrievequeryprofile";
    let UPDATE_QUERY_PROFILE = "updatequeryprofile";
    
    let FIND_RELATED_CONCEPTS = "findrelatedconcepts";
    let FIND_SIMILAR = "findsimilar";
    let GET_CONTENT = "getcontent";
    let GET_PARAMETRIC_VALUES = "getparametricvalues";
    let QUERY_TEXT_INDEX = "querytextindex";
    let RETRIEVE_INDEX_FIELDS = "retrieveindexfields";
    
    let AUTO_COMPLETE = "autocomplete";
    let CLASSIFY_DOCUMENT = "classifydocument";
    let EXTRACT_CONCEPTS = "extractconcepts";
    let CATEGORIZE_DOCUMENT = "categorizedocument";
    let ENTITY_EXTRACTION = "extractentities";
    let EXPAND_TERMS = "expandterms";
    let HIGHLIGHT_TEXT = "highlighttext";
    let IDENTIFY_LANGUAGE = "identifylanguage";
    let ANALYZE_SENTIMENT = "analyzesentiment";
    let TOKENIZE_TEXT = "tokenizetext";
    
    let ADD_TO_TEXT_INDEX = "addtotextindex";
    let CREATE_TEXT_INDEX = "createtextindex";
    let DELETE_TEXT_INDEX = "deletetextindex";
    let DELETE_FROM_TEXT_INDEX = "deletefromtextindex";
    let INDEX_STATUS = "indexstatus";
    //let LIST_INDEXES = "listindexes"; REMOVED
    let LIST_RESOURCES = "listresources";
    let RESTORE_TEXT_INDEX = "restoretextindex";
}
