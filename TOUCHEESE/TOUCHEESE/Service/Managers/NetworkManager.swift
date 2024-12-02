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
    
    /// 스튜디오 데이터를 요청하는 함수
    /// - Parameter concept: 스튜디오 컨셉
    /// - Parameter isHighRating: 점수 필터 (True에 적용 O, False와 Nil일 때 적용 X)
    /// - Parameter regionArray: 지역 필터 (배열에 해당하는 Region 타입을 담아서 사용)
    /// - Parameter isLowpricing: 가격 필터 (True == 낮은 가격순, False == 높은 가격순, Nil == 적용 X)
    /// - Parameter page: 페이지(페이징 처리에 사용, 서버 자체적으로 Nil일 때 기본값 1 적용)
    func getStudioListDatas(
        concept: StudioConcept,
        isHighRating: Bool? = nil,
        regionArray: [StudioRegion]? = nil,
        price: StudioPrice? = nil,
        page: Int? = nil
    ) async throws -> [Studio] {
        
        // request 생성
        let fetchRequest = Network.studioListRequest(
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
            // print("네트워크 통신 결과 (JSON 문자열) ===== \(String(data: data, encoding: .utf8) ?? "nil")")
            
            // 데이터를 StudioList로 디코딩
            let decoder = JSONDecoder()
            do {
                let studioList = try decoder.decode(StudioData.self, from: data)
                //print("디코딩된 Studio 배열 ===== \(studios)")
                return studioList.data.content
            } catch {
                print("디코딩 실패: \(error)")
                throw error
            }
            
        case .failure(let error):
            print("네트워크 요청 실패: \(error)")
            throw error
        }
    }
    
    /// 스튜디오의 자세한 데이터를 요청하는 메서드
    /// - Parameter studioID: 스튜디오 아이디
    func getStudioDetailData(studioID id: Int) async throws -> StudioDetail {
        let fetchRequest = Network.studioDetailRequest(id: id)
        let url = fetchRequest.baseURL + fetchRequest.path
        
        let request = AF.request(
            url,
            method: fetchRequest.method,
            parameters: fetchRequest.parameters,
            encoding: fetchRequest.encoding,
            headers: fetchRequest.headers
        )
        
        let reponse = await request.validate()
            .serializingData()
            .response
        
        switch reponse.result {
        case .success(let data):
            let decoder = JSONDecoder()
            
            do {
                let studioDetailData = try decoder.decode(StudioDetailData.self, from: data)
                
                return studioDetailData.data
            } catch {
                print("스튜디오 디테일 디코딩 실패: \(error.localizedDescription)")
                throw error
            }
        case .failure(let error):
            print("스튜디오 디테일 API 요청 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
