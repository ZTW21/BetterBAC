# App Store Connect Setup for Remove Ads IAP

## In-App Purchase Configuration

Once you're ready to submit your app to the App Store, you'll need to create the In-App Purchase product in App Store Connect.

### Steps:

1. **Log into App Store Connect**
   - Go to https://appstoreconnect.apple.com
   - Sign in with your Apple Developer account

2. **Navigate to Your App**
   - Go to "My Apps"
   - Select "BetterBAC" (or create it if it doesn't exist yet)

3. **Create In-App Purchase**
   - Click on the "In-App Purchases" tab
   - Click the "+" button to create a new In-App Purchase
   - Select **"Non-Consumable"**

4. **Configure Product Details**
   - **Reference Name:** `Remove Ads`
   - **Product ID:** `com.betterbac.removeads`
     - ⚠️ IMPORTANT: This MUST match the productID in PurchaseManager.swift
     - This cannot be changed after creation

5. **Set Price**
   - Click "Add Pricing"
   - Select all territories
   - Set price to **$4.99 USD**
   - Click "Next" and "Create"

6. **Add Localization**
   - Click "Create Localization"
   - Select Language: **English (U.S.)**
   - **Display Name:** `Remove Ads Forever`
   - **Description:** `Remove all advertisements from BetterBAC permanently. Support the development of BetterBAC while enjoying an ad-free experience!`
   - Upload a screenshot (optional but recommended)
   - Click "Save"

7. **Submit for Review**
   - The IAP must be submitted for review along with your app
   - Status will change from "Ready to Submit" → "Waiting for Review" → "Ready to Sell"

## Testing with Sandbox

### Create Sandbox Test Account

1. In App Store Connect, go to "Users and Access"
2. Click "Sandbox Testers"
3. Click "+" to add a tester
4. Fill in test account details (use a fake email you control)
5. Choose your region

### Test on Device

1. Sign out of your real Apple ID in Settings → App Store
2. Run your app from Xcode on a real device
3. When prompted to sign in for purchase, use your sandbox test account
4. Complete the test purchase (it's free in sandbox)
5. Verify ads are removed

## Important Notes

- ✅ IAP products can take a few hours to appear after creation
- ✅ Sandbox testing works ONLY on real devices, not simulators
- ✅ Use the StoreKit Configuration file (`BetterBAC.storekit`) for local testing in Xcode
- ✅ The product ID `com.betterbac.removeads` must match exactly in:
  - App Store Connect
  - PurchaseManager.swift
  - BetterBAC.storekit
- ⚠️ Don't use your real Apple ID for sandbox testing
- ⚠️ IAP must be submitted with app version, can't be added separately

## Offer Codes (Optional)

Offer codes allow you to give users free access to "Remove Ads" without payment.

### Creating Offer Codes

1. In App Store Connect, go to your IAP product
2. Click **"Offer Codes"** tab
3. Click **"Create Offer Code"**
4. Configure:
   - **Reference Name:** (e.g., "Launch Promo", "Beta Testers")
   - **Code Type:**
     - **One Code to Multiple Users** - Single code shared with many users
     - **One Code to One User** - Generate unique codes per user
   - **Number of Codes:** How many codes to generate
   - **Expiration Date:** Optional expiration
   - **Max Redemptions per Code:** Optional limit

5. Click "Create" and download codes as CSV

### Use Cases

- 🎁 **Beta testers** - Reward early supporters
- 📱 **Influencer promotions** - Partner with reviewers
- 🏆 **Contest prizes** - Community engagement
- 🎯 **Marketing campaigns** - Time-limited promotions
- 💬 **Support resolution** - Customer service

### User Redemption Flow

1. User opens Settings in your app
2. Taps **"Redeem Offer Code"** button
3. Apple's system sheet appears
4. User enters/pastes the code
5. Code validates and redeems
6. Ads are removed immediately
7. "✓ Ads Removed" shows in Settings

### Important Notes

- ✅ Offer codes work in production only (not in StoreKit Configuration)
- ✅ Redeemed codes grant same entitlement as purchase
- ✅ Your app automatically detects both purchases AND offer codes
- ✅ Users can redeem on any device (syncs via iCloud)
- ⚠️ Codes cannot be tested in local StoreKit Configuration
- ⚠️ Must create sandbox test codes for testing in TestFlight

## Verification Checklist

Before submitting to App Store:

- [ ] Product ID matches in all locations
- [ ] Price is set to $4.99
- [ ] Localization is complete
- [ ] Tested purchase flow with sandbox account
- [ ] Tested restore purchases
- [ ] Verified ads are actually removed after purchase
- [ ] Tested on multiple devices/reinstalls
- [ ] (Optional) Created offer codes for promotions
- [ ] (Optional) Tested offer code redemption in TestFlight
