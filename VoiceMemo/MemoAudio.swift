//
//  MemoAudio.swift
//  VoiceMemo
//
//  Created by Eric Hodgins on 2016-10-16.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import AVFoundation

class MemoSessionManager {
    static let sharedInstance = MemoSessionManager()
    
    let session: AVAudioSession!
    
    var permissionGranted: Bool {
        return session.recordPermission() == .granted
    }
    
    private init() {
        session = AVAudioSession.sharedInstance()
        configureSession()
    }
    
    private func configureSession() {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func requestPermission(completion: @escaping ((Bool) -> Void)) {
        session.requestRecordPermission { (permissionAllowed) in
            completion(permissionAllowed)
        }
    }
}

class MemoRecorder {
    static let sharedInstance = MemoRecorder()
    
    static let settings: [String : Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 22050.0,
        AVEncoderBitDepthHintKey: 16 as NSNumber,
        AVNumberOfChannelsKey: 1 as NSNumber,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    static func outPutURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths.first!
        let url = documentDirectory.appendingPathComponent("memo.m4a")
        
        return url
    }
    
    let recorder: AVAudioRecorder
    
    private init() {
        self.recorder =  try! AVAudioRecorder(url: MemoRecorder.outPutURL(), settings: MemoRecorder.settings)
        recorder.prepareToRecord()
    }
    
    func start() {
        recorder.record()
    }
    
    func stop() -> String {
        recorder.stop()
        return recorder.url.absoluteString
    }
}





























