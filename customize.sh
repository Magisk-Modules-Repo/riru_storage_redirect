SKIPUNZIP=1
CONFIG_PATH="/data/adb/storage-isolation"

# Extract verify.sh
ui_print "- Extracting verify.sh"
unzip -o "$ZIPFILE" 'verify.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/verify.sh" ]; then
  ui_print    "*********************************************************"
  ui_print    "! Unable to extract verify.sh!"
  ui_print    "! This zip may be corrupted, please try downloading again"
  abort "*********************************************************"
fi
. $TMPDIR/verify.sh

# Extract riru.sh

# Variables provided by riru.sh:
#
# RIRU_API: API version of installed Riru, 0 if not installed
# RIRU_MIN_COMPATIBLE_API: minimal supported API version by installed Riru, 0 if not installed or version < v23.2
# RIRU_VERSION_CODE: version code of installed Riru, 0 if not installed or version < v23.2
# RIRU_VERSION_NAME: version name of installed Riru, "" if not installed or version < v23.2

extract "$ZIPFILE" 'riru.sh' "$MODPATH"
. $MODPATH/riru.sh

# Functions from riru.sh
check_riru_version
enforce_install_from_magisk_app

# Check architecture
if [ "$ARCH" != "arm" ] && [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x86" ] && [ "$ARCH" != "x64" ]; then
  abort "! Unsupported platform: $ARCH"
else
  ui_print "- Device platform: $ARCH"
fi

# Check app version
[ -f "$CONFIG_PATH/.server_version" ] && VERSION=$(cat "$CONFIG_PATH/.server_version") || VERSION=0
[ "$VERSION" -eq "$VERSION" ] || VERSION=0
ui_print "- Storage Isolation core service version: $VERSION"
if [ "$VERSION" -lt 304 ]; then
  ui_print    "*****************************************"
  ui_print    "! Storage Isolation app is not installed or the version is too low"
  ui_print    "! Please upgrade the app to v6.0.0 or above and upgrade core service in the app"
  ui_print    "! You can find download link from https://sr.rikka.app"
  abort "*****************************************"
fi

ui_print "- Extracting Magisk files"

extract "$ZIPFILE" 'module.prop' "$MODPATH"
extract "$ZIPFILE" 'post-fs-data.sh' "$MODPATH"
extract "$ZIPFILE" 'uninstall.sh' "$MODPATH"

mkdir "$MODPATH/riru"
mkdir "$MODPATH/riru/lib"
mkdir "$MODPATH/riru/lib64"

if [ "$ARCH" = "arm" ] || [ "$ARCH" = "arm64" ]; then
  ui_print "- Extracting arm libraries"
  extract "$ZIPFILE" "lib/armeabi-v7a/libriru_$RIRU_MODULE_ID.so" "$MODPATH/riru/lib" true

  if [ "$IS64BIT" = true ]; then
    ui_print "- Extracting arm64 libraries"
    extract "$ZIPFILE" "lib/arm64-v8a/libriru_$RIRU_MODULE_ID.so" "$MODPATH/riru/lib64" true
    extract "$ZIPFILE" "lib/arm64-v8a/starter" "$MODPATH" true
  else
    extract "$ZIPFILE" "lib/armeabi-v7a/starter" "$MODPATH" true
  fi
fi

if [ "$ARCH" = "x86" ] || [ "$ARCH" = "x64" ]; then
  ui_print "- Extracting x86 libraries"
  extract "$ZIPFILE" "lib/x86/libriru_$RIRU_MODULE_ID.so" "$MODPATH/riru/lib" true

  if [ "$IS64BIT" = true ]; then
    ui_print "- Extracting x64 libraries"
    extract "$ZIPFILE" "lib/x86_64/libriru_$RIRU_MODULE_ID.so" "$MODPATH/riru/lib64" true
    extract "$ZIPFILE" "lib/x86_64/starter" "$MODPATH" true
  else
    extract "$ZIPFILE" "lib/x86/starter" "$MODPATH" true
  fi
fi

extract "$ZIPFILE" 'main.dex' "$MODPATH"

# Riru pre-v24 uses "/system", "/data/adb/riru/modules" is used as the module list
# If "/data/adb/riru/modules/example" exists, Riru will try to load "/system/lib(64)/libriru_example.so

# If your module does not need to support Riru pre-v24, you can raise the value of "moduleMinRiruApiVersion" in "module.gradle"
# and remove this part

if [ "$RIRU_API" -lt 11 ]; then
  ui_print "- Using old Riru"
  mv "$MODPATH/riru" "$MODPATH/system"
  mkdir -p "/data/adb/riru/modules/$RIRU_MODULE_ID"
fi

set_perm_recursive "$MODPATH" 0 0 0755 0644
