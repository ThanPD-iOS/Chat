//
//  ChatTheme+UserType.swift
//  Chat
//
//  Created by ftp27 on 21.02.2025.
//

import SwiftUI

extension ChatTheme.Colors {
    func messageBG(_ type: MessageRole) -> Color {
        switch type {
        case .user: messageMyBG
        case .assistant: messageSystemBG
        }
    }
    
    func messageText(_ type: MessageRole) -> Color {
        switch type {
        case .user: messageMyText
        case .assistant: messageSystemText
        }
    }
    
    func messageTimeText(_ type: MessageRole) -> Color {
        switch type {
        case .user: messageMyTimeText
        case .assistant: messageSystemTimeText
        }
    }
}
