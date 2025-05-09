# TrustChain

## Decentralized Reputation Protocol for Stacks Layer 2

## Overview

**TrustChain** is a Bitcoin-native, decentralized reputation protocol built on the Stacks Layer 2 blockchain. It empowers users to create portable digital identities with transparent, verifiable trust scores that evolve over time. By linking trust to real actions and introducing a natural decay mechanism, TrustChain ensures that reputations remain both credible and current.

## Features

* **Decentralized Identity (DID):** Users can register tamper-resistant identities.
* **Reputation Scoring:** Assigns quantitative trust scores based on defined actions.
* **Action-Based Impact:** Configurable multipliers for different types of contributions.
* **Time-Based Decay:** Automatically reduces reputation over time to reflect recent activity.
* **Threshold Verification:** Enables access gating based on minimum reputation scores.
* **Built-in Access Controls:** Protects identity creation and reputation updates.

## Key Concepts

| Component            | Description                                                              |
| -------------------- | ------------------------------------------------------------------------ |
| `DID`                | A unique decentralized identifier registered by a user.                  |
| `Reputation Score`   | A dynamic trust metric influenced by user actions and decayed over time. |
| `Action Multipliers` | Adjustable weights assigned to actions like voting or community support. |
| `Decay Rate`         | A fixed rate (10% per period) to reduce stale reputation values.         |
| `Max Reputation`     | Capped at `1000` to ensure consistent scaling.                           |

## Smart Contract Functions

### Public Functions

#### `create-identity (did)`

Creates a new identity and initializes the reputation score.

```clojure
(create-identity "user123")
```

* ✅ Returns: DID string on success.
* 🔒 Fails if identity already exists or `did` is too short.

---

#### `update-reputation (action-type)`

Updates the user's reputation based on an approved action.

```clojure
(update-reputation "contract-fulfillment")
```

* ✅ Returns: Updated reputation score.
* 🔒 Fails if the action is unrecognized.

---

#### `decay-reputation`

Applies the decay function to the caller's reputation.

```clojure
(decay-reputation)
```

* ✅ Returns: Updated reputation score after decay.

### Read-Only Functions

#### `get-reputation (owner)`

Retrieves the full identity and reputation data for a user.

```clojure
(get-reputation 'SP123...)
```

#### `verify-reputation (owner min-threshold)`

Checks if the user meets a minimum reputation score.

```clojure
(verify-reputation 'SP123... u200)
```

* ✅ Returns: `(some true)` if threshold met; `none` otherwise.

### Private Helpers

* `is-valid-owner`
  Verifies that the caller is the rightful owner of the identity.

## Constants & Configuration

```clojure
MAX-REPUTATION-SCORE     ;; u1000
MIN-REPUTATION-SCORE     ;; u0
REPUTATION-DECAY-RATE    ;; u10 (i.e. 10%)
```

**Reputation Actions Initialization:**

| Action Type              | Multiplier |
| ------------------------ | ---------- |
| "governance-vote"        | `5`        |
| "contract-fulfillment"   | `10`       |
| "community-contribution" | `7`        |

## Error Codes

| Code   | Description             |
| ------ | ----------------------- |
| `u100` | Unauthorized            |
| `u101` | Invalid Parameters      |
| `u102` | Identity Already Exists |
| `u103` | Identity Not Found      |
| `u104` | Insufficient Reputation |
| `u105` | Max Reputation Reached  |

## Getting Started

### Deployment

Ensure your Clarity contract development environment is set up using tools like [Clarinet](https://docs.hiro.so/clarity/clarinet/overview).

### 🔁 Initialize Reputation Actions

Run once after deployment:

```clojure
(initialize-reputation-actions)
```

## Use Cases

* **Decentralized Governance** – Gate proposals and voting rights based on user reputation.
* **DAO Memberships** – Require trust scores for joining communities or working groups.
* **Freelance Platforms** – Reputation portability for on-chain gig fulfillment.
* **Sybil Resistance** – Apply decay and scoring to mitigate fake account abuse.

## Contributing

Want to enhance TrustChain? Contributions are welcome! Feel free to submit issues or pull requests to the repository.
