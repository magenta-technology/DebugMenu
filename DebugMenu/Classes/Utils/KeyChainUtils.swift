//
//  KeyChainService.swift
//  DebugMenu
//
//  Created by Pavel Volkhin on 05.12.2019.
//

import Foundation
import Security

@objc open class KeyChainUtils: NSObject {
    @objc public static var keyChainGroupStr: String?
    @objc public static var maxRecentCount: UInt = 10
    static let recentCredentialUrl = "url://recentCredential"
    static let recentUrls = "url://recentUrls"
    
    @objc public class func setDefaultGroupIfNeeded() {
        keyChainGroupStr = keyChainGroup()
    }

    @objc public class func keyChainGroup() -> String? {
        if let keyChain = keyChainGroupStr {
            return keyChain
        }
        guard let appIdentifierPrefix = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String,
            let target = Bundle.main.infoDictionary?["TargetName"] as? String,
            let path = Bundle.main.path(forResource: target,
                                        ofType: "entitlements"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let keyChains = dictionary["keychain-access-groups"] as? [String],
            let keyChain = keyChains.first(where: { $0.hasSuffix("Shared")}) else {
                return nil
        }
        keyChainGroupStr = keyChain.replacingOccurrences(of: "$(AppIdentifierPrefix)", with: appIdentifierPrefix)
        return keyChainGroupStr
    }

    @objc public class func removeDataForKey(url: String) {
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: url,
                                    kSecReturnAttributes as String: kCFBooleanTrue,
                                    kSecReturnData as String: kCFBooleanTrue]
        if let keyChainStr = keyChainGroupStr {
            query[kSecAttrAccessGroup as String] = keyChainStr as Any
        }
        SecItemDelete(query as CFDictionary)
    }

    @objc public class func getDataForKey(url: String) -> String? {
        if url.isEmpty {
            return nil
        }
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: url,
                                    kSecReturnAttributes as String: kCFBooleanTrue,
                                    kSecReturnData as String: kCFBooleanTrue]
        if let keyChainStr = keyChainGroupStr {
            query[kSecAttrAccessGroup as String] = keyChainStr as Any
        }
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound || status != errSecSuccess {
            return nil
        }
        guard let existingItem = item as? [String : Any],
            let data = existingItem[kSecAttrAccount as String] as? String else {
            return nil
        }
        return data
        
    }

    @objc public class func saveDataForKey(data: String, url: String) {
        if data.isEmpty || url.isEmpty {
            return
        }
        removeDataForKey(url: url)
        let passwordData = "".data(using: .utf8) as Any
        var attributes: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                         kSecAttrServer as String: url,
                                         kSecValueData as String: passwordData,
                                         kSecAttrAccount as String: data]
        if let keyChainStr = keyChainGroupStr {
            attributes[kSecAttrAccessGroup as String] = keyChainStr as Any
        }
        SecItemAdd(attributes as CFDictionary, nil)
    }

    @objc public class func setRecentCredential(credential: Credential, urlString: String) {
        let url = URL(string: urlString)
        let urlString = String(format: "%@_%@", recentCredentialUrl, url?.host ?? "")
        let credentialStr = String(format: "%@{:2}%@{:2}%@",
                                   credential.username,
                                   credential.password,
                                   credential.account ?? "")
        var credentialsArr = [String]()
        let recentCredentials = getDataForKey(url: urlString)
        if let credentials = recentCredentials, credentials.count > 0 {
            credentialsArr = credentials.components(separatedBy: "{:1}")
        }
        credentialsArr.removeAll(where: {$0 == credentialStr})
        credentialsArr.insert(credentialStr, at: 0)
        var newCredentialsArr = [String]()
        var privateCount = 0
        var bussinesCount = 0
        credentialsArr.forEach { str in
            let arr = str.components(separatedBy: "{:2}")
            if arr[2].isEmpty {
                if bussinesCount < maxRecentCount && !newCredentialsArr.contains(str) {
                    newCredentialsArr.append(str)
                    bussinesCount += 1
                }
            } else {
                if privateCount < maxRecentCount && !newCredentialsArr.contains(str) {
                    newCredentialsArr.append(str)
                    privateCount += 1
                }
            }
        }
        let result = newCredentialsArr.joined(separator: "{:1}")
        if !result.isEmpty {
            saveDataForKey(data: result, url: urlString)
        }
    }

    @objc public class func getRecentCredentialForUrl(urlString: String) -> [Credential] {
        let url = URL(string: urlString)
        let urlString = String(format: "%@_%@", recentCredentialUrl, url?.host ?? "")
        let recentCredentials = getDataForKey(url: urlString)
        guard let credentials = recentCredentials, !credentials.isEmpty  else {
            return []
        }
        let credentialsArr = credentials.components(separatedBy: "{:1}")
        if credentialsArr.isEmpty {
            return []
        }
        var result = [Credential]()
        credentialsArr.forEach { str in
            let strArr = str.components(separatedBy: "{:2}")
            let credential = Credential(username: strArr[0],
                                        password: strArr[1],
                                        account: strArr.atIndex(2))
            result.append(credential)
        }
        return result
    }

    @objc public class func saveRecentUrl(hostUrl: HostUrl) {
        let recentUrlsStr = getDataForKey(url: recentUrls)
        let urlStr = String(format: "%@{:2}%@", hostUrl.name, hostUrl.url)
        var urlsArr = recentUrlsStr?.components(separatedBy: "{:1}") ?? []
        urlsArr.removeAll(where: {$0 == urlStr})
        urlsArr.append(urlStr)
        var newUrlsArr = [String]()
        urlsArr.enumerated().forEach { idx, str in
            if idx < maxRecentCount {
                newUrlsArr.append(str)
            }
        }
        saveDataForKey(data: newUrlsArr.joined(separator: "{:1}"), url: recentUrls)
    }

    @objc public class func getRecentUrls() -> [HostUrl] {
        let recentUrlsStr = getDataForKey(url: recentUrls)
        guard let urls = recentUrlsStr, !urls.isEmpty else {
            return []
        }
        return urls.components(separatedBy: "{:1}")
            .map { str -> HostUrl in
                let strArr = str.components(separatedBy: "{:2}")
                return HostUrl(name: strArr.atIndex(0) ?? "",
                               url: strArr.atIndex(1) ?? "")
        }
    }
}
