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
    
    static func saveSpot(spot: Spot) -> Bool {
        let db = Firestore.firestore()
        
        if let id = spot.id { // if true the spot exists
            do {
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data update successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else { // We need to add a new spot & create new id
            do {
                try db.collection("spots").addDocument(from: spot)
                print("🐣 Data added successfuly!")
                return true
            } catch {
                print("😡 ERROR: Could not add data in 'spots' \(error.localizedDescription)")
                return false
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
