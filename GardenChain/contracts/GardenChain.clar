;; GardenChain - Decentralized Gardening Community Platform
;; A comprehensive blockchain-based gardening platform that tracks plant growth,
;; rewards sustainable gardening, and builds green communities

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))
(define-constant err-insufficient-tokens (err u105))
(define-constant err-plant-not-active (err u106))
(define-constant err-invalid-season (err u107))

;; Token constants
(define-constant token-name "GardenChain Growth Token")
(define-constant token-symbol "GGT")
(define-constant token-decimals u6)
(define-constant token-max-supply u1600000000000) ;; 1.6 million tokens with 6 decimals

;; Reward amounts (in micro-tokens)
(define-constant reward-plant-success u60000000) ;; 60 GGT
(define-constant reward-harvest u85000000) ;; 85 GGT
(define-constant reward-garden-tip u35000000) ;; 35 GGT
(define-constant reward-seed-sharing u50000000) ;; 50 GGT
(define-constant reward-garden-mentor u75000000) ;; 75 GGT

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var next-gardener-id uint u1)
(define-data-var next-plant-id uint u1)
(define-data-var next-tip-id uint u1)

;; Token balances
(define-map token-balances principal uint)

;; Plant varieties
(define-map plant-varieties
  uint
  {
    name: (string-ascii 64),
    plant-type: (string-ascii 16), ;; "vegetable", "fruit", "herb", "flower"
    growth-days: uint,
    difficulty-level: uint, ;; 1-5
    water-needs: uint, ;; 1-5
    sun-requirements: uint, ;; 1-5
    space-needed: uint, ;; 1-5
    verified: bool
  }
)

;; Gardener profiles
(define-map gardener-profiles
  principal
  {
    username: (string-ascii 32),
    experience-level: uint, ;; 1-10
    garden-size: uint, ;; square meters
    plants-grown: uint,
    successful-harvests: uint,
    tips-shared: uint,
    seeds-traded: uint,
    gardens-mentored: uint,
    reputation-score: uint,
    join-date: uint,
    last-activity: uint
  }
)

;; Plant tracking
(define-map plant-tracking
  uint
  {
    gardener: principal,
    variety-id: uint,
    plant-name: (string-ascii 64),
    planting-date: uint,
    expected-harvest: uint,
    actual-harvest: (optional uint),
    growth-stage: (string-ascii 16), ;; "seedling", "growing", "flowering", "fruiting", "harvest"
    health-score: uint, ;; 1-10
    watering-frequency: uint,
    fertilizer-used: bool,
    companion-plants: (string-ascii 200),
    notes: (string-ascii 400),
    active: bool
  }
)

;; Garden care logs
(define-map care-logs
  { plant-id: uint, care-date: uint }
  {
    care-type: (string-ascii 32), ;; "watering", "fertilizing", "pruning", "pest-control"
    amount: uint, ;; ml for watering, grams for fertilizer
    weather-condition: (string-ascii 16),
    plant-response: (string-ascii 200),
    photo-hash: (optional (buff 32)),
    logged-by: principal
  }
)

;; Gardening tips
(define-map gardening-tips
  uint
  {
    author: principal,
    tip-title: (string-ascii 128),
    tip-content: (string-ascii 800),
    category: (string-ascii 32), ;; "watering", "soil", "pests", "harvesting"
    plant-type: (string-ascii 16),
    season-relevant: (string-ascii 8), ;; "spring", "summer", "fall", "winter"
    difficulty-level: uint, ;; 1-5
    helpfulness-votes: uint,
    publication-date: uint,
    verified: bool
  }
)

;; Seed exchange
(define-map seed-listings
  uint
  {
    trader: principal,
    variety-id: uint,
    seed-quantity: uint,
    harvest-year: uint,
    organic-certified: bool,
    germination-rate: uint, ;; percentage
    trade-type: (string-ascii 16), ;; "free", "exchange", "tokens"
    asking-price: uint,
    location: (string-ascii 64),
    available: bool,
    listing-date: uint
  }
)

;; Garden journals
(define-map garden-journals
  { gardener: principal, journal-date: uint }
  {
    weather-summary: (string-ascii 100),
    tasks-completed: (string-ascii 300),
    observations: (string-ascii 400),
    challenges: (string-ascii 300),
    successes: (string-ascii 300),
    photos-taken: uint,
    time-spent-minutes: uint
  }
)

;; Community gardens
(define-map community-gardens
  uint
  {
    organizer: principal,
    garden-name: (string-ascii 128),
    location: (string-ascii 64),
    total-plots: uint,
    available-plots: uint,
    plot-fee: uint,
    garden-rules: (string-ascii 500),
    established-date: uint,
    active: bool
  }
)

