// Static Hadist Data
class HadistData {
  static const List<Map<String, String>> hadists = [
    {
      'id': '1',
      'title': 'Hadist Keimananan',
      'arabic':
          'أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللهِ',
      'translation':
          'Aku bersaksi bahwa tidak ada Tuhan selain Allah, dan aku bersaksi bahwa Muhammad adalah utusan Allah',
      'source': 'HR. Muslim',
      'category': 'Iman',
    },
    {
      'id': '2',
      'title': 'Hadist about Islam',
      'arabic':
          'الإِسْلاَمُ أَنْ تَشْهَدَ أَنْ لاَ إِلَهَ إِلاَّ اللهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللهِ وَتُقِيمَ الصَّلاَةَ وَتُؤْتِيَ الزَّكَاةَ وَتَصُومَ رَمَضَانَ وَتَحُجَّ الْبَيْتَ إِنِ اسْتَطَعْتَ',
      'translation':
          'Islam adalah engkau bersaksi bahwa tidak ada Tuhan selain Allah dan bahwa Muhammad adalah utusan Allah, mendirikan salat, menunaikan-zakat, puasa Ramadan, dan naik Haji ke Baitullah jika mampu',
      'source': 'HR. Bukhari & Muslim',
      'category': 'Islam',
    },
    {
      'id': '3',
      'title': 'Hadist about Iman',
      'arabic':
          'الإِيمَانُ أَنْ تُؤْمِنَ بِاللهِ وَمَلاَئِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الآخِرِ وَتُؤْمِنَ بِالْقَدَرِ خَيْرِهِ وَشَرِّهِ',
      'translation':
          'Iman adalah engkau beriman kepada Allah, malaikat-malaikat-Nya, kitab-kitab-Nya, rasul-rasul-Nya, hari akhir, dan beriman kepada qadar baik dan buruk',
      'source': 'HR. Muslim',
      'category': 'Iman',
    },
    {
      'id': '4',
      'title': 'Hadist about Ihsan',
      'arabic':
          'الإِحْسَانُ أَنْ تَعْبُدَ اللهَ كَأَنَّكَ تَرَاهُ فَإِنْ لَمْ تَكُنْ تَرَاهُ فَإِنَّهُ يَرَاكَ',
      'translation':
          'Ihsan adalah engkau menyembah Allah seolah-olah kamu melihat-Nya, jika kamu tidak melihatnya maka sesungguhnya Dia melihatmu',
      'source': 'HR. Bukhari & Muslim',
      'category': 'Ihsan',
    },
    {
      'id': '5',
      'title': 'Hadist about Halal & Haram',
      'arabic':
          'إِنَّ الْحَلاَلَ بَيِّنٌ وَإِنَّ الْحَرَامَ بَيِّنٌ وَبَيْنَهُمَا أُمُورٌ مُشْتَبِهَاتٌ',
      'translation':
          'Sesuatu yang halal itu jelas dan sesuatu yang haram itu jelas, dan di antara keduanya ada hal-hal yang syubhat',
      'source': 'HR. Bukhari & Muslim',
      'category': 'Akhlak',
    },
    {
      'id': '6',
      'title': 'Hadist about Sedekah',
      'arabic':
          'مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ وَمَا زَادَ اللهُ عَبْدًا بِعَفْوٍ إِلاَّ عِزًّا',
      'translation':
          'Sedekah tidak akan berkurang dari harta, dan tidak ada seorang hamba yangAllah tambahkan kekayaan dengan pemberian maaf melainkan akan bertambah kemuliaan',
      'source': 'HR. Muslim',
      'category': 'Sedekah',
    },
    {
      'id': '7',
      'title': 'Hadist about Patience',
      'arabic': 'إِنَّمَا الصَّبْرُ عِنْدَ الصَّدْمَةِ الأُولَى',
      'translation':
          'Sesungguuhnya kesabaran itu adalah pada saat pertama kali mendapatkan musibah',
      'source': 'HR. Bukhari',
      'category': 'Sabr',
    },
    {
      'id': '8',
      'title': 'Hadist about Gratitude',
      'arabic': 'مَنْ لاَ يَشْكُرُ النَّاسَ لاَ يَشْكُرُ اللهَ',
      'translation':
          'Barangsiapa tidak berterima kasih kepada manusia, maka tidak berterima kasih kepada Allah',
      'source': 'HR. Abu Daud & Tirmidzi',
      'category': 'Syukur',
    },
    {
      'id': '9',
      'title': 'Hadist about Knowledge',
      'arabic': 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ',
      'translation': 'Menuntut ilmu adalah kewajiban bagi setiap muslim',
      'source': 'HR. Ibnu Majah',
      'category': 'Ilmu',
    },
    {
      'id': '10',
      'title': 'Hadist about Good Character',
      'arabic': 'إِنَّمَا بُعِثْتُ لِأُتَمِّمَ مَكَارِمَ الأَخْلَاقِ',
      'translation':
          'Sesungguhnya aku diutus untuk menyempurnakan akhlak yang mulia',
      'source': 'HR. Ahmad',
      'category': 'Akhlak',
    },
    {
      'id': '11',
      'title': 'Hadist about Prayer',
      'arabic': 'صَلُّوا كَمَا رَأَيْتُمُونِي أُصَلِّي',
      'translation': 'Salatlah kalian sebagaimana kalian melihat aku salat',
      'source': 'HR. Bukhari',
      'category': 'Shalat',
    },
    {
      'id': '12',
      'title': 'Hadist about Unity',
      'arabic':
          'مَنْ فَارَقَ الْجَمَاعَةَ شِبْرًا فَقَدْ خَلَعَ الرِّبْقَةَ مِنْ عُنُقِهِ',
      'translation':
          'Barangsiapa yang berpisah dari jama\'ah sejengkal saja, maka ia telah melepaskan ikatan agama dari lehernya',
      'source': 'HR. Abu Daud',
      'category': 'Ukhuwah',
    },
  ];
}
