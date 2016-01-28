//
//  HODResponseObjects.swift
//  Response predefined objects
//
//  Created by Van Phong Vu on 10/1/15.
//  Copyright (c) 2015 Van Phong Vu. All rights reserved.
//

import Foundation

public class HODErrorObject:NSObject
{
    var error:Int = 0
    var reason:String = ""
    var detail:String = ""
    var jobID:String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? Double {
                keyValue = (value as? Double)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class SpeechRecognitionResponse : NSObject{
    var document:NSMutableArray = [] // Document
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "document" {
                    for item in keyValue {
                        let p = Document(json: item as! NSDictionary)
                        self.document.addObject(p)
                    }
                }
            }
        }
    }
    public class Document:NSObject {
        var offset:Int64 = 0
        var content:String = ""
        var confidence:Int = 0
        var duration:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Int {
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
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CancelConnectorScheduleResponse:NSObject {
    var connector: String = ""
    var stopped_schedule: Bool = false
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? Bool {
                keyValue = (value as? Bool)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ConnectorHistoryResponse:NSObject {
    var history:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "history" {
                    for item in keyValue {
                        let p = History(json: item as! NSDictionary)
                        self.history.addObject(p)
                    }
                }
            }
        }
    }
    public class History:NSObject
    {
        var connector: String = ""
        var document_counts: Document_counts?
        var error:String = ""
        var failed:String = ""
        var process_end_time: String = ""
        var process_start_time: String = ""
        var start_time: String = ""
        var queued_time: String = ""
        var status: String = ""
        var time_in_queue: Double = 0
        var time_processing: Double = 0
        var token: String = ""
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
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.document_counts = Document_counts(json:keyValue)
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
    public class Document_counts:NSObject
    {
        var added: Int = 0
        var deleted: Int = 0
        var errors: Int = 0
        var ingest_added: Int = 0
        var ingest_deleted: Int = 0
        var ingest_failed: Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int {
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
    
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ConnectorStatusResponse:NSObject {
    var connector: String = ""
    var status: String = ""
    var document_counts: Document_counts?
    var error: String = ""
    var failed: String = ""
    var process_end_time: String = ""
    var process_start_time: String = ""
    var start_time: String = ""
    var queued_time: String = ""
    var time_in_queue: Double = 0
    var time_processing: Double = 0
    var token: String = ""
    var schedule: Schedule?
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
            } else if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                isDictionary = true
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    if keyName == "document_counts" {
                        self.document_counts = Document_counts(json:keyValue)
                    } else if keyName == "schedule" {
                        self.schedule = Schedule(json:keyValue)
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
    public class Document_counts:NSObject
    {
        var added: Int = 0
        var deleted: Int = 0
        var errors: Int = 0
        var ingest_added: Int = 0
        var ingest_deleted: Int = 0
        var ingest_failed: Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int {
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
    public class Schedule:NSObject
    {
        var last_run_time: String = ""
        var next_run_time: String = ""
        var occurrences_remaining: Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CreateConnectorResponse:NSObject {
    var connector: String = ""
    var download_link: Download_link?
    var message: String = ""
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
            } else if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                isDictionary = true
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    if keyName == "download_link" {
                        self.download_link = Download_link(json:keyValue)
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
    public class Download_link:NSObject
    {
        var linux_x86: String = ""
        var linux_x86_64: String = ""
        var windows_x86: String = ""
        var windows_x86_64: String = ""
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteConnectorResponse:NSObject {
    var connector: String = ""
    var deleted: Bool = false
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? Bool {
                keyValue = (value as? Bool)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RetrieveConnectorConfigurationFileResponse:NSObject {
    
    var name: String = ""
    var flavor: String = ""
    var config: String = ""
    var licenseKey: String = ""
    var validation: String = ""
    var verification: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the description conflict by changing it to _description
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RetrieveConnectorConfigurationAttrResponse:NSObject {
    
    var name: String = ""
    var flavor: String = ""
    var config: Config!
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var isDictionary = false
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? NSDictionary {
                let keyValue:NSDictionary = (value as? NSDictionary)!
                isDictionary = true
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    if keyName == "config" {
                        self.config = Config(json:keyValue)
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
    public class Config:NSObject
    {
        var config:ConfigObj!
        var destination:DestinationObj!
        var schedule:ScheduleObj!
        var credentials:CredentialsObj!
        var credentials_policy:CredentialsPolicy!
        var _description:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                var keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        if keyName == "config" {
                            self.config = ConfigObj(json:keyValue)
                        } else if keyName == "destination" {
                            self.destination = DestinationObj(json:keyValue)
                        } else if keyName == "schedule" {
                            self.schedule = ScheduleObj(json:keyValue)
                        } else if keyName == "credentials" {
                            self.credentials = CredentialsObj(json:keyValue)
                        } else if keyName == "credentials_policy" {
                            self.credentials_policy = CredentialsPolicy(json:keyValue)
                        }
                    }
                }
                if !isDictionary {
                    if keyValue != nil {
                        if keyName == "description" {
                            keyName = "_description"
                        }
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(keyValue, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    
    public class ConfigObj:NSObject
    {
        var url:String = ""
        var max_pages:Int64 = 0
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
    public class DestinationObj:NSObject
    {
        var action:String = ""
        var index:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    public class ScheduleObj:NSObject
    {
        var frequency:FrequencyObj!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        if keyName == "frequency" {
                            self.frequency = FrequencyObj(json:keyValue)
                        }
                    }
                }
            }
        }
        public class FrequencyObj:NSObject
        {
            var frequency_type:String = ""
            var interval:Int64 = 0
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
    }
    public class CredentialsObj:NSObject
    {
        var login_value:String = ""
        var password_value:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    public class CredentialsPolicy:NSObject
    {
        var notification_email:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class StartConnectorResponse:NSObject {
    var connector: String = ""
    var token: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class StopConnectorResponse:NSObject {
    var connector: String = ""
    var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class UpdateConnectorResponse:NSObject {
    var connector: String = ""
    var message: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ExpandContainerResponse:NSObject {
    var files:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "files" {
                    for item in keyValue {
                        let p = Files(json: item as! NSDictionary)
                        self.files.addObject(p)
                    }
                }
            }
        }
    }
    public class Files:NSObject
    {
        var name: String = ""
        var reference: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class StoreObjectResponse:NSObject {
    var reference: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ViewDocumentResponse:NSObject {
    var document: String = ""
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            }
            if keyValue != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetCommonNeighborsResponse:NSObject
{
    var nodes:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                }
            }
        }
    }

    public class Nodes:NSObject
    {
        var attributes:Attributes!
        var id:Int64 = 0
        var commonality: Int64 = 0
        var sort_value:Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
    public class Attributes:NSObject
    {
        var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetNeighborsResponse:NSObject
{
    var neighbors:NSMutableArray = [] //(array[Neighbors] , optional)
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "neighbors" {
                    for item in keyValue {
                        let p = Neighbors(json: item as! NSDictionary)
                        self.neighbors.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Neighbors:NSObject
    {
        var target: TargetOrSource!
        var source: TargetOrSource!
        var nodes:NSMutableArray = [] //(array[Nodes] )
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        if keyName == target {
                            self.target = TargetOrSource(json:keyValue)
                        } else if keyName == source {
                            self.source = TargetOrSource(json:keyValue)
                        }
                    }
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "nodes" {
                        for item in keyValue {
                            let p = Nodes(json: item as! NSDictionary)
                            self.nodes.addObject(p)
                        }
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        var attributes: Attributes!
        var id: Int64 = 0 //(integer )  Node ID
        var sort_value: Double = 0.0 //(number , optional)
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
    public class Attributes:NSObject
    {
        var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    public class TargetOrSource:NSObject
    {
        var id: Int64 = 0
        var attributes: Attributes!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetNodesResponse:NSObject
{
    var nodes: NSMutableArray = [] //(array[Nodes] )
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                }
            }
        }
    }
    public class Nodes:NSObject
    {
        var attributes: Attributes!
        var id: Int64 = 0 //(integer )  Node ID
        var sort_value: Double = 0.0 //(number , optional)  
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
    public class Attributes:NSObject
    {
        var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetShortestPathResponse:NSObject
{
    var edges: NSMutableArray = []
    var nodes: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                } else if keyName == "edges" {
                    for item in keyValue {
                        let p = Edges(json: item as! NSDictionary)
                        self.edges.addObject(p)
                    }
                }
            }
        }
    }
    public class Edges:NSObject
    {
        var attributes: Attributes!
        var length: Int64 = 0 //(number )  Length/weight/cost of edge.
        var source: Int64 = 0 //( integer )  Source node ID.
        var target: Int64 = 0 //( integer )  Target node ID.
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
    
    public class Attributes:NSObject
    {
        var weight: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        var attributes: Attributes!
        var id: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class GetSubgraphResponse:NSObject
{
    var edges: NSMutableArray = []
    var nodes: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "nodes" {
                    for item in keyValue {
                        let p = Nodes(json: item as! NSDictionary)
                        self.nodes.addObject(p)
                    }
                } else if keyName == "edges" {
                    for item in keyValue {
                        let p = Edges(json: item as! NSDictionary)
                        self.edges.addObject(p)
                    }
                }
            }
        }
    }

    public class Edges:NSObject
    {
        var attributes: Attributes!
        var source: Int64 = 0
        var target: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
    
    public class Attributes:NSObject
    {
        var weight: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        var attributes: Attributes!
        var id: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class SuggestLinksResponse:NSObject
{
    var suggestions: NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "suggestions" {
                    for item in keyValue {
                        let p = Suggestions(json: item as! NSDictionary)
                        self.suggestions.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Suggestions:NSObject
    {
        var source : Source!
        var nodes:NSMutableArray = []  //(array[Nodes] )
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.source = Source(json:keyValue)
                    }
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "nodes" {
                        for item in keyValue {
                            let p = Nodes(json: item as! NSDictionary)
                            self.nodes.addObject(p)
                        }
                    }
                }
            }
        }
    }
    
    public class Source:NSObject
    {
        var id: Int64 = 0
        var attributes: Attributes!
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
    
    public class Attributes:NSObject
    {
        var name: String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    
    public class Nodes:NSObject
    {
        var attributes: Attributes!
        var id: Int64 = 0
        var sort_value: Double = 0.0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? Int64 {
                    keyValue = (value as? Int)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.attributes = Attributes(json:keyValue)
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
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
public class SummarizeGraphResponse:NSObject
{
    var attributes: NSMutableArray = []
    var edges: Int64 = 0
    var nodes: Int64 = 0
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var isDictionary = false
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? Int64 {
                keyValue = (value as? Int)!
            } else if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                isDictionary = true
                if keyName == "attributes" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = Attributes(json: item as! NSDictionary)
                            self.attributes.addObject(c)
                        }
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
    public class Attributes:NSObject
    {
        var data_type: String = ""
        var element_type: String = ""
        var name: String = ""
        var number: Int64 = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Int {
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
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class OCRDocumentResponse:NSObject {
    var text_block:NSMutableArray = [] // TextBlock
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "text_block" {
                    for item in keyValue {
                        let p = TextBlock(json: item as! NSDictionary)
                        self.text_block.addObject(p)
                    }
                }
            }
        }
    }
    public class TextBlock:NSObject
    {
        var text:String = ""
        var left:Int = 0
        var top:Int = 0
        var width:Int = 0
        var height:Int = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RecognizeBarcodesResponse:NSObject {
    var barcode:NSMutableArray = [] // Barcode
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "barcode" {
                    for item in keyValue {
                        let p = Barcode(json: item as! NSDictionary)
                        self.barcode.addObject(p)
                    }
                }
            }
        }
    }
    public class Barcode:NSObject
    {
        var text:String = ""
        var barcode_type:String = ""
        var left:Int = 0
        var top:Int = 0
        var width:Int = 0
        var height:Int = 0
        var additional_information:AdditionalInformation?
        
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
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.additional_information = AdditionalInformation(json:keyValue)
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
    public class AdditionalInformation:NSObject
    {
        var country:String = ""
        
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RecognizeImagesResponse : NSObject{
    var object:NSMutableArray = [] // HODObject
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "object" {
                    for item in keyValue {
                        let p = HODObject(json: item as! NSDictionary)
                        self.object.addObject(p)
                    }
                }
            }
        }
    }
    public class HODObject:NSObject {
        var unique_name:String = ""
        var name:String = ""
        var db:String = ""
        var corners:NSMutableArray = []
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
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    isDictionary = true
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = Corners(json:item as! NSDictionary)
                            self.corners.addObject(c)
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
    public class Corners:NSObject {
        var x:Int = 0
        var y:Int = 0
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DetectFacesResponse : NSObject {
    var face:NSMutableArray = []
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "face" {
                    for item in keyValue {
                        let p = Face(json: item as! NSDictionary)
                        self.face.addObject(p)
                    }
                }
            }
        }
    }
    
    public class Face:NSObject {
        var left:Int = 0
        var top:Int = 0
        var width:Int = 0
        var height:Int = 0
        var additional_information:AdditionalInformation?
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                var isDictionary = false
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                } else if let _ = value as? NSDictionary {
                    let keyValue:NSDictionary = (value as? NSDictionary)!
                    isDictionary = true
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.additional_information = AdditionalInformation(json:keyValue)
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
    public class AdditionalInformation:NSObject {
        var age:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let keyValue:String = (value as? String) {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
        
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class PredictResponse:NSObject {
    var fields:NSMutableArray = []
    var values:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "fields" {
                    for item in keyValue {
                        let p = Fields(json: item as! NSDictionary)
                        self.fields.addObject(p)
                    }
                } else if keyName == "values" {
                    for item in keyValue {
                        let p = Values(json: item as! NSDictionary)
                        self.values.addObject(p)
                    }
                }
            }
        }
    }
    public class Fields:NSObject
    {
        var name: String = ""
        var order: Double = 0
        var type: String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    public class Values:NSObject
    {
        var row:NSMutableArray = []
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "row" {
                        for item in keyValue {
                            let p = item as! String
                            self.row.addObject(p)
                        }
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RecommendResponse:NSObject
{
    public var allRecommendations:NSMutableArray = []
    public var fields:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "fields" {
                    for item in keyValue {
                        let p = Fields(json: item as! NSDictionary)
                        self.fields.addObject(p)
                    }
                } else if keyName == "allRecommendations" {
                    for item in keyValue {
                        let p = Allrecommendations(json: item as! NSDictionary)
                        self.allRecommendations.addObject(p)
                    }
                }
            }
        }
    }
    public class Allrecommendations:NSObject
    {
        var originalValues:NSMutableArray = []
        var recommendations:NSMutableArray = []
        init(json : NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    if keyName == "originalValues" {
                        for item in keyValue {
                            let p = item as! String
                            self.originalValues.addObject(p)
                        }
                    } else if keyName == "recommendations" {
                        for item in keyValue {
                            let p = Recommendations(json: item as! NSDictionary)
                            self.recommendations.addObject(p)
                        }
                    }
                }
            }
        }
    }
    public class Recommendations:NSObject
    {
        var confidence:Double = 0
        var distance:Double = 0
        var new_prediction:String = ""
        var recommendation:NSMutableArray = []
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
                } else if let _ = value as? NSArray {
                    let keyValue:NSArray = (value as? NSArray)!
                    isDictionary = true
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.recommendation.addObject(c)
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
    public class Fields:NSObject
    {
        var name:String = ""
        var order:Int = 0
        var type:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Int {
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
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class TrainPredictorResponse:NSObject
{
    var message:String = ""
    var service:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CreateQueryProfileResponse:NSObject
{
    var message:String = ""
    var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteQueryProfileResponse:NSObject
{
    var message:String = ""
    var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the description conflict by changing it to _description
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RetrieveQueryProfileResponse:NSObject
{
    var query_profile:String = ""
    var _description:String = ""
    var query_manipulation_index:String = ""
    var promotions_enabled:Bool = false
    var promotion_categories:NSMutableArray = []
    var promotions_identified:Bool = false
    var synonyms_enabled:Bool = false
    var synonym_categories:NSMutableArray = []
    var blacklists_enabled:Bool = false
    var blacklist_categories:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var isDictionary = false
            var keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? Bool {
                keyValue = (value as? Bool)!
            } else if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                isDictionary = true
                if keyName == "promotion_categories" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.promotion_categories.addObject(c)
                        }
                    }
                } else if keyName == "synonym_categories" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.synonym_categories.addObject(c)
                        }
                    }
                } else if keyName == "blacklist_categories" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.blacklist_categories.addObject(c)
                        }
                    }
                }
            }
            if !isDictionary {
                if keyValue != nil {
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class UpdateQueryProfileResponse:NSObject
{
    var message:String = ""
    var query_profile:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class FindRelatedConceptsResponse:NSObject
{
    var entities:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "entities" {
                    for item in keyValue {
                        let p = Entities(json: item as! NSDictionary)
                        self.entities.addObject(p)
                    }
                }
            }
        }
    }
    public class Entities:NSObject
    {
        var cluster:Double = 0
        var docs_with_all_terms:Double = 0
        var docs_with_phrase:Double = 0
        var occurrences:Double = 0
        var text:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class AutoCompleteResponse:NSObject
{
    var words:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "words" {
                    for item in keyValue {
                        let p = item as! String
                        self.words.addObject(p)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ExtractConceptsResponse:NSObject
{
    var concepts:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "concepts" {
                    for item in keyValue {
                        let p = Concepts(json: item as! NSDictionary)
                        self.concepts.addObject(p)
                    }
                }
            }
        }
    }
    public class Concepts:NSObject
    {
        var concept:String = ""
        var occurrences:Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ExpandTermsResponse:NSObject
{
    var terms:NSMutableArray = [] // ( array[Terms] )  The details of the expanded terms.
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "terms" {
                    for item in keyValue {
                        let p = Terms(json: item as! NSDictionary)
                        self.terms.addObject(p)
                    }
                }
            }
        }
    }
    public class Terms:NSObject
    {
        var documents:Double = 0
        var term:String = ""
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class HighlightTextResponse:NSObject
{
    var text:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class IdentifyLanguageResponse:NSObject
{
    var encoding:String = ""
    var language:String = ""
    var language_iso639_2b:String = ""
    var unicode_scripts:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var isDictionary = false
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? Bool {
                keyValue = (value as? Bool)!
            } else if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                isDictionary = true
                if keyName == "unicode_scripts" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = item as! String
                            self.unicode_scripts.addObject(c)
                        }
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
//////////////////////----------------////////////////////////

// Solved the case conflict by changing it to _case
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class TokenizeTextResponse:NSObject
{
    var terms:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "terms" {
                    for item in keyValue {
                        let p = Terms(json: item as! NSDictionary)
                        self.terms.addObject(p)
                    }
                }
            }
        }
    }
    public class Terms:NSObject
    {
        var _case:String = ""
        var documents:Double = 0
        var length:Double = 0
        var numeric:Double = 0
        var occurrences:Double = 0
        var start_pos:Double = 0
        var stop_word :String = ""
        var term:String = ""
        var weight:Double = 0
        init(json:NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if keyName == "case" {
                        keyName = "_case"
                    }
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
class SentimentAnalysisResponse:NSObject
{
    var positive:NSMutableArray = []
    var negative:NSMutableArray = []
    var aggregate : Aggregate!
    
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "positive" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.positive.addObject(p)
                    }
                } else if keyName == "negative" {
                    for item in keyValue {
                        let p = Entity(json: item as! NSDictionary)
                        self.negative.addObject(p)
                    }
                }
            } else if let _ = value as? NSDictionary {
                if let keyValue:NSDictionary = (value as? NSDictionary) {
                    if keyName == "aggregate" {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.aggregate = Aggregate(json:keyValue)
                        }
                    }
                }
            }
        }
    }
    class Aggregate:NSObject {
        var sentiment : String = ""
        var score : Double = 0.0
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                } else if let _ = value as? Double {
                    keyValue = (value as? Double)!
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
    class Entity:NSObject
    {
        var sentiment:String = ""
        var topic:String = ""
        var score:Double = 0.0
        var original_text:String = ""
        var original_length:Int = 0
        var normalized_text:String = ""
        var normalized_length:Int = 0
        
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyVal:AnyObject!
                if let _ = value as? String {
                    keyVal = (value as? String)!
                } else if let _ = value as? Double {
                    keyVal = (value as? Double)!
                }
                if keyVal != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyVal, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class AddToTextIndexResponse:NSObject
{
    var index:String = ""
    var references:NSMutableArray = []
    init(json:NSDictionary) {
        super.init()
        for (key, value) in json {
            var isDictionary = false
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
            } else if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                isDictionary = true
                if keyName == "references" {
                    for item in keyValue {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            let c = References(json: item as! NSDictionary)
                            self.references.addObject(c)
                        }
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
    public class References:NSObject
    {
        var id:Double = 0
        var reference:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                let keyName:String = (key as? String)!
                var keyVal:AnyObject!
                if let _ = value as? String {
                    keyVal = (value as? String)!
                } else if let _ = value as? Double {
                    keyVal = (value as? Double)!
                }
                if keyVal != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyVal, forKey: keyName)
                    }
                }
            }
        }

    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class CreateTextIndexResponse:NSObject
{
    var index:String = ""
    var message:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteTextIndexResponse:NSObject
{
    var confirm:String = ""
    var deleted:Bool!
    var index:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyVal:AnyObject!
            if let _ = value as? String {
                keyVal = (value as? String)!
            } else if let _ = value as? Bool {
                keyVal = (value as? Bool)!
            }
            if keyVal != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyVal, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class DeleteFromTextIndexResponse:NSObject
{
    var documents_deleted :Double = 0
    var index:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyVal:AnyObject!
            if let _ = value as? String {
                keyVal = (value as? String)!
            } else if let _ = value as? Double {
                keyVal = (value as? Double)!
            }
            if keyVal != nil {
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyVal, forKey: keyName)
                }
            }
        }
    }

    
}
//////////////////////----------------////////////////////////

// Solved the 24hr problem by changing it to _24hr
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class IndexStatusResponse:NSObject
{
    var _24hr_index_updates:Double = 0
    var component_count:Double = 0
    var total_documents:Double = 0
    var total_index_size:Double = 0
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            var keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? Double {
                keyValue = (value as? Double)!
                if keyName == "24hr_index_updates" {
                    keyName = "_24hr_index_updates"
                }
                if keyValue != nil {
                    if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                        self.setValue(keyValue, forKey: keyName)
                    }
                }
            }
        }
    }
}
//////////////////////----------------////////////////////////

// Solved the description conflict by changing it to _description
/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class ListResourcesResponse:NSObject
{
    var private_resources:NSMutableArray = []
    var public_resources:NSMutableArray = []
    init(json : NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            if let _ = value as? NSArray {
                let keyValue:NSArray = (value as? NSArray)!
                if keyName == "private_resources" {
                    for item in keyValue {
                        let p = Private_resources(json: item as! NSDictionary)
                        self.private_resources.addObject(p)
                    }
                } else if keyName == "public_resources" {
                    for item in keyValue {
                        let p = Public_resources(json: item as! NSDictionary)
                        self.public_resources.addObject(p)
                    }
                }
            }
        }
    }
    public class Private_resources:NSObject
    {
        var date_created:String = ""
        var _description:String = ""
        var flavor:String = ""
        var resource:String = ""
        var type:String = ""
        var display_name:String = ""
        var resourceUUID:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                    if keyName == "description" {
                        keyName = "_description"
                    }
                    if keyValue != nil {
                        if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                            self.setValue(keyValue, forKey: keyName)
                        }
                    }
                }
            }
        }
    }
    public class Public_resources:NSObject
    {
        var _description:String = ""
        var resource:String = ""
        var type:String = ""
        init(json: NSDictionary) {
            super.init()
            for (key, value) in json {
                var keyName:String = (key as? String)!
                var keyValue:AnyObject?
                if let _ = value as? String {
                    keyValue = (value as? String)!
                    if keyName == "description" {
                        keyName = "_description"
                    }
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
//////////////////////----------------////////////////////////


/************************************************************/
//////////////////////////////////////////////////////////////
/************************************************************/
public class RestoreTextIndexResponse:NSObject
{
    var restored:String = ""
    init(json: NSDictionary) {
        super.init()
        for (key, value) in json {
            let keyName:String = (key as? String)!
            var keyValue:AnyObject?
            if let _ = value as? String {
                keyValue = (value as? String)!
                if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
}
//////////////////////---------------/////////////////////////