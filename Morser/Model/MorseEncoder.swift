//
//  MorseEncoder.swift
//  Morser
//
//  Created by Giuseppe Francione on 15/04/24.
//

import Foundation

class MorseEncoder {
    // map of all latin characters to morse
    private static let AlphaNumToMorse: [String:String] = [
        // latin alphabet
        "A": ".-",
        "B": "-...",
        "C": "-.-.",
        "D": "-..",
        "E": ".",
        "F": "..-.",
        "G": "--.",
        "H": "....",
        "I": "..",
        "J": ".---",
        "K": "-.-",
        "L": ".-..",
        "M": "--",
        "N": "-.",
        "O": "---",
        "P": ".--.",
        "Q": "--.-",
        "R": ".-.",
        "S": "...",
        "T": "-",
        "U": "..-",
        "V": "...-",
        "W": ".--",
        "X": "-..-",
        "Y": "-.--",
        "Z": "--..",
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--..",
        // numbers
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        "0": "-----",
        // special characters
        " ": "/",
        "'": ".----.",
        ".": ".-.-.-",
        ",": "--..--",
        ":": "---...",
        "+": ".-.-.",
        "\"": ".-..-.",
        "!":"-.-.--",
        "?": "..--..",
        "=": "-...-",
        "@": ".--.-.",
    ]
    // greek characters
    private static let GreekToMorse: [String:String] = [
        "Α":".-",
        "Β":"-...",
        "Γ":"--.",
        "Δ":"-..",
        "Ε":".",
        "Ζ":"--..",
        "Η":"....",
        "Θ":"-.-.",
        "Ι":"..",
        "Κ":"-.-",
        "Λ":".-..",
        "Μ":"--",
        "Ν":"-.",
        "Ξ":"-..-",
        "Ο":"---",
        "Π":".--.",
        "Ρ":".-.",
        "Σ":"...",
        "Τ":"-",
        "Υ":"-.--",
        "Φ":"..-.",
        "Χ":"----",
        "Ψ":"--.-",
        "Ω":".--",
        "α": ".-",       // Alpha (lowercase)
        "β": "-...",     // Beta (lowercase)
        "γ": "--.",      // Gamma (lowercase)
        "δ": "-..",      // Delta (lowercase)
        "ε": ".",        // Epsilon (lowercase)
        "ζ": "--..",     // Zeta (lowercase)
        "η": "....",     // Eta (lowercase)
        "θ": "-.-.",     // Theta (lowercase)
        "ι": "..",       // Iota (lowercase)
        "κ": "-.-",      // Kappa (lowercase)
        "λ": ".-..",     // Lambda (lowercase)
        "μ": "--",       // Mu (lowercase)
        "ν": "-.",       // Nu (lowercase)
        "ξ": "-..-",     // Xi (lowercase)
        "ο": "---",      // Omicron (lowercase)
        "π": ".--.",     // Pi (lowercase)
        "ρ": ".-.",      // Rho (lowercase)
        "σ": "...",      // Sigma (lowercase)
        "τ": "-",        // Tau (lowercase)
        "υ": "-.--",      // Upsilon (lowercase)
        "φ": "..-.",     // Phi (lowercase)
        "χ": "----",     // Chi (lowercase)
        "ψ": "--.-",     // Psi (lowercase)
        "ω": ".--",       // Omega (lowercase)
    ]
    // cyrillic characters
    private static let CyrillicToMorse: [String:String] = [
        "А":".-",
        "Б":"-...",
        "В":".--",
        "Г":"--.",
        "Д":"-..",
        "Е":".",
        "Ж":"...-",
        "З":"--..",
        "И":"..",
        "Й":".---",
        "К":"-.-",
        "Л":".-..",
        "М":"--",
        "Н":"-.",
        "О":"---",
        "П":".--.",
        "Р":".-.",
        "С":"...",
        "Т":"-",
        "У":"..-",
        "Ф":"..-.",
        "Х":"....",
        "Ц":"-.-.",
        "Ч":"---.",
        "Ш":"----",
        "Щ":"--.-",
        "Ъ":"--.--",
        "Ы":"-.--",
        "Ь":"-..-",
        "Э":"..-..",
        "Ю":"..--",
        "Я":".-.-",
        "Ї":".---.",
        "Є":"..-..",
        "І":"..",
        "Ґ":"--."
    ]
    // extended cyrillic characters
    private static let ExtendedCyrillicToMorse: [String:String] = [
        "А": ".-",       // A
        "Б": "-...",     // Be
        "В": ".--",      // Ve
        "Г": "--.",      // Ghe
        "Д": "-..",      // De
        "Е": ".",        // Ye
        "Ё": ".",        // Yo (uses same as Е)
        "Ж": "...-",     // Zhe
        "З": "--..",     // Ze
        "И": "..",       // I
        "Й": ".---",     // Short I
        "К": "-.-",      // Ka
        "Л": ".-..",     // El
        "М": "--",       // Em
        "Н": "-.",       // En
        "О": "---",      // O
        "П": ".--.",     // Pe
        "Р": ".-.",      // Er
        "С": "...",      // Es
        "Т": "-",        // Te
        "У": "..-",      // U
        "Ф": "..-.",     // Ef
        "Х": "----",     // Kha
        "Ц": "-.-.",     // Tse
        "Ч": "---.",     // Che
        "Ш": "----",     // Sha
        "Щ": "--.-",     // Shcha
        "Ъ": "--.--",    // Hard Sign
        "Ы": "-.--",     // Yeru
        "Ь": "-..-",     // Soft Sign
        "Э": "..-..",    // E
        "Ю": "..--",     // Yu
        "Я": ".-.-",     // Ya
        "а": ".-",       // A (lowercase)
        "б": "-...",     // Be (lowercase)
        "в": ".--",      // Ve (lowercase)
        "г": "--.",      // Ghe (lowercase)
        "д": "-..",      // De (lowercase)
        "е": ".",        // Ye (lowercase)
        "ё": ".",        // Yo (lowercase, uses same as е)
        "ж": "...-",     // Zhe (lowercase)
        "з": "--..",     // Ze (lowercase)
        "и": "..",       // I (lowercase)
        "й": ".---",     // Short I (lowercase)
        "к": "-.-",      // Ka (lowercase)
        "л": ".-..",     // El (lowercase)
        "м": "--",       // Em (lowercase)
        "н": "-.",       // En (lowercase)
        "о": "---",      // O (lowercase)
        "п": ".--.",     // Pe (lowercase)
        "р": ".-.",      // Er (lowercase)
        "с": "...",      // Es (lowercase)
        "т": "-",        // Te (lowercase)
        "у": "..-",      // U (lowercase)
        "ф": "..-.",     // Ef (lowercase)
        "х": "----",     // Kha (lowercase)
        "ц": "-.-.",     // Tse (lowercase)
        "ч": "---.",     // Che (lowercase)
        "ш": "----",     // Sha (lowercase)
        "щ": "--.-",     // Shcha (lowercase)
        "ъ": "--.--",    // Hard Sign (lowercase)
        "ы": "-.--",     // Yeru (lowercase)
        "ь": "-..-",     // Soft Sign (lowercase)
        "э": "..-..",    // E (lowercase)
        "ю": "..--",     // Yu (lowercase)
        "я": ".-.-",     // Ya (lowercase)
        "Ђ": ".--.-",    // Dje
        "Ј": ".---",     // Je
        "Љ": ".-..-",    // Lje
        "Њ": "--.--",    // Nje
        "Ћ": "-.--.-",   // Tshe
        "Џ": "--..-.",   // Dzhe
        "ђ": ".--.-",    // Dje (lowercase)
        "ј": ".---",     // Je (lowercase)
        "љ": ".-..-",    // Lje (lowercase)
        "њ": "--.--",    // Nje (lowercase)
        "ћ": "-.--.-",   // Tshe (lowercase)
        "џ": "--..-.",   // Dzhe (lowercase)
        "Ѡ": ".--",      // Wide On
        "ѡ": ".--",      // Wide on (lowercase, uses same as Ѡ)
        "Ѣ": ".-..",     // Yat
        "ѣ": ".-..",     // Yat (lowercase, uses same as Ѣ)
        "Ѥ": ".--.",     // Yest
        "ѥ": ".--.",     // Yest (lowercase, uses same as Ѥ)
        "Ѧ": ".-.-",     // Little Yus
        "ѧ": ".-.-",     // Little Yus (lowercase, uses same as Ѧ)
        "Ѩ": ".--.-",    // Iotified Little Yus
        "ѩ": ".--.-",    // Iotified Little Yus (lowercase, uses same as Ѩ)
        "Ѫ": "--.",      // Big Yus
        "ѫ": "--.",      // Big Yus (lowercase, uses same as Ѫ)
        "Ѭ": "---.",     // Iotified Big Yus
        "ѭ": "---.",     // Iotified Big Yus (lowercase, uses same as Ѭ)
        "Ѯ": "-.-",      // Ksi
        "ѯ": "-.-",      // Ksi (lowercase, uses same as Ѯ)
        "Ѱ": "..-",      // Psi
        "ѱ": "..-",      // Psi (lowercase, uses same as Ѱ)
        "Ѳ": "..-.",     // Fit
        "ѳ": "..-.",     // Fit (lowercase, uses same as Ѳ)
        "Ѵ": "...-",     // Izhitsa
        "ѵ": "...-",     // Izhitsa (lowercase, uses same as Ѵ)
        "Ѷ": ".-.-.",    // Izhe with Double Grave Accent
        "ѷ": ".-.-.",    // Izhe with Double Grave Accent (lowercase, uses same as Ѷ)
        "Ѹ": ".--.-.",   // Uk
        "ѹ": ".--.-.",   // Uk (lowercase, uses same as Ѹ)
        "Ѻ": "---",      // Omega
        "ѻ": "---",      // Omega (lowercase, uses same as Ѻ)
        "Ѽ": ".----.",   // Ot
        "ѽ": ".----.",   // Ot (lowercase, uses same as Ѽ)
        "Ѿ": "--.--",    // Koppa
        "ѿ": "--.--",    // Koppa (lowercase, uses same as Ѿ)
        "Ҁ": ".----.",   // Hundred Thousands
        "ҁ": ".----.",   // Hundred Thousands (lowercase, uses same as Ҁ)
        "҂": ".----.",   // Million
        "҃": ".----.",   // Million (lowercase, uses same as ҂)
        "҄": ".----.",   // Titlo
        "҅": ".----.",   // Titlo (lowercase, uses same as ҄)
        "҆": ".----.",   // Thousands
        "҇": ".----.",   // Thousands (lowercase, uses same as ҆)
        "҈": ".----.",   // Ten Thousands
        "҉": ".----.",    // Ten Thousands (lowercase, uses same as ҈)
        "Ҋ": ".---.",    // Short U with Diaeresis
        "ҋ": ".---.",    // Short u with Diaeresis (lowercase, uses same as Ҋ)
        "Ҍ": ".--..",    // Zhe with Diaeresis
        "ҍ": ".--..",    // Zhe with Diaeresis (lowercase, uses same as Ҍ)
        "Ҏ": "..-.-",    // Dzhe with Diaeresis
        "ҏ": "..-.-",    // Dzhe with Diaeresis (lowercase, uses same as Ҏ)
        "Ґ": "--.-",     // Ghe with Upturn
        "ґ": "--.-",     // Ghe with Upturn (lowercase, uses same as Ґ)
        "Ғ": "---.",     // Ghe with Stroke
        "ғ": "---.",     // Ghe with Stroke (lowercase, uses same as Ғ)
        "Ҕ": ".-.-.",    // Ghe with Middle Hook
        "ҕ": ".-.-.",    // Ghe with Middle Hook (lowercase, uses same as Ҕ)
        "Җ": "...-",     // Zhje
        "җ": "...-",     // Zhje (lowercase, uses same as Җ)
        "Ҙ": "..-.",     // Zhe with Descender
        "ҙ": "..-.",     // Zhe with Descender (lowercase, uses same as Ҙ)
        "Қ": "-.-",      // Ka with Descender
        "қ": "-.-",      // Ka with Descender (lowercase, uses same as Қ)
        "Ҝ": ".--.",     // Ka with Vertical Stroke
        "ҝ": ".--.",     // Ka with Vertical Stroke (lowercase, uses same as Ҝ)
        "Ҟ": "-..-",     // El with Tail
        "ҟ": "-..-",     // El with Tail (lowercase, uses same as Ҟ)
        "Ҡ": "---",      // En with Descender
        "ҡ": "---",      // En with Descender (lowercase, uses same as Ҡ)
        "Ң": "-.",       // En with Left Hook
        "ң": "-.",       // En with Left Hook (lowercase, uses same as Ң)
        "Ҥ": "..--",     // Che with Descender
        "ҥ": "..--",     // Che with Descender (lowercase, uses same as Ҥ)
        "Ҧ": ".-.-",     // Palochka
        "ҧ": ".-.-",     // Palochka (lowercase, uses same as Ҧ)
        "Ҩ": "..-.-",    // Kha with Stroke
        "ҩ": "..-.-",    // Kha with Stroke (lowercase, uses same as Ҩ)
        "Ҫ": "-.-.",     // Tse with Middle Hook
        "ҫ": "-.-.",     // Tse with Middle Hook (lowercase, uses same as Ҫ)
        "Ҭ": "--..",     // Te with Descender
        "ҭ": "--..",     // Te with Descender (lowercase, uses same as Ҭ)
        "Ү": "..-",      // Straight U
        "ү": "..-",      // Straight u (lowercase, uses same as Ү)
        "Ұ": "-.-",      // Straight U with Stroke
        "ұ": "-.-",      // Straight u with Stroke (lowercase, uses same as Ұ)
        "Ҳ": "----",     // Ha with Descender
        "ҳ": "----",     // Ha with Descender (lowercase, uses same as Ҳ)
        "Ҵ": "--.-",     // Shha
        "ҵ": "--.-",     // Shha (lowercase, uses same as Ҵ)
        "Ҷ": ".--.",     // Che with Vertical Stroke
        "ҷ": ".--.",     // Che with Vertical Stroke (lowercase, uses same as Ҷ)
        "Ҹ": ".--.-.",   // Che with Double Grave Accent
        "ҹ": ".--.-.",   // Che with Double Grave Accent (lowercase, uses same as Ҹ)
        "Һ": "....",     // Ha with Hook
        "һ": "....",     // Ha with Hook (lowercase, uses same as Һ)
        "Ҽ": ".-..-",    // Che with Dot
        "ҽ": ".-..-",    // Che with Dot (lowercase, uses same as Ҽ)
        "Ҿ": "..-..",    // Ze with Descender
        "ҿ": "..-..",    // Ze with Descender (lowercase, uses same as Ҿ)
        "Ӏ": "-",        // Palochka (Izhitsa)
        "Ӂ": ".-.--.",   // Izhitsa Double Grave
        "ӂ": ".-.--.",   // Izhitsa Double Grave (lowercase, uses same as Ӂ)
        "Ӄ": "..--.",    // Uk with Double Grave
        "ӄ": "..--.",    // Uk with Double Grave (lowercase, uses same as Ӄ)
        "Ӆ": "..-.-.",   // Dze with Double Grave
        "ӆ": "..-.-.",   // Dze with Double Grave (lowercase, uses same as Ӆ)
        "Ӈ": "...--",    // Te with Middle Hook
        "ӈ": "...--",    // Te with Middle Hook (lowercase, uses same as Ӈ)
        "Ӊ": "...-.",    // Tse with Middle Hook and Descender
        "ӊ": "...-.",    // Tse with Middle Hook and Descender (lowercase, uses same as Ӊ)
        "Ӌ": ".-...",    // Che with Middle Hook and Tail
        "ӌ": ".-...",    // Che with Middle Hook and Tail (lowercase, uses same as Ӌ)
        "Ӎ": ".-.-.",    // Palochka with Middle Hook
        "ӎ": ".-.-.",    // Palochka with Middle Hook (lowercase, uses same as Ӎ)
        "ӏ": "-.",       // Palochka (Izhitsa, lowercase, uses same as Ӏ)
        "Ӑ": ".-",       // A with Breve
        "ӑ": ".-",       // a with Breve (lowercase, uses same as Ӑ)
        "Ӓ": ".-",       // A with Diaeresis
        "ӓ": ".-",       // a with Diaeresis (lowercase, uses same as Ӓ)
        "Ӕ": ".--",      // Ae
        "ӕ": ".--",      // ae (lowercase, uses same as Ӕ)
        "Ӗ": "..-",      // E with Diaeresis
        "ӗ": "..-",      // e with Diaeresis (lowercase, uses same as Ӗ)
        "Ә": ".--.",     // Schwa
        "ә": ".--.",     // schwa (lowercase, uses same as Ә)
        "Ӛ": ".--.",     // Schwa with Diaeresis
        "ӛ": ".--.",     // schwa with Diaeresis (lowercase, uses same as Ӛ)
        "Ӝ": "...-",     // Zhe with Diaeresis
        "ӝ": "...-",     // zhe with Diaeresis (lowercase, uses same as Ӝ)
        "Ӟ": "...-",     // Ze with Diaeresis
        "ӟ": "...-",     // ze with Diaeresis (lowercase, uses same as Ӟ)
        "Ӡ": "--..",     // Dzhe with Diaeresis
        "ӡ": "--..",     // dzhe with Diaeresis (lowercase, uses same as Ӡ)
        "Ӣ": "..",       // I with Macron
        "ӣ": "..",       // i with Macron (lowercase, uses same as Ӣ)
        "Ӥ": "..",       // I with Diaeresis and Macron
        "ӥ": "..",       // i with Diaeresis and Macron (lowercase, uses same as Ӥ)
        "Ӧ": "..-",      // O with Diaeresis
        "ӧ": "..-",      // o with Diaeresis (lowercase, uses same as Ӧ)
        "Ө": "---",      // Barred O
        "ө": "---",      // barred o (lowercase, uses same as Ө)
        "Ӫ": "---",      // Barred O with Diaeresis
        "ӫ": "---",      // barred o with Diaeresis (lowercase, uses same as Ӫ)
        "Ӭ": ".--",      // Esh with Diaeresis
        "ӭ": ".--",      // esh with Diaeresis (lowercase, uses same as Ӭ)
        "Ӯ": "..--",     // U with Macron
        "ӯ": "..--",     // u with Macron (lowercase, uses same as Ӯ)
        "Ӱ": "..--",     // U with Diaeresis and Macron
        "ӱ": "..--",     // u with Diaeresis and Macron (lowercase, uses same as Ӱ)
        "Ӳ": "..--",     // U with Diaeresis and Acute
        "ӳ": "..--",     // u with Diaeresis and Acute (lowercase, uses same as Ӳ)
        "Ӵ": "-.-",      // Zhe with Diaeresis and Macron
        "ӵ": "-.-",      // zhe with Diaeresis and Macron (lowercase, uses same as Ӵ)
        "Ӷ": "---",      // Zhe with Diaeresis and Breve
        "ӷ": "---",      // zhe with Diaeresis and Breve (lowercase, uses same as Ӷ)
        "Ӹ": "...-",     // Kha with Diaeresis
        "ӹ": "...-",     // kha with Diaeresis (lowercase, uses same as Ӹ)
        "Ӻ": ".-..",     // Tse with Diaeresis
        "ӻ": ".-..",     // tse with Diaeresis (lowercase, uses same as Ӻ)
        "Ӽ": "--.-",     // Che with Diaeresis
        "ӽ": "--.-",     // che with Diaeresis (lowercase, uses same as Ӽ)
        "Ӿ": "..-..",    // Shha with Diaeresis
        "ӿ": "..-..",   // shha with Diaeresis (lowercase, uses same as Ӿ)
        "Ԁ": ".----.",   // Combining Cyrillic Letter Es-Te
        "ԁ": ".----.",   // Combining Cyrillic Letter Es-Te (lowercase, uses same as Ԁ)
        "Ԃ": ".----.",   // Combining Cyrillic Letter A
        "ԃ": ".----.",   // Combining Cyrillic Letter A (lowercase, uses same as Ԃ)
        "Ԅ": ".----.",   // Combining Cyrillic Letter Ve
        "ԅ": ".----.",   // Combining Cyrillic Letter Ve (lowercase, uses same as Ԅ)
        "Ԇ": ".----.",   // Combining Cyrillic Letter Ghe
        "ԇ": ".----.",   // Combining Cyrillic Letter Ghe (lowercase, uses same as Ԇ)
        "Ԉ": ".----.",   // Combining Cyrillic Letter De
        "ԉ": ".----.",   // Combining Cyrillic Letter De (lowercase, uses same as Ԉ)
        "Ԋ": ".----.",   // Combining Cyrillic Letter Ie
        "ԋ": ".----.",   // Combining Cyrillic Letter Ie (lowercase, uses same as Ԋ)
        "Ԍ": ".----.",   // Combining Cyrillic Letter Yi
        "ԍ": ".----.",   // Combining Cyrillic Letter Yi (lowercase, uses same as Ԍ)
        "Ԏ": ".----.",   // Combining Cyrillic Letter Je
        "ԏ": ".----.",   // Combining Cyrillic Letter Je (lowercase, uses same as Ԏ)
        "Ԑ": ".----.",   // Combining Cyrillic Letter Lje
        "ԑ": ".----.",   // Combining Cyrillic Letter Lje (lowercase, uses same as Ԑ)
        "Ԓ": ".----.",   // Combining Cyrillic Letter Nje
        "ԓ": ".----.",   // Combining Cyrillic Letter Nje (lowercase, uses same as Ԓ)
        "Ԕ": ".----.",   // Combining Cyrillic Letter Tshe
        "ԕ": ".----.",   // Combining Cyrillic Letter Tshe (lowercase, uses same as Ԕ)
        "Ԗ": ".----.",   // Combining Cyrillic Letter Kje
        "ԗ": ".----.",   // Combining Cyrillic Letter Kje (lowercase, uses same as Ԗ)
        "Ԙ": ".----.",   // Combining Cyrillic Letter I with Diaeresis
        "ԙ": ".----.",   // Combining Cyrillic Letter I with Diaeresis (lowercase, uses same as Ԙ)
        "Ԛ": ".----.",   // Combining Cyrillic Letter Yi with Diaeresis
        "ԛ": ".----.",   // Combining Cyrillic Letter Yi with Diaeresis (lowercase, uses same as Ԛ)
        "Ԝ": ".----.",   // Combining Cyrillic Letter U
        "ԝ": ".----.",   // Combining Cyrillic Letter U (lowercase, uses same as Ԝ)
        "Ԟ": ".----.",   // Combining Cyrillic Letter Soft Sign
        "ԟ": ".----.",   // Combining Cyrillic Letter Soft Sign (lowercase, uses same as Ԟ)
        "Ԡ": ".----.",   // Combining Cyrillic Letter Uk
        "ԡ": ".----.",   // Combining Cyrillic Letter Uk (lowercase, uses same as Ԡ)
        "Ԣ": ".----.",   // Combining Cyrillic Letter Ghe with Upturn
        "ԣ": ".----.",    // Combining Cyrillic Letter Ghe with Upturn (lowercase, uses same as Ԣ)
    ]
    // hebrew characters
    private static let HebrewToMorse: [String:String] = [
        "א":".-",
        "ב":"-...",
        "ג":"--.",
        "ד":"-..",
        "ה":"---",
        "ו":".",
        "ז":"--..",
        "ח":"....",
        "ט":"..-",
        "י":"..",
        "כ":"-.-",
        "ל":".-..",
        "מ":"--",
        "נ":"-.",
        "ס":"-.-.",
        "ע":".---",
        "פ":".--.",
        "צ":".--",
        "ק":"--.-",
        "ר":".-.",
        "ש":"...",
        "ת":"-"
    ]
    // arabic characters
    private static let ArabicToMorse: [String:String] = [
        "ا":".-",
        "ب":"-...",
        "ت":"-",
        "ث":"-.-.",
        "ج":".---",
        "ح":"....",
        "خ":"---",
        "د":"-..",
        "ذ":"--..",
        "ر":".-.",
        "ز":"---.",
        "س":"...",
        "ش":"----",
        "ص":"-..-",
        "ض":"...-",
        "ط":"..-",
        "ظ":"-.--",
        "ع":".-.-",
        "غ":"--.",
        "ف":"..-.",
        "ق":"--.-",
        "ك":"-.-",
        "ل":".-..",
        "م":"--",
        "ن":"-.",
        "ه":"..-..",
        "و":".--",
        "ي":"..",
        "ﺀ":"."
    ]
    // persian characters
    private static let PersianToMorse: [String:String] = [
        "ا":".-",
        "ب":"-...",
        "پ":".--.",
        "ت":"-",
        "ث":"-.-.",
        "ج":".---",
        "چ":"---.",
        "ح":"....",
        "خ":"-..-",
        "د":"-..",
        "ذ":"...-",
        "ر":".-.",
        "ز":"--..",
        "ژ":"--.",
        "س":"...",
        "ش":"----",
        "ص":".-.-",
        "ض":"..-..",
        "ط":"..-",
        "ظ":"-.--",
        "ع":"---",
        "غ":"..--",
        "ف":"..-.",
        "ق":"---...",
        "ک":"-.-",
        "گ":"--.-",
        "ل":".-..",
        "م":"--",
        "ن":"-.",
        "و":".--",
        "ه":".",
        "ی":".."
    ]
    // kurdish characters
    private static let KurdishToMorse: [String:String] = [
        "ا": ".-",       // Alef
        "ب": "-...",     // Beh
        "پ": ".--.",     // Pe
        "ت": "-",        // Te
        "ج": ".---",     // Jim
        "چ": "-..-",     // Che
        "ح": "----",     // Hah
        "خ": "-..-",     // Khah
        "د": "-..",      // Dal
        "ر": ".-.",      // Reh
        "ز": "--..",     // Ze
        "ژ": "---.",     // Zhe
        "س": "...",      // Seen
        "ش": "----",     // Sheen
        "ص": ".--.",     // Sad
        "ض": "-.-.",     // Zad
        "ط": "..-",      // Ta
        "ظ": "...-",     // Za
        "ع": "..-.",     // Ain
        "غ": "--.",      // Ghain
        "ف": "..-.",     // Fe
        "ق": "--.-",     // Qaf
        "ك": "-.-",      // Kaf
        "ل": ".-..",     // Lam
        "م": "--",       // Mim
        "ن": "-.",       // Noon
        "و": ".--",      // Waw
        "ه": "....",     // Heh
        "ی": "-.--",     // Ye
        "ئ": "..--",     // Hamze
        "ە": "..-..",    // E
        "ێ": "-.--.",    // E
        "گ": "--.",      // Gaf
        "ڤ": "...-",     // Vav
    ]
    // devanagari characters
    private static let DevanagariToMorse: [String:String] = [
        "अ": ".-",         // A
        "आ": ".-",         // AA (long A)
        "इ": "..",         // I
        "ई": "..",         // II (long I)
        "उ": "..-",        // U
        "ऊ": "..-",        // UU (long U)
        "ए": ".-.",        // E
        "ऐ": ".-.",        // AI (long E)
        "ओ": "---",        // O
        "औ": "---",        // AU (long O)
        "क": "-.-",        // Ka
        "ख": "-.-",        // Kha
        "ग": "--.",        // Ga
        "घ": "--.",        // Gha
        "ङ": "--.",        // Nga
        "च": "-.-.",       // Cha
        "छ": "-.-.",       // Chha
        "ज": ".---",       // Ja
        "झ": ".---",       // Jha
        "ञ": ".---",       // Nya
        "ट": "-..-",       // Ta
        "ठ": "-..-",       // Tha
        "ड": "-..-",       // Da
        "ढ": "-..-",       // Dha
        "ण": "-..-",       // Nna
        "त": "-",          // Ta
        "थ": "-",          // Tha
        "द": "-",          // Da
        "ध": "-",          // Dha
        "न": "-",          // Na
        "प": ".--.",       // Pa
        "फ": ".--.",       // Pha
        "ब": "---",        // Ba
        "भ": "---",        // Bha
        "म": "--",         // Ma
        "य": "-.--",       // Ya
        "र": ".-.",        // Ra
        "ल": ".-..",       // La
        "व": "...-",       // Va
        "श": "----",       // Sha
        "ष": ".--.",       // Ssa
        "स": "...",        // Sa
        "ह": "....",       // Ha
        "ा": ".-",         // AA (vowel sign)
        "ि": "..",         // I (vowel sign)
        "ी": "..",         // II (vowel sign)
        "ु": "..-",        // U (vowel sign)
        "ू": "..-",        // UU (vowel sign)
        "े": ".-.",        // E (vowel sign)
        "ै": ".-.",        // AI (vowel sign)
        "ो": "---",        // O (vowel sign)
        "ौ": "---",        // AU (vowel sign)
        "ं": "--.",        // Anusvara (nasalization)
        "ः": "---",        // Visarga (aspiration)
        "्": "-",          // Virama (vowel canceler)
        "ँ": "--.--",      // Chandra Bindu (nasalization)
        "०": "-----",      // Digit 0
        "१": ".----",      // Digit 1
        "२": "..---",      // Digit 2
        "३": "...--",      // Digit 3
        "४": "....-",      // Digit 4
        "५": ".....",      // Digit 5
        "६": "-....",      // Digit 6
        "७": "--...",      // Digit 7
        "८": "---..",      // Digit 8
        "९": "----."       // Digit 9
    ]
    // korean characters
    private static let KoreanToMorse: [String:String] = [
        "ㄱ": ".-..",
        "ㄴ": "..-.",
        "ㄷ": "-...",
        "ㄹ": "...-",
        "ㅁ": "--",
        "ㅂ": ".--",
        "ㅅ": "--.",
        "ㅇ": "-.-",
        "ㅈ": ".--.",
        "ㅊ": "-.-.",
        "ㅋ": "-..-",
        "ㅌ": "--..",
        "ㅍ": "---",
        "ㅎ": ".---",
        "ㅏ": ".",
        "ㅑ": "..",
        "ㅓ": "-",
        "ㅕ": "...",
        "ㅗ": ".-",
        "ㅛ": "-.",
        "ㅜ": "....",
        "ㅠ": ".-.",
        "ㅡ": "-..",
        "ㅣ": "..-",
        "ㅔ": "-.--",
        "ㅐ": "--.-",
        "ㅖ": "... ..-",
        "ㅒ": "....-"
    ]
    // japanese characters
    private static let JapaneseToMorse: [String:String] = [
        "ア":"--.--",
        "カ":".-..",
        "サ":"-.-.-",
        "タ":"-.",
        "ナ":".-.",
        "ハ":"-...",
        "マ":"-..-",
        "ヤ":".--",
        "ラ":"...",
        "ワ":"-.-",
        "イ":".-",
        "キ":"-.-..",
        "シ":"--.-.",
        "チ":"..-.",
        "ニ":"-.-.",
        "ヒ":"--..-",
        "ミ":"..-.-",
        "リ":"--.",
        "ヰ":".-..-",
        "ウ":"..-",
        "ク":"...-",
        "ス":"---.-",
        "ツ":".--.",
        "ヌ":"....",
        "フ":"--..",
        "ム":"-",
        "ユ":"-..--",
        "ル":"-.--.",
        "ン":".-.-.",
        "エ":"-.---",
        "ケ":"-.--",
        "セ":".---.",
        "テ":".-.--",
        "ネ":"--.-",
        "ヘ":".",
        "メ":"-...-",
        "レ":"---",
        "ヱ":".--..",
        "オ":".-...",
        "コ":"----",
        "ソ":"---.",
        "ト":"..-..",
        "ノ":"..--",
        "ホ":"-..",
        "モ":"-..-.",
        "ヨ":"--",
        "ロ":".-.-",
        "ヲ":".---",
        "゛":"..",
        "゜":"..--.",
        "。":".-.-.-",
        "ー":".--.-",
        "、":".-.-.-",
        "（":"-.--.-",
        "）":".-..-."
    ]
    
    // encode string to morse (removing trailing and leading whitespace)
    public static func encode(string: String) -> String {
        var morse: String = ""
        let dictionaries = [AlphaNumToMorse,KoreanToMorse,GreekToMorse,CyrillicToMorse,HebrewToMorse,ArabicToMorse,PersianToMorse,KurdishToMorse,DevanagariToMorse]
        let bigDictionary = dictionaries.reduce(into: [:]) { partialResult, map in
            partialResult = map.merging(partialResult, uniquingKeysWith: { current, _ in
                current
            })
        }
        string.trimmingCharacters(in: .whitespacesAndNewlines).folding(options: .diacriticInsensitive, locale: .current).forEach { char in
            morse.append(bigDictionary[char.description.uppercased()] ?? "")
        }
        return morse
    }
}


extension String {
    // helper function to get single char from string
    func charAt(_ i: Int) -> Character {
        return Array(self)[i]
    }
}
