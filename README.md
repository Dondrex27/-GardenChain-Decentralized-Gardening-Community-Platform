# GardenChain 🌱

> A decentralized gardening community platform that tracks plant growth, rewards sustainable gardening practices, and builds green communities through blockchain technology

[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-purple)](https://stacks.co/)
[![Clarity](https://img.shields.io/badge/Smart_Contract-Clarity-blue)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Sustainable](https://img.shields.io/badge/Focus-Sustainability-brightgreen)](https://github.com/yourusername/gardenchain)

## Overview

GardenChain revolutionizes gardening by creating a blockchain-based ecosystem where every seed planted, every harvest celebrated, and every gardening tip shared contributes to a thriving, sustainable community. Gardeners earn GardenChain Growth Tokens (GGT) for successful cultivation, knowledge sharing, and community building activities.

### Key Features

- **🌿 Plant Growth Tracking** - Complete lifecycle monitoring from seedling to harvest
- **📊 Garden Analytics** - Detailed care logs, weather tracking, and growth patterns
- **💡 Knowledge Sharing** - Community-driven tips, techniques, and best practices
- **🌱 Seed Exchange** - Decentralized marketplace for seed trading and sharing
- **📖 Garden Journals** - Personal gardening diaries with progress tracking
- **🏘️ Community Gardens** - Collaborative growing spaces and plot management
- **🏆 Sustainable Rewards** - Token incentives for eco-friendly gardening practices
- **🔬 Plant Database** - Comprehensive catalog of plant varieties and growing conditions

## Getting Started

### Prerequisites

- [Clarinet CLI](https://github.com/hirosystems/clarinet) installed
- [Stacks Wallet](https://www.hiro.so/wallet) for blockchain interactions
- Node.js 16+ (for development and testing)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/gardenchain-stacks
cd gardenchain-stacks
```

2. Install dependencies
```bash
clarinet install
```

3. Run tests
```bash
clarinet test
```

4. Deploy to testnet
```bash
clarinet deploy --testnet
```

## Smart Contract Architecture

### Core Components

#### Token Economy (GGT)
- **Token Name**: GardenChain Growth Token
- **Symbol**: GGT
- **Decimals**: 6
- **Max Supply**: 1,600,000 GGT
- **Philosophy**: Rewarding sustainable gardening and community knowledge sharing

#### Gardening Ecosystem
- **Plant Varieties Database**: Comprehensive plant catalog with growing specifications
- **Growth Tracking System**: Complete plant lifecycle monitoring and care logging
- **Knowledge Hub**: Community-driven tips, techniques, and gardening wisdom
- **Seed Exchange**: Decentralized marketplace for genetic diversity preservation
- **Community Gardens**: Collaborative growing spaces and resource sharing

### Reward Structure

| Activity | GGT Reward | Purpose |
|----------|------------|---------|
| Plant Success | 60 GGT | Successful plant growth to maturity |
| Harvest Completion | 85 GGT + Quality Bonus | Rewarding successful harvests |
| Garden Tips | 35 GGT | Knowledge sharing and community education |
| Seed Sharing | 50 GGT | Promoting genetic diversity and community support |
| Garden Mentoring | 75 GGT | Teaching and supporting new gardeners |
| Care Logging | 10 GGT | Consistent plant care documentation |
| Garden Journaling | 15 GGT | Personal reflection and progress tracking |
| Plant Starting | 20 GGT | Beginning new growing projects |

### Data Models

#### Gardener Profile
```clarity
{
  username: (string-ascii 32),
  experience-level: uint,           // 1-10 progression system
  garden-size: uint,                // Garden area in square meters
  plants-grown: uint,
  successful-harvests: uint,
  tips-shared: uint,
  seeds-traded: uint,
  gardens-mentored: uint,
  reputation-score: uint,           // Community standing (starts at 100)
  join-date: uint,
  last-activity: uint
}
```

#### Plant Variety Database
```clarity
{
  name: (string-ascii 64),
  plant-type: (string-ascii 16),    // "vegetable", "fruit", "herb", "flower"
  growth-days: uint,                // Expected days to harvest
  difficulty-level: uint,           // 1-5 growing difficulty
  water-needs: uint,                // 1-5 water requirements
  sun-requirements: uint,           // 1-5 sunlight needs
  space-needed: uint,               // 1-5 space requirements
  verified: bool                    // Admin verification status
}
```

#### Plant Tracking System
```clarity
{
  gardener: principal,
  variety-id: uint,
  plant-name: (string-ascii 64),
  planting-date: uint,
  expected-harvest: uint,
  actual-harvest: (optional uint),
  growth-stage: (string-ascii 16), // "seedling", "growing", "flowering", "fruiting", "harvest"
  health-score: uint,              // 1-10 plant health assessment
  watering-frequency: uint,
  fertilizer-used: bool,
  companion-plants: (string-ascii 200),
  notes: (string-ascii 400),
  active: bool
}
```

## Core Functions

### Plant Management

#### `add-plant-variety`
Add new plant varieties to the community database
```clarity
(add-plant-variety 
  "Cherokee Purple Tomato" 
  "vegetable" 
  u80 
  u3 
  u4 
  u5 
  u3)
```

#### `start-growing-plant`
Begin tracking a new plant's growth journey
```clarity
(start-growing-plant 
  u1 
  "My First Tomato" 
  u3 
  true 
  "Planted with basil and marigolds" 
  "Started from heirloom seeds")
```

#### `log-plant-care`
Record daily care activities and observations
```clarity
(log-plant-care 
  u1 
  "watering" 
  u500 
  "sunny" 
  "Leaves looking healthy, new growth visible" 
  (some photo-hash))
```

#### `log-harvest`
Document harvest results and celebrate successes
```clarity
(log-harvest u1 true u2000 u9) ;; plant-id, success, yield-grams, quality-rating
```

### Community Features

#### `share-gardening-tip`
Share knowledge and earn community recognition
```clarity
(share-gardening-tip 
  "Companion Planting for Pest Control" 
  "Plant marigolds near tomatoes to naturally repel pests..."
  "pests" 
  "vegetable" 
  "summer" 
  u2)
```

#### `list-seeds-for-trade`
Create listings in the community seed exchange
```clarity
(list-seeds-for-trade 
  u1 
  u50 
  u2024 
  true 
  u95 
  "exchange" 
  u0 
  "Urban Community Garden")
```

#### `log-garden-journal`
Maintain personal gardening records
```clarity
(log-garden-journal 
  "Warm and sunny, perfect growing weather" 
  "Watered all plants, harvested lettuce, planted new beans"
  "Tomatoes showing first flowers, very exciting!"
  "Aphids on roses, need organic solution"
  "First cucumber harvest - delicious!"
  u120)
```

## Plant Growth Tracking

### Growth Stages
- **Seedling**: Initial germination and early leaf development
- **Growing**: Active vegetative growth and establishment
- **Flowering**: Bloom development and pollination phase
- **Fruiting**: Fruit/seed development and maturation
- **Harvest**: Ready for collection and consumption

### Health Monitoring
Plants are rated on a 1-10 health scale considering:
- **Leaf Color & Condition**: Vibrant, disease-free foliage
- **Growth Rate**: Meeting expected development milestones
- **Pest Resistance**: Natural immunity and resilience
- **Root Development**: Strong foundation and nutrient uptake

## Knowledge Sharing System

### Tip Categories
- **Watering**: Irrigation techniques, schedules, and water conservation
- **Soil**: Composition, amendments, and soil health management
- **Pests**: Organic control methods and integrated pest management
- **Harvesting**: Timing, techniques, and post-harvest handling

### Verification Process
Community tips undergo peer review:
1. **Submission**: Gardener submits tip with experience level and details
2. **Community Review**: Other gardeners vote on helpfulness
3. **Expert Verification**: Experienced gardeners (reputation 200+) can verify
4. **Reward Distribution**: Verified tips earn additional reputation and tokens

## Seed Exchange Platform

### Trading Types
- **Free Sharing**: Community generosity and genetic diversity preservation
- **Seed Exchange**: Barter system for variety swapping
- **Token Trading**: GGT-based marketplace for rare varieties

### Quality Metrics
- **Harvest Year**: Seed age and viability tracking
- **Germination Rate**: Expected sprouting percentage
- **Organic Certification**: Chemical-free growing verification
- **Location**: Climate adaptation and shipping considerations

## Community Gardens

### Plot Management
- **Plot Allocation**: Fair distribution based on participation and need
- **Fee Structure**: Token-based rental system with sliding scale
- **Resource Sharing**: Tools, knowledge, and collaborative projects
- **Garden Rules**: Community-established guidelines and best practices

### Benefits
- **Reduced Barriers**: Access to gardening without private land
- **Knowledge Transfer**: Mentorship and skill sharing
- **Community Building**: Social connections through shared activities
- **Food Security**: Local food production and distribution

## API Reference

### Read-Only Functions

```clarity
;; Get gardener profile and statistics
(get-gardener-profile (gardener principal))

;; View plant variety information
(get-plant-variety (variety-id uint))

;; Check plant growth progress
(get-plant-tracking (plant-id uint))

;; View care log entries
(get-care-log (plant-id uint) (care-date uint))

;; Browse gardening tips
(get-gardening-tip (tip-id uint))

;; Check seed listings
(get-seed-listing (listing-id uint))

;; View garden journal entries
(get-garden-journal (gardener principal) (journal-date uint))
```

### Profile Management

```clarity
;; Update gardener username
(update-gardener-username "GreenThumb2024")

;; Check token balance
(get-balance (gardener principal))

;; Transfer tokens for seed purchases
(transfer u50000000 tx-sender recipient-principal none)
```

## Testing

Run the comprehensive test suite:

```bash
# Run all tests
clarinet test

# Run specific test files
clarinet test tests/plant-tracking_test.ts
clarinet test tests/seed-exchange_test.ts
clarinet test tests/community_test.ts

# Validate contract syntax
clarinet check
```

### Test Coverage
- Plant lifecycle tracking and rewards
- Care logging and health monitoring
- Tip sharing and verification system
- Seed exchange functionality
- Token distribution and economics
- Community garden management

## Sustainability Focus

### Environmental Benefits
- **Carbon Sequestration**: Encouraging plant growth for CO2 absorption
- **Biodiversity**: Seed exchange promotes genetic diversity preservation
- **Local Food Systems**: Reducing transportation emissions through home growing
- **Organic Practices**: Rewarding chemical-free gardening methods
- **Water Conservation**: Promoting efficient irrigation techniques

### Social Impact
- **Food Security**: Supporting home food production capabilities
- **Community Building**: Connecting gardeners for knowledge and resource sharing
- **Education**: Teaching sustainable growing practices to new generations
- **Economic Empowerment**: Creating value from home gardening activities

## Integration Examples

### IoT Garden Sensors
```javascript
// Automated care logging from sensor data
const logSensorData = async (plantId, sensorReading) => {
  await openContractCall({
    contractAddress: GARDENCHAIN_CONTRACT,
    contractName: 'gardenchain',
    functionName: 'log-plant-care',
    functionArgs: [
      uintCV(plantId),
      stringAsciiCV('watering'),
      uintCV(sensorReading.waterAmount),
      stringAsciiCV(sensorReading.weather),
      stringAsciiCV(`Automated: ${sensorReading.notes}`),
      noneCV()
    ]
  });
};
```

### Mobile App Integration
```kotlin
// Android app for garden management
class GardenTracker {
    fun logDailyCare(plantId: Int, careType: String, amount: Int) {
        contractCall(
            function = "log-plant-care",
            args = listOf(plantId, careType, amount, weather, notes, photoHash)
        )
    }
    
    fun shareGrowingTip(tip: GardeningTip) {
        contractCall(
            function = "share-gardening-tip",
            args = listOf(tip.title, tip.content, tip.category, tip.plantType, tip.season, tip.difficulty)
        )
    }
}
```

## Deployment

### Testnet Deployment
```bash
clarinet deploy --testnet
```

### Mainnet Deployment
```bash
clarinet deploy --mainnet
```

### Environment Configuration
```toml
# Clarinet.toml
[contracts.gardenchain]
path = "contracts/gardenchain.clar"
clarity_version = 2

[network.testnet]
node_rpc_address = "https://stacks-node-api.testnet.stacks.co"
```

## Roadmap

### Phase 1 (Current)
- Core plant tracking and care logging
- Basic community features and seed exchange
- Token rewards for sustainable practices

### Phase 2 (Q2 2024)
- Advanced analytics and growth predictions
- Weather integration and climate tracking
- Enhanced community garden management

### Phase 3 (Q3 2024)
- IoT sensor integration for automated logging
- AI-powered plant health diagnostics
- Carbon credit integration and tracking

### Phase 4 (Q4 2024)
- NFT integration for rare plant achievements
- Marketplace for garden produce trading
- Global sustainability impact tracking

## Contributing

We welcome contributions from the gardening community! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: [Wiki](https://github.com/yourusername/gardenchain-stacks/wiki)
- **Issues**: [GitHub Issues](https://github.com/yourusername/gardenchain-stacks/issues)
- **Community**: [Discord](https://discord.gg/gardenchain)
- **Gardening Tips**: [Reddit Community](https://reddit.com/r/gardenchain)

## Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Permaculture community for sustainable growing wisdom
- Open source seed libraries and preservation efforts
- Local gardening communities worldwide

---

**Growing together, one plant at a time 🌱**
