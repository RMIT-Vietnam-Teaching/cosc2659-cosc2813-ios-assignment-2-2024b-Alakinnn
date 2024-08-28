//
//  FirebaseAPI.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import Firebase

@Observable class FirebaseManager {
  var players: [PlayerScore] = []
 func fetchPlayers() -> Void {
   let db = Firestore.firestore()
      db.collection("players").order(by: "score", descending: true).getDocuments { (snapshot, error) in
               if let error = error {
                   print("Error fetching players: \(error)")
                   self.players = [] // Clear players array on error
               } else {
                   self.players = snapshot?.documents.compactMap {
                       try? $0.data(as: PlayerScore.self)
                   } ?? []
               }
           }
    }

  func addNewPlayer(name: String, completion: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    let playerRef = db.collection("players").document()
            let newPlayer = PlayerScore(id: playerRef.documentID, name: name, score: 0)
            do {
                try playerRef.setData(from: newPlayer) { error in
                    if let error = error {
                        print("Error adding player: \(error)")
                        completion(false)
                    } else {
                        self.fetchPlayers()
                        completion(true)
                    }
                }
            } catch {
                print("Error serializing player data: \(error)")
                completion(false)
            }
      }

  func updatePlayerScore(playerId: String, newScore: Int, completion: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    let playerRef = db.collection("players").document(playerId)
            playerRef.updateData(["score": newScore]) { error in
                if let error = error {
                    print("Error updating score: \(error)")
                    completion(false)
                } else {
                    self.fetchPlayers() 
                    print("Score updated successfully")
                    completion(true)
                }
            }
        }
}

