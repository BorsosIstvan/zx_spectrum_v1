# zx_typist_hex_custom.py
# Zet BASIC programma (.txt of .bas) om naar keys.hex voor ZX Spectrum typist
# Met zelf te definiëren keycodes voor keywords

# Alle gewone karakters
char_map = {
    'a': (1, 0b11110, 0b000),  # row 5, key 0, geen modifier
    'A': (1, 0b11110, 0b010),  # SS + a
    's': (1, 0b11101, 0b000),
    'S': (1, 0b11101, 0b010),
    'd': (1, 0b11011, 0b000),
    'D': (1, 0b11011, 0b010),
    'f': (1, 0b10111, 0b000),
    'F': (1, 0b10111, 0b010),
    'g': (1, 0b01111, 0b000),
    'G': (1, 0b01111, 0b010),   # GOTO
    '^': (1, 0b01111, 0b001),   #THEN
    'q': (2, 0b11110, 0b000),  # row 5, key 0, geen modifier
    'Q': (2, 0b11110, 0b010),  # SS + a
    'w': (2, 0b11101, 0b000),
    'W': (2, 0b11101, 0b010),
    'e': (2, 0b11011, 0b000),
    'E': (2, 0b11011, 0b010),
    'r': (2, 0b10111, 0b000),
    'R': (2, 0b10111, 0b010),
    '<': (2, 0b10111, 0b001),
    't': (2, 0b01111, 0b000),
    'T': (2, 0b01111, 0b010),
    '>': (2, 0b01111, 0b001),
    '1': (3, 0b11110, 0b000),
    '!': (3, 0b11110, 0b001),
    '2': (3, 0b11101, 0b000),
    '@': (3, 0b11101, 0b001),
    '3': (3, 0b11011, 0b000),
    '#': (3, 0b11011, 0b001),
    '4': (3, 0b10111, 0b000),
    '$': (3, 0b10111, 0b001),
    '5': (3, 0b01111, 0b000),
    '%': (3, 0b01111, 0b001),
    '0': (4, 0b11110, 0b000),  # row 5, key 0, geen modifier
    '_': (4, 0b11110, 0b001),  # SS + a
    '9': (4, 0b11101, 0b000),
    ')': (4, 0b11101, 0b001),
    '8': (4, 0b11011, 0b000),
    '(': (4, 0b11011, 0b001),
    '7': (4, 0b10111, 0b000),
    '`': (4, 0b10111, 0b001),
    '6': (4, 0b01111, 0b000),
    '&': (4, 0b01111, 0b001),
    
#    'z': (1, 0b11110, 0b000),  # row 5, key 0, geen modifier
#    'Z': (1, 0b11110, 0b010),  # SS + a
    'z': (0, 0b11101, 0b000),
    'Z': (0, 0b11101, 0b010),
    'x': (0, 0b11011, 0b000),
    '[': (0, 0b11011, 0b010),   #ink
    'X': (0, 0b11011, 0b010),
    'c': (0, 0b10111, 0b000),
    'C': (0, 0b10111, 0b010),
    ']': (0, 0b10111, 0b001),   #paper
    'v': (0, 0b01111, 0b000),
    'V': (0, 0b01111, 0b010),
    '/': (0, 0b01111, 0b001),
    'p': (5, 0b11110, 0b000),
    'P': (5, 0b11110, 0b010),   # PRINT
    '"': (5, 0b11110, 0b001),
    'o': (5, 0b11101, 0b000),
    'O': (5, 0b11101, 0b010),
    ';': (5, 0b11101, 0b001),
    'i': (5, 0b11011, 0b000),
    'I': (5, 0b11011, 0b010),
    '~': (5, 0b11011, 0b001),  # AT
    'u': (5, 0b10111, 0b000),
    'U': (5, 0b10111, 0b010),
    'y': (5, 0b01111, 0b000),
    'Y': (5, 0b01111, 0b010),
#    'enter': (6, 0b11110, 0b000),  # row 5, key 0, geen modifier
#    'A': (6, 0b11110, 0b010),  # SS + a
    'l': (6, 0b11101, 0b000),
    'L': (6, 0b11101, 0b010),
    '=': (6, 0b11101, 0b001),
    'k': (6, 0b11011, 0b000),
    'K': (6, 0b11011, 0b010),
    '+': (6, 0b11011, 0b001),
    'j': (6, 0b10111, 0b000),
    'J': (6, 0b10111, 0b010),
    '-': (6, 0b10111, 0b001),
    'h': (6, 0b01111, 0b000),
    'H': (6, 0b01111, 0b010),
    ' ': (7, 0b11110, 0b000),  # row 5, key 0, geen modifier
#    ' ': (7, 0b11110, 0b010),  # SS + a
#    'ss': (7, 0b11101, 0b000),
#    'SS': (7, 0b11101, 0b010),
    'm': (7, 0b11011, 0b000),
    'M': (7, 0b11011, 0b010),
    '.': (7, 0b11011, 0b001),
    'n': (7, 0b10111, 0b000),
    'N': (7, 0b10111, 0b010),
    ',': (7, 0b10111, 0b001),
    'b': (7, 0b01111, 0b000),
    'B': (7, 0b01111, 0b010),
    '*': (7, 0b01111, 0b001),

    '\n': (6, 0b11110, 0b000),  # ENTER bv op row7 key0

}

