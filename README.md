# Orivis FYP - Flutter Feature-First Architecture, Complete Grower Dashboard

Yeh README document poori details contain karta hai ke Complete **Grower Home Dashboard** (Header, Estimate Card, Start Scan, Quick Actions, Orchards, Ripeness Overview, Recent Scans [3 Cards], Your Listing, Scanning Tip, Sample Data Disclaimer, Persistent Bottom Navigation) kaise implement kiya gaya hai.

---

## 📁 Directory Structure & File Summary

```text
D:/ORIVIS_FYP/
├── assets/
│   ├── .env                            # FastAPI Base URL & Config
│   └── images/
│       └── logo.png                    # ORIVIS Brand Logo Image
├── lib/
│   ├── main.dart                       # App entry point (home: SplashScreen)
│   ├── core/                           # Shared components
│   │   ├── constants/
│   │   │   ├── app_colors.dart         # Exact Hex Colors (#19583F, #216747, #F8F6EE, #E6E0D2, #D92D20, #F99A20, #FFE8C7)
│   │   │   ├── app_assets.dart         # Assets constants
│   │   │   └── app_strings.dart        # Static text strings
│   │   ├── theme/
│   │   │   └── app_theme.dart          # Material 3 Theme with Cupertino overrides
│   │   ├── network/
│   │   │   ├── api_endpoints.dart      # FastAPI endpoint URLs
│   │   │   ├── api_exceptions.dart     # Dio Exception handling
│   │   │   ├── api_interceptors.dart    # Automatic Bearer Token Interceptor
│   │   │   └── api_client.dart         # Centralized Dio HTTP Client
│   │   ├── storage/
│   │   │   └── secure_storage_service.dart # Secure JWT Storage
│   │   └── widgets/
│   │       ├── custom_button.dart      # Platform Adaptive Button
│   │       └── custom_textfield.dart   # Responsive custom input textfield
│   └── features/                       # Modular Features
│       ├── splash/
│       │   └── presentation/
│       │       └── screens/splash_screen.dart # Navigates to WelcomeRoleScreen
│       ├── auth/
│       │   ├── data/
│       │   │   ├── models/user_model.dart             # JSON User Model
│       │   │   └── repositories/auth_repository.dart  # FastAPI Auth API calls
│       │   └── presentation/
│       │       └── screens/
│       │           ├── welcome_role_screen.dart       # Welcome Role Selection Screen
│       │           ├── grower_login_screen.dart       # Grower Login Screen
│       │           ├── grower_create_account_screen.dart # Grower Registration Screen
│       │           ├── login_screen.dart              # Vendor Login Screen
│       │           ├── vendor_create_account_screen.dart # Vendor Registration Screen
│       │           ├── otp_verification_screen.dart   # Navigates to Grower Dashboard
│       │           ├── forgot_password_screen.dart    # Forgot Password Screen
│       │           ├── password_reset_otp_screen.dart # Dedicated 4-Digit Reset OTP Screen
│       │           └── create_new_password_screen.dart # Create New Password Screen
│       └── home/
│           └── presentation/
│               └── screens/
│                   ├── home_screen.dart               # Default Home Screen
│                   └── grower_dashboard_screen.dart   # [UPDATED] Complete 11-Section Grower Home Dashboard
└── README.md                           # [UPDATED] Complete Documentation & Explanation Log
```

---

## 🌿 Complete Grower Dashboard Sections Implemented:

1. **Dashboard Header (`#19583F`):**
   - Safe-area protected top inset (`MediaQuery.paddingOf(context).top + 10.h`).
   - Orange avatar (`#F99A20`, initials `AR`), greeting `Assalam-o-Alaikum`, name `Ali Raza`, translucent green notification button with badge `3`.

2. **Latest AI Estimate Card:**
   - Positioned below avatar row overlapping lower green header (`#19583F`).
   - Title `Latest AI estimate · Kinnow Block A`, pale-orange `Sample` badge (`#FFE8C7`), count `1,248 fruits`, and 3 statistics (`12 Scans`, `1 Active listing`, `3 New bids`).

3. **Start a New Scan Button:**
   - Wide orange button (`#F99A20`, 52 px height, camera icon, text `Start a new scan`).

4. **Quick Actions Grid:**
   - 4 actions (`Scan`, `History`, `Sell`, `Payments`) in white rounded square boxes with subtle borders and shadows.

5. **Orchards Selector:**
   - Selectable chips (`Kinnow Block A`, `Block C`, `+ Add`) with dynamic state updates.

6. **Ripeness Overview Card:**
   - Heading `Ripeness overview`, action link `Full report`, 4-color stacked bar (`Unripe 12%`, `Partially ripe 28%`, `Ripe 52%`, `Overripe 8%`), and color dot legend.

7. **Recent Scans (3 Cards as shown in Reference Screenshots 2 & 3):**
   - Section heading `Recent scans` & `See all` action link.
   - **Card 1:** `Kinnow Block A` · `Today · 1,248 fruits` · `Completed` light-green badge (`#EAF1E9`).
   - **Card 2:** `Block C` · `3 days ago · 860 fruits` · `Completed` light-green badge (`#EAF1E9`).
   - **Card 3:** `Kinnow Block A` · `Last week · — fruits` · `Processing` pale-orange badge (`#FFE8C7`).

8. **Your Listing (Section shown in Screenshot 3):**
   - Heading `Your listing`.
   - Card displaying `Kinnow Block A`, `Active` light-green badge (`#EAF1E9`), bidding details `Asking PKR 200,000 · Highest bid PKR 182,000 · 3 bids`, and wide outlined button `Review bids`.

9. **Scanning Tip (Section shown in Screenshot 3):**
   - Pale-green card (`#EAF1E9`), lightbulb icon, heading `Scanning tip`, and guidance body text *"Move slowly around the tree for about 20 seconds in even daylight. Steady footage gives a more reliable count."*

10. **Sample Data Disclaimer:**
    - Centered footer text: *"All figures are sample data for the prototype."*

11. **Persistent Bottom Navigation:**
    - 5 destinations (`Home`, `History`, `Scan` center elevated orange action `#F99A20`, `Bids`, `Profile`) over white rounded surface (24 px radius).
