check: 
```
gnome-extensions list
```
---

### # manager
- To control [GNOME Shell extensions](https://gnome.pages.gitlab.gnome.org/gnome-browser-integration/pages/installation-guide.html) using this site you must install GNOME Shell integration that consists of two parts: <br>browser extension and native host messaging application.<br>
  (firefox addons not loading)
  ```
  sudo apt-get install gnome-browser-connector
  ```


---

### # extensions
- clipboard manager: | [UPDATE](https://github.com/b1tranger/learning-linux/blob/main/Linux/Day%202/3.%20Softwares%20to%20install%20%5BD3%5D.md)
  - [clipboard-indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)| The most popular clipboard manager for GNOME, with over 2M downloads. Check the Github page for a full list of features. | [Extension Homepage](https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator ) 
  - [ALT/copyq](https://flathub.org/en/apps/com.github.hluk.copyq) 
  - [ALT/gnome-shell-pano](https://github.com/oae/gnome-shell-pano) ✅
    <br>"You need libgda and gsound for this extension to work."
    ```
    sudo apt install gir1.2-gda-5.0 gir1.2-gsound-1.0
    ```
    does using apt commands auto install other dependencies?<br>
    
    Yes, using that specific command on Debian-based systems (like Ubuntu, Linux Mint, Pop!_OS) is designed to install the primary libraries
    and their required dependencies.[1] <br>The Advanced Packaging Tool (apt) automatically resolves and installs all necessary underlying packages that these two meta-packages require to function correctly [1]. You do not typically need to install base libraries (like libgda-5.0-4 or similar names) manually; apt manages that process for you. <br>The gir1.2-* packages you listed are specifically "GObject introspection" files. These files contain the metadata that allows interpreted languages like JavaScript (which GNOME Shell extensions use) to interact with the underlying C libraries (libgda and gsound). Installing these introspection packages ensures the extension can communicate with the services it needs.

---

### # source
- https://gnome.pages.gitlab.gnome.org/gnome-browser-integration/pages/installation-guide.html
- https://github.com/oae/gnome-shell-pano &larr; [suggested/TPC/bdeshi](https://bdeshi.space/pubkey.asc)
- 
