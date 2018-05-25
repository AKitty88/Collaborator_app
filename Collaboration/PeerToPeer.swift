//
//  PeerToPeer.swift
//  Collaboration
//
//  Created by Kitti Almasy on 21/5/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerToPeerManagerDelegate: AnyObject {
    func manager(_ manager: PeerToPeerManager, didReceive data: Data)
    func updatePeers()
}

class PeerToPeerManager: NSObject {
    static let serviceType = "task-kitty"
    var delegate: PeerToPeerManagerDelegate?
    
    let peerId = MCPeerID(displayName: "User \(arc4random_uniform(10))")
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    public var session: MCSession
    
    override init() {
        print("PtP - init")
        let service = PeerToPeerManager.serviceType
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: [ peerId.displayName : UIDevice.current.name ], serviceType: service)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: service)
        super.init()
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        print("PtP - deinit")
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func invite(peer: MCPeerID, timeout t: TimeInterval = 10) {
        print("PtP - invite \(peer.displayName)")
        
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
        print("session: \(session) , session.connectedPeers: \(session.connectedPeers)")
    }
    
    func send(data: Data) {
        print("PtP - send")
        
        guard !session.connectedPeers.isEmpty else { return }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("PtP - Error sending \(data.count) bytes: \(error)")
        }
    }
}

extension PeerToPeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("PtP - advertiser didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("PtP - advertiser didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, session)
    }
}

extension PeerToPeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("PtP - browser didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("PtP - browser foundPeer: \(peerID) - \(info?.description ?? "<no info>")")
        invite(peer: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("PtP - browser lostPeer: \(peerID)")
    }
}


extension PeerToPeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("PtP - session peer \(peerID) didChangeState: \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("PtP - session didReceiveData: \(data)")
        DispatchQueue.main.async {
            self.delegate?.manager(self, didReceive: data)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("PtP - session didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("PtP - session didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("PtP - session didFinishReceivingResourceWithName")
    }
}
