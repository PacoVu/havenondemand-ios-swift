//
//  HODResponseParser.swift
//  Parse HOD API Responses
//
//  Created by MAC_USER on 9/25/15.
//  Copyright (c) 2015 PhongVu. All rights reserved.
//

import Foundation

public struct HODErrorCode {
    static let IN_PROGRESS = 1610
    static let QUEUED = 1620;
    static let NONSTANDARD_RESPONSE = 1630;
    static let INVALID_PARAM = 1640;
    static let INVALID_HOD_RESPONSE = 1650;
    static let UNKNOWN_ERROR = 1660;
}

class HODResponseParser
{
    var hodErrors : NSMutableArray = []
    
    func GetLastError() -> NSMutableArray
    {
        return hodErrors
    }
    private func resetErrors()
    {
        hodErrors.removeAllObjects()
    }
    private func addError(error : HODErrorObject)
    {
        hodErrors.addObject(error)
    }

    func ParseJobID(jsonStr:String) -> String
    {
        var jobID = ""
        
        if (jsonStr.characters.count == 0) {
            return jobID
        }
        let resStr = jsonStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            guard let _ :NSDictionary = json as? NSDictionary else {
                return jobID
            }
            jobID = json.valueForKey("jobID") as! String
        }
        catch {
            return jobID;
        }
        return jobID
    }
    func ParseStandardResponse(hodApp : String, jsonStr:String) -> AnyObject?
    {
        resetErrors()
        var obj : AnyObject!
        if (jsonStr.characters.count == 0) {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Empty response.\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: jsonObj)
            addError(hodError)
            return nil
        }
        let resStr = jsonStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
        do {
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let _ :NSDictionary = jsonObj as? NSDictionary else {
                let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response.\"}"])
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: jsonObj)
                addError(hodError)
                return nil
            }
            
            var result = jsonStr;
            
            if let actions = jsonObj["actions"] as? NSArray {
                let status = actions[0].valueForKey("status") as? String;
                if status == "finished" || status == "FINISHED" {
                    let jsonData: NSData?
                    do {
                        jsonData = try NSJSONSerialization.dataWithJSONObject((actions[0].valueForKey("result") as? NSDictionary)!, options: [])
                        result = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
                        
                    } catch let error as NSError {
                        
                        let err = String(format: "%@%d%@%@%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"", error.localizedDescription, "\"}"])
                        let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                        let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                        let hodError = HODErrorObject(json: errorObj)
                        addError(hodError)
                        return nil
                    }
                } else if status == "failed" {
                    let errors = actions[0].valueForKey("errors") as! NSArray
                    for item in errors {
                        let hodError = HODErrorObject(json: item as! NSDictionary)
                        addError(hodError)
                    }
                    return nil
                } else if status == "queued" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":", HODErrorCode.QUEUED,",\"reason\":\"Task is in queue\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else if status == "in progress" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":",HODErrorCode.IN_PROGRESS,",\"reason\":\"Task is in progress\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else {
                    let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.UNKNOWN_ERROR,",\"reason\":\"", status!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                }
            } else {
                // handle error for sync mode
                for (key, _) in jsonObj as! NSDictionary {
                    if key as! String == "error" {
                        let hodError = HODErrorObject(json: jsonObj as! NSDictionary)
                        addError(hodError)
                        return nil
                    }
                }
            }

            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
                
                if hodApp == StandardResponse.RECOGNIZE_SPEECH {
                    obj = SpeechRecognitionResponse(json:dic)
                }else if hodApp == StandardResponse.CANCEL_CONNECTOR_SCHEDULE {
                    obj = CancelConnectorScheduleResponse(json:dic)
                }else if hodApp == StandardResponse.CONNECTOR_HISTORY {
                    obj = ConnectorHistoryResponse(json:dic)
                }else if hodApp == StandardResponse.CONNECTOR_STATUS {
                    obj = ConnectorStatusResponse(json:dic)
                }else if hodApp == StandardResponse.CREATE_CONNECTOR {
                    obj = CreateConnectorResponse(json:dic)
                }else if hodApp == StandardResponse.DELETE_CONNECTOR {
                    obj = DeleteConnectorResponse(json:dic)
                }else if hodApp == StandardResponse.RETRIEVE_CONFIG_ATTR {
                    obj = RetrieveConnectorConfigurationAttrResponse(json:dic)
                }else if hodApp == StandardResponse.RETRIEVE_CONFIG_FILE {
                    obj = RetrieveConnectorConfigurationFileResponse(json:dic)
                }else if hodApp == StandardResponse.START_CONNECTOR {
                    obj = StartConnectorResponse(json:dic)
                }else if hodApp == StandardResponse.STOP_CONNECTOR {
                    obj = StopConnectorResponse(json:dic)
                }else if hodApp == StandardResponse.UPDATE_CONNECTOR {
                    obj = UpdateConnectorResponse(json:dic)
                }else if hodApp == StandardResponse.EXPAND_CONTAINER {
                    obj = ExpandContainerResponse(json:dic)
                }else if hodApp == StandardResponse.STORE_OBJECT {
                    obj = StoreObjectResponse(json:dic)
                }else if hodApp == StandardResponse.VIEW_DOCUMENT {
                    obj = ViewDocumentResponse(json:dic)
                }else if hodApp == StandardResponse.GET_COMMON_NEIGHBORS {
                    obj = GetCommonNeighborsResponse(json:dic)
                }else if hodApp == StandardResponse.GET_NEIGHBORS {
                    obj = GetNeighborsResponse(json:dic)
                }else if hodApp == StandardResponse.GET_NODES {
                    obj = GetNodesResponse(json:dic)
                }else if hodApp == StandardResponse.GET_SHORTEST_PATH {
                    obj = GetShortestPathResponse(json:dic)
                }else if hodApp == StandardResponse.GET_SUB_GRAPH {
                    obj = GetSubgraphResponse(json:dic)
                }else if hodApp == StandardResponse.SUGGEST_LINKS {
                    obj = SuggestLinksResponse(json:dic)
                }else if hodApp == StandardResponse.SUMMARIZE_GRAPH {
                    obj = SummarizeGraphResponse(json:dic)
                }else if hodApp == StandardResponse.OCR_DOCUMENT {
                    obj = OCRDocumentResponse(json:dic)
                }else if hodApp == StandardResponse.RECOGNIZE_BARCODES {
                    obj = RecognizeBarcodesResponse(json:dic)
                }else if hodApp == StandardResponse.DETECT_FACES {
                    obj = DetectFacesResponse(json : dic)
                }else if hodApp == StandardResponse.RECOGNIZE_IMAGES {
                    obj = RecognizeImagesResponse(json : dic)
                }else if hodApp == StandardResponse.PREDICT {
                    obj = PredictResponse(json : dic)
                }else if hodApp == StandardResponse.RECOMMEND {
                    obj = RecommendResponse(json : dic)
                }else if hodApp == StandardResponse.TRAIN_PREDICTOR {
                    obj = TrainPredictorResponse(json : dic)
                }else if hodApp == StandardResponse.CREATE_QUERY_PROFILE {
                    obj = CreateQueryProfileResponse(json : dic)
                }else if hodApp == StandardResponse.DELETE_QUERY_PROFILE {
                    obj = DeleteQueryProfileResponse(json : dic)
                }else if hodApp == StandardResponse.RETRIEVE_QUERY_PROFILE {
                    obj = RetrieveQueryProfileResponse(json : dic)
                }else if hodApp == StandardResponse.UPDATE_QUERY_PROFILE {
                    obj = UpdateQueryProfileResponse(json : dic)
                }else if hodApp == StandardResponse.FIND_RELATED_CONCEPTS {
                    obj = FindRelatedConceptsResponse(json : dic)
                }else if hodApp == StandardResponse.AUTO_COMPLETE {
                    obj = AutoCompleteResponse(json : dic)
                }else if hodApp == StandardResponse.EXTRACT_CONCEPTS {
                    obj = ExtractConceptsResponse(json : dic)
                }else if hodApp == StandardResponse.EXPAND_TERMS {
                    obj = ExpandTermsResponse(json : dic)
                }else if hodApp == StandardResponse.HIGHLIGHT_TEXT {
                    obj = HighlightTextResponse(json : dic)
                }else if hodApp == StandardResponse.IDENTIFY_LANGUAGE {
                    obj = IdentifyLanguageResponse(json : dic)
                }else if hodApp == StandardResponse.ANALYZE_SENTIMENT {
                    obj = SentimentAnalysisResponse(json:dic)
                }else if hodApp == StandardResponse.TOKENIZE_TEXT {
                    obj = TokenizeTextResponse(json : dic)
                }else if hodApp == StandardResponse.ADD_TO_TEXT_INDEX {
                    obj = AddToTextIndexResponse(json:dic)
                }else if hodApp == StandardResponse.CREATE_TEXT_INDEX {
                    obj = CreateTextIndexResponse(json:dic)
                }else if hodApp == StandardResponse.DELETE_TEXT_INDEX {
                    obj = DeleteTextIndexResponse(json:dic)
                }else if hodApp == StandardResponse.DELETE_FROM_TEXT_INDEX {
                    obj = DeleteFromTextIndexResponse(json:dic)
                }else if hodApp == StandardResponse.INDEX_STATUS {
                    obj = IndexStatusResponse(json:dic)
                }else if hodApp == StandardResponse.LIST_RESOURCES {
                    obj = ListResourcesResponse(json:dic)
                }else if hodApp == StandardResponse.RESTORE_TEXT_INDEX {
                    obj = RestoreTextIndexResponse(json:dic)
                } else {
                    let err = String(format: "%@%d%@", arguments: ["{\"error\":",HODErrorCode.NONSTANDARD_RESPONSE,",\"reason\":\"Non standard response.\",\"detail\":\"Define a custom response object and use the ParseCustomResponse() method.\"}"])
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                }
                
            } catch let error as NSError {
                let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.INVALID_HOD_RESPONSE,",\"reason\":\"", error.localizedDescription, "\"}")
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: errorObj)
                addError(hodError)
                return nil
            }
        }
        catch {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: errorObj)
            addError(hodError)
            return nil;
        }
        return obj
    }
    
    func ParseCustomResponse(jsonStr:String) -> NSDictionary?
    {
        resetErrors()
        var obj : NSDictionary!
        if (jsonStr.characters.count == 0) {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Empty response.\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: jsonObj)
            addError(hodError)
            return nil
        }
        let resStr = jsonStr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let data = (resStr as NSString).dataUsingEncoding(NSUTF8StringEncoding);
        do {
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            guard let _ :NSDictionary = jsonObj as? NSDictionary else {
                let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response.\"}"])
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                let jsonObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: jsonObj)
                addError(hodError)
                return nil
            }
            
            var result = jsonStr;
            
            if let actions = jsonObj["actions"] as? NSArray {
                let status = actions[0].valueForKey("status") as? String;
                if status == "finished" || status == "FINISHED" {
                    let jsonData: NSData?
                    do {
                        jsonData = try NSJSONSerialization.dataWithJSONObject((actions[0].valueForKey("result") as? NSDictionary)!, options: [])
                        result = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)! as String
                        
                    } catch let error as NSError {
                        
                        let err = String(format: "%@%d%@%@%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"", error.localizedDescription, "\"}"])
                        let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                        let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                        let hodError = HODErrorObject(json: errorObj)
                        addError(hodError)
                        return nil
                    }
                } else if status == "failed" {
                    let errors = actions[0].valueForKey("errors") as! NSArray
                    for item in errors {
                        let hodError = HODErrorObject(json: item as! NSDictionary)
                        addError(hodError)
                    }
                    return nil
                } else if status == "queued" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":", HODErrorCode.QUEUED,",\"reason\":\"Task is in queue\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else if status == "in progress" {
                    var jobID = jsonObj.valueForKey("jobID") as? String
                    jobID = jobID!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let err = String(format: "%@%d%@%@%@", "{\"error\":",HODErrorCode.IN_PROGRESS,",\"reason\":\"Task is in progress\",\"jobID\":\"", jobID!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                } else {
                    let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.UNKNOWN_ERROR,",\"reason\":\"", status!, "\"}")
                    let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                    let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                    let hodError = HODErrorObject(json: errorObj)
                    addError(hodError)
                    return nil
                }
            } else {
                // handle error for sync mode
                for (key, _) in jsonObj as! NSDictionary {
                    if key as! String == "error" {
                        let hodError = HODErrorObject(json: jsonObj as! NSDictionary)
                        addError(hodError)
                        return nil
                    }
                }
            }
            do {
                let data1 = (result as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                obj = try NSJSONSerialization.JSONObjectWithData(data1!, options: []) as! NSDictionary
            } catch let error as NSError {
                let err = String(format: "%@%d%@%@", "{\"error\":",HODErrorCode.INVALID_HOD_RESPONSE,",\"reason\":\"", error.localizedDescription, "\"}")
                let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
                let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
                let hodError = HODErrorObject(json: errorObj)
                addError(hodError)
                return nil
            }
        }
        catch {
            let err = String(format: "%@%d%@", arguments: ["{\"error\":", HODErrorCode.INVALID_HOD_RESPONSE, ",\"reason\":\"Invalid json response\"}"])
            let errData = (err as NSString).dataUsingEncoding(NSUTF8StringEncoding);
            let errorObj = (try! NSJSONSerialization.JSONObjectWithData(errData!, options: [])) as! NSDictionary
            let hodError = HODErrorObject(json: errorObj)
            addError(hodError)
            return nil;
        }
        return obj
    }
}

