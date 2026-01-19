#!/usr/bin/env bash

# VFrame Setup Script
# Cross-platform installer for VFrame projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup function
main() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║     VFrame Project Setup Script       ║"
    echo "╔════════════════════════════════════════╗"
    echo ""

    # Check for required tools
    print_info "Checking prerequisites..."
    
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    print_success "Git is installed"

    if ! command_exists gh; then
        print_warning "GitHub CLI (gh) is not installed."
        print_info "You'll need it to create remote repositories automatically."
        print_info "Install from: https://cli.github.com/"
        print_info "You can still continue without it (manual GitHub setup later)."
        echo ""
    else
        print_success "GitHub CLI is installed"
    fi

    # Ask for project name
    echo ""
    read -p "Enter your project name: " PROJECT_NAME

    # Validate project name
    if [ -z "$PROJECT_NAME" ]; then
        print_error "Project name cannot be empty!"
        exit 1
    fi

    # Check if directory already exists
    if [ -d "$PROJECT_NAME" ]; then
        print_error "Directory '$PROJECT_NAME' already exists!"
        read -p "Do you want to remove it and continue? (yes/no): " CONFIRM
        if [ "$CONFIRM" != "yes" ]; then
            print_warning "Setup cancelled."
            exit 0
        fi
        rm -rf "$PROJECT_NAME"
    fi

    # Create project directory
    print_info "Creating project directory: $PROJECT_NAME"
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    print_success "Project directory created"

    # Clone VFrame (without git history)
    print_info "Downloading VFrame..."
    git clone --depth 1 git@github.com:yashyadav711/VFrame.git temp_vframe
    
    # Move contents and remove git history
    print_info "Setting up VFrame structure..."
    mv temp_vframe/* temp_vframe/.* . 2>/dev/null || true
    rm -rf temp_vframe
    rm -rf .git
    print_success "VFrame structure copied"

    # Initialize new git repository
    print_info "Initializing new Git repository..."
    git init
    git branch -m main
    print_success "New Git repository initialized"

    # Create initial commit
    print_info "Creating initial commit..."
    git add .
    git commit -m "Initial commit: $PROJECT_NAME based on VFrame"
    print_success "Initial commit created"

    # Update README with project name
    if [ -f "README.md" ]; then
        sed -i.bak "s/VFrame/$PROJECT_NAME/g" README.md 2>/dev/null || \
        sed -i '' "s/VFrame/$PROJECT_NAME/g" README.md 2>/dev/null || true
        rm -f README.md.bak
    fi

    echo ""
    print_success "🎉 Project '$PROJECT_NAME' has been set up successfully!"
    echo ""

    # Ask if user wants to create GitHub repo
    read -p "Do you want to create a GitHub repository now? (yes/no): " CREATE_REPO

    if [ "$CREATE_REPO" = "yes" ] || [ "$CREATE_REPO" = "y" ]; then
        # Check if GitHub CLI is installed
        if ! command_exists gh; then
            print_warning "GitHub CLI (gh) is not installed."
            print_info "Install it from: https://cli.github.com/"
            print_info ""
            print_info "Manual setup instructions:"
            echo "  1. Create repo on GitHub: https://github.com/new"
            echo "  2. git remote add origin git@github.com:yourusername/$PROJECT_NAME.git"
            echo "  3. git push -u origin main"
        else
            # Check if authenticated
            if ! gh auth status >/dev/null 2>&1; then
                print_warning "You're not authenticated with GitHub CLI."
                print_info "Authenticating now..."
                gh auth login
            fi

            # Ask for repository visibility
            echo ""
            read -p "Should the repository be private? (yes/no) [yes]: " IS_PRIVATE
            IS_PRIVATE=${IS_PRIVATE:-yes}

            VISIBILITY_FLAG="--public"
            if [ "$IS_PRIVATE" = "yes" ] || [ "$IS_PRIVATE" = "y" ]; then
                VISIBILITY_FLAG="--private"
            fi

            # Ask for description
            read -p "Repository description (optional): " REPO_DESC

            # Create the repository
            print_info "Creating GitHub repository..."
            
            if [ -n "$REPO_DESC" ]; then
                gh repo create "$PROJECT_NAME" $VISIBILITY_FLAG --source=. --remote=origin --push --description "$REPO_DESC"
            else
                gh repo create "$PROJECT_NAME" $VISIBILITY_FLAG --source=. --remote=origin --push
            fi

            if [ $? -eq 0 ]; then
                print_success "Repository created and code pushed!"
                print_info "View your repo: https://github.com/$(gh api user -q .login)/$PROJECT_NAME"
            else
                print_error "Failed to create repository."
                print_info "You can create it manually later."
            fi
        fi
    else
        print_info "Skipping GitHub repository creation."
        print_info ""
        print_info "To create it later:"
        echo "  1. cd $PROJECT_NAME"
        echo "  2. gh repo create $PROJECT_NAME --private --source=. --remote=origin --push"
        echo ""
        echo "  Or manually:"
        echo "  1. Create repo on GitHub: https://github.com/new"
        echo "  2. git remote add origin git@github.com:yourusername/$PROJECT_NAME.git"
        echo "  3. git push -u origin main"
    fi

    echo ""
    print_success "All done! Happy coding! 🚀"
    echo ""
}

# Run main function
main
