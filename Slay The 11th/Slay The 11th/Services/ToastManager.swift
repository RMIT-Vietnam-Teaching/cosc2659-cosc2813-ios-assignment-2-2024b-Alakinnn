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

import Foundation
@Observable class ToastManager {
    static let shared = ToastManager()
    var toastMessage: String?
    var showToast = false

    func showToast(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showToast = false
        }
    }
}
