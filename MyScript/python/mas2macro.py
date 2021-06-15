import sys
import os


# 递归遍历文件夹
def scan(p: str, func):
    for file in os.listdir(p):
        if p[-1] == '/':
            url = p + file
        else:
            url = p + '/' + file

        if os.path.isdir(url):
            scan(url, func)
        elif os.path.isfile(url):
            func(url)


# 打开文件进行读写操作
def replace(f):
    if f[-1] != 'm':
        return
    print(f)
    try:
        f1 = open(f, 'r', encoding='utf-8')
        text = f1.read()
        f1.close()
        text = transform(text)
        f2 = open(f, 'w', encoding='utf-8')
        f2.write(text)
        f2.close()
    finally:
        print('')


mapper = {
    ' mas_makeConstraints:^(MASConstraintMaker *make)': 'IESLiveMasMaker(',
    ' mas_updateConstraints:^(MASConstraintMaker *make)': 'IESLiveMasUpdate(',
    ' mas_remakeConstraints:^(MASConstraintMaker *make)': 'IESLiveMasReMaker(',
    ' ieslive_makeConstraints:^(MASConstraintMaker *make)': 'IESLiveMasMaker(',
    ' ieslive_updateConstraints:^(MASConstraintMaker *make)': 'IESLiveMasUpdate(',
    ' ieslive_remakeConstraints:^(MASConstraintMaker *make)': 'IESLiveMasReMaker(',
    ' ieslive_makeConstraints:^(MASConstraintMaker * _Nonnull make)': 'IESLiveMasMaker(',
    ' ieslive_updateConstraints:^(MASConstraintMaker * _Nonnull make)': 'IESLiveMasUpdate(',
    ' ieslive_remakeConstraints:^(MASConstraintMaker * _Nonnull make)': 'IESLiveMasReMaker(',
    ' ieslive_makeConstraints: ^(MASConstraintMaker *make)': 'IESLiveMasMaker(',
    ' ieslive_updateConstraints: ^(MASConstraintMaker *make)': 'IESLiveMasUpdate(',
    ' ieslive_remakeConstraints: ^(MASConstraintMaker *make)': 'IESLiveMasReMaker(',
}


# 没搞清楚正则怎么玩，生匹吧~
def transform(s: str) -> str:
    origin = s
    for k, v in mapper.items():
        s = mas2macro(s, k, v)
    return s if origin == s else transform(s)


def mas2macro(s: str, s1: str, s2: str) -> str:
    i = s.find(s1)
    if i != -1:
        s = s.replace(s1, ',', 1)
        temp = i
        while temp > 0:
            if s[temp] == '[':
                s_prev = s[0: temp]
                s_next = s[temp + 1:]
                s = s_prev + s2 + s_next
                break
            else:
                temp -= 1
        temp = i
        left = 0
        while temp < len(s) - 1:
            c = s[temp]
            if c == '[':
                left += 1
                temp += 1
            elif c == ']':
                if left == 0:
                    s = s[0:temp] + ')' + s[temp + 1:]
                    break
                else:
                    left -= 1
                    temp += 1
            else:
                temp += 1

    return s


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Input a file path please!")
        exit(-1)

    path = sys.argv[1]
    scan(path, replace)
    print('👌 Done!')
    exit(0)
