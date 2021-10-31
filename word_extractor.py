from nltk.corpus import words
import pickle as pkl

word_list = []
for word in words.words():
    word_list.append(word.lower())

file = open('word_list.pkl', 'wb')
pkl.dump(word_list, file)
file.close()

