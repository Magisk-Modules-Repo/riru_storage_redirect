#!/system/bin/sh
MODDIR=${0%/*}
DATADIR=/data/adb/storage-isolation

[ ! -f "$MODDIR/riru.sh" ] && exit 1
. $MODDIR/riru.sh

# Use magisk_file like other Magisk files
chcon $RIRU_SECONTEXT "$DATADIR"
chcon $RIRU_SECONTEXT "$DATADIR/bin"
chcon $RIRU_SECONTEXT "$DATADIR/bin/main.dex"
chcon $RIRU_SECONTEXT "$DATADIR/bin/daemon"

# Rename module.prop.new
if [ -f "$RIRU_MODULE_PATH/module.prop.new" ]; then
  rm "$RIRU_MODULE_PATH/module.prop"
  mv "$RIRU_MODULE_PATH/module.prop.new" "$RIRU_MODULE_PATH/module.prop"
fi

# Remove old file to avoid downgrade problems
rm -rf /data/misc/riru/modules/storage_redirect

# Run starter
echo "storage-isolation: run $RIRU_MODULE_PATH/bin/starter" > /dev/kmsg
exec "$RIRU_MODULE_PATH/bin/starter"