//
//  ViewModelList.swift
//  pure_MVVM
//
//  Created by matias on 13/12/2023.
//

import Foundation

class ViewModelList{
    
    // Crea un mecanismo para enlazar la vista con el modelo de la vista
    var refreshData = { ()->() in } // va a llamar a los datos actualizados
    
    // Fuente de datos
    var dataArray: [List] = [] {
        didSet{
            refreshData()
        }
    }
    
    private var error: Error?
    
    //¡¡¡ No debería ir aquí!!! en condiciones normales habria que crear una capa de conexión para hacer ete tipo de cosas. E instanciar desde aquí el objeto de capa de conexión.
    
    // Obtener los datos de la API
       func retrieveDataList() {
           guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

           URLSession.shared.dataTask(with: url) { (data, response, error) in
               // Check for network errors
               guard error == nil else {
                   self.error = error
                   self.handleDataRetrievalCompletion()
                   return
               }

               // Check for response status code
               guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode) else {
                   let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                   self.error = NSError(domain: "ServerError", code: statusCode, userInfo: nil)
                   self.handleDataRetrievalCompletion()
                   return
               }

               // Check if data is available
               guard let jsonData = data, !jsonData.isEmpty else {
                   self.error = NSError(domain: "NoData", code: 0, userInfo: nil)
                   self.handleDataRetrievalCompletion()
                   return
               }

               // Deserialize the data
               do {
                   let decoder = JSONDecoder()
                   self.dataArray = try decoder.decode([List].self, from: jsonData)
                   self.handleDataRetrievalCompletion()
               } catch let error {
                   self.error = error
                   self.handleDataRetrievalCompletion()
               }

           }.resume()
       }

       private func handleDataRetrievalCompletion() {
           // lógica adicional aquí según sea necesario
           // Por ejemplo, podrías actualizar la interfaz de usuario o realizar otras acciones
           print("Datos obtenidos: \(dataArray)")
           print("Error: \(error?.localizedDescription ?? "Ninguno")")
       }
   }