;; Helper function to get or create gardener profile
(define-private (get-or-create-profile (gardener principal))
  (match (map-get? gardener-profiles gardener)
    profile profile
    {
      username: "",
      experience-level: u1,
      garden-size: u0,
      plants-grown: u0,
      successful-harvests: u0,
      tips-shared: u0,
      seeds-traded: u0,
      gardens-mentored: u0,
      reputation-score: u100,
      join-date: stacks-block-height,
      last-activity: stacks-block-height
    }
  )
)

;; Token functions
(define-read-only (get-name)
  (ok token-name)
)

(define-read-only (get-symbol)
  (ok token-symbol)
)

(define-read-only (get-decimals)
  (ok token-decimals)
)

(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? token-balances user)))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-private (mint-tokens (recipient principal) (amount uint))
  (let (
    (current-balance (default-to u0 (map-get? token-balances recipient)))
    (new-balance (+ current-balance amount))
    (new-total-supply (+ (var-get total-supply) amount))
  )
    (asserts! (<= new-total-supply token-max-supply) err-invalid-input)
    (map-set token-balances recipient new-balance)
    (var-set total-supply new-total-supply)
    (ok amount)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (let (
    (sender-balance (default-to u0 (map-get? token-balances sender)))
  )
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (asserts! (>= sender-balance amount) err-insufficient-tokens)
    (try! (mint-tokens recipient amount))
    (map-set token-balances sender (- sender-balance amount))
    (print {action: "transfer", sender: sender, recipient: recipient, amount: amount, memo: memo})
    (ok true)
  )
)

;; Plant variety management
(define-public (add-plant-variety (name (string-ascii 64)) (plant-type (string-ascii 16))
                                 (growth-days uint) (difficulty-level uint) (water-needs uint)
                                 (sun-requirements uint) (space-needed uint))
  (let (
    (variety-id (var-get next-gardener-id))
  )
    (asserts! (> (len name) u0) err-invalid-input)
    (asserts! (> (len plant-type) u0) err-invalid-input)
    (asserts! (> growth-days u0) err-invalid-input)
    (asserts! (and (>= difficulty-level u1) (<= difficulty-level u5)) err-invalid-input)
    (asserts! (and (>= water-needs u1) (<= water-needs u5)) err-invalid-input)
    (asserts! (and (>= sun-requirements u1) (<= sun-requirements u5)) err-invalid-input)
    (asserts! (and (>= space-needed u1) (<= space-needed u5)) err-invalid-input)
    
    (map-set plant-varieties variety-id {
      name: name,
      plant-type: plant-type,
      growth-days: growth-days,
      difficulty-level: difficulty-level,
      water-needs: water-needs,
      sun-requirements: sun-requirements,
      space-needed: space-needed,
      verified: false
    })
    
    (var-set next-gardener-id (+ variety-id u1))
    (print {action: "plant-variety-added", variety-id: variety-id, name: name})
    (ok variety-id)
  )
)

