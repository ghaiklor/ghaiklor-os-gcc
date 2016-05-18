extern char _ctype[];

#define CT_UP 0x01
#define CT_LOW 0x02
#define CT_DIG 0x04
#define CT_CTL 0x08
#define CT_PUN 0x10
#define CT_WHT 0x20
#define CT_HEX 0x40
#define CT_SP 0x80

#define isalnum(c) ((_ctype + 1)[(unsigned)(c)] & (CT_UP | CT_LOW | CT_DIG))
#define isalpha(c) ((_ctype + 1)[(unsigned)(c)] & (CT_UP | CT_LOW))
#define iscntrl(c) ((_ctype + 1)[(unsigned)(c)] & (CT_CTL))
#define isdigit(c) ((_ctype + 1)[(unsigned)(c)] & (CT_DIG))
#define isgraph(c) ((_ctype + 1)[(unsigned)(c)] & (CT_PUN | CT_UP | CT_LOW | CT_DIG))
#define islower(c) ((_ctype + 1)[(unsigned)(c)] & (CT_LOW))
#define isprint(c) ((_ctype + 1)[(unsigned)(c)] & (CT_PUN | CT_UP | CT_LOW | CT_DIG | CT_SP))
#define ispunct(c) ((_ctype + 1)[(unsigned)(c)] & (CT_PUN))
#define isspace(c) ((_ctype + 1)[(unsigned)(c)] & (CT_WHT))
#define isupper(c) ((_ctype + 1)[(unsigned)(c)] & (CT_UP))
#define isxdigit(c) ((_ctype + 1)[(unsigned)(c)] & (CT_DIG | CT_HEX))
#define isascii(c) ((unsigned)(c) <= 0x7F)
#define toascii(c) ((unsigned)(c) & 0x7F)
#define tolower(c) (isupper(c) ? c + 'a' - 'A' : c)
#define toupper(c) (islower(c) ? c + 'A' - 'a' : c)
