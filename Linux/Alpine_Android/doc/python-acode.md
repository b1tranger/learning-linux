**1. Environment & Python Setup**

* **Option A (Built-in Acode Terminal):** Open Acode, go to **Menu** $\rightarrow$ **Terminal**, let the Alpine Linux environment initialize, and install Python:
```bash
apk add python3 py3-pip

```


(Optional: Install the **Runner** plugin via **Settings** $\rightarrow$ **Plugins** to enable a quick run button).


* **Option B (Termux Method):** Install Termux, open it, and install Python:
```bash
pkg install python

```



---

**2. Project & Code Setup**

* Place both `main.py` and your custom module (e.g., `helper.py`) inside the exact same folder.
* Import the module inside `main.py`:
```python
import helper
# or: from helper import custom_function

```



---

**3. Execution (Direct Interpretation)**

Unlike compiled C++ binaries, Python scripts do not face Android shared storage `noexec` permission errors because the Python interpreter executes them directly.

Navigate to your project directory using `cd` and run:

* **Acode Internal Terminal:**
```bash
python3 main.py

```


* **Termux:**
```bash
python main.py

```



---

**4. Setting Up a Quick Run Shortcut**

To run any Python script simply with `py <filename.py>`:

1. Install `nano` if it is not already present:


```bash
apk add nano

```


2. Open your bash configuration file:


```bash
nano ~/.bashrc

```


3. Add the custom runner function at the bottom:
```bash
py() {
    python3 "$1"
}

```


4. Save with `Ctrl + O` $\rightarrow$ `Enter`, and exit with `Ctrl + X`.


5. Apply the changes:


```bash
source ~/.bashrc

```


6. Execute any Python file instantly from your project folder:
```bash
py main.py

```