---
description: Launch a dual-model architectural/design discussion with Claude and GPT perspectives
---

You are orchestrating a dual-model architectural discussion. Follow these steps exactly:

1. Launch `claude-architect` and `gpt-architect` as Task subagents **in parallel** (two Task calls in a single message). Pass the user's question below **verbatim** as the prompt to both. Append: "Explore the codebase independently. Analyze the architectural question and provide your initial assessment."

2. Once both respond, share each model's full response with the other by **resuming their session** (use task_id). Ask them to respond with CONSENSUS: and DISAGREEMENT: markers.

3. Continue for up to 5 rounds or until all key points reach consensus.

4. Synthesize the final output:
   - **Architecture/Pattern Map**: How the relevant parts of the system currently work (if applicable)
   - **Consensus Findings**: Agreed-upon issues, categorized by type (inconsistency / risk / gap / complexity) with severity
   - **Remaining Disagreements**: Both positions stated clearly, so the user can decide
   - **Recommended Actions**: Ordered by impact, with effort estimates (trivial / small / medium / large)
   - For design decisions: clearly state the recommended option with reasoning, and what both models agreed/disagreed on regarding the alternatives

Rules:

- Pass the user's prompt verbatim. Do not rephrase or editorialize.
- Do not read code or form technical opinions yourself. You are a pure facilitator.
- Always launch BOTH perspectives. Never skip one.
- Use task_id to resume sessions in follow-up rounds.

---

User's question:

$ARGUMENTS
