# Nguyen Quang Minh Portfolio

Personal portfolio for AI, finance, data science, awards, certificates, job simulations, writing
notes, photography, and camera-based gesture interaction.

## Live portfolio

https://nqminh-ai.github.io/nqminh_portfolio/

## Run locally

```bash
python -m http.server 8000 --bind 127.0.0.1
```

Open `http://127.0.0.1:8000/`.

## Folders

| Folder           | What goes in it                                                            |
|------------------|----------------------------------------------------------------------------|
| `certificate/`   | Certificate PDFs (source of truth, linked from "View certificate")           |
| `cert_preview/`  | Auto-generated JPEG previews of the above — do not edit by hand              |
| `job_simulation/`| Job-simulation PDFs                                                          |
| `job_preview/`   | Auto-generated JPEG previews of the above                                    |
| `award/`         | Award photos — see `award/README.md` for the expected filenames              |
| `image/web/`     | Web-sized photography used by the page                                       |
| `image/`         | Original camera files (not loaded by the page)                               |

## Adding a certificate

1. Drop the PDF into `certificate/` (or `job_simulation/`).
2. Run `./tools/make-previews.sh` to build its preview image.
3. Add an entry to the `certificates` array in `portfolio_v3.html`.

The page never embeds PDFs inline — an embedded PDF needs a native viewer, so it renders blank
on phones and on desktops without one. Cards show the generated JPEG; the PDF opens on click.

## Adding an award

Add an entry to the `awards` array in `portfolio_v3.html` (`tier: 1 | 2 | 3` picks the
gold/silver/bronze styling) and drop the matching photo into `award/`.

## Adding a photo

Photos are downscaled before they ship. From the repo root:

```bash
sips -s format jpeg -s formatOptions 55 --resampleWidth 1200 image/YOUR.JPG --out image/web/YOUR.jpg
```

Then point a `.photo-slide` in `portfolio_v3.html` at `image/web/YOUR.jpg`.