public struct StandardResponse {
    static let RECOGNIZE_SPEECH = "recognizespeech";
    
    static let CANCEL_CONNECTOR_SCHEDULE = "cancelconnectorschedule";
    static let CONNECTOR_HISTORY = "connectorhistory";
    static let CONNECTOR_STATUS = "connectorstatus";
    static let CREATE_CONNECTOR = "createconnector";
    static let DELETE_CONNECTOR = "deleteconnector";
    static let RETRIEVE_CONFIG_ATTR = "retrieveconfig_attr";
    static let RETRIEVE_CONFIG_FILE = "retrieveconfig_file";
    static let START_CONNECTOR = "startconnector";
    static let STOP_CONNECTOR = "stopconnector";
    static let UPDATE_CONNECTOR = "updateconnector";
    
    static let EXPAND_CONTAINER = "expandcontainer";
    static let STORE_OBJECT = "storeobject";
    //static let EXTRACT_TEXT = "extracttext";
    static let VIEW_DOCUMENT = "viewdocument";
    
    static let OCR_DOCUMENT = "ocrdocument";
    static let RECOGNIZE_BARCODES = "recognizebarcodes";
    static let DETECT_FACES = "detectfaces";
    static let RECOGNIZE_IMAGES = "recognizeimages";
    
    static let GET_COMMON_NEIGHBORS = "getcommonneighbors";
    static let GET_NEIGHBORS = "getneighbors";
    static let GET_NODES = "getnodes";
    static let GET_SHORTEST_PATH = "getshortestpath";
    static let GET_SUB_GRAPH = "getsubgraph";
    static let SUGGEST_LINKS = "suggestlinks";
    static let SUMMARIZE_GRAPH = "summarizegraph";
    
