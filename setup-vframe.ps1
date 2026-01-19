# VFrame Setup Script for Windows PowerShell
# Cross-platform installer for VFrame projects

# Error handling
$ErrorActionPreference = "Stop"

function Write-ColorOutput($ForegroundColor, $Message) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Output $Message
    $host.UI.RawUI.ForegroundColor = $fc
}

function Print-Info($Message) {
    Write-ColorOutput Cyan "ℹ $Message"
}

function Print-Success($Message) {
    Write-ColorOutput Green "✓ $Message"
}

function Print-Warning($Message) {
    Write-ColorOutput Yellow "⚠ $Message"
}

function Print-Error($Message) {
    Write-ColorOutput Red "✗ $Message"
}

# Main setup function
function Main {
    Write-Output ""
    Write-Output "╔════════════════════════════════════════╗"
    Write-Output "║     VFrame Project Setup Script       ║"
    Write-Output "╚════════════════════════════════════════╝"
    Write-Output ""

    # Check for Git
    Print-Info "Checking prerequisites..."
    
    try {
        $null = Get-Command git -ErrorAction Stop
        Print-Success "Git is installed"
    }
    catch {
        Print-Error "Git is not installed. Please install Git first."
        exit 1
    }

    try {
        $null = Get-Command gh -ErrorAction Stop
        Print-Success "GitHub CLI is installed"
    }
    catch {
        Print-Warning "GitHub CLI (gh) is not installed."
        Print-Info "You'll need it to create remote repositories automatically."
        Print-Info "Install from: https://cli.github.com/"
        Print-Info "You can still continue without it (manual GitHub setup later)."
        Write-Output ""
    }

    # Ask for project name
    Write-Output ""
    $PROJECT_NAME = Read-Host "Enter your project name"

    # Validate project name
    if ([string]::IsNullOrWhiteSpace($PROJECT_NAME)) {
        Print-Error "Project name cannot be empty!"
        exit 1
    }

    # Check if directory already exists
    if (Test-Path $PROJECT_NAME) {
        Print-Error "Directory '$PROJECT_NAME' already exists!"
        $CONFIRM = Read-Host "Do you want to remove it and continue? (yes/no)"
        if ($CONFIRM -ne "yes") {
            Print-Warning "Setup cancelled."
            exit 0
        }
        Remove-Item -Path $PROJECT_NAME -Recurse -Force
    }

    # Create project directory
    Print-Info "Creating project directory: $PROJECT_NAME"
    New-Item -ItemType Directory -Path $PROJECT_NAME | Out-Null
    Set-Location $PROJECT_NAME
    Print-Success "Project directory created"

    # Clone VFrame (without git history)
    Print-Info "Downloading VFrame..."
    git clone --depth 1 git@github.com:yashyadav711/VFrame.git temp_vframe
    
    # Move contents and remove git history
    Print-Info "Setting up VFrame structure..."
    Get-ChildItem -Path "temp_vframe" -Force | Move-Item -Destination . -Force
    Remove-Item -Path "temp_vframe" -Recurse -Force
    Remove-Item -Path ".git" -Recurse -Force
    Print-Success "VFrame structure copied"

    # Initialize new git repository
    Print-Info "Initializing new Git repository..."
    git init
    git branch -m main
    Print-Success "New Git repository initialized"

    # Create initial commit
    Print-Info "Creating initial commit..."
    git add .
    git commit -m "Initial commit: $PROJECT_NAME based on VFrame"
    Print-Success "Initial commit created"

    Write-Output ""
    Print-Success "🎉 Project '$PROJECT_NAME' has been set up successfully!"
    Write-Output ""

    # Ask if user wants to create GitHub repo
    $CREATE_REPO = Read-Host "Do you want to create a GitHub repository now? (yes/no)"

    if ($CREATE_REPO -eq "yes" -or $CREATE_REPO -eq "y") {
        # Check if GitHub CLI is installed
        try {
            $null = Get-Command gh -ErrorAction Stop
        }
        catch {
            Print-Warning "GitHub CLI (gh) is not installed."
            Print-Info "Install it from: https://cli.github.com/"
            Print-Info ""
            Print-Info "Manual setup instructions:"
            Write-Output "  1. Create repo on GitHub: https://github.com/new"
            Write-Output "  2. git remote add origin git@github.com:yourusername/$PROJECT_NAME.git"
            Write-Output "  3. git push -u origin main"
            return
        }

        # Check if authenticated
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Print-Warning "You're not authenticated with GitHub CLI."
            Print-Info "Authenticating now..."
            gh auth login
        }

        # Ask for repository visibility
        Write-Output ""
        $IS_PRIVATE = Read-Host "Should the repository be private? (yes/no) [yes]"
        if ([string]::IsNullOrWhiteSpace($IS_PRIVATE)) {
            $IS_PRIVATE = "yes"
        }

        $VISIBILITY_FLAG = "--public"
        if ($IS_PRIVATE -eq "yes" -or $IS_PRIVATE -eq "y") {
            $VISIBILITY_FLAG = "--private"
        }

        # Ask for description
        $REPO_DESC = Read-Host "Repository description (optional)"

        # Create the repository
        Print-Info "Creating GitHub repository..."
        
        if (-not [string]::IsNullOrWhiteSpace($REPO_DESC)) {
            gh repo create $PROJECT_NAME $VISIBILITY_FLAG --source=. --remote=origin --push --description "$REPO_DESC"
        }
        else {
            gh repo create $PROJECT_NAME $VISIBILITY_FLAG --source=. --remote=origin --push
        }

        if ($LASTEXITCODE -eq 0) {
            Print-Success "Repository created and code pushed!"
            $username = gh api user -q .login
            Print-Info "View your repo: https://github.com/$username/$PROJECT_NAME"
        }
        else {
            Print-Error "Failed to create repository."
            Print-Info "You can create it manually later."
        }
    }
    else {
        Print-Info "Skipping GitHub repository creation."
        Print-Info ""
        Print-Info "To create it later:"
        Write-Output "  1. cd $PROJECT_NAME"
        Write-Output "  2. gh repo create $PROJECT_NAME --private --source=. --remote=origin --push"
        Write-Output ""
        Write-Output "  Or manually:"
        Write-Output "  1. Create repo on GitHub: https://github.com/new"
        Write-Output "  2. git remote add origin git@github.com:yourusername/$PROJECT_NAME.git"
        Write-Output "  3. git push -u origin main"
    }

    Write-Output ""
    Print-Success "All done! Happy coding! 🚀"
    Write-Output ""
}

# Run main function
try {
    Main
}
catch {
    Print-Error "An error occurred: $_"
    exit 1
}
