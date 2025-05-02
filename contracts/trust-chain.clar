;; Title: TrustChain - Decentralized Reputation Protocol
;; 
;; Summary:
;; A Bitcoin-native reputation system for Stacks Layer 2, enabling decentralized 
;; identity management with transparent reputation scoring and time-based decay.
;;
;; Description:
;; TrustChain implements a blockchain-based reputation framework that allows users
;; to establish portable digital identities with quantifiable trust metrics.
;; The protocol supports various reputation-building actions with configurable
;; impact multipliers and incorporates a natural decay mechanism to ensure
;; reputation scores remain current and accurate over time.

;; Constants & Error Codes

;; Error Codes
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-PARAMETERS (err u101))
(define-constant ERR-IDENTITY-EXISTS (err u102))
(define-constant ERR-IDENTITY-NOT-FOUND (err u103))
(define-constant ERR-INSUFFICIENT-REPUTATION (err u104))
(define-constant ERR-MAX-REPUTATION-REACHED (err u105))

;; System Constants
(define-constant MAX-REPUTATION-SCORE u1000)
(define-constant MIN-REPUTATION-SCORE u0)
(define-constant REPUTATION-DECAY-RATE u10)  ;; 10% decay per period

;; Data Storage

(define-map identities 
  {owner: principal}
  {
    did: (string-ascii 50),  ;; Decentralized Identity
    reputation-score: uint,
    created-at: uint,
    last-updated: uint
  }
)

(define-map reputation-actions
  {action-type: (string-ascii 50)}
  {multiplier: uint}
)

;; Private Functions

(define-private (is-valid-owner (owner principal))
  (and 
    (is-some (map-get? identities {owner: owner}))
    (is-eq owner tx-sender)
  )
)

;; Public Functions

;; Initialize Reputation Actions
(define-public (initialize-reputation-actions)
  (begin
    (map-set reputation-actions 
      {action-type: "governance-vote"} 
      {multiplier: u5}
    )
    (map-set reputation-actions 
      {action-type: "contract-fulfillment"} 
      {multiplier: u10}
    )
    (map-set reputation-actions 
      {action-type: "community-contribution"} 
      {multiplier: u7}
    )
    (ok true)
  )
)

;; Create New Identity
(define-public (create-identity (did (string-ascii 50)))
  (let 
    (
      (sender tx-sender)
      (current-stacks-block-height stacks-block-height)
    )
    (begin
      (asserts! (is-none (map-get? identities {owner: sender})) 
        (err ERR-IDENTITY-EXISTS))
      
      (asserts! (> (len did) u5) 
        (err ERR-INVALID-PARAMETERS))
      
      (map-set identities 
        {owner: sender}
        {
          did: did,
          reputation-score: u50,  ;; Starting reputation
          created-at: current-stacks-block-height,
          last-updated: current-stacks-block-height
        }
      )
      (ok did)
    )
  )
)