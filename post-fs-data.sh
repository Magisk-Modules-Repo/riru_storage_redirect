#!/system/bin/sh
MODDIR=${0%/*}

if [ -f "$MODDIR"/../riru-core/util_functions.sh ]; then
  # Riru v24
  # If this module is installed before Riru is updated to v24, we have to manually move the files to the new location
  [ -d "$MODDIR"/system ] && mv "$MODDIR"/system "$MODDIR"/riru

  # Remove unnecessary foloder
  rm -rf /data/misc/riru/modules/storage_redirect
else
  # Riru pre-v24
  # In case user downgrade Riru to pre-v24
  [ -d "$MODDIR"/riru ] && mv "$MODDIR"/riru "$MODDIR"/system
  mkdir -p /data/misc/riru/modules/storage_redirect
fi

# Run starter
chmod 700 "$MODDIR"/starter
echo "storage-isolation: run $MODDIR/starter" > /dev/kmsg
exec "$MODDIR/starter"
