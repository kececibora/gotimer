class AppStrings {
  // 5 dil: Türkçe, İngilizce, Japonca, Korece, Çince
  static const supportedLanguages = ['tr', 'en', 'ja', 'ko', 'zh', 'de', 'fr', 'es', 'it', 'ru', 'th'];

  static const Map<String, Map<String, String>> _values = {
    'tr': {
      'appSubtitle': 'Go Maç Saati',
      'timeSystemTitle': 'Zaman Sistemi',

      'byoyomiTitle': 'Japon Byoyomi',
      'byoyomiDesc': 'Ana Süre + Japon Byoyomi Hakkı x Süre',

      'canadaTitle': 'Kanada Byoyomi',
      'canadaDesc': 'Ana Süre + Süre / Hamle Sayısı',

      'simpleTitle': 'Basit Zaman',
      'simpleDesc': 'Ana Süre (Ek süre yok)',

      'fischerTitle': 'Fischer',
      'fischerDesc': 'Ana Süre + Her Hamlede Ek Süre',
      'incrementTime': 'Ek Süre (Her Hamle)',
      'timerFischerInfo': 'Ek Süre: +{seconds} sn / hamle',

      'settingsDifferent': 'Farklı Ayar Kullan',
      'settingsBlack': 'Siyah',
      'settingsWhite': 'Beyaz',

      'mainTime': 'Ana Süre',
      'byoyomiTime': 'Byoyomi Süresi',
      'canadaMoveCount': 'Hamle Sayısı (Kanada Byoyomi)',
      'japanByoCount': 'Japon Byoyomi Hakkı (Adet)',

      'btnStart': 'Başlat',

      'dialogPickTime': 'Süre Seç',
      'dialogPick': 'Seç',
      'cancel': 'İptal',
      'ok': 'Tamam',

      'moves': 'Hamle',
      'won': 'Kazandı!',
      'backToHome': 'Ana Sayfa',
      'sureTitle': 'Emin misin?',
      'sureHomeMsg': 'Ana sayfaya dönersen mevcut oyun/süre durumu kaybolabilir. Devam edilsin mi?',
      'liveSettingsTitle': 'Canlı Ayarlar',
      'remaining': 'Kalan',
      'settingsTitle': '{system} Ayarları',
      'timerJapanInfo': 'Byoyomi: {count} Hak | {seconds} sn',
      'timerCanadaInfo': 'Kalan Hamle: {count} | {seconds} sn',
      'unitHour': 'sa',
      'unitMinute': 'dk',
      'unitSecond': 'sn',

      // Info bottom sheet
      'infoTitle': 'Hakkında',
      'infoSoftware': 'Yazılım:',
      'infoDesign': 'Tasarım:',
      'infoThanks': 'Destekleri için teşekkürler:',
      'helpTitle': 'Go Match Timer Nasıl Kullanılır?',
      'helpGoalTitle': '🎯 Amaç',
      'helpGoalText':
          'Go Match Timer, Go / Baduk / Weiqi turnuvalarında kullanılan resmi zaman sistemlerini '
          'doğru ve sade bir şekilde uygulamak için tasarlanmıştır.',

      'helpHomeTitle': '🕹 Anasayfa',
      'helpHomeB1': 'Japon Byoyomi, Kanada Byoyomi veya Basit Zaman seçilir.',
      'helpHomeB2': 'Dil butonu ile arayüz dili değiştirilebilir.',
      'helpHomeB3': 'Bilgi (?) butonu uygulama hakkında detay verir.',

      'helpSystemsTitle': '⏱ Zaman Sistemleri',
      'helpSystemsB1': 'Basit Zaman: Süre bittiğinde oyun sona erer.',
      'helpSystemsB2': 'Japon Byoyomi: Ana süre bittikten sonra her hak için sabit süre verilir.',
      'helpSystemsB3': 'Kanada Byoyomi: Belirli sayıda hamle, sabit süre içinde oynanır.',

      'helpGameTitle': '▶️ Oyun Ekranı',
      'helpGameB1': 'Ekranın tamamına dokunmak hamleyi karşı tarafa geçirir.',
      'helpGameB2': 'Orta çubukta başlat / durdur ve ses kontrolü bulunur.',
      'helpGameB3': 'Üst ve alt oyuncu alanları otomatik döner.',

      'helpSoundTitle': '🔊 Ses Uyarıları',
      'helpSoundB1': 'Son 10 saniyede uyarı sesi çalar.',
      'helpSoundB2': 'Ses butonu ile açılıp kapatılabilir.',

      'helpEndTitle': '🏁 Oyun Sonu',
      'helpEndB1': 'Süre veya haklar bittiğinde kazanan otomatik belirlenir.',
      'helpEndB2': 'Ana sayfaya tek tuşla dönülebilir.',

      'helpOutro':
          'Go Match Timer turnuva masasında hızlı, sade ve dikkat dağıtmayan bir kullanım '
          'sunmak için tasarlanmıştır.',

      'helpDisclaimerTitle': '⚠️ Sorumluluk Reddi',
      'helpDisclaimerP1':
          'Bu uygulama yalnızca zaman takibini kolaylaştırmak amacıyla geliştirilmiştir. '
          'Uygulamanın kullanımı sırasında oluşabilecek zamanlama hataları, '
          'oyun sonuçları, turnuva kararları veya anlaşmazlıklardan geliştirici sorumlu değildir.',
      'helpDisclaimerP2':
          'Resmî turnuvalarda kullanılmadan önce organizatör onayı alınması önerilir. '
          'Zaman ayarlarının doğruluğunu kontrol etmek ve uygulamayı uygun şekilde kullanmak '
          'tamamen kullanıcının sorumluluğundadır.',
    },

    'en': {
      'appSubtitle': 'Go Game Clock',
      'timeSystemTitle': 'Time System',

      'byoyomiTitle': 'Japanese Byoyomi',
      'byoyomiDesc': 'Main Time + Japanese Byoyomi Periods × Time',

      'canadaTitle': 'Canadian Byoyomi',
      'canadaDesc': 'Main Time + Time / Move Count',

      'simpleTitle': 'Simple Time (Sudden Death)',
      'simpleDesc': 'Main Time (no extra period)',

      'fischerTitle': 'Fischer',
      'fischerDesc': 'Main Time + Increment Per Move',
      'incrementTime': 'Increment (Per Move)',
      'timerFischerInfo': 'Increment: +{seconds}s / move',

      'settingsDifferent': 'Use Different Settings',
      'settingsBlack': 'Black',
      'settingsWhite': 'White',

      'mainTime': 'Main Time',
      'byoyomiTime': 'Byoyomi Time',
      'canadaMoveCount': 'Move Count (Canadian Byoyomi)',
      'japanByoCount': 'Japanese Byoyomi Periods',

      'btnStart': 'Start',

      'dialogPickTime': 'Pick Time',
      'dialogPick': 'Pick',
      'cancel': 'Cancel',
      'ok': 'OK',

      'moves': 'Moves',
      'won': 'Won!',
      'backToHome': 'Home',
      'sureTitle': 'Are you sure?',
      'sureHomeMsg': 'If you go back to Home, the current game/timer state may be lost. Continue?',
      'liveSettingsTitle': 'Live Settings',
      'remaining': 'Remaining',
      'settingsTitle': '{system} Settings',
      'timerJapanInfo': 'Byoyomi: {count} periods | {seconds}s',
      'timerCanadaInfo': 'Moves left: {count} | {seconds}s',
      'unitHour': 'h',
      'unitMinute': 'm',
      'unitSecond': 's',

      'infoTitle': 'About',
      'infoSoftware': 'Software:',
      'infoDesign': 'Design:',
      'infoThanks': 'Special thanks to:',
      'helpTitle': 'How to Use Go Match Timer?',
      'helpGoalTitle': '🎯 Purpose',
      'helpGoalText':
          'Go Match Timer is designed to apply official timing systems used in Go / Baduk / Weiqi tournaments '
          'in a simple and accurate way.',

      'helpHomeTitle': '🕹 Home',
      'helpHomeB1': 'Choose Japanese Byoyomi, Canadian Byoyomi, or Simple Time.',
      'helpHomeB2': 'Use the language button to change the UI language.',
      'helpHomeB3': 'The info (?) button shows app details.',

      'helpSystemsTitle': '⏱ Time Systems',
      'helpSystemsB1': 'Simple Time: The game ends when time runs out.',
      'helpSystemsB2': 'Japanese Byoyomi: After main time ends, each period gives a fixed amount of time.',
      'helpSystemsB3': 'Canadian Byoyomi: Play a certain number of moves within a fixed time.',

      'helpGameTitle': '▶️ Game Screen',
      'helpGameB1': 'Tap anywhere on the screen to pass the turn to the opponent.',
      'helpGameB2': 'The middle bar contains start/pause and sound control.',
      'helpGameB3': 'Top and bottom player areas rotate automatically.',

      'helpSoundTitle': '🔊 Sound Alerts',
      'helpSoundB1': 'A warning beep plays in the last 10 seconds.',
      'helpSoundB2': 'Sound can be toggled on/off with the sound button.',

      'helpEndTitle': '🏁 End of Game',
      'helpEndB1': 'When time or periods run out, the winner is determined automatically.',
      'helpEndB2': 'You can return to the home screen with one tap.',

      'helpOutro': 'Go Match Timer is designed to be fast, clean, and distraction-free at the tournament table.',

      'helpDisclaimerTitle': '⚠️ Disclaimer',
      'helpDisclaimerP1':
          'This app is developed only to help track time. The developer is not responsible for timing errors, '
          'game results, tournament decisions, or disputes that may occur while using the app.',
      'helpDisclaimerP2':
          'Before using it in official tournaments, organizer approval is recommended. Checking time settings '
          'and using the app properly is entirely the user’s responsibility.',
    },

    'ja': {
      'appSubtitle': 'Go 対局時計',
      'timeSystemTitle': '時間設定',

      'byoyomiTitle': '秒読み',
      'byoyomiDesc': '持ち時間 ＋ 秒読み回数 × 秒数',

      'canadaTitle': 'カナダ秒読み',
      'canadaDesc': '持ち時間 ＋ 手数／時間',

      'simpleTitle': '単純時間',
      'simpleDesc': '持ち時間のみ（追加時間なし）',

      'fischerTitle': 'フィッシャー',
      'fischerDesc': '持ち時間 + 1手ごとの加算',
      'incrementTime': '加算時間（1手ごと）',
      'timerFischerInfo': '加算: +{seconds}秒 / 手',

      'settingsDifferent': '別の設定を使用',
      'settingsBlack': '黒番',
      'settingsWhite': '白番',

      'mainTime': '持ち時間',
      'byoyomiTime': '秒読み時間',
      'canadaMoveCount': '手数（カナダ秒読み）',
      'japanByoCount': '秒読み回数',

      'btnStart': '開始',

      'dialogPickTime': '時間を選択',
      'dialogPick': '選択',
      'cancel': 'キャンセル',
      'ok': 'OK',

      'moves': '手数',
      'won': '勝ち！',
      'backToHome': 'ホーム',
      'sureTitle': '本当によろしいですか？',
      'sureHomeMsg': 'ホームに戻ると現在の対局/タイマー状態が失われる可能性があります。続行しますか？',
      'liveSettingsTitle': 'ライブ設定',
      'remaining': '残り',
      'settingsTitle': '{system} 設定',
      'timerJapanInfo': '秒読み: {count} 回 | {seconds} 秒',
      'timerCanadaInfo': '残り手数: {count} | {seconds} 秒',
      'unitHour': '時間',
      'unitMinute': '分',
      'unitSecond': '秒',

      'infoTitle': '情報',
      'infoSoftware': 'ソフトウェア:',
      'infoDesign': 'デザイン:',
      'infoThanks': 'ご協力ありがとうございます：',
    },

    'ko': {
      'appSubtitle': 'Go 대국 시계',
      'timeSystemTitle': '시간 설정',

      'byoyomiTitle': '일본식 초읽기',
      'byoyomiDesc': '기본 시간 + 일본식 초읽기 횟수 × 시간',

      'canadaTitle': '캐나다 초읽기',
      'canadaDesc': '기본 시간 + 일정 수의 수 / 시간',

      'simpleTitle': '단순 시간',
      'simpleDesc': '기본 시간만 사용 (추가 시간 없음)',

      'fischerTitle': '피셔',
      'fischerDesc': '기본 시간 + 착수마다 추가',
      'incrementTime': '추가 시간(착수마다)',
      'timerFischerInfo': '추가: +{seconds}초 / 착수',

      'settingsDifferent': '흑/백 다른 설정 사용',
      'settingsBlack': '흑',
      'settingsWhite': '백',

      'mainTime': '기본 시간',
      'byoyomiTime': '초읽기 시간',
      'canadaMoveCount': '수(캐나다 초읽기)',
      'japanByoCount': '초읽기 횟수',

      'btnStart': '시작',

      'dialogPickTime': '시간 선택',
      'dialogPick': '선택',
      'cancel': '취소',
      'ok': '확인',

      'moves': '수',
      'won': '승리!',
      'backToHome': '홈',
      'sureTitle': '정말로 하시겠습니까?',
      'sureHomeMsg': '홈으로 돌아가면 현재 대국/타이머 상태가 사라질 수 있습니다. 계속할까요?',
      'liveSettingsTitle': '라이브 설정',
      'remaining': '남은',
      'settingsTitle': '{system} 설정',
      'timerJapanInfo': '초읽기: {count}회 | {seconds}초',
      'timerCanadaInfo': '남은 수: {count} | {seconds}초',
      'unitHour': '시간',
      'unitMinute': '분',
      'unitSecond': '초',

      'infoTitle': '정보',
      'infoSoftware': '소프트웨어:',
      'infoDesign': '디자인:',
      'infoThanks': '도움에 감사드립니다:',
    },

    'zh': {
      'appSubtitle': 'Go 对局计时器',
      'timeSystemTitle': '时间设置',

      'byoyomiTitle': '日本读秒',
      'byoyomiDesc': '基本时间 + 日本读秒次数 × 秒数',

      'canadaTitle': '加拿大读秒',
      'canadaDesc': '基本时间 + 每若干手用时',

      'simpleTitle': '简单计时',
      'simpleDesc': '只有基本时间（无追加时间）',

      'fischerTitle': '费舍尔',
      'fischerDesc': '基本时间 + 每步加时',
      'incrementTime': '加时（每步）',
      'timerFischerInfo': '加时: +{seconds}秒 / 步',

      'settingsDifferent': '黑白使用不同设置',
      'settingsBlack': '黑方',
      'settingsWhite': '白方',

      'mainTime': '基本时间',
      'byoyomiTime': '读秒时间',
      'canadaMoveCount': '手数（加拿大读秒）',
      'japanByoCount': '读秒次数',

      'btnStart': '开始',

      'dialogPickTime': '选择时间',
      'dialogPick': '选择',
      'cancel': '取消',
      'ok': '确定',

      'moves': '手数',
      'won': '获胜！',
      'backToHome': '首页',
      'sureTitle': '确定要继续吗？',
      'sureHomeMsg': '返回首页可能会丢失当前对局/计时状态。要继续吗？',
      'liveSettingsTitle': '实时设置',
      'remaining': '剩余',
      'settingsTitle': '{system} 设置',
      'timerJapanInfo': '读秒：{count} 次 | {seconds} 秒',
      'timerCanadaInfo': '剩余手数：{count} | {seconds} 秒',
      'unitHour': '时',
      'unitMinute': '分',
      'unitSecond': '秒',

      'infoTitle': '关于',
      'infoSoftware': '软件：',
      'infoDesign': '设计：',
      'infoThanks': '特别感谢：',
    },
    'de': {
      'appSubtitle': 'Go Spieluhr',
      'timeSystemTitle': 'Zeitsystem',

      'byoyomiTitle': 'Japanisches Byoyomi',
      'byoyomiDesc': 'Hauptzeit + Japanische Byoyomi-Perioden × Zeit',

      'canadaTitle': 'Kanadisches Byoyomi',
      'canadaDesc': 'Hauptzeit + Zeit / Zuganzahl',

      'simpleTitle': 'Einfache Zeit',
      'simpleDesc': 'Nur Hauptzeit (keine Zusatzzeit)',

      'fischerTitle': 'Fischer',
      'fischerDesc': 'Grundzeit + Inkrement pro Zug',
      'incrementTime': 'Inkrement (pro Zug)',
      'timerFischerInfo': 'Inkrement: +{seconds}s / Zug',

      'settingsDifferent': 'Unterschiedliche Einstellungen verwenden',
      'settingsBlack': 'Schwarz',
      'settingsWhite': 'Weiß',

      'mainTime': 'Hauptzeit',
      'byoyomiTime': 'Byoyomi-Zeit',
      'canadaMoveCount': 'Zuganzahl (Kanadisches Byoyomi)',
      'japanByoCount': 'Japanische Byoyomi-Perioden',

      'btnStart': 'Start',

      'dialogPickTime': 'Zeit wählen',
      'dialogPick': 'Wählen',
      'cancel': 'Abbrechen',
      'ok': 'OK',

      'moves': 'Züge',
      'won': 'Gewonnen!',
      'backToHome': 'Startseite',
      'sureTitle': 'Bist du sicher?',
      'sureHomeMsg': 'Wenn du zur Startseite zurückkehrst, kann der aktuelle Spiel-/Timer-Stand verloren gehen. Fortfahren?',
      'liveSettingsTitle': 'Live-Einstellungen',
      'remaining': 'Verbleibend',
      'settingsTitle': '{system}-Einstellungen',
      'timerJapanInfo': 'Byoyomi: {count} Perioden | {seconds}s',
      'timerCanadaInfo': 'Verbleibende Züge: {count} | {seconds}s',
      'unitHour': 'Std',
      'unitMinute': 'Min',
      'unitSecond': 'Sek',

      'infoTitle': 'Über',
      'infoSoftware': 'Software:',
      'infoDesign': 'Design:',
      'infoThanks': 'Besonderer Dank:',
      'helpTitle': 'Wie benutzt man Go Match Timer?',
      'helpGoalTitle': '🎯 Zweck',
      'helpGoalText':
          'Go Match Timer wurde entwickelt, um offizielle Zeitregelsysteme '
          'für Go / Baduk / Weiqi Turniere einfach und korrekt anzuwenden.',

      'helpHomeTitle': '🕹 Startseite',
      'helpHomeB1': 'Japanisches Byoyomi, Kanadisches Byoyomi oder Einfache Zeit auswählen.',
      'helpHomeB2': 'Die Sprache kann über die Sprachschaltfläche geändert werden.',
      'helpHomeB3': 'Die Info (?) Schaltfläche zeigt App-Details an.',

      'helpSystemsTitle': '⏱ Zeitsysteme',
      'helpSystemsB1': 'Einfache Zeit: Das Spiel endet, wenn die Zeit abläuft.',
      'helpSystemsB2': 'Japanisches Byoyomi: Nach Ablauf der Hauptzeit gibt jede Periode feste Zeit.',
      'helpSystemsB3': 'Kanadisches Byoyomi: Eine feste Anzahl Züge muss in einer festen Zeit gespielt werden.',

      'helpGameTitle': '▶️ Spielbildschirm',
      'helpGameB1': 'Tippen Sie auf den Bildschirm, um den Zug zu übergeben.',
      'helpGameB2': 'Die mittlere Leiste enthält Start/Pause und Soundsteuerung.',
      'helpGameB3': 'Oberer und unterer Spielerbereich drehen sich automatisch.',

      'helpSoundTitle': '🔊 Soundhinweise',
      'helpSoundB1': 'In den letzten 10 Sekunden ertönt ein Signal.',
      'helpSoundB2': 'Der Ton kann ein- oder ausgeschaltet werden.',

      'helpEndTitle': '🏁 Spielende',
      'helpEndB1': 'Wenn Zeit oder Perioden ablaufen, wird der Gewinner automatisch bestimmt.',
      'helpEndB2': 'Mit einem Tipp kehren Sie zur Startseite zurück.',

      'helpOutro': 'Go Match Timer ist für eine schnelle, klare und ablenkungsfreie Nutzung am Turniertisch konzipiert.',

      'helpDisclaimerTitle': '⚠️ Haftungsausschluss',
      'helpDisclaimerP1':
          'Diese App dient ausschließlich zur Zeitmessung. Der Entwickler übernimmt keine Haftung '
          'für Zeitfehler, Spielergebnisse oder Turnierentscheidungen.',
      'helpDisclaimerP2': 'Vor der Verwendung in offiziellen Turnieren wird die Genehmigung der Organisatoren empfohlen.',
    },
    'fr': {
      'appSubtitle': 'Horloge de Go',
      'timeSystemTitle': 'Système de temps',

      'byoyomiTitle': 'Byoyomi japonais',
      'byoyomiDesc': 'Temps principal + périodes de byoyomi × durée',

      'canadaTitle': 'Byoyomi canadien',
      'canadaDesc': 'Temps principal + durée / nombre de coups',

      'simpleTitle': 'Temps simple',
      'simpleDesc': 'Temps principal uniquement (pas de temps supplémentaire)',

      'fischerTitle': 'Fischer',
      'fischerDesc': 'Temps principal + incrément par coup',
      'incrementTime': 'Incrément (par coup)',
      'timerFischerInfo': 'Incrément : +{seconds}s / coup',

      'settingsDifferent': 'Utiliser des réglages différents',
      'settingsBlack': 'Noir',
      'settingsWhite': 'Blanc',

      'mainTime': 'Temps principal',
      'byoyomiTime': 'Temps de byoyomi',
      'canadaMoveCount': 'Nombre de coups (Byoyomi canadien)',
      'japanByoCount': 'Périodes de byoyomi',

      'btnStart': 'Démarrer',

      'dialogPickTime': 'Choisir le temps',
      'dialogPick': 'Choisir',
      'cancel': 'Annuler',
      'ok': 'OK',

      'moves': 'Coups',
      'won': 'Gagné !',
      'backToHome': 'Accueil',
      'sureTitle': 'Êtes-vous sûr ?',
      'sureHomeMsg': 'Si vous retournez à l’accueil, l’état actuel de la partie/de l’horloge peut être perdu. Continuer ?',
      'liveSettingsTitle': 'Réglages en direct',
      'remaining': 'Restant',
      'settingsTitle': 'Réglages {system}',
      'timerJapanInfo': 'Byoyomi : {count} périodes | {seconds}s',
      'timerCanadaInfo': 'Coups restants : {count} | {seconds}s',
      'unitHour': 'h',
      'unitMinute': 'min',
      'unitSecond': 's',

      'infoTitle': 'À propos',
      'infoSoftware': 'Logiciel :',
      'infoDesign': 'Design :',
      'infoThanks': 'Remerciements :',
      'helpTitle': 'Comment utiliser Go Match Timer ?',
      'helpGoalTitle': '🎯 Objectif',
      'helpGoalText':
          'Go Match Timer est conçu pour appliquer correctement et simplement '
          'les systèmes de temps officiels utilisés dans les tournois de Go / Baduk / Weiqi.',

      'helpHomeTitle': '🕹 Accueil',
      'helpHomeB1': 'Choisissez le Byoyomi japonais, canadien ou le temps simple.',
      'helpHomeB2': 'La langue peut être changée via le bouton de langue.',
      'helpHomeB3': 'Le bouton info (?) affiche les détails de l’application.',

      'helpSystemsTitle': '⏱ Systèmes de temps',
      'helpSystemsB1': 'Temps simple : la partie se termine lorsque le temps est écoulé.',
      'helpSystemsB2': 'Byoyomi japonais : chaque période donne un temps fixe.',
      'helpSystemsB3': 'Byoyomi canadien : un nombre de coups doit être joué dans un temps donné.',

      'helpGameTitle': '▶️ Écran de jeu',
      'helpGameB1': 'Touchez l’écran pour passer le tour à l’adversaire.',
      'helpGameB2': 'La barre centrale contient les contrôles démarrer/pause et son.',
      'helpGameB3': 'Les zones des joueurs se retournent automatiquement.',

      'helpSoundTitle': '🔊 Alertes sonores',
      'helpSoundB1': 'Un bip retentit dans les 10 dernières secondes.',
      'helpSoundB2': 'Le son peut être activé ou désactivé.',

      'helpEndTitle': '🏁 Fin de partie',
      'helpEndB1': 'Lorsque le temps ou les périodes sont écoulés, le gagnant est déterminé.',
      'helpEndB2': 'Retour à l’accueil en un seul appui.',

      'helpOutro': 'Go Match Timer est conçu pour une utilisation rapide et sans distraction en tournoi.',

      'helpDisclaimerTitle': '⚠️ Avertissement',
      'helpDisclaimerP1': 'Cette application sert uniquement à la gestion du temps. Le développeur décline toute responsabilité.',
      'helpDisclaimerP2': 'Une autorisation de l’organisateur est recommandée avant une utilisation officielle.',
    },
    'es': {
      'appSubtitle': 'Reloj de Go',
      'timeSystemTitle': 'Sistema de tiempo',

      'byoyomiTitle': 'Byoyomi japonés',
      'byoyomiDesc': 'Tiempo principal + períodos de byoyomi × tiempo',

      'canadaTitle': 'Byoyomi canadiense',
      'canadaDesc': 'Tiempo principal + tiempo / número de jugadas',

      'simpleTitle': 'Tiempo simple',
      'simpleDesc': 'Solo tiempo principal (sin tiempo extra)',

      'fischerTitle': 'Fischer',
      'fischerDesc': 'Tiempo principal + incremento por jugada',
      'incrementTime': 'Incremento (por jugada)',
      'timerFischerInfo': 'Incremento: +{seconds}s / jugada',

      'settingsDifferent': 'Usar ajustes diferentes',
      'settingsBlack': 'Negro',
      'settingsWhite': 'Blanco',

      'mainTime': 'Tiempo principal',
      'byoyomiTime': 'Tiempo de byoyomi',
      'canadaMoveCount': 'Número de jugadas (Byoyomi canadiense)',
      'japanByoCount': 'Períodos de byoyomi',

      'btnStart': 'Iniciar',

      'dialogPickTime': 'Elegir tiempo',
      'dialogPick': 'Elegir',
      'cancel': 'Cancelar',
      'ok': 'OK',

      'moves': 'Jugadas',
      'won': '¡Ganó!',
      'backToHome': 'Inicio',
      'sureTitle': '¿Estás seguro?',
      'sureHomeMsg': 'Si vuelves al inicio, el estado actual de la partida/temporizador podría perderse. ¿Continuar?',
      'liveSettingsTitle': 'Ajustes en vivo',
      'remaining': 'Restante',
      'settingsTitle': 'Ajustes de {system}',
      'timerJapanInfo': 'Byoyomi: {count} periodos | {seconds}s',
      'timerCanadaInfo': 'Movimientos restantes: {count} | {seconds}s',
      'unitHour': 'h',
      'unitMinute': 'min',
      'unitSecond': 's',

      'infoTitle': 'Acerca de',
      'infoSoftware': 'Software:',
      'infoDesign': 'Diseño:',
      'infoThanks': 'Agradecimientos:',
      'helpTitle': '¿Cómo usar Go Match Timer?',
      'helpGoalTitle': '🎯 Objetivo',
      'helpGoalText':
          'Go Match Timer está diseñado para aplicar de forma sencilla y precisa '
          'los sistemas oficiales de control de tiempo utilizados en torneos de Go / Baduk / Weiqi.',

      'helpHomeTitle': '🕹 Inicio',
      'helpHomeB1': 'Seleccione Byoyomi japonés, Byoyomi canadiense o Tiempo simple.',
      'helpHomeB2': 'El idioma de la interfaz se puede cambiar con el botón de idioma.',
      'helpHomeB3': 'El botón de información (?) muestra los detalles de la aplicación.',

      'helpSystemsTitle': '⏱ Sistemas de tiempo',
      'helpSystemsB1': 'Tiempo simple: La partida termina cuando se acaba el tiempo.',
      'helpSystemsB2': 'Byoyomi japonés: Tras finalizar el tiempo principal, cada período otorga un tiempo fijo.',
      'helpSystemsB3': 'Byoyomi canadiense: Se deben jugar un número determinado de jugadas dentro de un tiempo fijo.',

      'helpGameTitle': '▶️ Pantalla de juego',
      'helpGameB1': 'Tocar cualquier parte de la pantalla pasa el turno al oponente.',
      'helpGameB2': 'La barra central contiene los controles de iniciar/pausar y sonido.',
      'helpGameB3': 'Las áreas del jugador superior e inferior giran automáticamente.',

      'helpSoundTitle': '🔊 Alertas de sonido',
      'helpSoundB1': 'Suena una alerta en los últimos 10 segundos.',
      'helpSoundB2': 'El sonido se puede activar o desactivar con el botón correspondiente.',

      'helpEndTitle': '🏁 Fin de la partida',
      'helpEndB1': 'Cuando se acaba el tiempo o los períodos, el ganador se determina automáticamente.',
      'helpEndB2': 'Se puede volver a la pantalla principal con un solo toque.',

      'helpOutro':
          'Go Match Timer está diseñado para ofrecer un uso rápido, claro y sin distracciones '
          'en la mesa de torneo.',

      'helpDisclaimerTitle': '⚠️ Descargo de responsabilidad',
      'helpDisclaimerP1':
          'Esta aplicación se ha desarrollado únicamente para facilitar el control del tiempo. '
          'El desarrollador no se hace responsable de errores de tiempo, resultados de partidas, '
          'decisiones de torneos ni disputas que puedan surgir durante su uso.',
      'helpDisclaimerP2':
          'Antes de usarla en torneos oficiales, se recomienda obtener la aprobación del organizador. '
          'Verificar la configuración del tiempo y utilizar la aplicación correctamente es '
          'responsabilidad exclusiva del usuario.',
    },
    'it': {
      'appSubtitle': 'Orologio Go',
      'timeSystemTitle': 'Sistema di tempo',

      'byoyomiTitle': 'Byoyomi giapponese',
      'byoyomiDesc': 'Tempo principale + periodi di byoyomi × tempo',

      'canadaTitle': 'Byoyomi canadese',
      'canadaDesc': 'Tempo principale + tempo / numero di mosse',

      'simpleTitle': 'Tempo semplice',
      'simpleDesc': 'Solo tempo principale (nessun tempo extra)',

      'fischerTitle': 'Fischer',
      'fischerDesc': 'Tempo principale + incremento per mossa',
      'incrementTime': 'Incremento (per mossa)',
      'timerFischerInfo': 'Incremento: +{seconds}s / mossa',

      'settingsDifferent': 'Usa impostazioni diverse',
      'settingsBlack': 'Nero',
      'settingsWhite': 'Bianco',

      'mainTime': 'Tempo principale',
      'byoyomiTime': 'Tempo di byoyomi',
      'canadaMoveCount': 'Numero di mosse (Byoyomi canadese)',
      'japanByoCount': 'Periodi di byoyomi',

      'btnStart': 'Avvia',

      'dialogPickTime': 'Seleziona tempo',
      'dialogPick': 'Seleziona',
      'cancel': 'Annulla',
      'ok': 'OK',

      'moves': 'Mosse',
      'won': 'Vinto!',
      'backToHome': 'Home',
      'sureTitle': 'Sei sicuro?',
      'sureHomeMsg': 'Se torni alla home, lo stato di gioco o del timer potrebbe andare perso. Continuare?',
      'liveSettingsTitle': 'Impostazioni live',
      'remaining': 'Rimanente',
      'settingsTitle': 'Impostazioni {system}',
      'timerJapanInfo': 'Byoyomi: {count} periodi | {seconds}s',
      'timerCanadaInfo': 'Mosse rimanenti: {count} | {seconds}s',
      'unitHour': 'h',
      'unitMinute': 'min',
      'unitSecond': 's',

      'infoTitle': 'Informazioni',
      'infoSoftware': 'Software:',
      'infoDesign': 'Design:',
      'infoThanks': 'Ringraziamenti:',
      'helpTitle': 'Come usare Go Match Timer?',
      'helpGoalTitle': '🎯 Obiettivo',
      'helpGoalText':
          'Go Match Timer è progettato per applicare in modo semplice e accurato '
          'i sistemi ufficiali di gestione del tempo utilizzati nei tornei di Go / Baduk / Weiqi.',

      'helpHomeTitle': '🕹 Home',
      'helpHomeB1': 'Seleziona Byoyomi giapponese, Byoyomi canadese o Tempo semplice.',
      'helpHomeB2': 'La lingua dell’interfaccia può essere cambiata tramite il pulsante lingua.',
      'helpHomeB3': 'Il pulsante informativo (?) mostra i dettagli dell’applicazione.',

      'helpSystemsTitle': '⏱ Sistemi di tempo',
      'helpSystemsB1': 'Tempo semplice: La partita termina quando il tempo scade.',
      'helpSystemsB2': 'Byoyomi giapponese: Dopo il tempo principale, ogni periodo fornisce un tempo fisso.',
      'helpSystemsB3': 'Byoyomi canadese: Un numero prestabilito di mosse deve essere giocato entro un tempo fisso.',

      'helpGameTitle': '▶️ Schermata di gioco',
      'helpGameB1': 'Toccare lo schermo passa il turno all’avversario.',
      'helpGameB2': 'La barra centrale contiene i controlli di avvio/pausa e audio.',
      'helpGameB3': 'Le aree del giocatore superiore e inferiore ruotano automaticamente.',

      'helpSoundTitle': '🔊 Avvisi sonori',
      'helpSoundB1': 'Negli ultimi 10 secondi viene emesso un segnale acustico.',
      'helpSoundB2': 'L’audio può essere attivato o disattivato con il pulsante del suono.',

      'helpEndTitle': '🏁 Fine della partita',
      'helpEndB1': 'Quando il tempo o i periodi terminano, il vincitore viene determinato automaticamente.',
      'helpEndB2': 'È possibile tornare alla schermata principale con un solo tocco.',

      'helpOutro':
          'Go Match Timer è progettato per offrire un utilizzo rapido, chiaro e senza distrazioni '
          'al tavolo di torneo.',

      'helpDisclaimerTitle': '⚠️ Dichiarazione di non responsabilità',
      'helpDisclaimerP1':
          'Questa applicazione è stata sviluppata esclusivamente per facilitare il controllo del tempo. '
          'Lo sviluppatore non è responsabile di errori di temporizzazione, risultati delle partite, '
          'decisioni di torneo o controversie che possano sorgere durante l’uso.',
      'helpDisclaimerP2':
          'Prima dell’utilizzo in tornei ufficiali, si consiglia di ottenere l’approvazione '
          'dell’organizzatore. Verificare le impostazioni del tempo e utilizzare correttamente '
          'l’applicazione è interamente responsabilità dell’utente.',
    },
    'ru': {
      'appSubtitle': 'Часы для игры в го',
      'timeSystemTitle': 'Система времени',
      'byoyomiTitle': 'Японское бёёми',
      'byoyomiDesc': 'Основное время + периоды японского бёёми × время',
      'canadaTitle': 'Канадское бёёми',
      'canadaDesc': 'Основное время + время / число ходов',
      'simpleTitle': 'Простое время (внезапная смерть)',
      'simpleDesc': 'Основное время (без доп. периодов)',
      'fischerTitle': 'Фишер',
      'fischerDesc': 'Основное время + прибавка за ход',
      'incrementTime': 'Прибавка (за ход)',
      'timerFischerInfo': 'Прибавка: +{seconds}с / ход',
      'settingsDifferent': 'Разные настройки',
      'settingsBlack': 'Чёрные',
      'settingsWhite': 'Белые',
      'mainTime': 'Основное время',
      'byoyomiTime': 'Время бёёми',
      'canadaMoveCount': 'Число ходов (канадское бёёми)',
      'japanByoCount': 'Периоды японского бёёми',
      'btnStart': 'Старт',
      'dialogPickTime': 'Выбор времени',
      'dialogPick': 'Выбрать',
      'cancel': 'Отмена',
      'ok': 'ОК',
      'moves': 'Ходы',
      'won': 'Победа!',
      'backToHome': 'Главная',
      'sureTitle': 'Вы уверены?',
      'sureHomeMsg': 'При возврате на главную текущее состояние игры/таймера может быть потеряно. Продолжить?',
      'liveSettingsTitle': 'Настройки на лету',
      'remaining': 'Осталось',
      'settingsTitle': 'Настройки: {system}',
      'timerJapanInfo': 'Бёёми: {count} периодов | {seconds}с',
      'timerCanadaInfo': 'Осталось ходов: {count} | {seconds}с',
      'unitHour': 'ч',
      'unitMinute': 'м',
      'unitSecond': 'с',
      'infoTitle': 'О приложении',
      'infoSoftware': 'Разработка:',
      'infoDesign': 'Дизайн:',
      'infoThanks': 'Особая благодарность:',
      'helpTitle': 'Как пользоваться Go Match Timer?',
      'helpGoalTitle': '🎯 Назначение',
      'helpGoalText': 'Go Match Timer создан для простого и точного применения официальных систем контроля времени, используемых на турнирах по го / бадуку / вэйци.',
      'helpHomeTitle': '🕹 Главный экран',
      'helpHomeB1': 'Выберите японское бёёми, канадское бёёми или простое время.',
      'helpHomeB2': 'Кнопкой языка можно сменить язык интерфейса.',
      'helpHomeB3': 'Кнопка информации (?) показывает сведения о приложении.',
      'helpSystemsTitle': '⏱ Системы времени',
      'helpSystemsB1': 'Простое время: игра заканчивается, когда время истекает.',
      'helpSystemsB2': 'Японское бёёми: после окончания основного времени каждый период даёт фиксированное количество времени.',
      'helpSystemsB3': 'Канадское бёёми: нужно сделать определённое число ходов за фиксированное время.',
      'helpGameTitle': '▶️ Игровой экран',
      'helpGameB1': 'Коснитесь экрана в любом месте, чтобы передать ход сопернику.',
      'helpGameB2': 'На средней панели — старт/пауза и управление звуком.',
      'helpGameB3': 'Зоны верхнего и нижнего игроков поворачиваются автоматически.',
      'helpSoundTitle': '🔊 Звуковые сигналы',
      'helpSoundB1': 'В последние 10 секунд звучит предупреждающий сигнал.',
      'helpSoundB2': 'Звук можно включить или выключить кнопкой звука.',
      'helpEndTitle': '🏁 Конец игры',
      'helpEndB1': 'Когда заканчивается время или периоды, победитель определяется автоматически.',
      'helpEndB2': 'Вернуться на главный экран можно одним касанием.',
      'helpOutro': 'Go Match Timer создан быстрым, лаконичным и не отвлекающим от игры за турнирным столом.',
      'helpDisclaimerTitle': '⚠️ Отказ от ответственности',
      'helpDisclaimerP1': 'Это приложение создано только для помощи в отсчёте времени. Разработчик не несёт ответственности за ошибки хронометража, результаты партий, турнирные решения или споры, которые могут возникнуть при использовании приложения.',
      'helpDisclaimerP2': 'Перед использованием на официальных турнирах рекомендуется получить одобрение организатора. Проверка настроек времени и правильное использование приложения — целиком ответственность пользователя.',
    },
    'th': {
      'appSubtitle': 'นาฬิกาจับเวลาเกมโกะ',
      'timeSystemTitle': 'ระบบเวลา',
      'byoyomiTitle': 'เบียวโยมิแบบญี่ปุ่น',
      'byoyomiDesc': 'เวลาหลัก + จำนวนช่วงเบียวโยมิญี่ปุ่น × เวลา',
      'canadaTitle': 'เบียวโยมิแบบแคนาดา',
      'canadaDesc': 'เวลาหลัก + เวลา / จำนวนตาเดิน',
      'simpleTitle': 'เวลาแบบง่าย (Sudden Death)',
      'simpleDesc': 'เวลาหลัก (ไม่มีช่วงเวลาเพิ่ม)',
      'fischerTitle': 'Fischer',
      'fischerDesc': 'เวลาหลัก + เวลาเพิ่มต่อตาเดิน',
      'incrementTime': 'เวลาเพิ่ม (ต่อตาเดิน)',
      'timerFischerInfo': 'เวลาเพิ่ม: +{seconds} วิ/ตา',
      'settingsDifferent': 'ใช้การตั้งค่าแยกกัน',
      'settingsBlack': 'ดำ',
      'settingsWhite': 'ขาว',
      'mainTime': 'เวลาหลัก',
      'byoyomiTime': 'เวลาเบียวโยมิ',
      'canadaMoveCount': 'จำนวนตาเดิน (เบียวโยมิแคนาดา)',
      'japanByoCount': 'จำนวนช่วงเบียวโยมิญี่ปุ่น',
      'btnStart': 'เริ่ม',
      'dialogPickTime': 'เลือกเวลา',
      'dialogPick': 'เลือก',
      'cancel': 'ยกเลิก',
      'ok': 'ตกลง',
      'moves': 'ตาเดิน',
      'won': 'ชนะ!',
      'backToHome': 'หน้าหลัก',
      'sureTitle': 'แน่ใจหรือไม่?',
      'sureHomeMsg': 'หากกลับไปหน้าหลัก สถานะเกม/เวลาปัจจุบันอาจหายไป ดำเนินการต่อหรือไม่?',
      'liveSettingsTitle': 'ตั้งค่าสด',
      'remaining': 'คงเหลือ',
      'settingsTitle': 'ตั้งค่า {system}',
      'timerJapanInfo': 'เบียวโยมิ: {count} ช่วง | {seconds} วิ',
      'timerCanadaInfo': 'ตาที่เหลือ: {count} | {seconds} วิ',
      'unitHour': 'ชม.',
      'unitMinute': 'นาที',
      'unitSecond': 'วิ',
      'infoTitle': 'เกี่ยวกับ',
      'infoSoftware': 'ซอฟต์แวร์:',
      'infoDesign': 'ออกแบบ:',
      'infoThanks': 'ขอบคุณเป็นพิเศษ:',
      'helpTitle': 'วิธีใช้ Go Match Timer?',
      'helpGoalTitle': '🎯 วัตถุประสงค์',
      'helpGoalText': 'Go Match Timer ออกแบบมาเพื่อใช้งานระบบจับเวลาอย่างเป็นทางการที่ใช้ในการแข่งขันโกะ / บาดุก / เหวยฉี ได้อย่างเรียบง่ายและแม่นยำ',
      'helpHomeTitle': '🕹 หน้าหลัก',
      'helpHomeB1': 'เลือกเบียวโยมิญี่ปุ่น เบียวโยมิแคนาดา หรือเวลาแบบง่าย',
      'helpHomeB2': 'ใช้ปุ่มภาษาเพื่อเปลี่ยนภาษาของอินเทอร์เฟซ',
      'helpHomeB3': 'ปุ่มข้อมูล (?) แสดงรายละเอียดของแอป',
      'helpSystemsTitle': '⏱ ระบบเวลา',
      'helpSystemsB1': 'เวลาแบบง่าย: เกมจบลงเมื่อเวลาหมด',
      'helpSystemsB2': 'เบียวโยมิญี่ปุ่น: หลังจากเวลาหลักหมด แต่ละช่วงจะให้เวลาคงที่จำนวนหนึ่ง',
      'helpSystemsB3': 'เบียวโยมิแคนาดา: เดินหมากตามจำนวนที่กำหนดภายในเวลาที่กำหนด',
      'helpGameTitle': '▶️ หน้าจอเกม',
      'helpGameB1': 'แตะที่ใดก็ได้บนหน้าจอเพื่อส่งตาเดินให้ฝ่ายตรงข้าม',
      'helpGameB2': 'แถบตรงกลางมีปุ่มเริ่ม/หยุดชั่วคราวและควบคุมเสียง',
      'helpGameB3': 'พื้นที่ผู้เล่นด้านบนและด้านล่างจะหมุนโดยอัตโนมัติ',
      'helpSoundTitle': '🔊 การแจ้งเตือนด้วยเสียง',
      'helpSoundB1': 'เสียงเตือนจะดังในช่วง 10 วินาทีสุดท้าย',
      'helpSoundB2': 'เปิด/ปิดเสียงได้ด้วยปุ่มเสียง',
      'helpEndTitle': '🏁 จบเกม',
      'helpEndB1': 'เมื่อเวลาหรือช่วงเบียวโยมิหมด ผู้ชนะจะถูกตัดสินโดยอัตโนมัติ',
      'helpEndB2': 'กลับสู่หน้าหลักได้ด้วยการแตะเพียงครั้งเดียว',
      'helpOutro': 'Go Match Timer ออกแบบมาให้ใช้งานได้รวดเร็ว เรียบง่าย และไม่รบกวนสมาธิที่โต๊ะแข่งขัน',
      'helpDisclaimerTitle': '⚠️ ข้อจำกัดความรับผิดชอบ',
      'helpDisclaimerP1': 'แอปนี้พัฒนาขึ้นเพื่อช่วยจับเวลาเท่านั้น ผู้พัฒนาไม่รับผิดชอบต่อข้อผิดพลาดในการจับเวลา ผลการแข่งขัน การตัดสินของการแข่งขัน หรือข้อพิพาทที่อาจเกิดขึ้นขณะใช้งานแอป',
      'helpDisclaimerP2': 'ก่อนใช้ในการแข่งขันอย่างเป็นทางการ แนะนำให้ขออนุมัติจากผู้จัดการแข่งขัน การตรวจสอบการตั้งค่าเวลาและการใช้งานแอปอย่างถูกต้องเป็นความรับผิดชอบของผู้ใช้ทั้งหมด',
    },
  };

  static String t(String lang, String key) {
    final langMap = _values[lang] ?? _values['en']!;
    return langMap[key] ?? _values['en']![key] ?? key;
  }
}
