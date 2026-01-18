- https://flathub.org/en/apps/com.mattjakeman.ExtensionManager
  ```
  flatpak install flathub com.mattjakeman.ExtensionManager
  ```
  ```
  flatpak run com.mattjakeman.ExtensionManager
  ```
  <pre><b>com.mattjakeman.ExtensionManager</b> permissions:
    ipc      network      fallback-x11         wayland
    x11      dri          dbus access [1]

    [1] org.gnome.SessionManager, org.gnome.Shell.Extensions

  
  <b>        ID                                      Branch Op Remote  Download</b>
   1.     com.mattjakeman.ExtensionManager.Locale stable i  flathub &lt; 174.4 kB (partial)
   2.     org.gnome.Platform.Locale               49     i  flathub &lt; 385.3 MB (partial)
   3.     org.gnome.Platform                      49     i  flathub &lt; 404.8 MB
   4.     com.mattjakeman.ExtensionManager        stable i  flathub   &lt; 1.4 MB
  </pre>
  <pre>
  Error: While pulling runtime/org.gnome.Platform/x86_64/49 from remote flathub: While fetching https://dl.flathub.org/repo/deltas/m4/x7bKBn1vHr9k0BJd36s0doVEnWhelzQYV8EdXmQjw/8: [28] Timeout was reached
  <font color="#C01C28">
  <b>error: </b></font>Failed to install <b>org.gnome.Platform</b>: While pulling runtime/org.gnome.Platform/x86_64/49 from remote flathub: While fetching https://dl.flathub.org/repo/deltas/m4/x7bKBn1vHr9k0BJd36s0doVEnWhelzQYV8EdXmQjw/8: [28] Timeout was reached
  </pre>
