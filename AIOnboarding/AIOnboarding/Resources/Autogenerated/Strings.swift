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
  /// By continuing you accept our:
  internal static let byContinuingYouAcceptOur = Strings.tr("LocalizableStrings", "By continuing you accept our:", fallback: "By continuing you accept our:")
  /// LocalizableStrings.strings
  ///   AIOnboarding
  /// 
  ///   Created by Евгений  on 23/05/2023.
  internal static let `continue` = Strings.tr("LocalizableStrings", "continue", fallback: "Continue")
  /// Privacy Policy
  internal static let privacyPolicy = Strings.tr("LocalizableStrings", "Privacy Policy", fallback: "Privacy Policy")
  /// Restore Purchase
  internal static let restorePurchase = Strings.tr("LocalizableStrings", "restore_purchase", fallback: "Restore Purchase")
  /// Subscription Terms
  internal static let subscriptionTerms = Strings.tr("LocalizableStrings", "Subscription Terms", fallback: "Subscription Terms")
  /// Terms of Use
  internal static let termsOfUse = Strings.tr("LocalizableStrings", "Terms of Use", fallback: "Terms of Use")
  /// Try Free & Subscribe
  internal static let tryFreeSubscribe = Strings.tr("LocalizableStrings", "try_free_&_subscribe", fallback: "Try Free & Subscribe")
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
