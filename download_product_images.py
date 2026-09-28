"""
AUTO DOWNLOAD PRODUCT IMAGES
- Searches image results by exact product/model names.
- Downloads the first usable image candidates.
- Saves to assets/products/<product_slug>.jpg
- Run from the Flutter project root.

Install once:
    py -m pip install ddgs requests pillow

Run:
    py download_product_images.py
"""

from pathlib import Path
from io import BytesIO
import re
import time
import requests
from PIL import Image
from ddgs import DDGS

OUT = Path("assets/products")
OUT.mkdir(parents=True, exist_ok=True)

QUERIES = {
    "Logitech G102": "Logitech G102 Lightsync gaming mouse black official product",
    "Razer DeathAdder V2": "Razer DeathAdder V2 gaming mouse official product",
    "Fantech Crypto VX7": "Fantech Crypto VX7 gaming mouse official product",
    "Rexus Daxa Air III": "Rexus Daxa Air III gaming mouse official product",
    "SteelSeries Rival 3": "SteelSeries Rival 3 gaming mouse official product",
    "Royal Kludge RK61": "Royal Kludge RK61 mechanical keyboard official product",
    "Keychron K2": "Keychron K2 mechanical keyboard official product",
    "Fantech Maxfit61": "Fantech Maxfit61 mechanical keyboard official product",
    "Rexus Legionare": "Rexus Legionare mechanical keyboard official product",
    "Logitech G Pro": "Logitech G Pro keyboard official product",
    "HyperX Cloud II": "HyperX Cloud II gaming headset official product",
    "Razer BlackShark V2": "Razer BlackShark V2 gaming headset official product",
    "Logitech G733": "Logitech G733 gaming headset official product",
    "Fantech HG11": "Fantech HG11 gaming headset official product",
    "SteelSeries Arctis": "SteelSeries Arctis gaming headset official product",
    "ASUS Gaming Monitor": "ASUS TUF Gaming monitor official product",
    "Acer Nitro Gaming Monitor": "Acer Nitro gaming monitor official product",
    "LG UltraGear Monitor": "LG UltraGear gaming monitor official product",
    "Samsung Odyssey Monitor": "Samsung Odyssey gaming monitor official product",
    "Xiaomi Gaming Monitor": "Xiaomi gaming monitor official product",
    "AES BILED": "AES UX-2 BILED projector motorcycle lamp",
    "CR7 BILED": "CR7 C682 BILED projector motorcycle lamp",
    "SQL BILED": "SQL 818 BILED projector 2.5 inch motorcycle lamp",
    "Ayoto BILED": "Ayoto 2.5 inch BILED projector motorcycle lamp",
    "Vinyx BILED": "Vinyx MP1 LED mini projector motorcycle lamp",
    "VND Velg Motor": "VND Raceline motorcycle wheel rim",
    "Delkevic Velg Motor": "Delkevic motorcycle wheel rim",
    "Vrossi Velg Motor": "V.Rossi Venom Comet motorcycle wheel rim",
    "RCB Velg Motor": "RCB CT600 CNC motorcycle wheel rim",
    "CMG Velg Motor": "CMG CNC motorcycle wheel rim",
    "RCB Brake System": "RCB S Series motorcycle brake caliper",
    "Racepro Brake System": "Racepro GPX CNC motorcycle brake caliper",
    "KTC Brake System": "KTC Racing motorcycle brake caliper",
    "Brembo Brake System": "Brembo GP4-RX motorcycle brake caliper",
    "Nissin Brake System": "Nissin performance motorcycle brake caliper",
    "Ohlins Shockbreaker": "Öhlins motorcycle rear shock absorber",
    "YSS Shockbreaker": "YSS G-Series motorcycle rear shock absorber",
    "KTC Shockbreaker": "KTC Racing Extreme motorcycle shock absorber",
    "Nitron Shockbreaker": "Nitron R1 motorcycle shock absorber",
    "Ride It Shockbreaker": "Ride It GP Ultimate Gold Series motorcycle shock absorber",
    "Pirelli Motorcycle Tire": "Pirelli Diablo Rosso III motorcycle tire",
    "FDR Motorcycle Tire": "FDR Sport XR motorcycle tire",
    "Mizzle Motorcycle Tire": "Mizzle M77 motorcycle tire",
    "Zeneos Motorcycle Tire": "Zeneos ZN62 motorcycle tire",
    "IRC Motorcycle Tire": "IRC RX-01 motorcycle tire"
}

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/131 Safari/537.36"
}

def slug(name):
    return re.sub(r"[^a-z0-9]+", "_", name.lower()).strip("_")

def download_image(url, path):
    try:
        r = requests.get(url, headers=HEADERS, timeout=15)
        r.raise_for_status()
        content_type = r.headers.get("content-type", "").lower()
        if "image" not in content_type and not r.content[:10].startswith((b"\xff\xd8", b"\x89PNG", b"RIFF")):
            return False

        img = Image.open(BytesIO(r.content)).convert("RGB")
        # Reject tiny icons/placeholders.
        if img.width < 250 or img.height < 250:
            return False

        img.thumbnail((1200, 1200))
        img.save(path, "JPEG", quality=90, optimize=True)
        return True
    except Exception:
        return False

def search_candidates(query, max_results=12):
    try:
        with DDGS() as ddgs:
            results = ddgs.images(
                query=query,
                safesearch="moderate",
                size="Large",
                max_results=max_results,
            )
            return list(results)
    except Exception as e:
        print(f"   Search error: {e}")
        return []

def main():
    print("=" * 65)
    print(" NEXUS PRODUCT IMAGE DOWNLOADER")
    print("=" * 65)
    print(f"Products: {len(QUERIES)}")
    print(f"Output  : {OUT.resolve()}")
    print()

    ok = []
    failed = []

    for i, (name, query) in enumerate(QUERIES.items(), 1):
        target = OUT / f"{slug(name)}.jpg"
        print(f"[{i:02d}/{len(QUERIES)}] {name}")
        print(f"   Query: {query}")

        # Skip only if an existing valid image is already present.
        if target.exists() and target.stat().st_size > 10_000:
            try:
                with Image.open(target) as im:
                    if im.width >= 250 and im.height >= 250:
                        print("   ✓ Already exists")
                        ok.append(name)
                        continue
            except Exception:
                pass

        candidates = search_candidates(query)

        saved = False
        for result in candidates:
            url = result.get("image")
            if not url:
                continue
            if download_image(url, target):
                print(f"   ✓ Saved -> {target.name}")
                ok.append(name)
                saved = True
                break

        if not saved:
            print("   ✗ FAILED - tidak menemukan gambar yang usable")
            failed.append(name)

        time.sleep(0.8)

    print()
    print("=" * 65)
    print(f"SELESAI: {len(ok)} berhasil / {len(failed)} gagal")
    print("=" * 65)

    if failed:
        print("\nProduk yang gagal:")
        for name in failed:
            print(" -", name)
        print("\nJalankan ulang script setelah beberapa saat untuk mencoba lagi.")
    else:
        print("\nSemua gambar berhasil didownload. 🔥")

if __name__ == "__main__":
    main()
