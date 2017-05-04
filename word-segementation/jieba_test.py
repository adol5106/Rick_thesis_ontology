#encoding=utf-8
import sys
sys.path.append("../")
import jieba


def cuttest(test_sent):
    result = jieba.cut(test_sent)
    return (" ".join(result)).encode('utf-8')

file_path="I:/Dropbox/Qingyun-Zhang/Thesis-799A/data_points/placenames/wordcloud_bj/wordcloud_txt_unseg/changan_ave.txt"
file=open(file_path,"r")
file_text=file.read()
file_path_out="I:/Dropbox/Qingyun-Zhang/Thesis-799A/data_points/placenames/wordcloud_bj/wordcloud_txt_seg/changan_ave.txt"
file_out=open(file_path_out,"w")


if __name__ == "__main__":
    word_seg=cuttest(file_text)
    file_out.write(word_seg)
    file_out.close()