# Zelf te bepalen keywords en hun keycodes
keyword_map = {
    "PRINT": (5, 0b11110, 0b010),
    "GOTO":  (1, 0b01111, 0b010),
    "RUN":   (2, 0b10111, 0b010),
    "LET":   (6, 0b11101, 0b010),
    "CLS":   (0, 0b01111, 0b010),
    "AT":    (5, 0b11011, 0b001),
    "IF":    (5, 0b10111, 0b010),
    "THEN":  (1, 0b01111, 0b001),
    "GOTO":  (1, 0b01111, 0b010),
    "INK":   (0, 0b11011, 0b001),
    "PAPER": (0, 0b10111, 0b001),
    
}

# Zet een tuple (row, key, mod) om naar hexcode
def to_hexcode(row, key, mod):
    return f"{row:02X}{((mod & 0b111) << 5) | (key & 0b11111):02X}"

# Zet een karakter om naar hex
def char_to_hex(char):
    if char in char_map:
        row, key, mod = char_map[char]
        return to_hexcode(row, key, mod)
    else:
        print(f"⚠️ Onbekend karakter: {char}")
        return "0000"

# Zet een keyword om naar hexcode
def keyword_to_hex(keyword):
    if keyword.upper() in keyword_map:
        row, key, mod = keyword_map[keyword.upper()]
        return [to_hexcode(row, key, mod)]
    return []

# Zet hele tekst om naar hexcodes
def text_to_hex(text):
    hex_codes = []

    for line in text.splitlines():  # verwerk regel per regel
        tokens = line.split()  # splits de regel in woorden/tokens

        for token in tokens:
            if token.upper() in keyword_map:
                hex_codes += keyword_to_hex(token)
            else:
                for ch in token:
                    hex_codes.append(char_to_hex(ch))
            hex_codes.append(char_to_hex(' '))  # spatie tussen tokens

        hex_codes.append(char_to_hex('\n'))  # ENTER na elke regel

    hex_codes.append("FFFF")  # einde-markering
    return hex_codes

def main():
    infile = "zx_bas.txt"
    outfile = "zx_type.hex"

    with open(infile, "r") as f:
        text = f.read()

    codes = text_to_hex(text)

    with open(outfile, "w") as f:
        for code in codes:
            f.write(code + "\n")

    print(f"{len(codes)} codes geschreven naar {outfile}")

if __name__ == "__main__":
    main()