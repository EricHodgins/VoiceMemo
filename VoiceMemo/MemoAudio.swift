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
