# 📚 Brandshield Development Guide

## Структура проекта

```
brandshield-site/
├── docs/
│   ├── _layouts/        # Jekyll layouts
│   ├── _posts/          # Blog posts
│   ├── assets/          # CSS, JS, images
│   ├── _config.yml      # Jekyll config
│   ├── index.md         # Home page
│   ├── contact.md       # Contact page
│   ├── blog.md          # Blog page
│   └── [other-pages]    # Other pages
├── .github/workflows/   # GitHub Actions CI/CD
├── CNAME               # Domain configuration
├── README.md           # Project README
└── DEPLOYMENT.md       # Deployment guide
```

## 🚀 Local Development

### Prerequisites
```bash
ruby -v  # 3.0+
bundle --version
```

### Setup

```bash
# Install dependencies
bundle install

# Serve locally (no baseurl for development)
bundle exec jekyll serve --baseurl ""

# Visit http://localhost:4000
```

### Development modes

```bash
# Development (with drafts)
bundle exec jekyll serve --drafts

# Production (optimized)
JEKYLL_ENV=production bundle exec jekyll build
```

## 📝 Adding Content

### New Blog Post

```bash
# Create new post
cat > docs/_posts/$(date +%Y-%m-%d)-my-post.md << 'EOF'
---
layout: page
title: "My Post Title"
description: "Short description"
date: 2025-01-08
author: TakoVHS
categories: [category1, category2]
tags: [tag1, tag2]
excerpt: "This shows on the blog index"
---

# Content starts here
EOF
```

### New Page

```bash
# Create new page in docs/
cat > docs/my-page.md << 'EOF'
---
layout: page
title: "My Page"
description: "Page description"
permalink: /my-page
---

# Content here
EOF
```

## 🎨 Customization

### Update Colors

Edit `docs/assets/style.css` CSS variables:
```css
:root {
  --bg: #0b0d12;           /* Background */
  --text: #e9eef8;         /* Text color */
  --accent: #7c5cff;       /* Primary accent */
  --accent2: #33d6ff;      /* Secondary accent */
}
```

### Update Config

Edit `docs/_config.yml`:
```yaml
brandshield:
  cta_primary_url: "https://your-cal-link"
  cta_secondary_url: "https://your-form-link"
  contact_email: "your-email@domain.com"
```

## 📊 Analytics

### Add Google Analytics

1. Create property at [Google Analytics](https://analytics.google.com)
2. Get Measurement ID (format: `G-XXXXXXXXXX`)
3. Update `docs/_config.yml`:
```yaml
google_analytics:
  id: "G-YOUR-MEASUREMENT-ID"
```

## 🔒 Security

### Headers Configuration

All security headers configured in `_headers` file:
- CSP (Content Security Policy)
- HSTS (HTTP Strict Transport Security)
- X-Frame-Options
- Referrer-Policy

### CI/CD Pipeline

GitHub Actions workflow in `.github/workflows/build.yml`:
- Automatically builds on push to main
- Runs link checks
- Deploys to GitHub Pages

## 🚀 Deployment

### GitHub Pages Setup

1. Push code to main branch
2. GitHub Actions automatically builds & deploys
3. Check GitHub Pages settings for status
4. Custom domain points to CNAME

### Domain Configuration

Currently configured for: **brandshield.dev**

Add DNS CNAME:
```
@ IN CNAME takovhs.github.io
```

## 📈 Performance

### Optimization Techniques

- ✅ Minified CSS (via Jekyll)
- ✅ Lazy loading images
- ✅ Preconnect external resources
- ✅ Prefetch critical pages
- ✅ Compression enabled
- ✅ SEO optimized

### Check Performance

```bash
# Build for production
JEKYLL_ENV=production bundle exec jekyll build

# Check output size
du -sh _site/

# Test locally
bundle exec jekyll serve --baseurl ""
# Then open http://localhost:4000 in browser
```

## 🐛 Troubleshooting

### Jekyll won't install
```bash
# Update gem system
gem update --system

# Use specific Ruby version (if using rbenv)
rbenv install 3.0.0
rbenv local 3.0.0
```

### Build fails
```bash
# Clear cache
rm -rf .jekyll-cache/ _site/

# Rebuild
bundle exec jekyll build --verbose
```

### DNS issues with custom domain
```bash
# Check DNS records
dig brandshield.dev
nslookup brandshield.dev

# Verify GitHub Pages IP
dig takovhs.github.io
```

## 🔗 Useful Links

- [Jekyll Docs](https://jekyllrb.com/docs/)
- [Jekyll Plugins](https://jekyllrb.com/docs/plugins/)
- [GitHub Pages Help](https://docs.github.com/en/pages)
- [Markdown Guide](https://www.markdownguide.org/)

## 📝 Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes
git add .
git commit -m "feat: describe your change"

# Push and create PR
git push origin feature/my-feature
```

## 💾 Environment Variables

For local development, create `.env` (not tracked by git):
```bash
GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX
CONTACT_EMAIL=your-email@domain.com
```

---

**Last updated**: 2025-01-08
**Maintained by**: TakoVHS
