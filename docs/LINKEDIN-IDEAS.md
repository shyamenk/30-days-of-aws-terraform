# LinkedIn-worthy material

Nothing is posted until the course is finished. This file collects what is worth posting, so the post is easy to write later. Add a row whenever a day produces one of these:

- A mistake that cost real time, with the error text and the cause
- A concept that clicked, with the explanation that finally worked
- A comparison between the video and the current docs (something that changed)
- A cost surprise
- A diagram or short excerpt from my own code that teaches something

| Day | Type | The idea in one line | Evidence (note section, error text, commit) | Strength (1-3) |
|---|---|---|---|---|
| 0 | Lesson | The announced syllabus differed from the released videos, and the instructor's README still follows the announcement. Check a course's real content against its outline. | `docs/SYNC.md` known differences | 1 |
| 0 | Concept | What actually makes a subnet public: a route to the internet gateway plus a public IP. The gateway attaches to the VPC, not a subnet, and private subnets still reach out through NAT. | Day 0 note, section 2 and 7 | 2 |

| 1 | Concept | Why teams stop clicking: about 2 hours for one app by hand, times 6 environments, times hundreds of apps. The hours are the instructor's estimate, so say that. | Day 1 note, section 2 | 1 |
| 1 | Lesson | The video's loose wording on `destroy` and `init`: `destroy` removes what state says Terraform built, not "everything in the files", and `init` prepares the folder without creating cloud resources. | Day 1 note, section 7 | 2 |
| 2 | Lesson | A version constraint copied from an older course can block the current provider: `~> 5.0` allows only 5.x, while 6.72.0 is current. Read what `~>` allows before pasting it. | Day 2 note, section 7 | 2 |
| 2 | Mistake | My first working Terraform still failed my own CI: no `required_version` (`tflint` exit 2) and an untagged resource in a shared account. | Day 2 note, section 7 | 2 |

Strength 3 means a stranger would learn something real from it. Strength 1 is a note to myself.
