# Flutter Internship Readiness Tracker

Cross-platform Flutter app that scores readiness for a Flutter internship.

**Live demo:** https://rohitrk5972.github.io/flutter-readiness-tracker/

## Features
- Local auth: email validation, per-user random salt + SHA-256 hashed passwords
- Weighted skills checklist, 8-question Dart/Flutter quiz, resume keyword matcher
- Readiness score = 50% skills + 30% quiz + 20% keyword coverage
- REST API integration (http) with loading, error and retry states
- Provider state management; per-user progress saved with SharedPreferences

## Tech
Flutter, Dart, Provider, http, shared_preferences, crypto, GitHub Actions (CI/CD to GitHub Pages)

## Run locally
```
flutter create . --platforms=android,ios,web
flutter pub get
flutter run
```
Pushing to `main` auto-builds and deploys the web app via GitHub Actions.
