import spell_checker_and_suggester as scs

word = input("Enter a word: ")
suggested_word = scs.spell_check(word)
if suggested_word:
    print('You have spelled', word, 'correctly')
else:
    print('Did you mean:', scs.word_suggestion(word))
