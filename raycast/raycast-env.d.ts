/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `clear-notifications` command */
  export type ClearNotifications = ExtensionPreferences & {}
  /** Preferences accessible in the `latest-notification` command */
  export type LatestNotification = ExtensionPreferences & {}
  /** Preferences accessible in the `dismiss-notification` command */
  export type DismissNotification = ExtensionPreferences & {}
  /** Preferences accessible in the `notification-count` command */
  export type NotificationCount = ExtensionPreferences & {}
  /** Preferences accessible in the `toggle-dnd` command */
  export type ToggleDnd = ExtensionPreferences & {}
  /** Preferences accessible in the `toggle-notification-center` command */
  export type ToggleNotificationCenter = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `clear-notifications` command */
  export type ClearNotifications = {}
  /** Arguments passed to the `latest-notification` command */
  export type LatestNotification = {}
  /** Arguments passed to the `dismiss-notification` command */
  export type DismissNotification = {}
  /** Arguments passed to the `notification-count` command */
  export type NotificationCount = {}
  /** Arguments passed to the `toggle-dnd` command */
  export type ToggleDnd = {}
  /** Arguments passed to the `toggle-notification-center` command */
  export type ToggleNotificationCenter = {}
}

