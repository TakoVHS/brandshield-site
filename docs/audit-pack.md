---
title: 72‑Hour Audit Pack
description: Executive brief + technical annex + takedown packet + bundle JSON. Defensive-only. Public data. No PII.
permalink: /audit-pack
---

# 72‑Hour Audit Pack (для бирж/кошельков/он‑рампов)

**Цель:** за 72 часа дать вам **IR‑готовый пакет**: что происходит, почему это риск, что делать дальше и как эскалировать.

<div class="hero__cta" style="margin:14px 0 10px">
  <a class="btn" href="{{ site.brandshield.cta_primary_url }}">{{ site.brandshield.cta_primary_text }}</a>
  <a class="btn btn--ghost" href="{{ site.brandshield.cta_secondary_url }}">{{ site.brandshield.cta_secondary_text }}</a>
</div>

## Что входит (Deliverables)
1) **Incident Brief (Executive)** — 1–2 страницы: резюме, риски, приоритеты, план на 24–72h.  
2) **Technical Annex** — explainable сигналы (reason codes, confidence, ограничения FP/FN).  
3) **Takedown Packet** — нейтральный язык “suspected impersonation / potential phishing”.  
4) **Bundle JSON** — машиночитаемая сводка.  
5) **Evidence Index (no PII)** — hashes/refs/timestamps, без персональных данных.

## Как это выглядит (доказательство)
<div class="proof">
make unit  → PASS (no‑docker proof) <br/>
make audit-pack → report_generated=1 (bundle JSON + brief + takedown packet)
</div>

## Что нужно от вас (5 минут)
- official domains (списком)
- brand keywords (2–10)
- allowlist (ваши домены/партнёры) — опционально
- контакт для согласования результатов

## Границы
- Никаких приватных чатов/DM, обхода ToS/лимитов.
- Никаких обвинений — только **risk signals**, финальное решение через human review.
- PII не храним.

<div class="callout">
Если вы хотите начать мягко: сначала <b>Free Exposure Snapshot</b>, затем апгрейд до Audit Pack.
</div>
