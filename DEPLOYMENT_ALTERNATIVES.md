# 🚀 Alternative Deployment Options

## Netlify Deployment (Optional)

If you want to use Netlify instead of GitHub Pages, follow these steps:

### 1. Create netlify.toml

```toml
[build]
  base = "docs"
  command = "bundle exec jekyll build"
  publish = "docs/_site"

[build.environment]
  RUBY_VERSION = "3.0.0"
  JEKYLL_ENV = "production"

[context.production]
  command = "bundle exec jekyll build --config _config.yml"

[context.deploy-preview]
  command = "bundle exec jekyll build --config _config.yml,_config.dev.yml"

[[redirects]]
  from = "/*"
  to = "/404.html"
  status = 404

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "geolocation=(), microphone=(), camera=()"
    Strict-Transport-Security = "max-age=31536000; includeSubDomains; preload"
```

### 2. Create Netlify.com Account

1. Go to [Netlify](https://netlify.com)
2. Sign up with GitHub account
3. Authorize Netlify to access repositories

### 3. Deploy from GitHub

1. Click "New site from Git"
2. Select GitHub, then this repository
3. Configure:
   - **Base directory**: `docs`
   - **Build command**: `bundle exec jekyll build`
   - **Publish directory**: `docs/_site`
4. Click Deploy

### 4. Configure Custom Domain

1. In Netlify dashboard: **Domain settings**
2. Add custom domain: `brandshield.dev`
3. Update DNS at registrar:
   ```
   brandshield.dev  ALIAS  brandshield.netlify.app
   ```
4. Netlify auto-provisions Let's Encrypt SSL

## Docker Deployment (Self-hosted)

### Create Dockerfile

```dockerfile
FROM ruby:3.0-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy files
COPY docs/Gemfile docs/Gemfile.lock ./
RUN bundle install --frozen

COPY docs/ .

# Build site
ENV JEKYLL_ENV=production
RUN bundle exec jekyll build

# Serve with webrick
FROM ruby:3.0-slim
WORKDIR /app
COPY --from=0 /app/_site /var/www/html

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Create nginx.conf

```nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    gzip on;
    gzip_vary on;
    gzip_types text/plain text/css text/xml text/javascript 
               application/x-javascript application/xml+rss 
               application/javascript application/json;

    # Security headers
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    # CSP header
    add_header Content-Security-Policy "default-src 'self' https:; script-src 'self' 'unsafe-inline' https://www.googletagmanager.com https://www.google-analytics.com https://cdn.tally.so; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; img-src 'self' data: https:; font-src 'self' https://fonts.gstatic.com;" always;

    server {
        listen 80;
        listen [::]:80;
        server_name _;

        root /var/www/html;
        index index.html;

        # Redirect to HTTPS
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name brandshield.dev www.brandshield.dev;

        root /var/www/html;
        index index.html;

        # SSL certificates (use Let's Encrypt via Certbot)
        ssl_certificate /etc/letsencrypt/live/brandshield.dev/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/brandshield.dev/privkey.pem;

        # Jekyll static files
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # Try files in order
        location / {
            try_files $uri $uri/ $uri.html =404;
        }

        # Custom 404
        error_page 404 /404.html;
        location = /404.html {
            internal;
        }

        # Deny access to sensitive files
        location ~ /\. {
            deny all;
        }

        location ~ ~$ {
            deny all;
        }
    }
}
```

### Build & Run

```bash
# Build image
docker build -t brandshield-site .

# Run container
docker run -d -p 80:80 -p 443:443 \
  --name brandshield \
  -e VIRTUAL_HOST=brandshield.dev \
  -e LETSENCRYPT_HOST=brandshield.dev \
  -e LETSENCRYPT_EMAIL=contact@takovhs.dev \
  brandshield-site
```

## AWS S3 + CloudFront Deployment

### Create S3 bucket

```bash
# Create bucket
aws s3 mb s3://brandshield-site --region us-east-1

# Enable static website hosting
aws s3 website s3://brandshield-site \
  --index-document index.html \
  --error-document 404.html

# Upload built site
aws s3 sync docs/_site s3://brandshield-site/ \
  --region us-east-1 \
  --cache-control "public, max-age=300"
```

### Create CloudFront distribution

```bash
# Create distribution with:
# - Origin: s3://brandshield-site.s3-website-us-east-1.amazonaws.com
# - Viewer Protocol Policy: Redirect HTTP to HTTPS
# - Cache Behavior: All (max 1 year for static assets)
# - SSL Certificate: Use AWS Certificate Manager for brandshield.dev
# - Custom Domain: brandshield.dev
```

### Setup GitHub Actions for S3 Deploy

```yaml
name: Deploy to S3

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.0
          bundler-cache: true
          working-directory: docs
      
      - name: Build Jekyll
        working-directory: docs
        run: bundle exec jekyll build
      
      - name: Deploy to S3
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 sync docs/_site s3://brandshield-site/ \
            --region us-east-1 \
            --delete \
            --cache-control "public, max-age=300"
      
      - name: Invalidate CloudFront
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
            --paths "/*"
```

## Vercel Deployment (Recommended for Edge Cases)

### Create vercel.json

```json
{
  "buildCommand": "cd docs && bundle install && bundle exec jekyll build",
  "outputDirectory": "docs/_site",
  "env": {
    "JEKYLL_ENV": "production"
  }
}
```

### Deploy

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel deploy --prod
```

## Comparison

| Platform | Ease | Cost | Performance | Support |
|----------|------|------|-------------|---------|
| GitHub Pages | ⭐⭐⭐⭐⭐ | Free | ⭐⭐⭐⭐ | Excellent |
| Netlify | ⭐⭐⭐⭐ | Free (pro available) | ⭐⭐⭐⭐⭐ | Excellent |
| Vercel | ⭐⭐⭐⭐ | Free (pro available) | ⭐⭐⭐⭐⭐ | Excellent |
| AWS S3 | ⭐⭐ | Very low | ⭐⭐⭐⭐ | Good |
| Docker | ⭐⭐⭐ | Depends | ⭐⭐⭐⭐ | Self-hosted |

**Current Setup**: ✅ GitHub Pages (Free, Simple, Production-ready)

---

**Last Updated**: 2025-01-08
**For more info**: See [DEVELOPMENT.md](DEVELOPMENT.md)
