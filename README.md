# VFrame Installer

🚀 A cross-platform installer script for quickly setting up new projects based on [VFrame](https://github.com/yashyadav711/VFrame).

## What is VFrame?

VFrame is a comprehensive AI agent framework with skills, sub-agents, and workflows for building intelligent applications. This installer helps you bootstrap new projects with VFrame's structure in seconds.

## Features

✅ Cross-platform support (Linux, macOS, Windows)  
✅ Interactive project setup  
✅ Automatic GitHub repository creation (optional)  
✅ Fresh Git repository (no VFrame history)  
✅ SSH key support  
✅ Customizable project names  

## Prerequisites

### Required
- **Git** - [Install Git](https://git-scm.com/downloads)

### Optional (for automatic GitHub repo creation)
- **GitHub CLI** - [Install GitHub CLI](https://cli.github.com/)
- **SSH keys configured for GitHub** - [GitHub SSH Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

## Quick Start

### Linux / macOS (Bash/Zsh)

```bash
# Download and run the installer
curl -o setup-vframe.sh https://raw.githubusercontent.com/yashyadav711/vframe-installer/main/setup-vframe.sh
chmod +x setup-vframe.sh
./setup-vframe.sh
```

Or one-liner:
```bash
bash <(curl -s https://raw.githubusercontent.com/yashyadav711/vframe-installer/main/setup-vframe.sh)
```

### Fish Shell

```fish
# One-liner for Fish
curl -s https://raw.githubusercontent.com/yashyadav711/vframe-installer/main/setup-vframe.sh | bash
```

Or download first:
```fish
curl -o setup-vframe.sh https://raw.githubusercontent.com/yashyadav711/vframe-installer/main/setup-vframe.sh
chmod +x setup-vframe.sh
bash setup-vframe.sh
```

### Windows (PowerShell)

```powershell
# Download and run the installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yashyadav711/vframe-installer/main/setup-vframe.ps1" -OutFile "setup-vframe.ps1"
.\setup-vframe.ps1
```

Or one-liner:
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/yashyadav711/vframe-installer/main/setup-vframe.ps1'))
```

## What It Does

1. **Checks prerequisites** - Verifies Git and GitHub CLI installation
2. **Prompts for project name** - You choose your project name
3. **Downloads VFrame** - Clones the latest VFrame structure
4. **Creates fresh Git repo** - Initializes new Git repository (no VFrame history)
5. **Optional: Creates GitHub repo** - Automatically creates and pushes to GitHub

## Usage Example

```bash
$ ./setup-vframe.sh

╔════════════════════════════════════════╗
║     VFrame Project Setup Script       ║
╚════════════════════════════════════════╝

ℹ Checking prerequisites...
✓ Git is installed
✓ GitHub CLI is installed

Enter your project name: my-awesome-project
ℹ Creating project directory: my-awesome-project
✓ Project directory created
ℹ Downloading VFrame...
✓ VFrame structure copied
ℹ Initializing new Git repository...
✓ New Git repository initialized
ℹ Creating initial commit...
✓ Initial commit created

✓ 🎉 Project 'my-awesome-project' has been set up successfully!

Do you want to create a GitHub repository now? (yes/no): yes

Should the repository be private? (yes/no) [yes]: yes
Repository description (optional): My awesome VFrame project

ℹ Creating GitHub repository...
✓ Repository created and code pushed!
ℹ View your repo: https://github.com/yourusername/my-awesome-project

✓ All done! Happy coding! 🚀
```

## Manual GitHub Setup

If you skip automatic GitHub repo creation, you can set it up manually later:

```bash
# Create repo on GitHub web interface, then:
cd your-project-name
git remote add origin git@github.com:yourusername/your-project-name.git
git push -u origin main
```

## Project Structure

After setup, your project will have:

```
your-project-name/
├── .agent/
│   ├── rules/           # AI agent rules and protocols
│   ├── skills/          # Specialized skills (50+ skills)
│   ├── sub-agents/      # Sub-agent definitions
│   └── workflows/       # Workflow templates
├── ai/
│   ├── approvals/       # Approval tracking
│   ├── blueprints/      # Architecture blueprints
│   ├── completed/       # Completed tasks log
│   ├── logs/           # Development logs
│   ├── specs/          # Project specifications
│   └── tasks/          # Task queue
├── scripts/            # Project scripts
├── src/                # Source code
├── tests/              # Tests
├── .gitignore
├── GEMINI.md          # Gemini AI configuration
└── README.md          # Project README
```

## Troubleshooting

### SSH Authentication Issues

If you get authentication errors when creating the GitHub repo:

1. Ensure SSH keys are set up:
   ```bash
   ssh -T git@github.com
   ```

2. If not set up, follow: [GitHub SSH Setup Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

### GitHub CLI Not Authenticated

If GitHub CLI is installed but not authenticated:

```bash
gh auth login
```

Follow the prompts to authenticate with your GitHub account.

### Directory Already Exists

If you get "Directory already exists" error, you can:
- Choose a different project name
- Remove the existing directory: `rm -rf project-name`
- When prompted, type `yes` to remove and continue

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

MIT License - feel free to use this installer for any purpose.

## Related

- [VFrame Repository](https://github.com/yashyadav711/VFrame) - The main VFrame framework
- [GitHub CLI](https://cli.github.com/) - GitHub's official command-line tool
- [Git Documentation](https://git-scm.com/doc)

---

Made with ❤️ for the VFrame community
