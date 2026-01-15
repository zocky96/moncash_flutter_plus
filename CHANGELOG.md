## 0.0.4

### 🐛 Bug Fixes
* **CRITICAL**: Fixed navigation bug where `PaymentResponse` was never returned to the calling widget
* Fixed typo: `transanctionId` renamed to `transactionId` (with deprecated getter for backward compatibility)
* Updated from deprecated `WillPopScope` to `PopScope` (requires Flutter 3.12+)
* Updated `DioError` to `DioException` (Dio 5.x compatibility)

### ✨ Improvements
* Enhanced error handling with better user feedback and structured logging
* Added comprehensive code documentation (French)
* Improved null safety throughout the codebase
* Added timeout configuration (30s) for all HTTP requests
* Better navigation handling with proper result passing
* Added AppBar with close button for improved UX
* Modern API usage with `InAppWebViewSettings` instead of deprecated `InAppWebViewGroupOptions`

### ⚠️ Breaking Changes
* Requires Flutter 3.12+ for `PopScope` support
* `transanctionId` is now deprecated in favor of `transactionId` (backward compatible getter provided)
* `retrieveTransanction()` method renamed to `retrieveTransaction()` for consistency

## 0.0.3

* Updated Dependencies and documentation

## 0.0.2

* Bug Fixes

## 0.0.1

* Initial release
