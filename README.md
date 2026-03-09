<img width="355" height="349" alt="image" src="https://github.com/user-attachments/assets/f8408f66-5df6-4ea1-a44c-b8376357d740" />

## Run Oracle and NOP

**Recommended:** use the wrapper script (fixes Docker + verifier issues):

```bash
./run-oracle-nop.sh
```

- **Oracle** → Mean: 1.000 (reference solution)
- **NOP** → Mean: 0.000 (no-op agent)

**Requirements:** `harbor` CLI (`uv tool install harbor`) and Docker.

---

### What was fixed

1. **RuntimeError / Docker "must be lowercase"**  
   The project folder name `Harbour_Assignment-main` was used for the Docker image (`hb__Harbour_Assignment-main`), which Docker rejects. The script runs from a copy at `/tmp/harbour_word_count_task` so the image name is valid.

2. **VerifierOutputParseError**  
   The verifier expects `reward.txt` to contain only a single number (0 or 1). `tests/test.sh` was redirecting the whole command (including pytest output) into `reward.txt`. Pytest output is now discarded so only the reward is written.

---

### Manual commands (from a Harbor repo with this task as `harbor_tasks/word-count-task`)

```bash
# Oracle Test (should return Mean: 1.000)
uv run harbor run --agent oracle --path harbor_tasks/word-count-task --job-name test-oracle

# NOP Test (should return Mean: 0.000)
uv run harbor run --agent nop --path harbor_tasks/word-count-task --job-name test-nop
```
