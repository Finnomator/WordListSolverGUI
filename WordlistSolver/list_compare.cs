

using System;
using System.Collections.Generic;
using System.Diagnostics;

public class list_compare
{
    wordlist WordList;
    public list_compare()
    {
        WordList = new wordlist();
    }

    List<List<char>> get_wordlist_of_list()
    {
        List<List<char>> new_words = new List<List<char>>();
        string[] words = WordList.words;
        for (int i = 0; i < words.Length; i++)
        {
            new_words.Add(new List<char>());
            foreach (char l in words[i])
            {
                new_words[i].Add(char.ToLower(l));
            }

        }

        return new_words;
    }

    public List<string> wordlist(string request, bool endless_word, bool allow_spaces = true)
    {


        if (endless_word)
        {
            request = request.Replace(":", "").ToLower();

            string[] words = WordList.words;
            
            List<string> res = new List<string>();
            foreach (string word in words)
            {
                if (word.ToLower().StartsWith(request))
                {
                    res.Add(word);
                }
            }
            return res;
        }

        List<List<char>> word_list = get_wordlist_of_list();
        int length = request.Length;
        request = request.ToLower();
        char[] request_list = request.ToCharArray();

        List<List<char>> approved = new List<List<char>>();
        foreach (List<char> i in word_list)
        {
            if (length == i.Count)
            {
                approved.Add(i);
            }
        }

        List<string> super_approved = new List<string>();
        foreach (List<char> i in approved)
        {
            bool fitting = true;
            for (int j = 0; j < length; j++)
            {
                if (request_list[j] != '_' && request_list[j] != i[j])
                {
                    fitting = false;
                    break;
                }
            }
            if (fitting)
            {
                if (allow_spaces)
                {
                    super_approved.Add(string.Join("", i));
                }
                else
                {
                    if (!i.Contains(' ') || Array.IndexOf(request_list, ' ') > -1)
                    {
                        super_approved.Add(string.Join("", i));
                    }
                }
            }
        }
        return super_approved;
    }
}