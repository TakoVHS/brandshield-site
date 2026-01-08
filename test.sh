#!/bin/bash
# 🧪 Brandshield Site Testing & Validation Script
# Usage: bash test.sh [command]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directory checks
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$PROJECT_DIR/docs"
SITE_DIR="$DOCS_DIR/_site"

echo -e "${BLUE}🔍 Brandshield Site Test Suite${NC}"
echo "========================================"

# Function: Check Ruby/Ruby installation
check_ruby() {
    echo -e "${YELLOW}1️⃣ Checking Ruby environment...${NC}"
    
    if ! command -v ruby &> /dev/null; then
        echo -e "${RED}❌ Ruby not found. Install Ruby 3.0+${NC}"
        exit 1
    fi
    
    RUBY_VERSION=$(ruby -v)
    echo -e "${GREEN}✅ $RUBY_VERSION${NC}"
    
    if ! command -v bundle &> /dev/null; then
        echo -e "${YELLOW}⚠️  Bundler not found. Installing...${NC}"
        gem install bundler
    fi
    echo -e "${GREEN}✅ Bundler ready${NC}"
}

# Function: Install dependencies
install_deps() {
    echo -e "${YELLOW}2️⃣ Installing dependencies...${NC}"
    cd "$DOCS_DIR"
    bundle install
    cd "$PROJECT_DIR"
    echo -e "${GREEN}✅ Dependencies installed${NC}"
}

# Function: Build site
build_site() {
    echo -e "${YELLOW}3️⃣ Building Jekyll site...${NC}"
    cd "$DOCS_DIR"
    JEKYLL_ENV=production bundle exec jekyll build
    cd "$PROJECT_DIR"
    echo -e "${GREEN}✅ Site built successfully${NC}"
    echo "  Output: $SITE_DIR"
}

# Function: Serve locally
serve_local() {
    echo -e "${YELLOW}4️⃣ Starting local server...${NC}"
    cd "$DOCS_DIR"
    echo -e "${BLUE}🌐 Server running at http://localhost:4000${NC}"
    echo -e "${BLUE}📝 Press Ctrl+C to stop${NC}"
    bundle exec jekyll serve --baseurl ""
}

# Function: Validate HTML
validate_html() {
    echo -e "${YELLOW}5️⃣ Validating HTML files...${NC}"
    
    if [ ! -d "$SITE_DIR" ]; then
        echo -e "${RED}❌ Site not built. Run: bash test.sh build${NC}"
        exit 1
    fi
    
    HTML_FILES=$(find "$SITE_DIR" -name "*.html" | wc -l)
    echo "   Found $HTML_FILES HTML files"
    
    # Basic validation: check for common issues
    ISSUES=0
    
    while IFS= read -r file; do
        # Check for unclosed tags
        if grep -q '<div[^>]*>[^<]*</span>' "$file"; then
            echo -e "${YELLOW}⚠️  Potential unclosed div in: $file${NC}"
            ((ISSUES++))
        fi
        
        # Check for broken metadata
        if ! grep -q '<meta charset' "$file" && ! grep -q '<!DOCTYPE html>' "$file"; then
            echo -e "${YELLOW}⚠️  Missing doctype in: $file${NC}"
            ((ISSUES++))
        fi
    done < <(find "$SITE_DIR" -name "*.html")
    
    if [ $ISSUES -eq 0 ]; then
        echo -e "${GREEN}✅ HTML validation passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $ISSUES potential issues${NC}"
    fi
}

