//
//  LocalProvider.swift
//  TodoAll
//
//  Created by Franklin Cruz on 27-10-20.
//  Copyright © 2020 S.Y.Soft. All rights reserved.
//

import Foundation
import Combine

class LocalProvider: Provider {
    private static var storeNames = [
        Task.typeName: "tasks"
    ]
    
    class func registerStoreName(forType type: Any.Type) {
        storeNames[String(describing: type)] = String(describing: type)
    }
    
    private func getAllData<T>() -> [T] where T : Identifiable  & Codable {
        let userDefaults = UserDefaults.standard
        
        guard let storeName = LocalProvider.storeNames[T.typeName] else { return [] }
        
        guard let data = userDefaults.data(forKey:  storeName) else { return [] }
        
        let decoder = JSONDecoder()
        
        if let decoded = try? decoder.decode([T].self, from: data) {
            return decoded
        }
        
        return []
    }
    
    private func save<T>(data: [T]) where T : Identifiable  & Codable {
        let userDefaults = UserDefaults.standard
        
        guard let storeName = LocalProvider.storeNames[T.typeName] else { return }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.set(encoded, forKey: storeName)
        }
    }
    
    func list<T>(filter: [String : Any]?, sort: [String : SortDirection]?) -> Future<[T], ServiceError> where T : Identifiable  & Codable {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                promise(.success(self.getAllData()))
            }
        }
    }
    
    func get<T>(byId id: T.ID) -> Future<T?, ServiceError> where T : Identifiable & Codable  {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                let data: T? = self.getAllData().first(where: { $0.id == id })
                promise(.success(data))
            }
        }
    }
    
    func create<T>(_ element: T) -> Future<T?, ServiceError> where T : Identifiable & Codable {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                var all: [T] = self.getAllData()
                all.append(element)
                self.save(data: all)
                promise(.success(element))
            }
        }
    }
    
    func update<T>(_ element: T) -> Future<T?, ServiceError> where T : Identifiable & Codable {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                var all: [T] = self.getAllData()
                all.removeAll(where: {$0.id == element.id})
                all.append(element)
                self.save(data: all)
                promise(.success(element))
            }
        }
    }
    
    func delete<T>(byId id: T.ID) -> Future<T?, ServiceError> where T : Identifiable & Codable {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                var all: [T] = self.getAllData()
                let element = all.first(where: { $0.id == id})
                all.removeAll(where: {$0.id == id})
                self.save(data: all)
                promise(.success(element))
            }
        }
    }
}
