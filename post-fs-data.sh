#!/system/bin/sh
MODDIR=${0%/*}
[ ! -f "$MODDIR/riru.sh" ] && exit 1
. $MODDIR/riru.sh

# Reset context in case
chcon -R u:object_r:system_file:s0 "$MODDIR"

# Rename module.prop.new
if [ -f "$RIRU_MODULE_PATH/module.prop.new" ]; then
  rm "$RIRU_MODULE_PATH/module.prop"
  mv "$RIRU_MODULE_PATH/module.prop.new" "$RIRU_MODULE_PATH/module.prop"
fi

# Run starter
STARTER="$RIRU_MODULE_PATH/bin/starter"
chmod 700 $STARTER
exec $STARTER
