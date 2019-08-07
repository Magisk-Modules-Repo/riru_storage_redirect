#!/system/bin/sh
MODDIR=${0%/*}

# Reset context in case
chcon -R u:object_r:system_file:s0 $MODDIR

# Run starter
STARTER=/data/misc/riru/modules/storage_redirect/bin/starter
exec $STARTER