# Riru - Storage Redirect (Enhanced mode)

Storage Redirect is an app which provides isolated storage feature for apps. It can prevent poor-designed apps making your storage messy and let you control files app can access.

This module enables Enhanced mode for Storage Redirect which includes some important features related to user experience.

You can learn more about Storage Redirect from <https://sr.rikka.app/>.

## Changelog

### v20.0 (29)

- Fix the problem that redirection not work for apps installed in external storage card when using [Adoptable Storage](https://source.android.com/devices/storage/adoptable)
- Change the implementation of "Fix app interaction", no longer be break by "Xposed Taich", it may also solve some other problems
- "Fix app interaction" can be switched individually for each app

### v19.7 (27)

- Handle special system apps (appId > 19999 or appId < 10000, appId = uid % 100000)