# Function: Check for broken links (simple)
check_links() {
    echo -e "${YELLOW}6️⃣ Checking for broken links (basic)...${NC}"
    
    if [ ! -d "$SITE_DIR" ]; then
        echo -e "${RED}❌ Site not built. Run: bash test.sh build${NC}"
        exit 1
    fi
    
    BROKEN=0
    
    # Extract all href and src attributes
    grep -rho '\(href\|src\)="[^"]*"' "$SITE_DIR" | sed 's/.*="\([^"]*\)"/\1/' | sort | uniq | while read url; do
        # Skip external URLs and anchors
        if [[ $url == http* ]] || [[ $url == \#* ]]; then
            continue
        fi
        
        # Check if local file exists
        if [[ ! "$url" =~ ^/ ]] && [ ! -f "$SITE_DIR/$url" ]; then
            # Could be a directory index
            if [ ! -f "$SITE_DIR${url}/index.html" ] && [ ! -f "$SITE_DIR$url/index.html" ]; then
                echo -e "${RED}❌ Broken link: $url${NC}"
                ((BROKEN++))
            fi
        fi
    done
    
    if [ $BROKEN -eq 0 ]; then
        echo -e "${GREEN}✅ No obvious broken links found${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $BROKEN potentially broken links${NC}"
    fi
}

# Function: Check SEO basics
check_seo() {
    echo -e "${YELLOW}7️⃣ Checking SEO basics...${NC}"
    
    if [ ! -d "$SITE_DIR" ]; then
        echo -e "${RED}❌ Site not built. Run: bash test.sh build${NC}"
        exit 1
    fi
    
    MISSING_SEO=0
    
    # Check index.html
    INDEX_FILE="$SITE_DIR/index.html"
    
    if ! grep -q '<meta.*description' "$INDEX_FILE"; then
        echo -e "${YELLOW}⚠️  Missing meta description in index${NC}"
        ((MISSING_SEO++))
    fi
    
    if ! grep -q '<meta.*og:' "$INDEX_FILE"; then
        echo -e "${YELLOW}⚠️  Missing Open Graph tags${NC}"
        ((MISSING_SEO++))
    fi
    
    if ! grep -q '<title' "$INDEX_FILE"; then
        echo -e "${YELLOW}⚠️  Missing title tag${NC}"
        ((MISSING_SEO++))
    fi
    
    if ! grep -q 'schema.org\|JSON-LD' "$SITE_DIR"/*.html 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Missing structured data (JSON-LD)${NC}"
        ((MISSING_SEO++))
    fi
    
    # Check sitemap
    if [ ! -f "$SITE_DIR/sitemap.xml" ]; then
        echo -e "${YELLOW}⚠️  Missing sitemap.xml${NC}"
        ((MISSING_SEO++))
    else
        echo -e "${GREEN}✅ sitemap.xml found${NC}"
    fi
    
    # Check robots.txt
    if [ ! -f "$SITE_DIR/robots.txt" ]; then
        echo -e "${YELLOW}⚠️  Missing robots.txt${NC}"
        ((MISSING_SEO++))
    else
        echo -e "${GREEN}✅ robots.txt found${NC}"
    fi
    
    if [ $MISSING_SEO -eq 0 ]; then
        echo -e "${GREEN}✅ SEO basics look good${NC}"
    else
        echo -e "${YELLOW}⚠️  Found $MISSING_SEO SEO issues${NC}"
    fi
}

# Function: Performance check
check_performance() {
    echo -e "${YELLOW}8️⃣ Checking performance...${NC}"
    
    if [ ! -d "$SITE_DIR" ]; then
        echo -e "${RED}❌ Site not built. Run: bash test.sh build${NC}"
        exit 1
    fi
    
    # Calculate site size
    TOTAL_SIZE=$(du -sh "$SITE_DIR" | cut -f1)
    FILE_COUNT=$(find "$SITE_DIR" -type f | wc -l)
    
    echo -e "${BLUE}📊 Site Statistics:${NC}"
    echo "   Total size: $TOTAL_SIZE"
    echo "   Total files: $FILE_COUNT"
    
    # Check for unminified files
    UNMINIFIED=$(find "$SITE_DIR" -name "*.js" -o -name "*.css" | wc -l)
    if [ $UNMINIFIED -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Found $UNMINIFIED JS/CSS files (consider minification)${NC}"
    fi
    
    # Check image optimization
    IMAGES=$(find "$SITE_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | wc -l)
    echo "   Images: $IMAGES files"
    
    echo -e "${GREEN}✅ Performance check complete${NC}"
}

# Function: Run all tests
run_all() {
    check_ruby
    echo ""
    install_deps
    echo ""
    build_site
    echo ""
    validate_html
    echo ""
    check_links
    echo ""
    check_seo
    echo ""
    check_performance
    
    echo ""
    echo -e "${GREEN}========================================"
    echo "✅ All tests completed!${NC}"
    echo -e "${BLUE}Next: bash test.sh serve${NC}"
}

# Main menu
case "${1:-all}" in
    check-ruby)
        check_ruby
        ;;
    install)
        install_deps
        ;;
    build)
        check_ruby
        install_deps
        build_site
        ;;
    serve)
        check_ruby
        serve_local
        ;;
    validate)
        validate_html
        ;;
    links)
        check_links
        ;;
    seo)
        check_seo
        ;;
    perf|performance)
        check_performance
        ;;
    all|test)
        run_all
        ;;
    clean)
        echo -e "${YELLOW}Cleaning up...${NC}"
        rm -rf "$SITE_DIR" "$DOCS_DIR/.jekyll-cache"
        echo -e "${GREEN}✅ Clean complete${NC}"
        ;;
    rebuild)
        echo -e "${YELLOW}Rebuilding...${NC}"
        bash "$0" clean
        bash "$0" build
        ;;
    *)
        echo "📖 Usage: bash test.sh [command]"
        echo ""
        echo "Commands:"
        echo "  check-ruby    Check Ruby installation"
        echo "  install       Install dependencies"
        echo "  build         Build site"
        echo "  serve         Serve locally (http://localhost:4000)"
        echo "  validate      Validate HTML"
        echo "  links         Check for broken links"
        echo "  seo           Check SEO basics"
        echo "  perf          Check performance"
        echo "  all (default) Run all tests"
        echo "  clean         Remove generated files"
        echo "  rebuild       Clean and rebuild"
        echo ""
        echo "Examples:"
        echo "  bash test.sh build       # Build site once"
        echo "  bash test.sh serve       # Serve locally with live reload"
        echo "  bash test.sh all         # Run all checks"
        exit 0
        ;;
esac
