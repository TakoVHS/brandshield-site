.PHONY: help install build serve test clean rebuild deploy lint docs

# Variables
JEKYLL_DIR=docs
RUBY_VERSION=3.0
DOMAIN=brandshield.dev
REPO_URL=https://github.com/TakoVHS/brandshield-site

# Colors for output
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)═════════════════════════════════════════$(NC)"
	@echo "$(BLUE)  Brandshield Site - Makefile Commands  $(NC)"
	@echo "$(BLUE)═════════════════════════════════════════$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BLUE)Examples:$(NC)"
	@echo "  make install     # Install dependencies"
	@echo "  make build       # Build site for production"
	@echo "  make serve       # Start local development server"
	@echo "  make test        # Run all tests"
	@echo "  make deploy      # Deploy to GitHub Pages"
	@echo ""

# Development
install: ## Install dependencies
	@echo "$(YELLOW)Installing dependencies...$(NC)"
	@cd $(JEKYLL_DIR) && bundle install
	@echo "$(GREEN)✅ Dependencies installed$(NC)"

update: ## Update Ruby gems
	@echo "$(YELLOW)Updating gems...$(NC)"
	@cd $(JEKYLL_DIR) && bundle update
	@echo "$(GREEN)✅ Gems updated$(NC)"

serve: install ## Start development server (http://localhost:4000)
	@echo "$(YELLOW)🚀 Starting server at http://localhost:4000$(NC)"
	@echo "$(YELLOW)Press Ctrl+C to stop$(NC)"
	@cd $(JEKYLL_DIR) && bundle exec jekyll serve --baseurl ""

serve-drafts: install ## Start server with draft posts
	@echo "$(YELLOW)🚀 Starting server with drafts...$(NC)"
	@cd $(JEKYLL_DIR) && bundle exec jekyll serve --baseurl "" --drafts

build: install ## Build site for production
	@echo "$(YELLOW)Building site for production...$(NC)"
	@cd $(JEKYLL_DIR) && JEKYLL_ENV=production bundle exec jekyll build --verbose
	@echo "$(GREEN)✅ Site built: $(JEKYLL_DIR)/_site$(NC)"

# Testing
test: ## Run all tests (test.sh)
	@bash test.sh all

test-html: build ## Validate HTML
	@bash test.sh validate

test-links: build ## Check for broken links
	@bash test.sh links

test-seo: build ## Check SEO
	@bash test.sh seo

test-perf: build ## Check performance
	@bash test.sh perf

lint-config: ## Validate Jekyll config
	@echo "$(YELLOW)Validating Jekyll config...$(NC)"
	@cd $(JEKYLL_DIR) && bundle exec jekyll build --config _config.yml --dry-run
	@echo "$(GREEN)✅ Config valid$(NC)"

# Cleanup
clean: ## Remove generated files
	@echo "$(YELLOW)Cleaning up...$(NC)"
	@rm -rf $(JEKYLL_DIR)/_site $(JEKYLL_DIR)/.jekyll-cache
	@echo "$(GREEN)✅ Cleaned$(NC)"

rebuild: clean build ## Clean and rebuild

# Git operations
status: ## Show git status
	@git status

log: ## Show recent commits
	@git log --oneline -10

add: ## Stage all changes
	@git add .
	@echo "$(GREEN)✅ Changes staged$(NC)"

commit: add ## Commit with message (usage: make commit MSG="message")
	@git commit -m "$(MSG)" || echo "$(RED)No changes to commit$(NC)"

push: ## Push to GitHub
	@echo "$(YELLOW)Pushing to GitHub...$(NC)"
	@git push origin main
	@echo "$(GREEN)✅ Pushed$(NC)"

deploy: build push ## Deploy: build + push
	@echo "$(GREEN)✅ Deployment initiated!$(NC)"
	@echo "   Check: $(REPO_URL)/actions"
	@echo "   Site: https://$(DOMAIN)"

# Utility commands
info: ## Show project info
	@echo "$(BLUE)Project Information$(NC)"
	@echo "  Domain: $(DOMAIN)"
	@echo "  Repo: $(REPO_URL)"
	@echo "  Jekyll: $(JEKYLL_DIR)"
	@echo "  Ruby: $(RUBY_VERSION)+"
	@echo ""
	@echo "$(BLUE)Current Status:$(NC)"
	@git status --short || echo "  (no changes)"

check-ruby: ## Check Ruby version
	@echo "$(YELLOW)Ruby version:$(NC)"
	@ruby -v

check-bundle: ## Check bundler version
	@echo "$(YELLOW)Bundler version:$(NC)"
	@bundle --version

check-jekyll: ## Check Jekyll version
	@echo "$(YELLOW)Jekyll version:$(NC)"
	@cd $(JEKYLL_DIR) && bundle exec jekyll --version

check-all: check-ruby check-bundle check-jekyll ## Check all versions

