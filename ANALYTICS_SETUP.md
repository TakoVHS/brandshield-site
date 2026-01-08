# 📊 Google Analytics Setup Guide

## Step-by-Step Setup

### 1. Create Google Analytics Account

#### If you don't have a Google account:
1. Go to [accounts.google.com](https://accounts.google.com)
2. Click "Create account"
3. Follow the verification process

#### If you already have Google Account:
1. Go to [analytics.google.com](https://analytics.google.com)
2. Sign in with your Google account
3. Click "Start measuring" or "Create"

### 2. Create GA4 Property

1. **Account Setup**
   - Account name: `Brandshield` (or your company name)
   - Data sharing settings: Choose your preferences
   - Click "Next"

2. **Property Setup**
   - Property name: `brandshield.dev` (or your domain)
   - Timezone: Select your timezone (e.g., UTC+7 for Vietnam)
   - Currency: USD (or your currency)
   - Industry category: Computer & Electronics or Marketing/Advertising
   - Business size: Choose your size
   - Click "Next"

3. **Create a data stream**
   - Platform: Select "Web"
   - Website URL: `https://brandshield.dev`
   - Stream name: `Brandshield Website`
   - Enhanced measurement: Enable (recommended)
   - Click "Create stream"

4. **Get Measurement ID**
   - You'll see "Stream details" page
   - Find "Measurement ID" - it looks like: `G-XXXXXXXXXX`
   - **Copy this ID** - you'll need it next

### 3. Add ID to Your Site

#### Update Jekyll Config

1. Open `docs/_config.yml` in your editor
2. Find the `google_analytics:` section (around line 34)
3. Replace `"G-XXXXXXXXXXXX"` with your actual ID:

```yaml
google_analytics:
  id: "G-1234567890"  # Replace with YOUR Measurement ID
```

4. Save the file
5. Push to GitHub:

```bash
cd /path/to/brandshield-site
git add docs/_config.yml
git commit -m "feat: add Google Analytics tracking ID"
git push origin main
```

6. Wait for GitHub Actions to deploy (check [Actions tab](https://github.com/TakoVHS/brandshield-site/actions))

### 4. Verify Installation

#### Method 1: Google Analytics Real-time View
1. Go to [analytics.google.com](https://analytics.google.com)
2. Select your property: `brandshield.dev`
3. Go to **Reports** > **Realtime**
4. Open https://brandshield.dev (or staging site) in browser
5. You should see 1 active user in Realtime panel within 10 seconds

#### Method 2: Browser DevTools
1. Open your site in Chrome/Firefox
2. Open DevTools (F12)
3. Go to **Console** tab
4. Paste: `gtag('event', 'page_view')`
5. Check Network tab for calls to `google-analytics.com`

#### Method 3: Google Tag Assistant
1. Install [Google Tag Assistant](https://chrome.google.com/webstore/detail/google-tag-assistant/jjdg0fkhbojjlilfohpoknmjpnkamahd) extension
2. Visit your site
3. Click extension icon
4. You should see "Google Analytics" with your Measurement ID

### 5. Configure Events (Optional but Recommended)

#### Contact Form Conversion
The Tally form already sends events. To track it:

1. Go to GA4 > **Events**
2. Check for `tally_form_submission` event
3. Go to **Conversions** > **New conversion event**
4. Create conversion:
   - **Event name**: `tally_form_submission`
   - **Description**: "Contact form submission"
5. Click **Create**

#### Blog Post Engagement
To track blog post clicks:

1. Add event tracking to blog links
2. Edit `docs/_layouts/page.html`
3. Add to blog post links:

```html
<a href="..." onclick="gtag('event', 'blog_click', {'blog_title': 'Post Title'});">Link</a>
```

Or use automatic scroll tracking:

```javascript
gtag('event', 'page_view', {
  'page_title': document.title,
  'page_path': window.location.pathname,
  'scroll_depth': document.documentElement.scrollHeight
});
```

### 6. Create Custom Dashboard

1. Go to GA4 > **Dashboards**
2. Click **Create new dashboard**
3. Name: `Brandshield Overview`
4. Add cards:
   - **Users** (top left)
   - **Views** (top right)
   - **Avg. Session Duration** (middle left)
   - **Bounce Rate** (middle right)
   - **Top Pages** (bottom left)
   - **Traffic Source** (bottom right)
5. Click **Save**

### 7. Set Up Alerts (Optional)

1. Go to GA4 > **Admin** (bottom left)
2. Select your property
3. Click **Conversion events** or **Custom alerts**
4. Create alerts for:
   - Traffic drop > 50%
   - Conversion increase > 200%
   - Unusual activity

### 8. Connect Google Search Console

1. Go to GA4 > **Admin** > **Product links**
2. Click **Search Console links**
3. Click **New Connection**
4. Select your GSC property: `brandshield.dev`
5. Authorize
6. Click **Done**

This connects your search data with analytics!

---

## Useful Reports

### Essential Reports to Monitor

#### **Acquisition Tab**
- **Traffic Source**: Where visitors come from
- **Channels**: Organic, direct, social, referral
- **Campaigns**: UTM tracking (if you use them)

#### **Engagement Tab**
- **Pages and Screens**: Most visited pages
- **Events**: Form submissions, clicks, scrolls
- **Conversions**: Goal completions

#### **Retention Tab**
- **Returning Users**: User retention trends
- **Cohort Analysis**: User behavior patterns

#### **Monetization Tab** (if applicable)
- **E-commerce**: Product views, purchases
- **Revenue**: If you have paid features

### Key Metrics to Track

| Metric | Target | How to Improve |
|--------|--------|----------------|
| Users | 10,000+/month | Content marketing, SEO |
| Session Duration | 2+ minutes | Improve content, reduce ads |
| Bounce Rate | <40% | Better CTAs, relevant content |
| Conversion Rate | 2-5% | Optimize forms, clear CTAs |
| Pages/Session | 3+ pages | Internal linking, sidebars |

---

## UTM Parameters for Campaign Tracking

Use UTM parameters to track campaigns:

### Email Newsletter Link
```
https://brandshield.dev/?utm_source=newsletter&utm_medium=email&utm_campaign=jan-2025
```

### Social Media Link
```
https://brandshield.dev/?utm_source=twitter&utm_medium=social&utm_campaign=product-launch
```

### Paid Ad Link
```
https://brandshield.dev/?utm_source=google&utm_medium=cpc&utm_campaign=search-ads&utm_term=brand+protection
```

**Parameters:**
- `utm_source`: Where (google, newsletter, twitter)
- `utm_medium`: How (cpc, email, social)
- `utm_campaign`: Why/What campaign
- `utm_term`: Specific keyword
- `utm_content`: Ad variant (A/B testing)

### Tool: UTM Builder
Use [Google Analytics UTM Builder](https://ga-dev-tools.web.app/campaign-url-builder/) to generate links easily.

---

## Data Privacy & Compliance

### GDPR Compliance
If you have EU visitors, add cookie consent:

```javascript
// In _config.yml
analytics_consent_required: true
```

Then update page.html:
```html
{% if site.analytics_consent_required %}
<script>
  // Show cookie banner before loading analytics
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('consent', 'default', {
    'analytics_storage': 'denied'
  });
</script>
{% endif %}
```

### Anonymize IP (Already Configured)
Your config already has:
```yaml
anonymize_ip: true
```

This masks user IP addresses for privacy.

### User Exclusion
If you want to exclude your own traffic:

1. Go to GA4 > **Admin** > **Data Filters**
2. **Create filter** > **Internal traffic**
3. **Filter type**: Internal traffic
4. **Matching pattern**: Your IP address
5. Enable filter

---

## Troubleshooting

### GA Not Recording Data
1. ✅ Check Measurement ID is correct (format: G-XXXXXXXXXX)
2. ✅ Wait 24-48 hours for initial data
3. ✅ Disable ad blockers (they block analytics)
4. ✅ Check gtag script is loading (DevTools > Console)
5. ✅ Verify site is not in private/incognito mode

### "No data yet" After 24 Hours
1. Open https://pagespeed.web.dev/ on your site
2. Screenshot showing traffic
3. Then check GA again
4. If still no data, contact Google Analytics support

### Events Not Tracking
1. Open DevTools > Network
2. Filter for "google-analytics"
3. Check requests are being sent
4. Wait 24-48 hours for reports to populate

---

## Advanced Features

### Custom Dimensions
Track custom data:

```javascript
gtag('set', {
  'user_role': 'premium',
  'customer_id': '12345',
  'company': 'Acme Corp'
});
```

### E-commerce Tracking
If you add products:

```javascript
gtag('event', 'view_item', {
  'items': [{
    'item_id': 'sku_123',
    'item_name': 'Premium Protection Plan',
    'price': 99.99
  }]
});
```

### Conversion API
For server-side conversions:

```bash
curl -X POST \
  https://www.google-analytics.com/mp/collect \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "user_id",
    "events": [{
      "name": "purchase",
      "params": {
        "value": 99.99,
        "currency": "USD"
      }
    }]
  }'
```

---

## Resources

- [Google Analytics Docs](https://support.google.com/analytics)
- [GA4 Beginner Guide](https://support.google.com/analytics/answer/10089681)
- [GA4 Event Guide](https://support.google.com/analytics/answer/9322407)
- [UTM Parameters Guide](https://support.google.com/analytics/answer/1033173)
- [GA4 Debugging Guide](https://support.google.com/analytics/answer/9382218)

---

## Quick Checklist

```
[ ] Created Google Analytics account
[ ] Created GA4 property for brandshield.dev
[ ] Copied Measurement ID (G-XXXXXXXXXX)
[ ] Updated docs/_config.yml with ID
[ ] Pushed code to GitHub
[ ] Verified tracking in Realtime view
[ ] Set timezone and currency
[ ] Created dashboard
[ ] Set up conversion tracking
[ ] Connected Google Search Console
[ ] Added privacy notice if needed
[ ] Tested with Google Tag Assistant
```

---

**Last Updated**: January 8, 2025  
**Need Help?** Email [support@takovhs.dev](mailto:support@takovhs.dev)
