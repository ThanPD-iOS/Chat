//
//  Created by Alex.M on 27.06.2022.
//

import Foundation
import ExyteChat

struct MockUser: Equatable {
    let uid: String
    let name: String
    let avatar: URL?

    init(uid: String, name: String, avatar: URL? = nil) {
        self.uid = uid
        self.name = name
        self.avatar = avatar
    }
}

extension MockUser {
    func toChatUser(messageRole: MessageRole) -> ExyteChat.MessageRole {
        return messageRole
    }
}
