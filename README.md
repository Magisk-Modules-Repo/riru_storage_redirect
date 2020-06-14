# Riru - Enhanced mode for Storage Isolation

Storage Isolation is an app which provides isolated storage feature for apps. It can prevent poor-designed apps making your storage messy and let you control files app can access.

This module enables Enhanced mode for Storage Isolation app which includes some important features related to user experience.

You can learn more about Storage Isolation from <https://sr.rikka.app/>.

## Changelog

### v22.6 (43) (2020-06-14)

- Fix app-level toggle of "Fix app interaction" not work

### v22.5 (42) (2020-04-25)

- Upgrade to Riru API 6 (because Android 11 DP3 changes again)

### v22.4 (41) (2020-04-25)

- Add `untrusted_app_29` in `sepolicy.rule`
- Upgrade to Riru API 5

### v22.3 (40) (2020-03-20)

- Fix service not starting on some devices

  On these devices (yeah, it's you, Xiaomi, again and again) symlinks in `/data/misc` breaks after reboot

### v22.2 (39) (2020-03-16)

- Fix service not starting in rare cases

### v22.1 (38) (2020-03-08)

- Fix service "not starting" on some devices

### v22.0 (37) (2020-02-28)

- Adapt changes for "Shared User ID" support
- Adapt changes for "fix isolate early started apps may cause system not starting"

### v21.1 (36) (2020-01-7)

- Add missing sepolicy rule for Samsung
- Use customize.sh

### v21.1 (35) (2019-12-28)

- Add custom sepolicy rule file for Magisk v20.2+ (20110+)

### v21.1 (34)

- Add "Block system remount" option

### v20.3 (32)

- Switch cgroup for starter
- Verify important files on install

### v20.1 (30)

- Don't hardcode `HIDDEN_API_ENFORCEMENT_POLICY_MASK` value
- Fix log is printed in zygote process

### v20.0 (29)

- Fix the problem that redirection not work for apps installed in external storage card when using [Adoptable Storage](https://source.android.com/devices/storage/adoptable)
- Change the implementation of "Fix app interaction", no longer be break by "Xposed Taich", it may also solve some other problems
- "Fix app interaction" can be switched individually for each app

### v19.7 (27)

- Handle special system apps (appId > 19999 or appId < 10000, appId = uid % 100000)