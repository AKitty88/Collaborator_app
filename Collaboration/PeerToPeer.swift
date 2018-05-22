//
//  PeerToPeer.swift
//  Collaboration
//
//  Created by Kitti Almasy on 21/5/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerToPeerManagerDelegate: AnyObject {
    func manager(_ manager: PeerToPeerManager, didReceive data: Data)
}

class PeerToPeerManager: NSObject {
    static let serviceType = "task-exchange"
    var delegate: PeerToPeerManagerDelegate?
    
    private let peerId = MCPeerID(displayName: "first person")
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    public var session: MCSession
    
    override init() {
        let service = PeerToPeerManager.serviceType
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: [ peerId.displayName : UIDevice.current.name ], serviceType: service)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: service)
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
        session.delegate = self
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func invite(peer: MCPeerID, timeout t: TimeInterval = 10) {
        print("inviting \(peer.displayName)")        
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
        print("session: \(session) , session.connectedPeers: \(session.connectedPeers)")
    }
    
    func send(peers: [MCPeerID], data: Data) {
        guard !peers.isEmpty else { return }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending \(data.count) bytes: \(error)")
        }
    }
    
    func send(data: Data) {
        guard !session.connectedPeers.isEmpty else { return }
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending \(data.count) bytes: \(error)")
        }
    }
}

extension PeerToPeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, session)
    }
}

extension PeerToPeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID) - \(info?.description ?? "<no info>")")
        invite(peer: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
    }
}


extension PeerToPeerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        DispatchQueue.main.async {
            self.delegate?.manager(self, didReceive: data)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
}
