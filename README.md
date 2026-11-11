# Orivis FYP - Flutter Feature-First Architecture, Create Listing Screen

Yeh README document poori details contain karta hai ke **Create Listing Screen** (`CreateListingScreen`) kaise implement ki gayi hai aur **Scan Report Screen** ke **`Create marketplace listing`** button ke sath kaise connect ki gayi hai.

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
│       ├── scan/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── scan_orchard_screen.dart       # Live Camera Preview Scan Screen
│       │           ├── scan_processing_screen.dart    # 4-Step Sequential Processing Screen
│       │           ├── scan_review_screen.dart        # Scan Review Screen
│       │           └── scan_report_screen.dart        # Complete Redesigned Scan Report Screen
│       ├── marketplace/
│       │   └── presentation/
│       │       └── screens/
│       │           └── create_listing_screen.dart     # [NEW] Create Marketplace Listing Screen
│       └── home/
│           └── presentation/
│               └── screens/
│                   ├── home_screen.dart               # Default Home Screen
│                   └── grower_dashboard_screen.dart   # Complete 11-Section Grower Home Dashboard
└── README.md                           # [UPDATED] Complete Documentation & Explanation Log
```

---

## 🏷️ Create Listing Screen (`CreateListingScreen`) Features:

1. **Navigation Flow:**
   - `Grower Dashboard` ➔ `Scan Orchard` ➔ `Processing` ➔ `Scan Report` ➔ `Create marketplace listing` ➔ `CreateListingScreen`.

2. **Orchard Summary Card:**
   - Displays dark green fruit thumbnail icon, `Kinnow Block A` title, and summary subtitle `~1,248 fruits (AI estimate) · Ripe 52%`.

3. **Form Fields & Validation:**
   - **`Tree variety`**: Initial value `Kinnow` (editable).
   - **`Asking price (PKR) *`**: Numeric input with validation (must be positive number).
   - **`Minimum bid (PKR) *`**: Numeric input with validation (must be positive and cannot exceed Asking Price).
   - **`Notes for buyers`**: Multiline optional field (`Harvest timing, access, etc.`).

4. **Open for Bids Toggle:**
   - White rounded card with `Open for bids` label and green `Switch` (`activeTrackColor: AppColors.darkGreen`).

5. **Publish Listing Action:**
   - Prominent orange button **`Publish listing`** (`#F99A20`).
   - Validates form input and displays SnackBar: *"Demo mode: Your listing has been prepared locally. It has not been published to a marketplace."*, then returns to `GrowerDashboardScreen`.

6. **Persistent Bottom Navigation:**
   - 5-item persistent bottom navigation bar.
