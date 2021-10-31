import pickle as pkl
from nltk import jaccard_distance as jc
from nltk import edit_distance as ed

# loading the words in dictionary to a list "words"
words_file = open('word_list.pkl', 'rb')
words = pkl.load(words_file)
words_file.close()

bi_gram_file = open('bi-gram_list_.pkl', 'rb')
bi_gram_list = pkl.load(bi_gram_file)  # loading bi-grams to a list
bi_gram_file.close()

tri_gram_file = open('tri-gram_list_.pkl', 'rb')
tri_gram_list = pkl.load(tri_gram_file)  # loading tri-grams to a list
tri_gram_file.close()


def spell_check(word):
    # checking if word is in word list or not
    if word in words:
        return True  # if word is spelled correct it will return true
    else:
        return False  # else suggest correct spelling of the word


def n_gram_filter(word):
    if len(word) < 8:
        filtered_words = bi_gram_filter(word)  # if word length is less than 8, bi-grams are used
    else:
        filtered_words = tri_gram_filter(word)  # else tri-grams are used
    return filtered_words


def bi_gram_filter(word):  # takes the input word
    print('Extracting bigrams...')  # filter outs the bi-grams which do not consist of any bi-gram of given word
    word_index = 0
    word_bi_grams = n_gram_converter(2, word)  # returns bi-grams of given word
    filtered_words = []
    for bi_grams in bi_gram_list:
        for word_bi_gram in word_bi_grams:
            if word_bi_gram in bi_grams:
                if (len(words[word_index]) > len(word) - 3) & (len(words[word_index]) < len(word) + 3):  # restricting too long & too short words
                    filtered_words.append(words[word_index])  # appending words
                break
        word_index += 1
    return filtered_words


def tri_gram_filter(word):  # takes the input word
    print('Extracting trigrams...')  # filter outs the tri-grams which do not consist of any tri-gram of given word
    word_index = 0
    word_tri_grams = n_gram_converter(3, word)  # returns tri-grams of given word
    filtered_words = []
    for tri_grams in tri_gram_list:
        for word_tri_gram in word_tri_grams:
            if word_tri_gram in tri_grams:
                if (len(words[word_index]) > len(word) - 3) & (len(words[word_index]) < len(word) + 3):  # restricting too long & too short words
                    filtered_words.append(words[word_index])  # appending words
                break
        word_index += 1
    return filtered_words


def n_gram_converter(n, word):  # extracts bi-grams or tri-grams of a given word
    processed_word = []
    letter_no = 0
    if n == 2:
        for bi_gram_no in range(len(word) - 1):
            processed_word.append(word[letter_no:letter_no + 2])
            letter_no = letter_no + 1
        return processed_word
    else:
        for tri_gram_no in range(len(word) - 2):
            processed_word.append(word[letter_no:letter_no + 3])
            letter_no = letter_no + 1
        return processed_word


def jaccard_filter(word):  # filter outs the word with jaccard coefficient less than 0.4
    filtered_words = n_gram_filter(word)
    print('Calculating Jaccard Distance of '+word+' with', len(filtered_words), 'words')
    set_word = set(word)  # changing to set data type to perform set operations
    jc_filtered_words = []
    fw_index = 0
    for x in filtered_words:
        n_gram_set = set(x)  # changing to set data type to perform set operations
        # jc = len(n_gram_word & n_gram_set)/len(n_gram_word | n_gram_set)  # calculating jaccard coefficient
        if jc(set_word, n_gram_set) < 0.4:
            jc_filtered_words.append(filtered_words[fw_index])
        fw_index += 1
    return jc_filtered_words


def word_suggestion(word):  # calculates edit distance with all the filtered words
    jc_filtered_words = jaccard_filter(word)
    print('Calculating Edit Distance of '+word+' with', len(jc_filtered_words), 'words')
    # n_gram_word, jc_filtered_words, n_gram_filtered = n_gram_filter(word)
    edit_distance_list = []
    for x in jc_filtered_words:
        edit_distance_list.append(ed(word, x))
    # for i in range(3):
    min_edit_dist_index = edit_distance_list.index(min(edit_distance_list))
    return jc_filtered_words[min_edit_dist_index]  # returns the word with least edit distance



