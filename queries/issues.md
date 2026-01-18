- hit storage limit<br>
  <pre>Error: Not enough disk space to complete this operation
  <font color="#C01C28"><b>error: </b></font>Failed to install <b>org.gnome.Platform</b>: While pulling runtime/org.gnome.Platform/x86_64/49 from remote flathub: Writing content object: min-free-space-size 500MB would be exceeded, at least 1.1 MB requested
  </pre>
  <img width="600" height="609" alt="image" src="https://github.com/user-attachments/assets/522dd62f-723d-4ed0-86cb-82bdcbbe1d68" /><br>
  I already hit my 16GB storage limit 🤲<br>
  should I start again, or could yo guys suggest some cleanup options?<br>
  <img width="600" height="862" alt="image" src="https://github.com/user-attachments/assets/3e71d126-fb2d-4250-9b34-1a388fbc7437" /><br>
  should I allocate all 50GB without mount partitions?<br>
  - fix for storage limit
  > Google AI Mode: [link](https://share.google/aimode/KUmHoACt9JphMK21g)

  First, determine which partition is full using the df (disk free) command in a human-readable format:
  ```
  df -h
  ```
  Once you know which partition is full, use the du (disk usage) command to find the biggest culprits. For example, to check the size of folders in the root directory (/), run this command:
  ```
  sudo du -sh /* | sort -nr | head -n 10
  ```

  ### Here are the most common and safest ways to free up space, especially in Debian/Ubuntu-based systems:
  
  Clean the APT package cache: Your system caches downloaded installation files in /var/cache/apt/archives. You can safely clear this cache:
  ```
  sudo apt clean
  ```
  Remove unneeded dependencies and old kernels: Over time, packages installed as dependencies for other software might become unnecessary. This command removes them:
  ```
  sudo apt autoremove
  ```
  Clear System Logs: Log files can grow very large, especially in /var/log. You can check the current usage:
  ```
  journalctl --disk-usage
  ```
  To clear logs older than a specific time (e.g., 3 days), use:
  ```
  sudo journalctl --vacuum-time=3d
  ```
  Empty the Trash Bin: Files deleted via the GUI still reside in the trash bin until manually emptied.
  ```
  rm -rf ~/.local/share/Trash/*
  ```
  If the above commands don't free enough space, you may need to manually delete large, unnecessary files (like old downloads, large video files, or backups).
  <br>Use the find command to locate large files:
  ```
  find /home/youruser -type f -size +100M -exec du -h {} \; | sort -nr
  ```
  Replace /home/youruser with the specific path you are investigating. Carefully review the output before using rm to delete any files.
  <br>After freeing up space, try running your operation again.


### # source:
- https://share.google/aimode/KUmHoACt9JphMK21g

