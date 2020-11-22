SKIPUNZIP=1
CONFIG_PATH="/data/adb/storage-isolation"

# extract verify.sh
ui_print "- Extracting verify.sh"
unzip -o "$ZIPFILE" 'verify.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/verify.sh" ]; then
  ui_print    "*********************************************************"
  ui_print    "! Unable to extract verify.sh!"
  ui_print    "! This zip may be corrupted, please try downloading again"
  abort "*********************************************************"
fi
. $TMPDIR/verify.sh

# extract riru.sh
extract "$ZIPFILE" 'riru.sh' "$MODPATH"
. $MODPATH/riru.sh

check_riru_version
check_architecture

# check app version
[ -f "$CONFIG_PATH/.server_version" ] && VERSION=$(cat "$CONFIG_PATH/.server_version") || VERSION=0
[ "$VERSION" -eq "$VERSION" ] || VERSION=0
ui_print "- Storage Isolation core service version: $VERSION"
if [ "$VERSION" -lt 274 ]; then
  ui_print    "*****************************************"
  ui_print    "! Storage Isolation app is not installed or the verison too low"
  ui_print    "! Please upgrade the app to v5.0.0 or above and upgrade core service in the app"
  ui_print    "! You can find download from https://sr.rikka.app"
  abort "*****************************************"
fi

ui_print "- Extracting Magisk files"

extract "$ZIPFILE" 'module.prop' "$MODPATH"
extract "$ZIPFILE" 'post-fs-data.sh' "$MODPATH"
extract "$ZIPFILE" 'uninstall.sh' "$MODPATH"

if [ "$ARCH" = "x86" ] || [ "$ARCH" = "x64" ]; then
  ui_print "- Extracting x86 libraries"
  extract "$ZIPFILE" "system_x86/lib/libriru_$RIRU_MODULE_ID.so" "$MODPATH"
  mv "$MODPATH/system_x86" "$MODPATH/system"

  if [ "$IS64BIT" = true ]; then
    ui_print "- Extracting x64 libraries"
    extract "$ZIPFILE" "system_x86/lib64/libriru_$RIRU_MODULE_ID.so" "$MODPATH"
    mv "$MODPATH/system_x86/lib64" "$MODPATH/system/lib64"
  fi
else
  ui_print "- Extracting arm libraries"
  extract "$ZIPFILE" "system/lib/libriru_$RIRU_MODULE_ID.so" "$MODPATH"

  if [ "$IS64BIT" = true ]; then
    ui_print "- Extracting arm64 libraries"
    extract "$ZIPFILE" "system/lib64/libriru_$RIRU_MODULE_ID.so" "$MODPATH"
  fi
fi

set_perm_recursive "$MODPATH" 0 0 0755 0644

# Riru files
ui_print "- Extracting extra files"
[ -d "$RIRU_MODULE_PATH" ] || mkdir -p "$RIRU_MODULE_PATH" || abort "! Can't create $RIRU_MODULE_PATH"
[ -d "$RIRU_MODULE_PATH/bin" ] || mkdir -p "$RIRU_MODULE_PATH/bin" || abort "! Can't create $RIRU_MODULE_PATH/bin"

rm -f "$RIRU_MODULE_PATH/module.prop.new"
extract "$ZIPFILE" 'riru/module.prop.new' "$RIRU_MODULE_PATH" true
set_perm "$RIRU_MODULE_PATH/module.prop.new" 0 0 0600 $RIRU_SECONTEXT

extract "$ZIPFILE" "starter/starter_$ARCH" "$RIRU_MODULE_PATH/bin" true
mv "$RIRU_MODULE_PATH/bin/starter_$ARCH" "$RIRU_MODULE_PATH/bin/starter"
set_perm "$RIRU_MODULE_PATH/bin/starter" 0 0 0700 $RIRU_SECONTEXT