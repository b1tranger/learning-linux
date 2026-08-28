
# C++ Setup in Acode Mobile & Termux

**Acode APK (F-Droid / Releases):** [https://github.com/Acode-Foundation/Acode/releases/tag/v1.13.1](https://github.com/Acode-Foundation/Acode/releases/tag/v1.13.1)

> **Summary:** Setup process to configure the environment and run `new.cpp` and `new.h` in the same project folder on Android.

---

### 1. Environment & Compiler Setup

* **Option A (Built-in Acode Terminal):**  
  Open Acode, go to **Menu** $\rightarrow$ **Terminal**, allow the Alpine Linux environment to initialize, and install the compiler:

  ```bash
  apk add g++
  ```

*(Optional: Install the **Runner** plugin via **Settings** $\rightarrow$ **Plugins** to enable a quick run button).*

* **Option B (Termux Method):**
Install Termux, open it, and install the toolchain:
```bash
pkg install clang

```



---

### 2. Project & Code Setup

* Place both `new.cpp` and `new.h` inside the **exact same folder**.
* Include the header inside `new.cpp` using double quotes:
```cpp
#include "new.h"

```



---

### 3. Compiling and Execution (Avoiding Permission Denied Errors)

Android shared storage (`/storage/emulated/0/...`) restricts direct binary execution (`noexec`).

Navigate to your project folder using `cd` and output the binary to `/tmp` or the home directory (`~`):

* **Acode Internal Terminal (`g++`):**
```bash
g++ new.cpp -o /tmp/program && /tmp/program

```


*or outputting to the home directory:*
```bash
g++ new.cpp -o ~/program && ~/program

```


* **Termux (`clang++`):**
```bash
clang++ new.cpp -o $PREFIX/tmp/program &&$PREFIX/tmp/program

```


*or outputting to the home directory:*
```bash
clang++ new.cpp -o ~/program && ~/program

```



> **Note:** Do not include `new.h` directly in the compilation command; the compiler detects it automatically through `#include "new.h"`. If multiple `.cpp` files exist, compile them together:
> `g++ main.cpp new.cpp -o /tmp/program && /tmp/program`

---

### 4. Setting Up a Quick Run Shortcut

Create a terminal shortcut so you don't have to retype the full command:

1. **Install `nano**` if it is not already present:
```bash
apk add nano

```


2. **Open your bash configuration file:**
```bash
nano ~/.bashrc

```


3. **Add the custom runner function at the bottom:**
```bash
run() {
    g++ "$1" -o /tmp/app && /tmp/app
}

```


4. **Save and exit:**
Press `Ctrl + O` $\rightarrow$ `Enter`, then exit with `Ctrl + X`.
5. **Apply the changes:**
```bash
source ~/.bashrc

```


6. **Execute any C++ file instantly from your project folder:**
```bash
run new.cpp

```
