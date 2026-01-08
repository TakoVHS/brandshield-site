# 🚀 BRANDSHIELD — DEPLOYMENT GUIDE

## Что сделано

### ✅ Пункт 1: brandshield.dev

**CNAME создан** → `CNAME` файл с содержимым `brandshield.dev`
**Config обновлен** → url и baseurl в `docs/_config.yml`

**ТРЕБУЕТ ДЕЙСТВИЯ:**
```bash
# Перейди сюда и добавь DNS:
https://github.com/TakoVHS/brandshield-site/settings/pages

# Добавь в регистратор (где ты купил brandshield.dev):
Type: CNAME
Name: @
Value: takovhs.github.io

# Проверь через 10-30 минут:
dig brandshield.dev
```

---

### ✅ Пункт 4: Страница контактов

**Новая страница**: `docs/contact.md` с Tally формой
**Nav обновлена**: Добавлена ссылка "Contact"
**FAQ добавлен**: Типичные вопросы и ответы
**Email контакт**: contact@takovhs.dev

**Тест сейчас:**
```
https://takovhs.github.io/brandshield-site/contact
```

**После DNS:**
```
https://brandshield.dev/contact
```

---

## Структура сайта

```
/                 → Home (героя + услуги)
/audit-pack       → 72-Hour Audit
/snapshot         → Quick Assessment
/radar            → Continuous Monitoring
/compliance       → Data sources
/contact          → Contact form + FAQ ← 🆕
/privacy          → Privacy policy
/methodology      → Methodology docs
/404              → Custom 404
```

---

## Git история

```bash
23a180b ✨ Add custom domain (brandshield.dev) + contact page with Tally
68c25c9 📚 Add .gitignore and comprehensive README
3987364 🚀 Optimize: Fix GitHub Pages URLs, improve SEO
fedc485 Publish Brandshield landing (GitHub Pages)
```

---

## 🔒 Финальные шаги

1. **Добавь DNS** (у регистратора brandshield.dev)
   - CNAME: `@` → `takovhs.github.io`
   
2. **Проверь Pages Settings** (GitHub)
   - Должно быть зелёный чекбокс "DNS check passed"
   
3. **Включи HTTPS** 
   - Галочка "Enforce HTTPS" появится автоматом

4. **Протестируй в браузере**
   - https://brandshield.dev/contact

---

## 📊 Что ещё можно добавить

- [ ] Google Analytics (G-ID в _config.yml)
- [ ] Blog (_posts/)
- [ ] API endpoints (/api/check)
- [ ] Email notifications (Zapier + SendGrid)
- [ ] Live dashboard (/radar)

---

## 📧 Контакты

**Email**: contact@takovhs.dev
**GitHub**: github.com/TakoVHS
**Repo**: github.com/TakoVHS/brandshield-site
