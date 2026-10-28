# Nashi · zarlof Windows çalışması

Bu depo [orkunisitmak/nashi-app](https://github.com/orkunisitmak/nashi-app) projesinin MIT lisanslı kişisel fork'udur. Windows sürümü mevcut WPF/.NET 10 uygulamasını temel alır. Özgün lisans ve üçüncü taraf bildirimleri korunur.

## Kurulum ve kullanım

Windows x64 üzerinde .NET 10 SDK ile:

```powershell
./scripts/Install-Windows.ps1 -Build
```

Varsayılan çıktı, kaynak deponun yanındaki `Nashi` klasörüdür. `-Destination` farklı konum seçer; `-Dotnet` SDK çalıştırıcısının yolunu alır; `-NoShortcuts` kısayol oluşturmayı atlar. Çalıştırmak için çıktıdaki `Nashi.exe` veya masaüstü/Başlat menüsü kısayolu kullanılır. Çıktı kendi .NET çalışma zamanını içerir.

Dosya Gezgini'nde dosyaları seç → sağ tık → **Diğer seçenekleri göster → Gönder → Nashi ile aç**. Birden fazla dosya ve boşluk/Türkçe karakter içeren yollar desteklenir. `Ctrl+O` dosya seçer, `Ctrl+V` panodan alır, `Ctrl+Space` araç çarkını, `Ctrl+2` kütüphaneyi açar.

Medya ve Office araçları ilk açılıştaki kurulumdan, sabitlenmiş SHA-256 doğrulamasıyla indirilir. Görsel/PDF araçları bu ek indirmelerden bağımsızdır. Ayarlar ve kütüphane `%LOCALAPPDATA%\Nashi` altında saklanır. Otomatik başlangıç eklenmez.

Bu fork ayrıca etkileşimsiz `Nashi.exe --setup-tools` komutunu ekler. Medya (FFmpeg/yt-dlp/Deno), Office ve ExifTool bileşenlerini özgün sabitlenmiş indirme/doğrulama koduyla sırayla kurar. İşlem mevcut bileşenleri kullanır; başarıda 0, hatada 1 çıkış kodu verir. Canlı ilerleme ve son durum `%LOCALAPPDATA%\Nashi\tool-setup.json` içindedir. PowerShell'de tamamlanmasını beklemek için `Start-Process ./Nashi.exe -ArgumentList --setup-tools -Wait` kullanılır. Windows'taki kaynak güvenlik taraması da SHA-256 ile sabitlenmiş Gitleaks ZIP paketiyle çalışır.

## Kaynak ve güncelleme

Kişisel kaynak: https://github.com/zarlof/nashi-app. `origin` kişisel depo, `upstream` özgün projedir. Yeni değişiklikleri alırken `git fetch upstream` ve `git merge upstream/main` kullanılır; ardından tekrar derlenir. Uygulamanın özgün imzalı güncelleme kanalı korunur: uygulama içinden resmî güncelleme kurmak kişisel derlemeyi özgün sürümle değiştirebilir. Kişisel fork güncellemeleri bu betikle yeniden derlenir.

Doğrulama: `dotnet run --project windows/Nashi.Verify -c Release`. Gerçek masaüstü testi için `NASHI_SMOKE_DIRECTORY` geçici bir kanıt klasörüne ayarlanıp `Nashi.exe --smoke-test` çalıştırılır. Bu yerel Windows çalışması macOS doğrulaması veya özgün yayıncının resmî sürümü değildir.
