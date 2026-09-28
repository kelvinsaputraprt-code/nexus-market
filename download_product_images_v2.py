import os
import io
import time
import requests
from PIL import Image
from ddgs import DDGS

OUTPUT_DIR = os.path.join('assets', 'products')
os.makedirs(OUTPUT_DIR, exist_ok=True)

FAILED_PRODUCTS = {
    'steelseries_rival_3.jpg': ['SteelSeries Rival 3 gaming mouse official', 'SteelSeries Rival 3 mouse', 'SteelSeries Rival 3 black mouse'],
    'logitech_g_pro.jpg': ['Logitech G Pro gaming mouse official', 'Logitech G Pro mouse', 'Logitech G Pro wireless mouse'],
    'aes_biled.jpg': ['AES Biled motorcycle lamp', 'AES BILED lamp motor', 'lampu AES Biled motor'],
    'cr7_biled.jpg': ['CR7 Biled motorcycle lamp', 'CR7 BILED lamp motor', 'lampu CR7 Biled motor'],
    'rcb_velg_motor.jpg': ['RCB motorcycle wheel rim official', 'RCB velg motor', 'RCB racing motorcycle rim'],
    'cmg_velg_motor.jpg': ['CMG motorcycle wheel rim', 'CMG velg motor', 'CMG racing motorcycle rim'],
    'racepro_brake_system.jpg': ['Racepro motorcycle brake system', 'Racepro brake caliper motorcycle', 'Racepro rem motor'],
    'ktc_brake_system.jpg': ['KTC motorcycle brake system', 'KTC brake caliper motorcycle', 'KTC rem motor'],
    'nissin_brake_system.jpg': ['Nissin motorcycle brake system official', 'Nissin brake caliper motorcycle', 'Nissin motorcycle brake'],
    'ohlins_shockbreaker.jpg': ['Ohlins motorcycle shock absorber official', 'Ohlins motorcycle rear shock', 'Ohlins shockbreaker motor'],
    'ktc_shockbreaker.jpg': ['KTC motorcycle shock absorber', 'KTC shockbreaker motor', 'KTC rear shock motorcycle'],
    'ride_it_shockbreaker.jpg': ['Ride It motorcycle shock absorber', 'Ride It shockbreaker motor', 'Ride It rear shock motorcycle'],
    'pirelli_motorcycle_tire.jpg': ['Pirelli motorcycle tire official', 'Pirelli Diablo Rosso III motorcycle tire', 'Pirelli motorcycle tyre'],
    'fdr_motorcycle_tire.jpg': ['FDR motorcycle tire official', 'FDR Sport XR motorcycle tire', 'FDR motorcycle tyre'],
}

def download_image(url, timeout=25):
    try:
        r = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'}, timeout=timeout)
        r.raise_for_status()
        if 'image' not in r.headers.get('content-type', '').lower():
            return None
        img = Image.open(io.BytesIO(r.content))
        img.load()
        if img.width < 250 or img.height < 250:
            return None
        img = img.convert('RGB')
        img.thumbnail((1200, 1200))
        out = io.BytesIO()
        img.save(out, 'JPEG', quality=92, optimize=True)
        return out.getvalue()
    except Exception:
        return None

def search_images(query):
    for attempt in range(1, 4):
        try:
            with DDGS(timeout=30) as ddgs:
                results = list(ddgs.images(query=query, max_results=12, safesearch='moderate'))
                if results:
                    return results
        except Exception as e:
            print(f'    Search attempt {attempt}/3 gagal: {e}')
            time.sleep(2 * attempt)
    return []

print('=' * 65)
print('NEXUS PRODUCT IMAGE DOWNLOADER V2')
print('14 PRODUK YANG SEBELUMNYA GAGAL')
print('=' * 65)
print(f'Output: {os.path.abspath(OUTPUT_DIR)}\n')

success = 0
failed = []

for index, (filename, queries) in enumerate(FAILED_PRODUCTS.items(), 1):
    path = os.path.join(OUTPUT_DIR, filename)
    print(f'[{index}/14] {filename}')

    if os.path.exists(path) and os.path.getsize(path) > 5000:
        print('  ✓ Sudah ada - skip')
        success += 1
        print()
        continue

    saved = False

    for q_index, query in enumerate(queries, 1):
        print(f'  🔎 Query {q_index}: {query}')
        results = search_images(query)

        for result in results:
            for url in [result.get('image'), result.get('thumbnail'), result.get('url')]:
                if not url:
                    continue
                data = download_image(url)
                if data:
                    with open(path, 'wb') as f:
                        f.write(data)
                    print(f'  ✓ BERHASIL: {filename}')
                    saved = True
                    break
            if saved:
                break

        if saved:
            break
        time.sleep(1.5)

    if saved:
        success += 1
    else:
        failed.append(filename)
        print(f'  ✗ MASIH GAGAL: {filename}')
    print()

print('=' * 65)
print(f'SELESAI: {success} berhasil / {len(failed)} gagal')
print('=' * 65)

if failed:
    print('\nMasih gagal:')
    for item in failed:
        print('  -', item)
    print('\nJangan hapus gambar yang sudah berhasil.')
else:
    print('\n🔥 Semua 14 gambar berhasil!')
