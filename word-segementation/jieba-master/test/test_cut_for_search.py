#encoding=utf-8
from __future__ import print_function
import sys
sys.path.append("../")
import jieba

def cuttest(test_sent):
    result = jieba.cut_for_search(test_sent)
    for word in result:
        print(word,end=' ')
    print("")


if __name__ == "__main__":
    cuttest("这是一个伸手不见五指的黑夜。我叫孙悟空，我爱北京，我爱Python和C++。")

