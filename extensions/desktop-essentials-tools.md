- Google Drive for Desktop | While Google doesn't offer an
official native client for Linux, you can easily integrate Google Drive via built-in desktop environment features (like GNOME Online Accounts for Ubuntu/Mint) for seamless file manager access, or use powerful third-party tools like <mark>Rclone (command-line) or Insync (GUI)</mark> for advanced syncing and local folder mirroring. Most modern Linux systems provide simple ways to mount Drive as a network location without installing extra apps, or offer robust alternatives for true local sync
- Git Client (GUI) | does git kraken work like github desktop?<br>Yes, both
GitKraken and GitHub Desktop function as graphical user interfaces (GUIs) for Git, allowing users to perform standard version control operations (like committing, pushing, and pulling) without the command line. However, GitKraken is a more feature-rich and advanced tool designed for teams, while GitHub Desktop is a simpler, more basic tool aimed primarily at beginners or simple repository management tasks.
- PDF/Document editor | For the best Linux PDF editor,
  <mark>LibreOffice Draw</mark> is excellent for general text/image edits, Okular shines for annotations, while PDFsam handles merging/splitting; for advanced features, Master PDF Editor (paid/proprietary) offers Acrobat-like tools, and Stirling PDF (web-based) provides powerful free OCR and editing
- CloudFare Warp | https://developers.cloudflare.com/warp-client/get-started/linux/
  ```
  sudo apt install cloudflare-warp
  ```
  If you get an error message when trying to install via the terminal, download the package that suits your distro from the [package repository ↗](https://pkg.cloudflareclient.com/)
  <pre><font color="#C01C28"><b>E: </b></font>Unable to locate package cloudflare-warp
  </pre>  

   Add cloudflare gpg key
  ```
  curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
  ```
  Add this repo to your apt repositories
  ```
  echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
  ```
  Install
  ```
  sudo apt-get update && sudo apt-get install cloudflare-warp
  ```

  <br>To connect for the very first time:

    Register the client
  ```
  warp-cli registration new.
  ```
    Connect
  ```
  warp-cli connect.
  ```
    Run
  ```
  curl https://www.cloudflare.com/cdn-cgi/trace/ and verify that warp=on.
  ```

### # source
- https://pkg.cloudflareclient.com/
