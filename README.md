# Orivis FYP - Flutter Feature-First Architecture & Complete Password Reset Flow

Yeh README document poori details contain karta hai ke complete Password Reset Flow (`ForgotPasswordScreen` ➔ 4-Digit `PasswordResetOtpScreen` ➔ `CreateNewPasswordScreen`) kaise implement kiya gaya hai.

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
│   │   │   ├── app_colors.dart         # Exact Hex Colors (#19583F, #216747, #F8F6EE, #E6E0D2, #D92D20)
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
│       │           ├── otp_verification_screen.dart   # Reusable 6-Digit OTP Verification Screen
│       │           ├── forgot_password_screen.dart    # Forgot Password Screen
│       │           ├── password_reset_otp_screen.dart # [NEW] Dedicated 4-Digit Reset OTP Screen
│       │           └── create_new_password_screen.dart # [NEW] Create New Password Screen
│       └── home/
│           └── presentation/
│               └── screens/home_screen.dart           # Home Screen
└── README.md                           # [UPDATED] Complete Documentation & Explanation Log
```

---

## 🔐 Complete Role-Aware Password Reset Flow

1. **Step 1: `ForgotPasswordScreen`**:
   - Accepts role (`Grower` or `Vendor`) & prefilled email.
   - On tapping **Send reset instructions**: Validates email and navigates to `PasswordResetOtpScreen(role: role, email: email)`.

2. **Step 2: `PasswordResetOtpScreen` [NEW]**:
   - Heading **Verify your email** & Subtitle **Enter the 4-digit code to continue resetting your password.**.
   - Displays role badge (`GROWER ACCOUNT` / `VENDOR ACCOUNT`) & entered email.
   - **4 OTP Boxes:** 54w × 58h, 12 px radius, auto-advance, auto-backspace, 4-digit paste support.
   - On tapping **Verify code**: Validates 4 digits and navigates to `CreateNewPasswordScreen(role: role, email: email)`.

3. **Step 3: `CreateNewPasswordScreen` [NEW]**:
   - Heading **Create new password** (26 px bold `#19583F`) & Subtitle **Choose a strong password for your account.**.
   - **New password** & **Confirm new password** fields with working eye show/hide toggles.
   - On tapping **Reset password**: Validates min 8 chars and password match. Displays SnackBar: `Demo mode: password reset is not connected yet.`.
   - **Sign in / Back to Login:** Returns directly to the corresponding login screen (`GrowerLoginScreen` for Grower, `LoginScreen(role: 'vendor')` for Vendor).
