# Sync log: playlist, instructor repo, this repo

Last sync: **2026-11-05**. Playlist: 32 videos. Instructor repo: `main` at commit `3897acf` (pushed 2026-04-27), MIT licensed.

Rule: the playlist decides day order and titles. The instructor repo is reference code to compare with after you attempt a day. Do not copy it into `infra/`.

## Known differences

| Item | Playlist | Instructor repo / README | What we do |
|---|---|---|---|
| Day 5 and 6 order | 6/30 listed before 5/30 | `day05`, `day06` folders | Follow day numbers |
| Day 11 and 12 | Two videos | One folder, `day11-12` | Two notes, one reference folder |
| Day 22 | 2-tier architecture | README table says RDS database | Trust the video, check the folder |
| Day 28 | 3-tier architecture | README links Video 28 to `day29`, yet a `day28` folder exists | Check both folders when you reach it |
| Day 29 | GitOps with ArgoCD on EKS | README says 3-tier | Trust the video |
| Day 31, `tobeday02` | Not in playlist (Day 30 is the last video) | Extra folders | Ignore unless the instructor adds a video |
| 50 Early Winners announcement | In playlist at position 14 | n/a | Not a lesson, skipped |

Folder names inside the instructor repo can differ from video day numbers, so open the folder after you watch the video and compare topics, not numbers.

## How to re-sync (do this at the start of each week)

```
yt-dlp --flat-playlist --print "%(playlist_index)s|%(title)s|%(duration_string)s|%(id)s" \
  "https://www.youtube.com/playlist?list=PLl4APkPHzsUXcfBSJDExYR-a4fQiZGmMp"
gh api repos/piyushsachdeva/Terraform-Full-Course-Aws/commits --jq '.[0] | "\(.sha[0:7]) \(.commit.committer.date)"'
gh api repos/piyushsachdeva/Terraform-Full-Course-Aws/contents/lessons --jq '.[].name'
```

Compare against the table above. If the commit hash changed, read the diff on GitHub, update this file and [SYLLABUS.md](SYLLABUS.md), and bump the "Last sync" line.
