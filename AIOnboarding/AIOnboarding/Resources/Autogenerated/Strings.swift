// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  /// and
  internal static let and = Strings.tr("LocalizableStrings", "and", fallback: "and")
  /// Problems with receipt were occured
  internal static let badReceipt = Strings.tr("LocalizableStrings", "bad receipt", fallback: "Problems with receipt were occured")
  /// By continuing you accept our:
  internal static let byContinuingYouAcceptOur = Strings.tr("LocalizableStrings", "by continuing you accept our:", fallback: "By continuing you accept our:")
  /// LocalizableStrings.strings
  ///   AIOnboarding
  /// 
  ///   Created by Евгений  on 23/05/2023.
  internal static let `continue` = Strings.tr("LocalizableStrings", "continue", fallback: "Continue")
  /// Error
  internal static let error = Strings.tr("LocalizableStrings", "error", fallback: "Error")
  /// Failed Decoding
  internal static let failedDecoding = Strings.tr("LocalizableStrings", "failed decoding", fallback: "Failed Decoding")
  /// Failed Response
  internal static let failedResponse = Strings.tr("LocalizableStrings", "failed response", fallback: "Failed Response")
  /// Invalid Data
  internal static let invalidData = Strings.tr("LocalizableStrings", "invalid data", fallback: "Invalid Data")
  /// Invalid URL
  internal static let invalidUrl = Strings.tr("LocalizableStrings", "invalid url", fallback: "Invalid URL")
  /// Privacy Policy
  internal static let privacyPolicy = Strings.tr("LocalizableStrings", "privacy policy", fallback: "Privacy Policy")
  /// product not found
  internal static let productNotFound = Strings.tr("LocalizableStrings", "product not found", fallback: "product not found")
  /// purchase in progress
  internal static let purchaseInProgress = Strings.tr("LocalizableStrings", "purchase in progress", fallback: "purchase in progress")
  /// You have successfully purchased a subscription
  internal static let purchased = Strings.tr("LocalizableStrings", "purchased", fallback: "You have successfully purchased a subscription")
  /// Restore Purchase
  internal static let restorePurchase = Strings.tr("LocalizableStrings", "restore_purchase", fallback: "Restore Purchase")
  /// You have successfully restored your subscription
  internal static let restored = Strings.tr("LocalizableStrings", "restored", fallback: "You have successfully restored your subscription")
  /// Subscription Terms
  internal static let subscriptionTerms = Strings.tr("LocalizableStrings", "subscription terms", fallback: "Subscription Terms")
  /// Terms of Use
  internal static let termsOfUse = Strings.tr("LocalizableStrings", "terms of Use", fallback: "Terms of Use")
  /// Try Free & Subscribe
  internal static let tryFreeSubscribe = Strings.tr("LocalizableStrings", "try_free_&_subscribe", fallback: "Try Free & Subscribe")
  /// unknown error
  internal static let unknownError = Strings.tr("LocalizableStrings", "unknown error", fallback: "unknown error")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