# Documentation
docs: ## Generate documentation
	@echo "$(YELLOW)Documentation files:$(NC)"
	@ls -lh *.md
	@echo ""
	@echo "Key files:"
	@echo "  $(GREEN)README.md$(NC)                  - Project overview"
	@echo "  $(GREEN)DEVELOPMENT.md$(NC)             - Development setup"
	@echo "  $(GREEN)DEPLOYMENT.md$(NC)              - Deployment guide"
	@echo "  $(GREEN)ANALYTICS_SETUP.md$(NC)         - Google Analytics"
	@echo "  $(GREEN)SEO.md$(NC)                     - SEO optimization"
	@echo "  $(GREEN)CHANGELOG.md$(NC)               - Version history"
	@echo "  $(GREEN)docs/roadmap.md$(NC)            - Product roadmap"

# Advanced
shell: ## Open Jekyll shell
	@cd $(JEKYLL_DIR) && bundle exec jekyll shell

console: ## Ruby console
	@cd $(JEKYLL_DIR) && bundle console

doctor: ## Run Jekyll doctor (diagnose issues)
	@echo "$(YELLOW)Running Jekyll doctor...$(NC)"
	@cd $(JEKYLL_DIR) && bundle exec jekyll doctor

# Docker commands
docker-build: ## Build Docker image
	@echo "$(YELLOW)Building Docker image...$(NC)"
	@docker build -t brandshield-site:latest .
	@echo "$(GREEN)✅ Built$(NC)"

docker-run: ## Run Docker container
	@echo "$(YELLOW)Running Docker container...$(NC)"
	@docker run -p 4000:4000 -v $(PWD):/app brandshield-site:latest

docker-clean: ## Remove Docker images
	@docker rmi brandshield-site:latest 2>/dev/null || true
	@echo "$(GREEN)✅ Docker images cleaned$(NC)"

# Monitoring
watch: ## Watch for file changes
	@echo "$(YELLOW)Watching for changes...$(NC)"
	@cd $(JEKYLL_DIR) && bundle exec jekyll build --watch

monitor: ## Monitor server and show logs
	@echo "$(YELLOW)Monitoring...$(NC)"
	@echo "  Run: tail -f $(JEKYLL_DIR)/_site/error.log"

# Performance
analyze: build ## Analyze site performance
	@echo "$(YELLOW)Site Statistics:$(NC)"
	@du -sh $(JEKYLL_DIR)/_site/
	@echo ""
	@echo "File counts:"
	@find $(JEKYLL_DIR)/_site -type f | wc -l
	@echo ""
	@echo "By extension:"
	@find $(JEKYLL_DIR)/_site -type f | sed 's/.*\.//' | sort | uniq -c

# CI/CD
validate-ci: ## Validate GitHub Actions workflow
	@echo "$(YELLOW)Validating CI/CD workflow...$(NC)"
	@if [ -f .github/workflows/build.yml ]; then \
		echo "$(GREEN)✅ Workflow found$(NC)"; \
	else \
		echo "$(RED)❌ Workflow not found$(NC)"; \
	fi

# New content
new-post: ## Create new blog post (usage: make new-post TITLE="My Post Title")
	@echo "$(YELLOW)Creating new post: $(TITLE)$(NC)"
	@FILENAME=$$(echo "$(TITLE)" | tr ' ' '-' | tr '[:upper:]' '[:lower:]'); \
	FILEPATH="$(JEKYLL_DIR)/_posts/$$(date +%Y-%m-%d)-$$FILENAME.md"; \
	echo "---" > $$FILEPATH; \
	echo "layout: page" >> $$FILEPATH; \
	echo "title: \"$(TITLE)\"" >> $$FILEPATH; \
	echo "date: $$(date +%Y-%m-%d)" >> $$FILEPATH; \
	echo "author: TakoVHS" >> $$FILEPATH; \
	echo "categories: []" >> $$FILEPATH; \
	echo "tags: []" >> $$FILEPATH; \
	echo "excerpt: \"\"" >> $$FILEPATH; \
	echo "---" >> $$FILEPATH; \
	echo "" >> $$FILEPATH; \
	echo "# $(TITLE)" >> $$FILEPATH; \
	echo "" >> $$FILEPATH; \
	echo "Your content here..." >> $$FILEPATH; \
	echo "$(GREEN)✅ Post created: $$FILEPATH$(NC)"

# Development workflow
dev: ## Development workflow: install -> serve
	@make install
	@make serve

test-and-push: ## Test -> commit -> push
	@make test
	@read -p "Commit message: " MSG; \
	git add .; \
	git commit -m "$$MSG" || true; \
	git push origin main

# Help categories
help-dev: ## Show development commands
	@echo "$(BLUE)Development Commands:$(NC)"
	@echo "  make install      - Install dependencies"
	@echo "  make serve        - Start local server"
	@echo "  make build        - Build for production"
	@echo "  make test         - Run all tests"

help-git: ## Show git commands
	@echo "$(BLUE)Git Commands:$(NC)"
	@echo "  make status       - Show git status"
	@echo "  make commit       - Commit changes"
	@echo "  make push         - Push to GitHub"
	@echo "  make deploy       - Deploy to production"

help-docker: ## Show Docker commands
	@echo "$(BLUE)Docker Commands:$(NC)"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-run   - Run Docker container"
	@echo "  make docker-clean - Remove Docker images"

# Default target
.DEFAULT_GOAL := help
