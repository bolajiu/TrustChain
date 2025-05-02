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