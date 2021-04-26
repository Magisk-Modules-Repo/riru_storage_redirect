# Riru - Enhanced mode for Storage Isolation

Storage Isolation is an app which provides isolated storage feature for apps. It can prevent poor-designed apps making your storage messy and let you control files app can access.

This module enables Enhanced mode for Storage Isolation app which includes some important features related to user experience.

You can learn more about Storage Isolation from <https://sr.rikka.app/>.

## Changelog

### v24.1.2 (62) (2021-04-27)

- Fix "Fix app interaction issues" not works on some devices (requires update app to v5.3.2 as well)

### v24.1.0 (60) (2021-04-08)

- Fix "Fix app interaction issues" not works after upgrading to Riru 25

### v24.0.0 (59) (2021-03-23)

- Changes for Riru 25

### v23.8 (58) (2021-03-21)

- Explicitly check child zygote

Child zygote (`webview_zygote` and `app_zygote`) has no permission to use binder (this modules uses binder). Before only `mount_external != 0` is used for check, and child zygote do have `mount_external = 0` set, so there is no problem.

However, recently there are two modules, `riru-unshare` and `Riru-IsolatedMagiskHider` that changes `mount_external` for `app_zygote`. So if you are using one of these modules with the older version of this module, it will finally cause the crash.

### v23.7 (57) (2021-02-19)

- Works on devices which has remove 32-bit support (Android 12 emulator and maybe new real devices in the future)
- Reduce file size

### v23.6 (56) (2021-02-11)

- Reduce file size
- Fix an undefined behavior

### v23.5 (55) (2021-01-12)

- Fix "Fix rename" can cause wrong behavior in some cases

### v23.4 (54) (2020-12-29)

- Same from v23.3 but ensure it really works

### v23.3 (53) (2020-12-12)

- Attempt to workaround the problem that the required changes are reverted by something else

  If you have this problem, you will find Storage Isolation "stop working" at a random time (few minutes or few hours after booting).

  **All reports are from Huawei users**. The new method works for Android 8+.

### v23.2 (52) (2020-12-07)

- Works on pre-Android-8.0

### v23.1 (51) (2020-12-03)

- Read files with "rirud" (added from Riru v22.x) first

### v23.0 (48) (2020-11-05)

- Use binder for all IPC involving `untrusted_app` domain, SELinux policy patch is not required anymore 🎉 (For the module itself, everything are completely rewritten)
- Adapt Riru v22

### v22.8 (45) (2020-08-11)

- Revert changes of v22.7 (because this will cause problem on devices with external SD card or highly modified system like MIUI, OxygenOS)

### v22.7 (44) (2020-06-16)

- Change mount mode to `MOUNT_EXTERNAL_DEFAULT` for isolated apps

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

### v21.1 (36) (2020-01-07)

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
