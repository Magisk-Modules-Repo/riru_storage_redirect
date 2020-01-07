SKIPUNZIP=1
RIRU_PATH="/data/misc/riru"
CONFIG_PATH="/data/misc/storage_redirect"

check_riru_version() {
  [[ ! -f "$RIRU_PATH/api_version" ]] && abort "! Please Install Riru - Core v19 or above"
  VERSION=$(cat "$RIRU_PATH/api_version")
  ui_print "- Riru API version: $VERSION"
  [[ "$VERSION" -ge 4 ]] || abort "! Please upgrade Riru - Core to v19 or above"
}

check_architecture() {
  if [[ "$ARCH" != "arm" && "$ARCH" != "arm64" && "$ARCH" != "x86" && "$ARCH" != "x64" ]]; then
    abort "! Unsupported platform: $ARCH"
  else
    ui_print "- Device platform: $ARCH"
  fi
}

check_app_version() {
  VERSION=$(cat "$CONFIG_PATH/.server_version")
  ui_print "- Storage Redirect core service version: $VERSION"
  if [[ "$VERSION" -lt 232 ]]; then
    ui_print "*****************************************"
	ui_print "! Storage Redirect app version too low"
    ui_print "! Please upgrade to v3.0.0 or above (and run service)"
    ui_print "! You can find download from https://sr.rikka.app"
	ui_print "! For Google users, Google Play usually has hours to a day of delay"
	abort    "*****************************************"
  fi
}

check_architecture
check_riru_version
check_app_version

unzip -o "$ZIPFILE" 'verify.sh' -d $TMPDIR >&2
. $TMPDIR/verify.sh

ui_print "- Extracting module files"
vunzip -o "$ZIPFILE" 'module.prop' 'post-fs-data.sh' -d "$MODPATH"

if [[ "$ARCH" == "x86" || "$ARCH" == "x64" ]]; then
  ui_print "- Extracting x86/64 libraries"
  vunzip -o "$ZIPFILE" 'system_x86/*' -d $MODPATH
  mv "$MODPATH/system_x86/lib" "$MODPATH/system/lib"
  mv "$MODPATH/system_x86/lib64" "$MODPATH/system/lib64"
else
  ui_print "- Extracting arm/arm64 libraries"
  vunzip -o "$ZIPFILE" 'system/*' -d $MODPATH
fi

if [[ "$IS64BIT" = false ]]; then
  ui_print "- Removing 64-bit libraries"
  rm -rf "$MODPATH/system/lib64"
fi

vunzip -o "$ZIPFILE" 'sepolicy.rule' -d "$MODPATH"

ui_print "- Extracting starter"
mkdir -p "$RIRU_PATH/modules/storage_redirect/bin"
vunzip -o -j "$ZIPFILE" "starter/starter_$ARCH" -d "$RIRU_PATH/modules/storage_redirect/bin"
mv "$RIRU_PATH/modules/storage_redirect/bin/starter_$ARCH" "$RIRU_PATH/modules/storage_redirect/bin/starter"

ui_print "- Extracting Riru files"
vunzip -o "$ZIPFILE" 'data/*' -d "$TMPDIR"
TARGET="$RIRU_PATH/modules"
[[ -d "$TARGET" ]] || mkdir -p "$TARGET" || abort "! Can't mkdir -p $TARGET"
cp -af "$TMPDIR$TARGET/." "$TARGET" || abort "! Can't cp -af $TMPDIR$TARGET/. $TARGET"

ui_print "- Setting permissions"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm "$RIRU_PATH/modules/storage_redirect/bin/starter" 0 0 0700 u:object_r:system_file:s0