;; Plant tracking
(define-public (start-growing-plant (variety-id uint) (plant-name (string-ascii 64))
                                   (watering-frequency uint) (fertilizer-used bool)
                                   (companion-plants (string-ascii 200)) (notes (string-ascii 400)))
  (let (
    (plant-id (var-get next-plant-id))
    (variety (unwrap! (map-get? plant-varieties variety-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
    (expected-harvest (+ stacks-block-height (get growth-days variety)))
  )
    (asserts! (> (len plant-name) u0) err-invalid-input)
    (asserts! (> watering-frequency u0) err-invalid-input)
    
    (map-set plant-tracking plant-id {
      gardener: tx-sender,
      variety-id: variety-id,
      plant-name: plant-name,
      planting-date: stacks-block-height,
      expected-harvest: expected-harvest,
      actual-harvest: none,
      growth-stage: "seedling",
      health-score: u8,
      watering-frequency: watering-frequency,
      fertilizer-used: fertilizer-used,
      companion-plants: companion-plants,
      notes: notes,
      active: true
    })
    
    ;; Update gardener profile
    (map-set gardener-profiles tx-sender
      (merge profile {
        plants-grown: (+ (get plants-grown profile) u1),
        reputation-score: (+ (get reputation-score profile) u5),
        last-activity: stacks-block-height
      })
    )
    
    ;; Small reward for starting to grow
    (try! (mint-tokens tx-sender u20000000)) ;; 20 GGT
    
    (var-set next-plant-id (+ plant-id u1))
    (print {action: "plant-started", plant-id: plant-id, gardener: tx-sender, plant-name: plant-name})
    (ok plant-id)
  )
)

;; Care logging
(define-public (log-plant-care (plant-id uint) (care-type (string-ascii 32))
                              (amount uint) (weather-condition (string-ascii 16))
                              (plant-response (string-ascii 200)) (photo-hash (optional (buff 32))))
  (let (
    (plant (unwrap! (map-get? plant-tracking plant-id) err-not-found))
    (care-date (/ stacks-block-height u144)) ;; Daily grouping
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (is-eq tx-sender (get gardener plant)) err-unauthorized)
    (asserts! (get active plant) err-plant-not-active)
    (asserts! (> (len care-type) u0) err-invalid-input)
    (asserts! (> (len weather-condition) u0) err-invalid-input)
    
    (map-set care-logs {plant-id: plant-id, care-date: care-date} {
      care-type: care-type,
      amount: amount,
      weather-condition: weather-condition,
      plant-response: plant-response,
      photo-hash: photo-hash,
      logged-by: tx-sender
    })
    
    ;; Update profile
    (map-set gardener-profiles tx-sender
      (merge profile {
        reputation-score: (+ (get reputation-score profile) u2),
        last-activity: stacks-block-height
      })
    )
    
    ;; Small reward for care logging
    (try! (mint-tokens tx-sender u10000000)) ;; 10 GGT
    
    (print {action: "plant-care-logged", plant-id: plant-id, care-type: care-type, gardener: tx-sender})
    (ok true)
  )
)

;; Harvest logging
(define-public (log-harvest (plant-id uint) (harvest-success bool) (yield-amount uint) (quality-rating uint))
  (let (
    (plant (unwrap! (map-get? plant-tracking plant-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (is-eq tx-sender (get gardener plant)) err-unauthorized)
    (asserts! (get active plant) err-plant-not-active)
    (asserts! (>= stacks-block-height (get expected-harvest plant)) err-invalid-input)
    (asserts! (and (>= quality-rating u1) (<= quality-rating u10)) err-invalid-input)
    
    ;; Update plant tracking
    (map-set plant-tracking plant-id
      (merge plant {
        actual-harvest: (some stacks-block-height),
        growth-stage: "harvest",
        active: false
      })
    )
    
    ;; Update gardener profile
    (map-set gardener-profiles tx-sender
      (merge profile {
        successful-harvests: (+ (get successful-harvests profile) (if harvest-success u1 u0)),
        experience-level: (+ (get experience-level profile) (if harvest-success u1 u0)),
        reputation-score: (+ (get reputation-score profile) (if harvest-success u15 u5)),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award harvest rewards
    (if harvest-success
      (begin
        (try! (mint-tokens tx-sender reward-harvest))
        ;; Bonus for high quality harvest
        (if (>= quality-rating u8)
          (begin
            (try! (mint-tokens tx-sender u30000000)) ;; 30 GGT bonus
            true
          )
          true
        )
        true
      )
      (begin
        (try! (mint-tokens tx-sender u25000000)) ;; 25 GGT consolation
        true
      )
    )
    
    (print {action: "harvest-logged", plant-id: plant-id, success: harvest-success, quality: quality-rating})
    (ok true)
  )
)

;; Gardening tips
(define-public (share-gardening-tip (tip-title (string-ascii 128)) (tip-content (string-ascii 800))
                                   (category (string-ascii 32)) (plant-type (string-ascii 16))
                                   (season-relevant (string-ascii 8)) (difficulty-level uint))
  (let (
    (tip-id (var-get next-tip-id))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len tip-title) u0) err-invalid-input)
    (asserts! (> (len tip-content) u0) err-invalid-input)
    (asserts! (> (len category) u0) err-invalid-input)
    (asserts! (and (>= difficulty-level u1) (<= difficulty-level u5)) err-invalid-input)
    
    (map-set gardening-tips tip-id {
      author: tx-sender,
      tip-title: tip-title,
      tip-content: tip-content,
      category: category,
      plant-type: plant-type,
      season-relevant: season-relevant,
      difficulty-level: difficulty-level,
      helpfulness-votes: u0,
      publication-date: stacks-block-height,
      verified: false
    })
    
    ;; Update author profile
    (map-set gardener-profiles tx-sender
      (merge profile {
        tips-shared: (+ (get tips-shared profile) u1),
        reputation-score: (+ (get reputation-score profile) u12),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award tip sharing reward
    (try! (mint-tokens tx-sender reward-garden-tip))
    
    (var-set next-tip-id (+ tip-id u1))
    (print {action: "gardening-tip-shared", tip-id: tip-id, author: tx-sender, title: tip-title})
    (ok tip-id)
  )
)

;; Seed trading
(define-public (list-seeds-for-trade (variety-id uint) (seed-quantity uint) (harvest-year uint)
                                     (organic-certified bool) (germination-rate uint)
                                     (trade-type (string-ascii 16)) (asking-price uint) (location (string-ascii 64)))
  (let (
    (listing-id (var-get next-plant-id)) ;; Reuse counter
    (variety (unwrap! (map-get? plant-varieties variety-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> seed-quantity u0) err-invalid-input)
    (asserts! (>= harvest-year u2020) err-invalid-input)
    (asserts! (and (>= germination-rate u0) (<= germination-rate u100)) err-invalid-input)
    (asserts! (> (len trade-type) u0) err-invalid-input)
    (asserts! (> (len location) u0) err-invalid-input)
    
    (map-set seed-listings listing-id {
      trader: tx-sender,
      variety-id: variety-id,
      seed-quantity: seed-quantity,
      harvest-year: harvest-year,
      organic-certified: organic-certified,
      germination-rate: germination-rate,
      trade-type: trade-type,
      asking-price: asking-price,
      location: location,
      available: true,
      listing-date: stacks-block-height
    })
    
    ;; Update profile
    (map-set gardener-profiles tx-sender
      (merge profile {
        reputation-score: (+ (get reputation-score profile) u8),
        last-activity: stacks-block-height
      })
    )
    
    ;; Award seed sharing reward
    (try! (mint-tokens tx-sender reward-seed-sharing))
    
    (var-set next-plant-id (+ listing-id u1))
    (print {action: "seeds-listed-for-trade", listing-id: listing-id, trader: tx-sender, variety-id: variety-id})
    (ok listing-id)
  )
)

;; Garden journal
(define-public (log-garden-journal (weather-summary (string-ascii 100)) (tasks-completed (string-ascii 300))
                                  (observations (string-ascii 400)) (challenges (string-ascii 300))
                                  (successes (string-ascii 300)) (time-spent-minutes uint))
  (let (
    (journal-date (/ stacks-block-height u144)) ;; Daily grouping
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len weather-summary) u0) err-invalid-input)
    (asserts! (> time-spent-minutes u0) err-invalid-input)
    
    (map-set garden-journals {gardener: tx-sender, journal-date: journal-date} {
      weather-summary: weather-summary,
      tasks-completed: tasks-completed,
      observations: observations,
      challenges: challenges,
      successes: successes,
      photos-taken: u0,
      time-spent-minutes: time-spent-minutes
    })
    
    ;; Update profile
    (map-set gardener-profiles tx-sender
      (merge profile {
        reputation-score: (+ (get reputation-score profile) u5),
        last-activity: stacks-block-height
      })
    )
    
    ;; Small reward for journaling
    (try! (mint-tokens tx-sender u15000000)) ;; 15 GGT
    
    (print {action: "garden-journal-logged", gardener: tx-sender, date: journal-date})
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-gardener-profile (gardener principal))
  (map-get? gardener-profiles gardener)
)

(define-read-only (get-plant-variety (variety-id uint))
  (map-get? plant-varieties variety-id)
)

(define-read-only (get-plant-tracking (plant-id uint))
  (map-get? plant-tracking plant-id)
)

(define-read-only (get-care-log (plant-id uint) (care-date uint))
  (map-get? care-logs {plant-id: plant-id, care-date: care-date})
)

(define-read-only (get-gardening-tip (tip-id uint))
  (map-get? gardening-tips tip-id)
)

(define-read-only (get-seed-listing (listing-id uint))
  (map-get? seed-listings listing-id)
)

(define-read-only (get-garden-journal (gardener principal) (journal-date uint))
  (map-get? garden-journals {gardener: gardener, journal-date: journal-date})
)

(define-read-only (get-community-garden (garden-id uint))
  (map-get? community-gardens garden-id)
)

;; Admin functions
(define-public (verify-plant-variety (variety-id uint))
  (let (
    (variety (unwrap! (map-get? plant-varieties variety-id) err-not-found))
  )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set plant-varieties variety-id (merge variety {verified: true}))
    (print {action: "plant-variety-verified", variety-id: variety-id})
    (ok true)
  )
)

(define-public (update-gardener-username (new-username (string-ascii 32)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-username) u0) err-invalid-input)
    (map-set gardener-profiles tx-sender (merge profile {username: new-username}))
    (print {action: "gardener-username-updated", gardener: tx-sender, username: new-username})
    (ok true)
  )
)