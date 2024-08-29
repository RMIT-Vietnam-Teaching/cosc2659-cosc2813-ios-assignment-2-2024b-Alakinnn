//
//  ToastManager.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

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
