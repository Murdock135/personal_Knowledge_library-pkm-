### 1 . Amazon Bedrock (Anthropic) — **1 user, 30 calls wk⁻¹**

| Model                 | $PinP_{\text{in}}$ $[\$/1 k]$ | $PoutP_{\text{out}}$ $[\$/1 k]$ |  1 mo | 1 mo + 15 % |    1 yr | 1 yr + 15 % |
| --------------------- | ----------------------------: | ------------------------------: | ----: | ----------: | ------: | ----------: |
| Claude 3 Haiku        |                       0.00025 |                         0.00125 |  $ 97 |       $ 112 | $ 1 170 |     $ 1 346 |
| Claude Instant        |                       0.00080 |                         0.00240 |   187 |         215 |   2 246 |       2 583 |
| Claude 3.5 Haiku      |                       0.00080 |                         0.00400 |   312 |         359 |   3 744 |       4 306 |
| Claude 3 / 3.5 Sonnet |                       0.00300 |                         0.01500 | 1 169 |       1 344 |  14 040 |      16 146 |
| Claude Opus 4         |                       0.01500 |                         0.07500 | 5 846 |       6 722 |  70 201 |      80 732 |

_(token prices ([Vantage](https://www.vantage.sh/blog/aws-bedrock-claude-vs-azure-openai-gpt-ai-cost?utm_source=chatgpt.com "Claude vs OpenAI: Pricing Considerations - Vantage"), [AWS Builder Center](https://community.aws/content/2n9wWygDkfoZd74eAsaBNtEjZON/prompt-compression-using-amazon-bedrock-reduce-rag-costs?utm_source=chatgpt.com "Prompt Compression using Amazon Bedrock :: Reduce RAG costs")))_

---

### 2 . Gemini 2.5 Pro — **1 user, 30 calls wk⁻¹**

| Model                           | $PinP_{\text{in}}$ $[\$/1 M]$ | $PoutP_{\text{out}}$ $[\$/1 M]$ |    1 mo | 1 mo + 15 % |     1 yr | 1 yr + 15 % |
| ------------------------------- | ----------------------------: | ------------------------------: | ------: | ----------: | -------: | ----------: |
| Gemini 2.5 Pro (>!200 k prompt) |                          2.50 |                           15.00 | $ 1 169 |     $ 1 344 | $ 14 040 |    $ 16 146 |

_(prices ([Google AI for Developers](https://ai.google.dev/gemini-api/docs/pricing "Gemini Developer API Pricing  |  Gemini API  |  Google AI for Developers")))_

---

### 3 . Mixed Gemini workload — **Gemini 2.5 Pro (30 calls wk⁻¹) + Gemini 2.5 Flash‑Lite (200 calls wk⁻¹)**

| Component               | $PinP_{\text{in}}$ $[\$/1 M]$ | $PoutP_{\text{out}}$ $[\$/1 M]$ |        1 mo |         1 yr |
| ----------------------- | ----------------------------: | ------------------------------: | ----------: | -----------: |
| Pro (30 wk⁻¹)           |                          2.50 |                           15.00 |     $ 1 169 |     $ 14 040 |
| Flash‑Lite (200 wk⁻¹)   |                          0.10 |                            0.40 |         208 |        2 496 |
| **Total**               |                             — |                               — | **$ 1 377** | **$ 16 536** |
| **Total + 15 % buffer** |                             — |                               — | **$ 1 584** | **$ 19 017** |

_(Flash‑Lite prices ([Google AI for Developers](https://ai.google.dev/gemini-api/docs/pricing "Gemini Developer API Pricing  |  Gemini API  |  Google AI for Developers")))_

All costs use the traffic model 6060 input + 6 ⁣× ⁣1056\!\times\!10^{5} output tok · call⁻¹; month ≈ 4.33 weeks, year = 52 weeks. Input spend is < ⁣0.01%<\!0.01\% everywhere; output dominates. Figures exclude ancillary cloud charges (≈ 5–10 %). Add 15 % contingency as shown.