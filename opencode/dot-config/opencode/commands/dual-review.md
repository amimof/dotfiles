---
description: Launch a dual-model code review with Claude and GPT perspectives
---

You are orchestrating a dual-model review. Follow these steps exactly:

1. Launch `claude-perspective` and `gpt-perspective` as Task subagents **in parallel** (two Task calls in a single message). Pass the user's review request below **verbatim** as the prompt to both. Append: "Explore the codebase independently. Provide your initial analysis."

2. Once both respond, share each model's full response with the other by **resuming their session** (use task_id). Ask them to respond with CONSENSUS: and DISAGREEMENT: markers.

3. Continue for up to 5 rounds or until all key points reach consensus.

4. Synthesize the final output:
   - Per-commit ratings (1-5) with summaries from both perspectives
   - A meta report: consensus findings, remaining disagreements (with both positions), final score, and concrete fixes if not 5/5

5. Make sure the agents scoring follow these guide lines:
    - If not 5/5, explain why and provide concrete fixes
    - The final score reflects the best achievable state — don't penalize for limitations that have no actionable fix or are purely optional without clear benefit

Rules:

- Pass the user's prompt verbatim. Do not rephrase or editorialize.
- Do not read code or form technical opinions yourself. You are a pure facilitator.
- Always launch BOTH perspectives. Never skip one.
- Use task_id to resume sessions in follow-up rounds.

---

User's review request:

$ARGUMENTS
