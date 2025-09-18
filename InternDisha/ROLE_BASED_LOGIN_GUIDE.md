# Role-Based Login System Implementation

## Overview
The InternDisha app now supports role-based authentication with two user types:
- **Student**: Access to internship browsing, applications, and profile management
- **Admin**: Access to admin dashboard, user management, internship management, and analytics

## New Components

### 1. UserRole Enum
- Located in `DataModel.swift`
- Defines two roles: `student` and `admin`
- Includes display names and system icons for each role

### 2. RoleSelectionView
- New initial screen where users select their role before login/signup
- Modern card-based interface with role descriptions
- Located in `Auth/RoleSelectionView.swift`

### 3. Updated Authentication Flow
- `RootView.swift` now includes role selection as the first step
- `LoginView.swift` shows selected role and includes back navigation
- **Role-based signup forms**:
  - Students: `SignupView.swift` - Personal info, skills, interests, locations
  - Admins: `AdminSignupView.swift` - Company info, job details, organization data

### 4. AdminContentView
- New admin interface with specialized tabs:
  - Dashboard: Quick stats and recent activity
  - Internship Management: Manage internship listings
  - User Management: View students and admins
  - Analytics: Reports and data insights
  - Profile: Standard profile view

### 5. Updated User Model
- Added company/organization fields for admin users:
  - `companyName`, `companyWebsite`, `companyDescription`
  - `companySize`, `industry`, `jobTitle`, `department`
- Added `CompanySize` enum for organization size classification

### 6. Updated AuthViewModel
- Now creates dummy users for both roles for testing
- Added `getUsersByRole()` method for admin user management
- Student: `student@intern.com` / `password`
- Admin: `admin@intern.com` / `password` (with company info)

## User Experience Flow

1. **Role Selection**: User selects Student or Admin role
2. **Authentication**: Login/Signup with role context displayed
3. **Role-Based Content**:
   - Students see: Internships, My Internships, Profile
   - Admins see: Dashboard, Internship Management, User Management, Analytics, Profile

## Signup Forms

### Student Signup (SignupView.swift)
- **Step 1**: Personal Information (Name, Email, Mobile, DOB)
- **Step 2**: Education (Qualification level)
- **Step 3**: Skills (Searchable skill selection)
- **Step 4**: Interests (Sector and area selection)
- **Step 5**: Location Preferences (Searchable location selection)
- **Step 6**: Security (Password creation)

### Admin Signup (AdminSignupView.swift)
- **Step 1**: Personal Information (Name, Email, Mobile)
- **Step 2**: Company Information (Company name, industry, size, website, description)
- **Step 3**: Job Information & Security (Job title, department, password)

### Key Differences
- **Students**: Focus on personal development, skills, and career interests
- **Admins**: Focus on company information and professional role within organization
- **Validation**: Different required fields based on role
- **UI/UX**: Tailored interfaces for each user type

## Demo Credentials

### Student Account
- Email: `student@intern.com`
- Password: `password`
- Role: Student

### Admin Account
- Email: `admin@intern.com`
- Password: `password`
- Role: Admin

## Technical Implementation

### Data Model Changes
- Added `UserRole` enum with `.student` and `.admin` cases
- Updated `User` struct to include `role: UserRole` property
- Maintained backward compatibility with existing user data

### Navigation Flow
```
RoleSelectionView → LoginView/SignupView → ContentView/AdminContentView
```

### Role-Based Routing
```swift
if auth.currentUser?.role == .admin {
    AdminContentView()
} else {
    ContentView() // Student interface
}
```

## Features for Each Role

### Student Features
- Browse internships
- Apply for internships
- View application status
- Manage profile and preferences
- Save favorite internships

### Admin Features
- View dashboard with key metrics
- Manage internship listings
- View all users (students and admins)
- Access analytics and reports
- Manage platform content
- Full profile management

The implementation ensures a seamless experience while providing role-appropriate functionality for each user type.


