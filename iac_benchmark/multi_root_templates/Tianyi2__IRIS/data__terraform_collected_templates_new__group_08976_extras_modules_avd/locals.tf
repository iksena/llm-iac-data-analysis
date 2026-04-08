locals {
  # Built-in Azure role definition IDs
  desktop_virtualization_user_role = "1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63"
  vm_user_login_role               = "fb879df8-f326-4884-b1cf-06f3ad86be52"

  # Host pool configuration
  rdp_properties = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;enablerdsaadauth:i:1;"
}
