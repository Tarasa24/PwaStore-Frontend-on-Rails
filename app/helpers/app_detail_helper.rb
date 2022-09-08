# frozen_string_literal: true

require 'iso-639'

module AppDetailHelper # rubocop:disable Metrics/ModuleLength
  # Converts ISO 639-1 Language Code into ISO 3166-1-alpha-2 Country Code
  # @param [String] lang ISO 639-1 Language Code
  # @return [String] ISO 3166-1-alpha-2 Country Code
  # @example
  #  language_code_to_country_code('en') #=> 'US'
  #  language_code_to_country_code('fr') #=> 'FR'
  #  language_code_to_country_code('es') #=> 'ES'
  #  language_code_to_country_code('de') #=> 'DE'
  def lang_to_flag(lang) # rubocop:disable Metrics/MethodLength
    return nil if lang.nil? || lang.empty?

    codex = {
      aa: 'dj',
      af: 'za',
      ak: 'gh',
      sq: 'al',
      am: 'et',
      az: 'az',
      bm: 'ml',
      be: 'by',
      bn: 'bd',
      bi: 'vu',
      bs: 'ba',
      bg: 'bg',
      my: 'mm',
      ca: 'ad',
      zh: 'cn',
      hr: 'hr',
      cs: 'cz',
      da: 'dk',
      dv: 'mv',
      nl: 'nl',
      dz: 'bt',
      en: 'gb',
      et: 'ee',
      fj: 'fj',
      fil: 'ph',
      fi: 'fi',
      fr: 'fr',
      gaa: 'gh',
      ka: 'ge',
      de: 'de',
      el: 'gr',
      gu: 'in',
      ht: 'ht',
      he: 'il',
      hi: 'in',
      ho: 'pg',
      hu: 'hu',
      is: 'is',
      ig: 'ng',
      id: 'id',
      ga: 'ie',
      it: 'it',
      ja: 'jp',
      kr: 'ne',
      kk: 'kz',
      km: 'kh',
      kmb: 'ao',
      rw: 'rw',
      kg: 'cg',
      ko: 'kr',
      kj: 'ao',
      ku: 'iq',
      ky: 'kg',
      lo: 'la',
      la: 'va',
      lv: 'lv',
      ln: 'cg',
      lt: 'lt',
      lu: 'cd',
      lb: 'lu',
      mk: 'mk',
      mg: 'mg',
      ms: 'my',
      mt: 'mt',
      mi: 'nz',
      mh: 'mh',
      mn: 'mn',
      mos: 'bf',
      ne: 'np',
      nd: 'zw',
      nso: 'za',
      no: 'no',
      nb: 'no',
      nn: 'no',
      ny: 'mw',
      pap: 'aw',
      ps: 'af',
      fa: 'ir',
      pl: 'pl',
      pt: 'pt',
      pa: 'in',
      qu: 'wh',
      ro: 'ro',
      rm: 'ch',
      rn: 'bi',
      ru: 'ru',
      sg: 'cf',
      sr: 'rs',
      srr: 'sn',
      sn: 'zw',
      si: 'lk',
      sk: 'sk',
      sl: 'si',
      so: 'so',
      snk: 'sn',
      nr: 'za',
      st: 'ls',
      es: 'es',
      ss: 'sz',
      sv: 'se',
      tl: 'ph',
      tg: 'tj',
      ta: 'lk',
      te: 'in',
      tet: 'tl',
      th: 'th',
      ti: 'er',
      tpi: 'pg',
      ts: 'za',
      tn: 'bw',
      tr: 'tr',
      tk: 'tm',
      uk: 'ua',
      umb: 'ao',
      ur: 'pk',
      uz: 'uz',
      ve: 'za',
      vi: 'vn',
      cy: 'gb',
      wo: 'sn',
      xh: 'za',
      zu: 'za'
    }

    lang = lang.split('-')[0]
    return nil unless codex.key?(lang.to_sym)
    codex[lang.to_sym]
  end

  # Converts raw number of bytes into human readable format
  # @param [Integer] bytes
  # @return [String]
  # @example
  #  bytes_to_human(1024) #=> "1.0 KB"
  #  bytes_to_human(1024 * 1024) #=> "1.0 MB"
  #  bytes_to_human(1024 * 1024 * 1024) #=> "1.0 GB"
  #  bytes_to_human(1024 * 1024 * 1024 * 1024) #=> "1.0 TB"
  def bytes_to_string(bytes)
    if bytes < 1024
      "#{bytes} B"
    elsif bytes < 1024 * 1024
      "#{(bytes / 1024).to_i} KB"
    elsif bytes < 1024 * 1024 * 1024
      "#{(bytes / 1024 / 1024).to_i} MB"
    else
      "#{(bytes / 1024 / 1024 / 1024).to_i} GB"
    end
  end
end
