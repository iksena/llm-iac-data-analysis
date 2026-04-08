variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "content_type" {
  description = "The upload's content type (for example, application/octet-stream)."
  type        = string
  default     = null
}

variable "name" {
  description = "The upload's file name. The name should not contain any forward slashes (/). If you are uploading an iOS app, the file name must end with the .ipa extension. If you are uploading an Android app, the file name must end with the .apk extension. For all others, the file name must end with the .zip file extension."
  type        = string

  validation {
    condition     = !can(regex("/", var.name))
    error_message = "resource_aws_devicefarm_upload, name must not contain forward slashes (/)."
  }

  validation {
    condition     = can(regex("\\.(ipa|apk|zip)$", var.name))
    error_message = "resource_aws_devicefarm_upload, name must end with .ipa (for iOS apps), .apk (for Android apps), or .zip (for all others)."
  }
}

variable "project_arn" {
  description = "The ARN of the project for the upload."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:devicefarm:", var.project_arn))
    error_message = "resource_aws_devicefarm_upload, project_arn must be a valid AWS Device Farm project ARN."
  }
}

variable "type" {
  description = "The upload's upload type. See AWS Docs for valid list of values."
  type        = string

  validation {
    condition = contains([
      "ANDROID_APP",
      "IOS_APP",
      "WEB_APP",
      "EXTERNAL_DATA",
      "APPIUM_JAVA_JUNIT_TEST_PACKAGE",
      "APPIUM_JAVA_TESTNG_TEST_PACKAGE",
      "APPIUM_PYTHON_TEST_PACKAGE",
      "APPIUM_NODE_TEST_PACKAGE",
      "APPIUM_RUBY_TEST_PACKAGE",
      "APPIUM_WEB_JAVA_JUNIT_TEST_PACKAGE",
      "APPIUM_WEB_JAVA_TESTNG_TEST_PACKAGE",
      "APPIUM_WEB_PYTHON_TEST_PACKAGE",
      "APPIUM_WEB_NODE_TEST_PACKAGE",
      "APPIUM_WEB_RUBY_TEST_PACKAGE",
      "CALABASH_TEST_PACKAGE",
      "INSTRUMENTATION_TEST_PACKAGE",
      "UIAUTOMATION_TEST_PACKAGE",
      "UIAUTOMATOR_TEST_PACKAGE",
      "XCTEST_TEST_PACKAGE",
      "XCTEST_UI_TEST_PACKAGE",
      "APPIUM_JAVA_JUNIT_TEST_SPEC",
      "APPIUM_JAVA_TESTNG_TEST_SPEC",
      "APPIUM_PYTHON_TEST_SPEC",
      "APPIUM_NODE_TEST_SPEC",
      "APPIUM_RUBY_TEST_SPEC",
      "APPIUM_WEB_JAVA_JUNIT_TEST_SPEC",
      "APPIUM_WEB_JAVA_TESTNG_TEST_SPEC",
      "APPIUM_WEB_PYTHON_TEST_SPEC",
      "APPIUM_WEB_NODE_TEST_SPEC",
      "APPIUM_WEB_RUBY_TEST_SPEC",
      "INSTRUMENTATION_TEST_SPEC",
      "XCTEST_UI_TEST_SPEC"
    ], var.type)
    error_message = "resource_aws_devicefarm_upload, type must be a valid AWS Device Farm upload type."
  }
}