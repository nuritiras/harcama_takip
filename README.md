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

*(Projenizi GitHub'a yüklediğinizde, uygulamanızın ekran görüntülerini "Giriş Ekranı", "Harcama Listesi" ve "Ekleme Formu" olacak şekilde klasörünüze ekleyip bu kısımda sergileyebilirsiniz. Örnek kullanım: `![Giriş Ekranı](assets/login.png)` )*

---

**Geliştirici:** [Senin Adın/Kullanıcı Adın]  
Herhangi bir sorunuz veya katkınız olursa iletişime geçmekten çekinmeyin!
```

---
