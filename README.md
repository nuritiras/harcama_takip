### 2. Frontend (Flutter) Kurulumu

Django sunucusu çalışmaya devam ederken yeni bir terminal penceresi açın.

```bash
# 1. Flutter proje dizinine gidin
cd flutter_klasoru # (Kendi klasör adınızı yazın)

# 2. Gerekli paketleri indirin
flutter pub get

# 3. (ÖNEMLİ) API IP Ayarını Yapın
# lib/api_service.dart dosyasını açın ve 'baseUrl' değişkenini kontrol edin:
# - Android Emülatör kullanıyorsanız: '[http://10.0.2.2:8000/api](http://10.0.2.2:8000/api)'
# - iOS Simülatör kullanıyorsanız: '[http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)'
# - Gerçek cihaz kullanıyorsanız: Bilgisayarınızın yerel IP adresini (örn: 192.168.1.X) girin.

# 4. Uygulamayı çalıştırın
flutter run
```

---

## 📡 API Uç Noktaları (Endpoints)

Uygulamanın arka planında çalışan REST API rotaları şunlardır:

| Metot | Uç Nokta (Endpoint) | Açıklama | Yetki |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/token-al/` | Kullanıcı adı ve şifre ile sisteme giriş yapıp Token alır. | Herkese Açık |
| `GET` | `/api/harcamalar/` | Giriş yapmış kullanıcının harcamalarını listeler. | Token Gerekli |
| `POST` | `/api/harcamalar/` | Yeni bir harcama ekler. | Token Gerekli |
| `PUT` | `/api/harcamalar/<id>/` | Belirli bir harcamayı günceller. | Token Gerekli |
| `DELETE` | `/api/harcamalar/<id>/` | Belirli bir harcamayı siler. | Token Gerekli |

---

## 📸 Ekran Görüntüleri

<img width="484" height="886" alt="Ekran Resmi 2026-03-21 00 53 52" src="https://github.com/user-attachments/assets/04f7c9fa-8f61-4e49-a794-ff164a95bdc7" />
<img width="484" height="886" alt="Ekran Resmi 2026-03-21 00 54 39" src="https://github.com/user-attachments/assets/ad2321a1-870c-45df-abb1-ee083b9c0b59" />
<img width="484" height="886" alt="Ekran Resmi 2026-03-21 00 55 07" src="https://github.com/user-attachments/assets/320b474f-aded-46f4-9261-289576bc0a08" />

---

**Geliştirici:** [Senin Adın/Kullanıcı Adın]  
Herhangi bir sorunuz veya katkınız olursa iletişime geçmekten çekinmeyin!
```

---
