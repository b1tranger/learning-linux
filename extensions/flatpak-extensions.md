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
  The issue might be a temporary network glitch on your end or Flathub's end. Simply trying the command again often works [link-1](https://github.com/actions/runner-images/issues/2264)
  <pre><b>com.mattjakeman.ExtensionManager</b> permissions:
    ipc      network      fallback-x11         wayland
    x11      dri          dbus access [1]

    [1] org.gnome.SessionManager, org.gnome.Shell.Extensions
  
  
  <b>        ID                               Branch Op Remote  Download</b>
   1.     org.gnome.Platform               49     i  flathub &lt; 404.8 MB
   2.     com.mattjakeman.ExtensionManager stable i  flathub   &lt; 1.4 MB
  </pre>
  after I enabled CloudFare Warp
  <pre><b>com.mattjakeman.ExtensionManager</b> permissions:
    ipc      network      fallback-x11         wayland
    x11      dri          dbus access [1]

    [1] org.gnome.SessionManager, org.gnome.Shell.Extensions

  
  <b>        ID                                            Branch      Op Remote  Download</b>
   1.     com.mattjakeman.ExtensionManager.Locale       stable      i  flathub &lt; 174.4 kB (partial)
   2.     org.freedesktop.Platform.GL.default           25.08       i  flathub &lt; 140.1 MB
   3.     org.freedesktop.Platform.GL.default           25.08-extra i  flathub &lt; 140.1 MB
   4.     org.freedesktop.Platform.GL.nvidia-535-274-02 1.4         i  flathub &lt; 293.2 MB
   5.     org.freedesktop.Platform.VAAPI.nvidia         25.08       i  flathub  &lt; 44.5 kB
   6.     org.freedesktop.Platform.codecs-extra         25.08-extra i  flathub  &lt; 14.4 MB
   7.     org.gnome.Platform.Locale                     49          i  flathub &lt; 385.3 MB (partial)
   8.     org.gtk.Gtk3theme.Yaru-dark                   3.22        i  flathub &lt; 196.5 kB
   9.     org.gnome.Platform                            49          i  flathub &lt; 404.8 MB
  10.     com.mattjakeman.ExtensionManager              stable      i  flathub   &lt; 1.4 MB
  
  Proceed with these changes to the system installation?</pre>
