import os
import io
import time
import requests
from PIL import Image
from ddgs import DDGS

OUTPUT_DIR = os.path.join("assets", "products")
os.makedirs(OUTPUT_DIR, exist_ok=True)

PRODUCT_QUERIES = {
    "anker_powercore_20k.jpg": ["Anker PowerCore 20K official product", "Anker PowerCore 20K", "Anker PowerCore 20K Indonesia"],
    "baseus_blade_power_bank.jpg": ["Baseus Blade Power Bank official product", "Baseus Blade Power Bank", "Baseus Blade Power Bank Indonesia"],
    "xiaomi_redmi_note_14.jpg": ["Xiaomi Redmi Note 14 official product", "Xiaomi Redmi Note 14", "Xiaomi Redmi Note 14 Indonesia"],
    "samsung_galaxy_a16.jpg": ["Samsung Galaxy A16 official product", "Samsung Galaxy A16", "Samsung Galaxy A16 Indonesia"],
    "poco_x7.jpg": ["POCO X7 official product", "POCO X7", "POCO X7 Indonesia"],
    "anker_323_charger.jpg": ["Anker 323 Charger official product", "Anker 323 Charger", "Anker 323 Charger Indonesia"],
    "ugreen_nexode_charger.jpg": ["UGREEN Nexode Charger official product", "UGREEN Nexode Charger", "UGREEN Nexode Charger Indonesia"],
    "baseus_usb_c_charger.jpg": ["Baseus USB-C Charger official product", "Baseus USB-C Charger", "Baseus USB-C Charger Indonesia"],
    "apple_airpods_4.jpg": ["Apple AirPods 4 official product", "Apple AirPods 4", "Apple AirPods 4 Indonesia"],
    "samsung_galaxy_buds_fe.jpg": ["Samsung Galaxy Buds FE official product", "Samsung Galaxy Buds FE", "Samsung Galaxy Buds FE Indonesia"],
    "soundcore_r50i.jpg": ["Soundcore R50i official product", "Soundcore R50i", "Soundcore R50i Indonesia"],
    "xiaomi_redmi_watch_5.jpg": ["Xiaomi Redmi Watch 5 official product", "Xiaomi Redmi Watch 5", "Xiaomi Redmi Watch 5 Indonesia"],
    "amazfit_bip_5.jpg": ["Amazfit Bip 5 official product", "Amazfit Bip 5", "Amazfit Bip 5 Indonesia"],
    "samsung_galaxy_watch_fe.jpg": ["Samsung Galaxy Watch FE official product", "Samsung Galaxy Watch FE", "Samsung Galaxy Watch FE Indonesia"],
    "ugreen_usb_hub_5_in_1.jpg": ["UGREEN USB Hub 5-in-1 official product", "UGREEN USB Hub 5-in-1", "UGREEN USB Hub 5-in-1 Indonesia"],
    "baseus_metal_gleam_hub.jpg": ["Baseus Metal Gleam Hub official product", "Baseus Metal Gleam Hub", "Baseus Metal Gleam Hub Indonesia"],
    "samsung_t7_ssd_1tb.jpg": ["Samsung T7 SSD 1TB official product", "Samsung T7 SSD 1TB", "Samsung T7 SSD 1TB Indonesia"],
    "kingston_xs1000_1tb.jpg": ["Kingston XS1000 1TB official product", "Kingston XS1000 1TB", "Kingston XS1000 1TB Indonesia"],
    "wd_my_passport_ssd.jpg": ["WD My Passport SSD official product", "WD My Passport SSD", "WD My Passport SSD Indonesia"],
    "sandisk_extreme_portable_ssd.jpg": ["Sandisk Extreme Portable SSD official product", "Sandisk Extreme Portable SSD", "Sandisk Extreme Portable SSD Indonesia"],
    "uniqlo_airism_t_shirt.jpg": ["Uniqlo Airism T-Shirt official product", "Uniqlo Airism T-Shirt", "Uniqlo Airism T-Shirt Indonesia"],
    "h_m_basic_t_shirt.jpg": ["H&M Basic T-Shirt official product", "H&M Basic T-Shirt", "H&M Basic T-Shirt Indonesia"],
    "nike_sportswear_t_shirt.jpg": ["Nike Sportswear T-Shirt official product", "Nike Sportswear T-Shirt", "Nike Sportswear T-Shirt Indonesia"],
    "adidas_essentials_t_shirt.jpg": ["Adidas Essentials T-Shirt official product", "Adidas Essentials T-Shirt", "Adidas Essentials T-Shirt Indonesia"],
    "erigo_oversized_t_shirt.jpg": ["Erigo Oversized T-Shirt official product", "Erigo Oversized T-Shirt", "Erigo Oversized T-Shirt Indonesia"],
    "erigo_basic_hoodie.jpg": ["Erigo Basic Hoodie official product", "Erigo Basic Hoodie", "Erigo Basic Hoodie Indonesia"],
    "h_m_pullover_hoodie.jpg": ["H&M Pullover Hoodie official product", "H&M Pullover Hoodie", "H&M Pullover Hoodie Indonesia"],
    "uniqlo_sweat_hoodie.jpg": ["Uniqlo Sweat Hoodie official product", "Uniqlo Sweat Hoodie", "Uniqlo Sweat Hoodie Indonesia"],
    "adidas_essentials_hoodie.jpg": ["Adidas Essentials Hoodie official product", "Adidas Essentials Hoodie", "Adidas Essentials Hoodie Indonesia"],
    "nike_club_fleece_hoodie.jpg": ["Nike Club Fleece Hoodie official product", "Nike Club Fleece Hoodie", "Nike Club Fleece Hoodie Indonesia"],
    "levis_trucker_jacket.jpg": ["Levis Trucker Jacket official product", "Levis Trucker Jacket", "Levis Trucker Jacket Indonesia"],
    "uniqlo_utility_jacket.jpg": ["Uniqlo Utility Jacket official product", "Uniqlo Utility Jacket", "Uniqlo Utility Jacket Indonesia"],
    "adidas_windbreaker_jacket.jpg": ["Adidas Windbreaker Jacket official product", "Adidas Windbreaker Jacket", "Adidas Windbreaker Jacket Indonesia"],
    "levis_501_jeans.jpg": ["Levis 501 Jeans official product", "Levis 501 Jeans", "Levis 501 Jeans Indonesia"],
    "uniqlo_slim_fit_jeans.jpg": ["Uniqlo Slim Fit Jeans official product", "Uniqlo Slim Fit Jeans", "Uniqlo Slim Fit Jeans Indonesia"],
    "dickies_work_pants.jpg": ["Dickies Work Pants official product", "Dickies Work Pants", "Dickies Work Pants Indonesia"],
    "nike_air_force_1.jpg": ["Nike Air Force 1 official product", "Nike Air Force 1", "Nike Air Force 1 Indonesia"],
    "adidas_samba_og.jpg": ["Adidas Samba OG official product", "Adidas Samba OG", "Adidas Samba OG Indonesia"],
    "new_balance_530.jpg": ["New Balance 530 official product", "New Balance 530", "New Balance 530 Indonesia"],
    "vans_old_skool.jpg": ["Vans Old Skool official product", "Vans Old Skool", "Vans Old Skool Indonesia"],
    "casio_vintage_a168.jpg": ["Casio Vintage A168 official product", "Casio Vintage A168", "Casio Vintage A168 Indonesia"],
    "g_shock_ga_2100.jpg": ["G-Shock GA-2100 official product", "G-Shock GA-2100", "G-Shock GA-2100 Indonesia"],
    "fossil_minimalist_watch.jpg": ["Fossil Minimalist Watch official product", "Fossil Minimalist Watch", "Fossil Minimalist Watch Indonesia"],
    "herschel_classic_backpack.jpg": ["Herschel Classic Backpack official product", "Herschel Classic Backpack", "Herschel Classic Backpack Indonesia"],
    "eiger_daypack.jpg": ["Eiger Daypack official product", "Eiger Daypack", "Eiger Daypack Indonesia"],
    "fjallraven_kanken.jpg": ["Fjallraven Kanken official product", "Fjallraven Kanken", "Fjallraven Kanken Indonesia"],
    "bellroy_slim_wallet.jpg": ["Bellroy Slim Wallet official product", "Bellroy Slim Wallet", "Bellroy Slim Wallet Indonesia"],
    "levis_leather_wallet.jpg": ["Levis Leather Wallet official product", "Levis Leather Wallet", "Levis Leather Wallet Indonesia"],
    "ray_ban_aviator.jpg": ["Ray-Ban Aviator official product", "Ray-Ban Aviator", "Ray-Ban Aviator Indonesia"],
    "oakley_holbrook.jpg": ["Oakley Holbrook official product", "Oakley Holbrook", "Oakley Holbrook Indonesia"],
    "new_era_9forty_cap.jpg": ["New Era 9FORTY Cap official product", "New Era 9FORTY Cap", "New Era 9FORTY Cap Indonesia"],
    "adidas_baseball_cap.jpg": ["Adidas Baseball Cap official product", "Adidas Baseball Cap", "Adidas Baseball Cap Indonesia"],
    "uniqlo_leather_belt.jpg": ["Uniqlo Leather Belt official product", "Uniqlo Leather Belt", "Uniqlo Leather Belt Indonesia"],
    "timex_weekender.jpg": ["Timex Weekender official product", "Timex Weekender", "Timex Weekender Indonesia"],
    "fossil_bifold_wallet.jpg": ["Fossil Bifold Wallet official product", "Fossil Bifold Wallet", "Fossil Bifold Wallet Indonesia"],
    "herschel_waist_bag.jpg": ["Herschel Waist Bag official product", "Herschel Waist Bag", "Herschel Waist Bag Indonesia"],
    "nike_heritage_waistpack.jpg": ["Nike Heritage Waistpack official product", "Nike Heritage Waistpack", "Nike Heritage Waistpack Indonesia"],
    "oakley_sutro_lite.jpg": ["Oakley Sutro Lite official product", "Oakley Sutro Lite", "Oakley Sutro Lite Indonesia"],
    "casio_mtp_v002.jpg": ["Casio MTP-V002 official product", "Casio MTP-V002", "Casio MTP-V002 Indonesia"],
    "eiger_adventure_hat.jpg": ["Eiger Adventure Hat official product", "Eiger Adventure Hat", "Eiger Adventure Hat Indonesia"],
    "philips_led_bulb_10w.jpg": ["Philips LED Bulb 10W official product", "Philips LED Bulb 10W", "Philips LED Bulb 10W Indonesia"],
    "xiaomi_smart_led_bulb.jpg": ["Xiaomi Smart LED Bulb official product", "Xiaomi Smart LED Bulb", "Xiaomi Smart LED Bulb Indonesia"],
    "philips_table_lamp.jpg": ["Philips Table Lamp official product", "Philips Table Lamp", "Philips Table Lamp Indonesia"],
    "miyako_desk_fan.jpg": ["Miyako Desk Fan official product", "Miyako Desk Fan", "Miyako Desk Fan Indonesia"],
    "cosmos_stand_fan.jpg": ["Cosmos Stand Fan official product", "Cosmos Stand Fan", "Cosmos Stand Fan Indonesia"],
    "xiaomi_smart_fan.jpg": ["Xiaomi Smart Fan official product", "Xiaomi Smart Fan", "Xiaomi Smart Fan Indonesia"],
    "miyako_rice_cooker_1_8l.jpg": ["Miyako Rice Cooker 1.8L official product", "Miyako Rice Cooker 1.8L", "Miyako Rice Cooker 1.8L Indonesia"],
    "cosmos_rice_cooker.jpg": ["Cosmos Rice Cooker official product", "Cosmos Rice Cooker", "Cosmos Rice Cooker Indonesia"],
    "philips_daily_collection_rice_cooker.jpg": ["Philips Daily Collection Rice Cooker official product", "Philips Daily Collection Rice Cooker", "Philips Daily Collection Rice Cooker Indonesia"],
    "midea_vacuum_cleaner.jpg": ["Midea Vacuum Cleaner official product", "Midea Vacuum Cleaner", "Midea Vacuum Cleaner Indonesia"],
    "philips_powerpro_vacuum.jpg": ["Philips PowerPro Vacuum official product", "Philips PowerPro Vacuum", "Philips PowerPro Vacuum Indonesia"],
    "xiaomi_vacuum_cleaner_g20.jpg": ["Xiaomi Vacuum Cleaner G20 official product", "Xiaomi Vacuum Cleaner G20", "Xiaomi Vacuum Cleaner G20 Indonesia"],
    "ikea_kuggis_storage_box.jpg": ["IKEA KUGGIS Storage Box official product", "IKEA KUGGIS Storage Box", "IKEA KUGGIS Storage Box Indonesia"],
    "ikea_samla_storage_box.jpg": ["IKEA SAMLA Storage Box official product", "IKEA SAMLA Storage Box", "IKEA SAMLA Storage Box Indonesia"],
    "ikea_skubb_organizer.jpg": ["IKEA SKUBB Organizer official product", "IKEA SKUBB Organizer", "IKEA SKUBB Organizer Indonesia"],
    "ikea_dvala_bed_sheet.jpg": ["IKEA DVALA Bed Sheet official product", "IKEA DVALA Bed Sheet", "IKEA DVALA Bed Sheet Indonesia"],
    "kintakun_sprei.jpg": ["Kintakun Sprei official product", "Kintakun Sprei", "Kintakun Sprei Indonesia"],
    "maspion_electric_fan.jpg": ["Maspion Electric Fan official product", "Maspion Electric Fan", "Maspion Electric Fan Indonesia"],
    "locknlock_food_container.jpg": ["LocknLock Food Container official product", "LocknLock Food Container", "LocknLock Food Container Indonesia"],
    "tefal_fry_pan.jpg": ["Tefal Fry Pan official product", "Tefal Fry Pan", "Tefal Fry Pan Indonesia"],
}

