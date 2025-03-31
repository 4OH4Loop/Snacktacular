//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Carolyn Ballinger on 3/31/25.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel {
    
    static func saveSpot(spot: Spot) async -> String? {
        let db = Firestore.firestore()
        
        if let id = spot.id { // if true the spot exists
            do {
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data update successfully!")
                return id
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return id
            }
        } else { // We need to add a new spot & create new id
            do {
                let docRef = try db.collection("spots").addDocument(from: spot)
                print("🐣 Data added successfuly!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not add data in 'spots' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func deleteSpot(spot: Spot) {
        let db = Firestore.firestore()
        guard let id = spot.id else {
            print("No spot.id")
            return
        }
        Task {
            do {
                try await db.collection("spots").document(id).delete()
                print("😎 Data deleted successfully!")
            } catch {
                print("😡 ERROR: Could not delete document \(id). \(error.localizedDescription)")
            }
        }
        
    }
}
