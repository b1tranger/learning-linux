check: 
```
gnome-extensions list
```
---

### # manager
- To control [GNOME Shell extensions](https://gnome.pages.gitlab.gnome.org/gnome-browser-integration/pages/installation-guide.html) using this site you must install GNOME Shell integration that consists of two parts: <br>browser extension and native host messaging application.


---

### # extensions
- [clipboard-indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)| The most popular clipboard manager for GNOME, with over 2M downloads. Check the Github page for a full list of features. | [Extension Homepage](https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator ) | [ALT/flatpak](https://flathub.org/en/apps/com.github.hluk.copyq)
  - installation:<br>
  ```
  cd /home/saraf/Downloads/git_clones/extensions
  ```
  Installation via git is performed by cloning the repo into your local gnome-shell extensions directory (usually ~/.local/share/gnome-shell/extensions/):
  ```
  git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
  ```
  After cloning the repo, the extension is practically installed yet disabled. In order to enable it, run the following command:
  ```
  gnome-extensions enable clipboard-indicator@tudmotu.com
  ```
  ~/.local/share/gnome-shell/extensions/

---

### # source
- https://gnome.pages.gitlab.gnome.org/gnome-browser-integration/pages/installation-guide.html