def download_image(url, timeout=25):
    try:
        r = requests.get(
            url,
            headers={"User-Agent": "Mozilla/5.0"},
            timeout=timeout,
        )
        r.raise_for_status()

        if "image" not in r.headers.get("content-type", "").lower():
            return None

        img = Image.open(io.BytesIO(r.content))
        img.load()

        if img.width < 250 or img.height < 250:
            return None

        img = img.convert("RGB")
        img.thumbnail((1200, 1200))

        out = io.BytesIO()
        img.save(out, "JPEG", quality=92, optimize=True)
        return out.getvalue()

    except Exception:
        return None

def search_images(query):
    for attempt in range(1, 4):
        try:
            with DDGS(timeout=30) as ddgs:
                results = list(
                    ddgs.images(
                        query=query,
                        max_results=12,
                        safesearch="moderate",
                    )
                )
                if results:
                    return results
        except Exception as e:
            print(f"    Search {attempt}/3 gagal: {e}")
            time.sleep(2 * attempt)

    return []

print("=" * 70)
print("NEXUS PRODUCT IMAGE DOWNLOADER - 80 PRODUK BARU")
print("=" * 70)
print(f"Target: {len(PRODUCT_QUERIES)} produk")
print(f"Output: {os.path.abspath(OUTPUT_DIR)}")
print()

