# Brandshield — Brand Abuse Early Warning

> Defensive-only brand protection: CT signals → explainable risk alerts → takedown-ready audit packs

![GitHub Pages Status](https://github.com/TakoVHS/brandshield-site/actions/workflows/pages.yml/badge.svg)

## 🚀 Live Site

**[https://takovhs.github.io/brandshield-site/](https://takovhs.github.io/brandshield-site/)**

---

## 📋 What's Inside

- **Audit Pack** — 72-hour reconnaissance + takedown packet (IR/SOC format)
- **Snapshot** — Quick exposure assessment for your brand
- **Radar** — Continuous domain monitoring
- **Compliance** — Data source documentation & methodology

---

## 🛠 Local Development

### Prerequisites
- Ruby 2.7+ (for Jekyll)
- Bundler

### Setup

```bash
# Clone repository
git clone https://github.com/TakoVHS/brandshield-site.git
cd brandshield-site

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve --baseurl ""
# Visit http://localhost:4000
```

### Edit content
- **Homepage**: `docs/index.md`
- **Config**: `docs/_config.yml`
- **Layout**: `docs/_layouts/page.html`
- **Styles**: `docs/assets/style.css`

---

## 📊 Google Analytics

To enable analytics tracking:

1. Create property in [Google Analytics](https://analytics.google.com)
2. Get your Measurement ID (format: `G-XXXXXXXXXX`)
3. Update `docs/_config.yml`:
   ```yaml
   google_analytics:
     id: "G-YOUR-ID-HERE"
   ```

---

## 📋 SEO & Meta

- ✅ OpenGraph tags (social sharing)
- ✅ Twitter Card support
- ✅ Canonical URLs (prevents duplicate content)
- ✅ Sitemap auto-generation (`/sitemap.xml`)
- ✅ RSS feed (`/feed.xml`)
- ✅ robots.txt configured

---

## 🔧 Update CTA Links

In `docs/_config.yml`:

```yaml
brandshield:
  cta_primary_url: "https://cal.com/your-handle/meeting"
  cta_secondary_url: "https://tally.so/r/your-form"
```

---

## 🚀 Deployment

GitHub Pages deploys automatically when you push to `main`:

```bash
git add .
git commit -m "Update content"
git push origin main
```

**Build status**: [Actions tab](https://github.com/TakoVHS/brandshield-site/actions)

---

## 📝 License

Brandshield brand protection methodology © TakoVHS. 

---

## 📧 Contact

- **Email**: contact@takovhs.dev
- **GitHub**: [TakoVHS](https://github.com/TakoVHS)