    /*
    static let CREATE_CLASSIFICATION_OBJECTS = "createclassificationobjects";
    static let CREATE_POLICY_OBJECTS = "createpolicyobjects";
    static let DELETE_CLASSIFICATION_OBJECTS = "deleteclassificationobjects";
    static let DELETE_POLICY_OBJECTS = "deletepolicyobjects";
    static let RETRIEVE_CLASSIFICATION_OBJECTS = "retrieveclassificationobjects";
    static let RETRIEVE_POLICY_OBJECTS = "retrievepolicyobjects";
    static let UPDATE_CLASSIFICATION_OBJECTS = "updateclassificationobjects";
    static let UPDATE_POLICY_OBJECTS = "updatepolicyobjects";
    */
    
    static let PREDICT = "predict";
    static let RECOMMEND = "recommend";
    static let TRAIN_PREDICTOR = "trainpredictor";
    
    static let CREATE_QUERY_PROFILE = "createqueryprofile";
    static let DELETE_QUERY_PROFILE = "deletequeryprofile";
    static let RETRIEVE_QUERY_PROFILE = "retrievequeryprofile";
    static let UPDATE_QUERY_PROFILE = "updatequeryprofile";
    
    static let FIND_RELATED_CONCEPTS = "findrelatedconcepts";
    /*
    static let FIND_SIMILAR = "findsimilar";
    static let GET_CONTENT = "getcontent";
    static let GET_PARAMETRIC_VALUES = "getparametricvalues";
    static let QUERY_TEXT_INDEX = "querytextindex";
    static let RETRIEVE_INDEX_FIELDS = "retrieveindexfields";
    */
    
    static let AUTO_COMPLETE = "autocomplete";
    //static let CLASSIFY_DOCUMENT = "classifydocument";
    static let EXTRACT_CONCEPTS = "extractconcepts";
    //static let CATEGORIZE_DOCUMENT = "categorizedocument";
    //static let ENTITY_EXTRACTION = "extractentities";
    static let EXPAND_TERMS = "expandterms";
    static let HIGHLIGHT_TEXT = "highlighttext";
    static let IDENTIFY_LANGUAGE = "identifylanguage";
    static let ANALYZE_SENTIMENT = "analyzesentiment";
    static let TOKENIZE_TEXT = "tokenizetext";
    
    static let ADD_TO_TEXT_INDEX = "addtotextindex";
    static let CREATE_TEXT_INDEX = "createtextindex";
    static let DELETE_TEXT_INDEX = "deletetextindex";
    static let DELETE_FROM_TEXT_INDEX = "deletefromtextindex";
    static let INDEX_STATUS = "indexstatus";
    //static let LIST_INDEXES = "listindexes"; REMOVED
    static let LIST_RESOURCES = "listresources";
    static let RESTORE_TEXT_INDEX = "restoretextindex";
    
}