success = 0
failed = []

for i, (filename, queries) in enumerate(PRODUCT_QUERIES.items(), 1):
    path = os.path.join(OUTPUT_DIR, filename)
    print(f"[{i:02d}/{len(PRODUCT_QUERIES)}] {filename}")

    if os.path.exists(path) and os.path.getsize(path) > 5000:
        print("  ✓ Sudah ada - skip")
        success += 1
        print()
        continue

    saved = False

    for q_no, query in enumerate(queries, 1):
        print(f"  Query {q_no}: {query}")
        results = search_images(query)

        for result in results:
            for url in (
                result.get("image"),
                result.get("thumbnail"),
                result.get("url"),
            ):
                if not url:
                    continue

                data = download_image(url)

                if data:
                    with open(path, "wb") as f:
                        f.write(data)

                    print(f"  ✓ BERHASIL: {filename}")
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
        print(f"  ✗ MASIH GAGAL: {filename}")

    print()

print("=" * 70)
print(f"SELESAI: {success} berhasil / {len(failed)} gagal")
print("=" * 70)

if failed:
    print("\nYang masih gagal:")
    for item in failed:
        print("  -", item)
    print("\nJangan hapus gambar yang sudah berhasil.")
else:
    print("\n🔥 Semua 80 gambar baru berhasil didownload!")
