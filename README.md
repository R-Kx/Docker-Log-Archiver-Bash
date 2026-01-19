[![ShellCheck](https://img.shields.io/badge/shellcheck-passed-brightgreen)](https://www.shellcheck.net/)
[![Run on GitHub](https://img.shields.io/badge/run%20script-GitHub-blue)](https://github.com/R-Kx/Docker-Log-Archiver-Bash/blob/main/docker.sh)



🐳 Docker Logs Archiver (Bash)

A defensive Bash script that captures Docker logs from journalctl, archives them, and cleans up old Docker logs — with proper handling of sudo execution and user environments.

📌 Features

📥 Captures the latest Docker logs using journalctl
📦 Archives logs into a timestamped .tar.gz file
🧹 Optionally removes Docker logs older than 7 days (root-only)
🔐 Correctly resolves the invoking user’s home directory when run with sudo
🛡 Uses defensive Bash practices (set -euo pipefail)
📂 Stores logs safely on the user’s Desktop

🧠 Why This Script Exists

When running scripts with sudo, environment variables like $HOME change to /root, which can lead to files being created in unexpected locations.

This script explicitly detects whether it is being executed with sudo and resolves the real invoking user’s home directory using $SUDO_USER, ensuring consistent and predictable behavior.

This is a common real-world Linux and DevOps pitfall — and this script demonstrates how to handle it correctly.

⚙️ How It Works

1. Detects whether the script is run with sudo
2. Resolves the correct user home directory
3. Captures the last 50 Docker log entries
4. Archives the logs with a unique timestamp
5. Removes the temporary log file
6. Cleans Docker logs older than 7 days (if run as root)

📂 Output Example
Desktop/
└── docker-logs/
    └── docker-logs-2026-01-19-14-33-22.tar.gz

🔐 Permissions & Requirements

1. Linux system using systemd
2. Docker service managed by systemd
3. journalctl available
4. Root privileges required only for log cleanup

🛡 Defensive Bash Practices Used

1. set -euo pipefail
2. Quoted variables to prevent word splitting
3. Explicit exit codes
4. Root privilege checks using $EUID
5. Safe environment variable handling ($SUDO_USER)
6. Timestamped filenames to prevent overwrites
