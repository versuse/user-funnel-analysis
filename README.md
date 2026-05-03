# User Funnel Analysis
### Where are we losing users — and what do we do about it?

**[→ View Live Case Study](https://versuse.github.io/user-funnel-analysis/)**

---

## Overview

70% of users who open the app never place a single order. This project is a full funnel analysis across 1,000 users to identify exactly where activation breaks, which acquisition channels perform best, and whether a first-order incentive meaningfully improves conversion.

| Metric | Value |
|---|---|
| Total users | 1,000 |
| App open rate | 80.1% |
| First order conversion | 30.4% |
| Repeat order rate | 39.1% of converters |
| Largest drop-off | App Open → First Order (−62%) |
| A/B uplift (Group B) | +3–5% conversion |

---

## The Funnel

```
Signup       1,000   ████████████████████  baseline
App Open       801   ████████████████      −19.9%
First Order    304   ██████                −62.1%  ⚠ critical drop
Repeat Order   119   ██                    −60.9%
```

The Signup → App Open drop is within normal range. The real failure is **App Open → First Order** — users who were engaged enough to open the app still didn't buy. That's a product and UX problem, not an acquisition problem.

---

## Repository Structure

```
user-funnel-analysis/
├── data/
│   ├── users.csv          # User attributes: source, experiment group, signup date
│   └── events.csv         # Event log: signup, app_open, first_order, repeat_order
├── sql/
│   └── queries.sql        # All analysis queries
├── outputs/
│   └── screenshots/       # Power BI dashboard exports
├── index.html             # Live case study site
└── README.md
```

---

## SQL Analysis

The full analysis is in [`sql/queries.sql`](sql/queries.sql). Key queries below.

### Funnel drop-off

```sql
SELECT 
  COUNT(DISTINCT CASE WHEN event_name = 'signup'       THEN user_id END) AS signup,
  COUNT(DISTINCT CASE WHEN event_name = 'app_open'     THEN user_id END) AS app_open,
  COUNT(DISTINCT CASE WHEN event_name = 'first_order'  THEN user_id END) AS first_order,
  COUNT(DISTINCT CASE WHEN event_name = 'repeat_order' THEN user_id END) AS repeat_order
FROM events;
```

### Step-by-step conversion rates

```sql
SELECT 
  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name = 'signup'   THEN user_id END), 2
  ) AS signup_to_open,
  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'first_order' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name = 'app_open'    THEN user_id END), 2
  ) AS open_to_order
FROM events;
```

### Conversion by acquisition source

```sql
SELECT 
  u.source,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) AS converted_users,
  ROUND(
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS conversion_rate
FROM users u
LEFT JOIN events e ON u.user_id = e.user_id
GROUP BY u.source;
```

### A/B test — first-order incentive

```sql
SELECT 
  u.experiment_group,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) AS converted_users,
  ROUND(
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS conversion_rate
FROM users u
LEFT JOIN events e ON u.user_id = e.user_id
GROUP BY u.experiment_group;
```

### Cohort retention by signup date

```sql
SELECT 
  u.signup_date,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE 
      WHEN e.event_name = 'app_open' 
      AND e.event_time > u.signup_date 
      THEN u.user_id 
  END) AS retained_users,
  ROUND(
    COUNT(DISTINCT CASE 
        WHEN e.event_name = 'app_open' 
        AND e.event_time > u.signup_date 
        THEN u.user_id 
    END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS retention_rate
FROM users u
LEFT JOIN events e ON u.user_id = e.user_id
GROUP BY u.signup_date
ORDER BY u.signup_date;
```

### Average time to first order

```sql
SELECT 
  ROUND(AVG(DATEDIFF(e.event_time, u.signup_date)), 2) AS avg_days_to_order
FROM users u
JOIN events e ON u.user_id = e.user_id
WHERE e.event_name = 'first_order';
```

---

## Key Findings

**Funnel** — The 62% drop between App Open and First Order is the primary conversion problem. Users have intent; the product isn't converting it.

**Acquisition** — Ads (33.66%) and Referral (30.48%) outperform Organic (28.37%). Referral's performance at likely lower CAC makes it the strongest channel to invest in.

**A/B Test** — Group B (first-order incentive) showed 3–5% higher conversion than Group A. Directionally strong; needs a larger cohort to confirm statistical significance.

**Timing** — Average time to first order is 2–3 days. Users who don't convert within 72 hours almost never do. The activation window is narrow.

---

## Recommendations

1. **Fix the onboarding experience** — the App Open → First Order gap is a UX problem. Map where users drop in-session before adding external incentives.
2. **48-hour nudge** — trigger a push notification or email for users who've opened the app but not ordered within 48 hours.
3. **Scale the incentive carefully** — measure whether Group B users also retain, not just convert. A lower repeat rate would indicate the incentive is pulling forward purchases, not creating new habits.
4. **Invest in Referral** — if CAC is lower than Ads with comparable conversion, Referral is the higher-leverage channel.

---

## Tools Used

- **SQL** (MySQL) — funnel queries, cohort analysis, A/B segmentation
- **Power BI** — dashboard: funnel drop-off, conversion by source, A/B impact
- **Python** — data simulation and event log generation

---

## Dashboard

Live interactive version: **[versuse.github.io/user-funnel-analysis](https://versuse.github.io/user-funnel-analysis/)**

Power BI screenshots in [`outputs/Screenshot 2026-05-02 173348.png`](outputs/Screenshot 2026-05-02 173348.png)

---

*Vishnu C · [versuse.github.io](https://versuse.github.io) · 2026*
