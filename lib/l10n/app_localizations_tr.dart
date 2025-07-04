// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Pamuk Desktop';

  @override
  String get appSubtitle => 'Android Adware Kaldırma Aracı';

  @override
  String get connectToDevice => 'Cihaza Bağlan';

  @override
  String get disconnect => 'Bağlantıyı Kes';

  @override
  String get connected => 'Bağlandı';

  @override
  String get connecting => 'Bağlanıyor...';

  @override
  String get disconnected => 'Bağlantı Kesildi';

  @override
  String get error => 'Hata';

  @override
  String get catalogueMode => 'Katalog Modu';

  @override
  String get hunterMode => 'Avcı Modu';

  @override
  String get appListMode => 'Uygulama Listesi';

  @override
  String get searchApps => 'Uygulama ara...';

  @override
  String get refreshApps => 'Uygulamaları Yenile';

  @override
  String get uninstall => 'Kaldır';

  @override
  String get backup => 'Yedekle';

  @override
  String get installedApps => 'Yüklü Uygulamalar';

  @override
  String get adwareApps => 'Adware Uygulamaları';

  @override
  String get currentApp => 'Mevcut Uygulama';

  @override
  String get version => 'Sürüm';

  @override
  String get installDate => 'Yükleme Tarihi';

  @override
  String get updateDate => 'Güncelleme Tarihi';

  @override
  String get packageName => 'Paket Adı';

  @override
  String get adbNotFound => 'ADB bulunamadı';

  @override
  String get adbNotFoundDescription =>
      'Lütfen Android SDK platform araçlarını yükleyin ve ADB\'yi PATH\'e ekleyin';

  @override
  String get noDeviceConnected => 'Bağlı cihaz yok';

  @override
  String get noDeviceConnectedDescription =>
      'Lütfen USB hata ayıklama etkin bir Android cihaz bağlayın';

  @override
  String get deviceUnauthorized => 'Cihaz yetkisiz';

  @override
  String get deviceUnauthorizedDescription =>
      'Lütfen Android cihazınızda USB hata ayıklamasına izin verin';

  @override
  String get loadingApps => 'Uygulamalar yükleniyor...';

  @override
  String get noAppsFound => 'Uygulama bulunamadı';

  @override
  String get uninstallSuccess => 'Uygulama başarıyla kaldırıldı';

  @override
  String get uninstallError => 'Uygulama kaldırılamadı';

  @override
  String get backupSuccess => 'Uygulama başarıyla yedeklendi ve kaldırıldı';

  @override
  String get backupError => 'Uygulama yedeklenemedi ve kaldırılamadı';

  @override
  String get selectBackupLocation => 'Yedekleme konumunu seçin';

  @override
  String get hunterModeDescription =>
      'Avcı modu şu anda çalışan uygulamayı izler ve adware olup olmadığını kontrol eder';

  @override
  String get catalogueModeDescription =>
      'Katalog modu katalogdaki tüm bilinen adware uygulamalarını gösterir';

  @override
  String get appListModeDescription =>
      'Uygulama listesi modu cihazdaki tüm yüklü uygulamaları gösterir';

  @override
  String get settings => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get english => 'İngilizce';

  @override
  String get turkish => 'Türkçe';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutDescription =>
      'Pamuk Desktop, Android adware uygulamalarını tespit etmek ve kaldırmak için geliştirilmiş bir Flutter uygulamasıdır.';

  @override
  String get device => 'Cihaz';

  @override
  String get restartAdbServer => 'ADB Sunucusunu Yeniden Başlat';

  @override
  String get troubleshooting => 'Sorun Giderme';

  @override
  String get troubleshootingTitle => 'Bağlantı Sorun Giderme';

  @override
  String get troubleshootingDescription =>
      'Android cihazınıza bağlanmakta sorun yaşıyorsanız, lütfen şunları kontrol edin:';

  @override
  String get adbInstallation => '1. ADB Kurulumu:';

  @override
  String get installAndroidSDK =>
      '   • Android SDK platform araçlarını yükleyin';

  @override
  String get addAdbToPath => '   • ADB\'yi sistem PATH\'ine ekleyin';

  @override
  String get testAdbDevices => '   • Şu komutla test edin: adb devices';

  @override
  String get deviceSettings => '2. Cihaz Ayarları:';

  @override
  String get enableDeveloperOptions =>
      '   • Geliştirici Seçeneklerini etkinleştirin';

  @override
  String get enableUsbDebugging => '   • USB Hata Ayıklamasını etkinleştirin';

  @override
  String get setUsbMode =>
      '   • USB modunu Dosya Aktarımı (MTP) olarak ayarlayın';

  @override
  String get connectionTroubleshooting => '3. Bağlantı:';

  @override
  String get useQualityUSBCable => '   • Kaliteli bir USB kablosu kullanın';

  @override
  String get tryDifferentPorts => '   • Farklı USB portlarını deneyin';

  @override
  String get acceptUsbDialog =>
      '   • Cihazdaki USB hata ayıklama iletişim kutusunu kabul edin';

  @override
  String get permissions => '4. İzinler:';

  @override
  String get runAsAdmin =>
      '   • Bu uygulamayı yönetici olarak çalıştırın (gerekirse)';

  @override
  String get checkUsbAuthorization =>
      '   • USB hata ayıklama yetkilendirmesini kontrol edin';

  @override
  String get close => 'Kapat';

  @override
  String get mode => 'Mod';

  @override
  String get hunterModeActive => 'Avcı Modu Aktif';

  @override
  String get monitoringCurrentApp =>
      'Cihazınızdaki mevcut ön plan uygulaması izleniyor.';

  @override
  String get howItWorks => 'Nasıl çalışır:';

  @override
  String get step1 => '1. Android cihazınızda herhangi bir uygulamayı açın';

  @override
  String get step2 => '2. Uygulama tespit edilecek ve aşağıda gösterilecek';

  @override
  String get step3 => '3. Şüpheli uygulamaları hemen kaldırmayı seçebilirsiniz';

  @override
  String get step4 =>
      '4. Kaldırılan uygulamalar otomatik olarak kataloğa eklenir';

  @override
  String get waitingForApp => 'Uygulama tespiti bekleniyor...';

  @override
  String get openAnyApp => 'Android cihazınızda herhangi bir uygulamayı açın';

  @override
  String get uninstallApp => 'Uygulamayı Kaldır';

  @override
  String confirmUninstall(String appName) {
    return '\"$appName\" uygulamasını kaldırmak istediğinizden emin misiniz?';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get uninstallNow => 'Şimdi Kaldır';

  @override
  String get backupAndUninstall => 'Yedekle ve Kaldır';

  @override
  String get scanningAdware => 'Adware paketleri taranıyor...';

  @override
  String get deviceClean =>
      'Cihazınız temiz görünüyor. Bilinen hiçbir adware paketi tespit edilmedi.';

  @override
  String get switchToHunterMode => 'Avcı Moduna Geç';

  @override
  String get uninstallAll => 'Tümünü Kaldır';

  @override
  String get uninstallAllAdware => 'Tüm Adware\'leri Kaldır';

  @override
  String uninstalledPackages(int count) {
    return '$count paket kaldırıldı';
  }

  @override
  String get loadingAppsMessage => 'Yüklü uygulamalar yükleniyor...';

  @override
  String appsCount(int count) {
    return '$count uygulama';
  }

  @override
  String get noAppsFoundSearch => 'Uygulama bulunamadı';

  @override
  String get adjustSearchTerms => 'Arama terimlerinizi ayarlamayı deneyin';

  @override
  String get tryRefreshing => 'Uygulama listesini yenilemeyi deneyin';

  @override
  String get refresh => 'Yenile';

  @override
  String get details => 'Detaylar';

  @override
  String get appDetails => 'Uygulama Detayları';

  @override
  String confirmUninstallAll(int count) {
    return 'Tüm $count adware uygulamasını kaldırmak istediğinizden emin misiniz?';
  }

  @override
  String get noAdwareFound => 'Adware bulunamadı!';

  @override
  String get adwareDetected => 'Adware Tespit Edildi!';

  @override
  String suspiciousPackagesFound(int count) {
    return '$count şüpheli paket bulundu';
  }

  @override
  String get thisActionCannotBeUndone => 'Bu işlem geri alınamaz.';

  @override
  String successfullyUninstalled(String appName) {
    return '$appName başarıyla kaldırıldı';
  }

  @override
  String failedToUninstall(String appName) {
    return '$appName kaldırılamadı';
  }

  @override
  String backupApkMessage(String appName) {
    return 'Bu, \"$appName\" için APK dosyasını yedekleyecek ve ardından kaldıracaktır.\n\nAPK, apk_backups klasörüne kaydedilecektir.';
  }

  @override
  String successfullyBackedUpAndUninstalled(String appName) {
    return '$appName başarıyla yedeklendi ve kaldırıldı';
  }

  @override
  String failedToBackupAndUninstall(String appName) {
    return '$appName yedeklenemedi ve kaldırılamadı';
  }

  @override
  String get unknown => 'Bilinmeyen';

  @override
  String get package => 'Paket';

  @override
  String get installed => 'Yüklendi';

  @override
  String get updated => 'Güncellendi';

  @override
  String get suspicious => 'ŞÜPHELİ';

  @override
  String knownSuspiciousApp(String category) {
    return 'Bilinen $category uygulama!';
  }

  @override
  String get contributeToRepository => 'Depoya Katkıda Bulun';

  @override
  String packageAddedToCatalogue(String packageName, String category) {
    return '$packageName paketi kataloga \'$category\' kategorisi altında eklendi.';
  }

  @override
  String get considerContributing =>
      'Bu paketin resmi depoya dahil edilmesine yardımcı olmak için lütfen github.com/gAtrium/pamuk adresinde bir sorun açmayı düşünün.';

  @override
  String get openGitHub => 'GitHub\'ı Aç';

  @override
  String get notNow => 'Şimdi Değil';
}
