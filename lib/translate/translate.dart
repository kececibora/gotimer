class AppStrings {
  // 5 dil: Türkçe, İngilizce, Japonca, Korece, Çince
  static const supportedLanguages = ['tr', 'en', 'ja', 'ko', 'zh'];

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
      'backToHome': 'Ana Sayfaya Dön',

      // Info bottom sheet
      'infoTitle': 'Hakkında',
      'infoSoftware': 'Yazılım:',
      'infoDesign': 'Tasarım:',
      'infoThanks': 'Destekleri için teşekkürler:',
    },

    'en': {
      'appSubtitle': 'Go Game Clock',
      'timeSystemTitle': 'Time System',

      'byoyomiTitle': 'Japanese Byoyomi',
      'byoyomiDesc': 'Main Time + Japanese Byoyomi Periods × Time',

      'canadaTitle': 'Canadian Byoyomi',
      'canadaDesc': 'Main Time + Time / Move Count',

      'simpleTitle': 'Simple Time',
      'simpleDesc': 'Main Time (no extra period)',

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
      'backToHome': 'Back to Home',

      'infoTitle': 'About',
      'infoSoftware': 'Software:',
      'infoDesign': 'Design:',
      'infoThanks': 'Special thanks to:',
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
      'backToHome': 'ホームに戻る',

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
      'backToHome': '처음 화면으로',

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
      'backToHome': '返回首页',

      'infoTitle': '关于',
      'infoSoftware': '软件：',
      'infoDesign': '设计：',
      'infoThanks': '特别感谢：',
    },
  };

  static String t(String lang, String key) {
    final langMap = _values[lang] ?? _values['en']!;
    return langMap[key] ?? _values['en']![key] ?? key;
  }
}
