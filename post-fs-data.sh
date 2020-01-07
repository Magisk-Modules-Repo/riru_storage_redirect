#!/system/bin/sh
MODDIR=${0%/*}

# Reset context in case
chcon -R u:object_r:system_file:s0 $MODDIR

# Rename module.prop.new
if [ -f "/data/misc/riru/modules/storage_redirect/module.prop.new" ]; then
    rm "/data/misc/riru/modules/storage_redirect/module.prop"
    mv "/data/misc/riru/modules/storage_redirect/module.prop.new" "/data/misc/riru/modules/storage_redirect/module.prop"
fi

# Run starter
STARTER=/data/misc/riru/modules/storage_redirect/bin/starter
exec $STARTER