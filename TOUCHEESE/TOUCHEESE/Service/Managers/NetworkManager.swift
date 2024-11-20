//
//  NetworkManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    func request(target: TargetType) async throws -> Data {
        // URL 주소 생성
        let url = target.baseURL + target.path
        
        // 네트워크 호출
        let request = AF.request(url,
                                 method: target.method,
                                 parameters: target.parameters,
                                 encoding: target.encoding,
                                 headers: target.headers)
        
        // Alamofire의 async/await 지원 기능으로 responseData 호출
        let response = await request.validate()
            .serializingData()
            .response
        switch response.result {
        case .success(let data):
            print("네트워크 통신 결과: \(data)")
            return data
        case .failure(let error):
            throw error
        }
    }
    
    /// 컨셉에 해당하는 스튜디오를 요청하는 함수
    func requestConceptStudio(concept: StudioConcept) async throws -> [Studio] {
        let requestType = Network.conceptRequestType(concept: concept)
        let url = requestType.baseURL + requestType.path
        
        // 네트워크 요청
        let request = AF.request(url,
                                 method: requestType.method,
                                 parameters: requestType.parameters,
                                 encoding: requestType.encoding,
                                 headers: requestType.headers)
        
        // 응답을 받기
        let response = await request.validate()
        // 비동기 방식의 응답 처리 메서드.
        // 서버의 HTTP 응답 데이터를 Data 형식으로 직렬화(serialization)하여 반환받을 수 있다.
            .serializingData()
            .response
        
        switch response.result {
        case .success(let data):
            print("네트워크 통신 결과 (JSON 문자열) ===== \(String(data: data, encoding: .utf8) ?? "nil")")
            
            // 데이터를 StudioList로 디코딩
            let decoder = JSONDecoder()
            do {
                let studioList = try decoder.decode(StudioData.self, from: data)
                let studios = studioList.data.content
                print("디코딩된 Studio 배열 ===== \(studios)")
                return studios
            } catch {
                print("디코딩 실패: \(error)")
                throw error
            }
            
        case .failure(let error):
            print("네트워크 요청 실패: \(error)")
            throw error
        }
    }
    
    /// 스튜디오 데이터를 요청하는 함수
    /// - Parameter concept: 스튜디오 컨셉
    /// - Parameter isHighRating: 점수 필터 (True에 적용 O, False와 Nil일 때 적용 X)
    /// - Parameter regionArray: 지역 필터 (배열에 해당하는 Region 타입을 담아서 사용)
    /// - Parameter isLowpricing: 가격 필터 (True == 낮은 가격순, False == 높은 가격순, Nil == 적용 X)
    /// - Parameter page: 페이지(페이징 처리에 사용, 서버 자체적으로 Nil일 때 기본값 1 적용)
    func fetchStudioDatas(
        concept: StudioConcept,
        isHighRating: Bool? = nil,
        regionArray: [StudioRegion]? = nil,
        price: StudioPrice? = nil,
        page: Int? = nil
    ) async throws -> [Studio] {
        
        // request 생성
        let fetchRequest = Network.tempStudioRequest(
            concept: concept,
            isHighRating: isHighRating,
            regionArray: regionArray,
            price: price,
            page: page
        )
        
        // url 생성
        let url = fetchRequest.baseURL + fetchRequest.path
        
        // 네트워크 요청
        let request = AF.request(
            url,
            method: fetchRequest.method,
            parameters: fetchRequest.parameters,
            encoding: fetchRequest.encoding,
            headers: fetchRequest.headers
        )
        
        // 응답 비동기로 수신(serializingData)
        let response = await request.validate()
            .serializingData()
            .response
        
        switch response.result {
        case .success(let data):
            print("네트워크 통신 결과 (JSON 문자열) ===== \(String(data: data, encoding: .utf8) ?? "nil")")
            
            // 데이터를 StudioList로 디코딩
            let decoder = JSONDecoder()
            do {
                let studioList = try decoder.decode(StudioData.self, from: data)
                let studios = studioList.data.content
                print("디코딩된 Studio 배열 ===== \(studios)")
                return studios
            } catch {
                print("디코딩 실패: \(error)")
                throw error
            }
            
        case .failure(let error):
            print("네트워크 요청 실패: \(error)")
            throw error
        }
    }
}
