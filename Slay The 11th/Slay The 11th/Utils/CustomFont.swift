/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 29/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import SwiftUI

extension Font {
    static func kreon(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("Kreon", size: size).weight(weight)
    }

    // Renamed custom styles to avoid conflicts
    static var kreonTitle: Font {
        return .kreon(size: 36, weight: .bold)
    }

    static var kreonTitle2: Font {
        return .kreon(size: 32, weight: .semibold)
    }

    static var kreonBody: Font {
        return .kreon(size: 26, weight: .regular)
    }

    static var kreonCaption: Font {
        return .kreon(size: 24, weight: .regular)
    }

    static var kreonHeadline: Font {
        return .kreon(size: 22, weight: .bold)
    }

    static var kreonSubheadline: Font {
        return .kreon(size: 20, weight: .regular)
    }
}

