//
//  IODClient.swift
//
//  Created by MAC_USER on 2/12/15.
//  Copyright (c) 2015 PhongVu. All rights reserved.
//

import Foundation
import MobileCoreServices

protocol IODClientDelegate {
    func requestCompletedWithContent(response:String);
    func requestCompletedWithJobID(response:String);
    func onErrorOccurred(errorMEssage:String);
}



class IODClient : NSObject
{
    enum REQ_MODE { case SYNC, ASYNC }
    
    var delegate: IODClientDelegate! = nil;
    private var _apikey : String = "";

    private let _idolBase : String = "https://api.idolondemand.com/1/api/";
    private let _idolJobResult : String = "https://api.idolondemand.com/1/job/result/";
    private var _getJobID = true;
    private var _isBusy = false;
    private var _version = "v1";
    
    private var session = NSURLSession.sharedSession();
    var iodApps = IODApps();
    
    init(apiKey:String, version:String = "v1") {
        _apikey = apiKey;
        _version = version;
        session.configuration.timeoutIntervalForRequest = 600;
    }
    internal func GetJobResult(jobID:String)
    {
        if !_isBusy {
            var queryStr:String = _idolJobResult;
            queryStr += jobID + "?";
            queryStr += "apikey=" + _apikey;
            _getJobID = false;
            let uri = NSURL(string: queryStr);
            var request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET";
            _isBusy = true;
            sendRequest(request);
        }
    }
    internal func GetRequest(inout params:Dictionary<String, AnyObject>, iodApp:String, requestMode:REQ_MODE = .ASYNC)
    {
        if !_isBusy {
            var queryStr:String = _idolBase;
            if requestMode == .SYNC {
                queryStr += "sync/";
                _getJobID = false;
            } else {
                queryStr += "async/";
                _getJobID = true;
            }
            queryStr += iodApp;
            queryStr += "/" + _version + "?";
            queryStr += "apikey=" + _apikey;
            if params.count > 0 {
                for (key, value) in params {
                    if (key == "arrays") {
                        for (subkey, subvalue) in value as! Dictionary<String, String> {
                            let separator = ",";
                            var array = subvalue.componentsSeparatedByString(separator);
                            for item : String in array {
                                queryStr += "&";
                                queryStr += subkey;
                                queryStr += "=";
                                queryStr += item;
                            }
                        }
                    } else {
                        queryStr += "&";
                        queryStr += key;
                        queryStr += "=";
                        queryStr += value as! String;
                    }
                }
            }

            let uri = NSURL(string: queryStr);
            var request = NSMutableURLRequest(URL: uri!)
            request.HTTPMethod = "GET";
            _isBusy = true;
            sendRequest(request);
        }
    }
    internal func PostRequest(inout params : Dictionary<String, AnyObject>, iodApp:String, requestMode:REQ_MODE = .ASYNC)
    {
        if !_isBusy {
            var queryStr:String = _idolBase;
            if requestMode == .SYNC {
                queryStr += "sync/";
                _getJobID = false;
            } else {
                queryStr += "async/";
                _getJobID = true;
            }
            queryStr += iodApp;
            queryStr += "/" + _version;
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
                _isBusy = true;
                sendRequest(request);
            }
        }
    }
    
    /********
    // private functions
    ********/
    private func createBodyWithParameters(inout parameters: Dictionary<String, AnyObject>, boundary: String) -> NSData? {
        var body = NSMutableData();
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition: form-data; name=\"apikey\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("\(_apikey)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        if parameters.count > 0 {
            for (key, value) in parameters {
                if (key == "file") {
                    var fullFileNameWithPath = value as! String
                    var imageUrl = NSURL(fileURLWithPath: fullFileNameWithPath)
                    var err: NSError?
                    var imageData : NSData = NSData(contentsOfURL: imageUrl!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
                    if err != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            var errorStr = err?.localizedDescription
                            self.delegate.requestCompletedWithContent(errorStr! as String)
                        })
                        return nil
                    }
                    var index = fullFileNameWithPath.rangeOfString("/", options: .BackwardsSearch)?.endIndex
                    let fileName = fullFileNameWithPath.substringFromIndex(index!)
                    index = fileName.rangeOfString(".", options: .BackwardsSearch)?.endIndex
                    let fileExtension = fileName.substringFromIndex(index!)
                    
                    let mimeType = DetermineMIMEType(fileExtension)!
                    
                    body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    body.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    body.appendData("Content-Type: \(mimeType)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    body.appendData(imageData)
                    body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                } else if (key == "arrays") {
                    for (subkey, subvalue) in value as! Dictionary<String, String> {
                        let separator = ",";
                        var array = subvalue.componentsSeparatedByString(separator);
                        for item : String in array {
                            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("Content-Disposition: form-data; name=\"\(subkey)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                            body.appendData("\(item)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                        }
                    }
                } else {
                    body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                    body.appendData("\(value as! String)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
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
            let UTI = UTIRef.takeUnretainedValue()
            UTIRef.release()
            
            let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)
            if MIMETypeRef != nil
            {
                let MIMEType = MIMETypeRef.takeUnretainedValue()
                MIMETypeRef.release()
                return MIMEType as String
            }
        }
        return "application/octet-stream"
    }
    private func sendRequest(request: NSMutableURLRequest)
    {
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            self._isBusy = false;
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    var errorStr:String = error.localizedDescription;
                    self.delegate.onErrorOccurred(errorStr);
                })
            } else {
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
                dispatch_async(dispatch_get_main_queue(), {
                    if (self._getJobID) {
                        self.delegate.requestCompletedWithJobID(strData! as String);
                    } else {
                        self.delegate.requestCompletedWithContent(strData! as String);
                    }
                })
            }
        })
        task.resume()
    }
}

class IODApps {
    let OCR_DOCUMENT = "ocrdocument";
    let RECOGNIZE_SPEECH = "recognizespeech";
    let ENTITY_EXTRACTION = "extractentities";
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
    let RECOGNIZE_BARCODES = "recognizebarcodes";
    let DETECT_FACES = "detectfaces";
    let RECOGNIZE_IMAGES = "recognizeimages";
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
    let FIND_RELATED_CONCEPTS = "findrelatedconcepts";
    let FIND_SIMILAR = "findsimilar";
    let GET_CONTENT = "getcontent";
    let GET_PARAMETRIC_VALUES = "getparametricvalues";
    let QUERY_TEXT_INDEX = "querytextindex";
    let RETRIEVE_INDEX_FIELDS = "retrieveindexfields";
    let UPDATE_QUERY_PROFILE = "updatequeryprofile";
    let CLASSIFY_DOCUMENT = "classifydocument";
    
    let EXTRACT_CONCEPTS = "extractconcepts";
    let CATEGORIZE_DOCUMENT = "categorizedocument";
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
    let LIST_INDEXES = "listindexes";
    let LIST_RESOURCES = "listresources";
    let RESTORE_TEXT_INDEX = "restoretextindex";
}
