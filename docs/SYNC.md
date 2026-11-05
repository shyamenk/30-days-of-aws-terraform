# Sync log: playlist, instructor repo, this repo

Last sync: **2026-11-05** (mapping added). Playlist: 32 videos. Instructor repo: `main` at commit `3897acf` (pushed 2026-04-27), MIT licensed.

Rule: the playlist decides day order and titles. The instructor repo is reference code to compare with after you attempt a day. Do not copy it into `infra/`.

## Mapping: our day to the instructor folder

Checked 2026-11-05 by listing every folder under `lessons/` and reading the README titles. The folder is for comparing after you attempt a day, never for copying.

| Day | Instructor folder | What is in it |
|---|---|---|
| 0 | none | Course intro video; no folder |
| 1 | [day01](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day01) | README, task |
| 2 | [day02](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day02) | README, task |
| 3 | [day03](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day03) | README, task, `main.tf` |
| 4 | [day04](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day04) | README, task, `code/` |
| 5 | [day05](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day05) | README, task, `code/` |
| 6 | [day06](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day06) | README, task only (no code) |
| 7 | [day07](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day07) | README, task, `.tf` files at folder root |
| 8 | [day08](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day08) | README, task, `code/` |
| 9 | [day09](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day09) | README, task, `code/` |
| 10 | [day10](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day10) | readme (lowercase), task, `code/` |
| 11 | [day11-12](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day11-12) | Shared with Day 12: README, task, `.tf` files |
| 12 | [day11-12](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day11-12) | Shared with Day 11 |
| 13 | [day13](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day13) | README, task, `code/` |
| 14 | [day14](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day14) | README, task, `.tf` files, `backend.tf`, `www/` |
| 15 | [day15](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day15) | README, task, `.tf` files, `terraform.tfvars.example` |
| 16 | [day16](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day16) | README, task, `.tf` files, `users.csv` |
| 17 | [day17](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day17) | README, task, blue and green `.tf`, `app-v1/`, `app-v2/`, swap scripts |
| 18 | [day18](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day18) | README, task, `lambda/`, `scripts/`, `terraform/` |
| 19 | [day19](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day19) | README, task, `code/` |
| 20 | [day20](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day20) | README, task, `code/`; README titled "EKS Cluster" |
| 21 | [day21](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day21) | README, task, `.tf` files. **Contains a committed `tfplan` file, which we must not copy.** |
| 22 | [day22](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day22) | README, task, `demo_guide.md`, `modules/`. **README is titled "RDS Database" but describes a modular web app stack.** |
| 23 | [day23](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day23) | README, task, `aws-lamda-monitoring/`, `s3-security-monitoring.backup/` (S3 monitoring with CloudTrail and CloudWatch) |
| 24 | [day24](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day24) | README, task, `code/` (HA Django app) |
| 25 | [day25](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day25) | README, task only (no code) |
| 26 | [day26](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day26) | README, task only (no code) |
| 27 | [day27](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day27) | README (a demo guide), task, `code/`. Points to a separate infrastructure repo. |
| 28 | [day28](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day28) | README, task, `backend/`, `frontend/`, `terraform-infra/`, `docker-local-deployment/` |
| 29 | [day29](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day29) | README, task, `manifests/`, `terraform/` (ArgoCD with Kustomize on EKS) |
| 30 | [day30](https://github.com/piyushsachdeva/Terraform-Full-Course-Aws/tree/main/lessons/day30) | README, task, `code/`. **README pins Terraform 1.10.3, older than our 1.17.1.** |

Folders with no matching video: `day31` (README only, "Drift Detection using Terraform Cloud") and `tobeday02` (a placeholder titled "Day 1: Introduction to Terraform").

## Known differences

| Item | Playlist | Instructor repo | What we do |
|---|---|---|---|
| Day 5 and 6 order | 6/30 listed before 5/30 | `day05` variables, `day06` structure, matching the day numbers | Follow day numbers |
| Day 11 and 12 | Two videos | One folder, `day11-12` | Two notes, one reference folder |
| Day 22 | 2-tier architecture | README title says RDS, body describes a modular web stack | Trust the video; confirm the folder when you reach it |
| Day 28 and 29 | 3-tier, then ArgoCD on EKS | Folders match the videos. The top-level README table has the two swapped or mislabelled | Use the folders, ignore the README table |
| Day 21 | Policy and governance | Folder matches, but includes a committed `tfplan` | Never commit plan files (`.gitignore` already blocks them) |
| Day 30 | Drift detection | README pins Terraform 1.10.3 | Use our pinned version and note differences in Gotchas |
| Missing code | Days 1, 2, 6, 25, 26 | README and task only | Expected for concept days |
| Day 31, `tobeday02` | Not in playlist | Extra folders | Ignore unless a video is added |
| "50 Early Winners" announcement | Playlist position 14 | n/a | Not a lesson, skipped |

## How to re-sync (do this at the start of each week)

```
yt-dlp --flat-playlist --print "%(playlist_index)s|%(title)s|%(duration_string)s|%(id)s" \
  "https://www.youtube.com/playlist?list=PLl4APkPHzsUXcfBSJDExYR-a4fQiZGmMp"
gh api repos/piyushsachdeva/Terraform-Full-Course-Aws/commits --jq '.[0] | "\(.sha[0:7]) \(.commit.committer.date)"'
gh api repos/piyushsachdeva/Terraform-Full-Course-Aws/contents/lessons --jq '.[].name'
```

Compare against the table above. If the commit hash changed, read the diff on GitHub, update this file and [SYLLABUS.md](SYLLABUS.md), and bump the "Last sync" line.
