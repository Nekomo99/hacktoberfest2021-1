import pickle


file = open('word_list.txt', 'rb')

# loading the words in a list
dictionary = pickle.load(file)
# code for bi-gram

bi_gram_list = []
word_no = 0  # to position a word in dictionary

for word in dictionary:
    word_length = len(word)

    if word_length < 2:
        bi_gram_list.append(word[:2])

    else:
        bi_grams = []
        letter_no = 0
        for bi_gram_no in range(word_length - 1):
            bi_grams.append(word[letter_no:letter_no + 2])
            letter_no = letter_no+1
        bi_gram_list.append(bi_grams)

bi_gram = open('bi-gram_list_.pkl', 'wb')
pickle.dump(bi_gram_list, bi_gram)
bi_gram.close()
# code for tri-gram

tri_gram_list = []
word_no = 0  # to position a word in dictionary

for word in dictionary:
    word_length = len(word)

    if word_length < 3:
        tri_gram_list.append(word[:3])

    else:
        tri_grams = []
        letter_no = 0
        for tri_gram_no in range(word_length - 2):
            tri_grams.append(word[letter_no:letter_no + 3])
            letter_no = letter_no+1
        tri_gram_list.append(tri_grams)

tri_gram = open('tri-gram_list_.pkl', 'wb')
pickle.dump(tri_gram_list, tri_gram)
tri_gram.close()
