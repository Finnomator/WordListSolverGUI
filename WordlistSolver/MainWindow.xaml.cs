using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace WordlistSolver
{

    public class MyLabel
    {
        public TextBox label;
        public MyLabel(string content, int x, int y, int fontsize)
        {
            label = new TextBox();
            label.Height = Double.NaN;
            label.Width = Double.NaN;
            label.FontSize = fontsize;
            label.FontFamily = new System.Windows.Media.FontFamily("Segoe Ui");
            label.IsReadOnly = true;
            label.Background = null;
            label.BorderBrush = null;
            label.BorderThickness = new Thickness(0, 0, 0, 0);

            label.Margin = new Thickness(x, y, 0, 0);
            label.Padding = new Thickness(0, 0, 0, 0);

            label.HorizontalAlignment = HorizontalAlignment.Left;
            label.VerticalAlignment = VerticalAlignment.Top;
            label.Text = content;

        }
    }

    public class MyButton
    {
        public Button button;

        public MyButton(string text, int x, int y, int fontsize, RoutedEventHandler handler, string name)
        {
            button = new Button();
            button.Height = fontsize;
            button.Width = 70;
            //button.FontSize = fontsize;
            button.Name = name.Replace(" ","_").Replace("-","__");
            button.Click += handler;
            button.FontFamily = new FontFamily("Segoe Ui");
            button.BorderThickness = new Thickness(0, 0, 0, 0);
            button.Background = new SolidColorBrush(Color.FromRgb(179, 194, 242));

            button.Margin = new Thickness(0, y, x, 0);
            button.Padding = new Thickness(-5, -5.5, -5, -5);

            button.HorizontalAlignment = HorizontalAlignment.Right;
            button.VerticalAlignment = VerticalAlignment.Top;
            button.Content = text;
        }
    }

    public partial class MainWindow : Window
    {
        bool first = true;
        bool first2 = true;
        int copy_num = -1;
        list_compare wc;
        public MainWindow()
        {
            InitializeComponent();
            MainGrid.Children.Remove(Scroller);
            wc = new list_compare();
        }
        void make_output()
        {

            if (!(bool)UseLabelsCheck.IsChecked)
            {

                if (WordInputTextBox.Text.Length < 3)
                {
                    OutputTextBox.Text = "";
                    return;
                }

                List<string> posible_words;

                if (copy_num == -1)
                {
                    posible_words = wc.wordlist(WordInputTextBox.Text, !(bool)AttentionSpace.IsChecked);
                }
                else
                {
                    posible_words = wc.wordlist(WordInputTextBox.Text.Replace(copy_num.ToString(), ""), !(bool)AttentionSpace.IsChecked);
                    if (copy_num > posible_words.Count || copy_num < 1)
                    {
                        return;
                    }
                    Clipboard.SetText(posible_words[copy_num - 1]);
                    return;
                }

                OutputTextBox.Text = "";
                if ((bool)ReplaceHyphonWith_.IsChecked)
                {
                    int oldpos = WordInputTextBox.SelectionStart;
                    WordInputTextBox.Text = WordInputTextBox.Text.Replace("-", "_");
                    WordInputTextBox.SelectionStart = oldpos;
                }

                if (posible_words.Count == 1 && (bool)AutoCopyBox.IsChecked)
                {
                    Clipboard.SetText(posible_words[0]);
                }

                int digits = posible_words.Count.ToString().Length;

                for (int i = 0; i < posible_words.Count; i++)
                {
                    string space = new string(' ', (digits - (i + 1).ToString().Length) * 2);
                    OutputTextBox.AppendText((i + 1) + ". " + space + posible_words[i] + Environment.NewLine);
                }
            }

            else
            {
                if (WordInputTextBox.Text.Length < 3)
                {
                    LabelGrid.Children.Clear();
                    return;
                }

                List<string> posible_words;

                if (copy_num == -1)
                {
                    posible_words = wc.wordlist(WordInputTextBox.Text, !(bool)AttentionSpace.IsChecked);
                }
                else
                {
                    posible_words = wc.wordlist(WordInputTextBox.Text.Replace(copy_num.ToString(), ""), !(bool)AttentionSpace.IsChecked);
                    if (copy_num > posible_words.Count || copy_num < 1)
                    {
                        return;
                    }
                    Clipboard.SetText(posible_words[copy_num - 1]);
                    return;
                }

                LabelGrid.Children.Clear();
                if ((bool)ReplaceHyphonWith_.IsChecked)
                {
                    int oldpos = WordInputTextBox.SelectionStart;
                    WordInputTextBox.Text = WordInputTextBox.Text.Replace("-", "_");
                    WordInputTextBox.SelectionStart = oldpos;
                }

                if (posible_words.Count == 1 && (bool)AutoCopyBox.IsChecked)
                {
                    Clipboard.SetText(posible_words[0]);
                }

                int digits = posible_words.Count.ToString().Length;

                for (int i = 0; i < posible_words.Count; i++)
                {

                    int x = 0;
                    int fontsize = int.Parse(FontSizeBox.Text);
                    int y = i * (fontsize + 3);

                    string space = new string(' ', (digits - (i + 1).ToString().Length) * 2);
                    MyLabel mylabel = new MyLabel((i + 1) + ". " + space + posible_words[i], x, y, fontsize);
                    LabelGrid.Children.Add(mylabel.label);

                    MyButton copybutton = new MyButton("Copy " + (i + 1) + ".", 30, y, fontsize, ClickCopyButton, posible_words[i]);

                    LabelGrid.Children.Add(copybutton.button);
                }
            }
        }


        int extract_num_fromstring(string theString)
        {
            bool foundnum = false;
            int i = 0;
            for (; i < theString.Length; i++)
            {
                if (char.IsNumber(theString[i]))
                {
                    foundnum = true;
                    break;
                }
            }

            if (foundnum)
            {
                int end = theString.Length - i;
                int num;
                if (int.TryParse(theString.Substring(i, end), out num))
                {
                    return num;
                }

            }

            return -1;
        }

        private async void InputChange(object sender, TextChangedEventArgs e)
        {

            if (!first)
            {
                int wlength = 0;

                for (int i = 0; i < WordInputTextBox.Text.Length; i++)
                {
                    if (!int.TryParse(WordInputTextBox.Text[i].ToString(), out int _))
                    {
                        wlength++;
                    }
                }

                WordLengthLabel.Content = "Word length: " + wlength;
            }
            else
            {
                first = false;
            }

            async Task<bool> UserKeepsTyping()
            {
                string txt = WordInputTextBox.Text;
                if (int.TryParse(TextUpdateTimeBox.Text, out int n))
                {
                    await Task.Delay(n);
                }
                else
                {
                    await Task.Delay(100);
                    TextUpdateTimeBox.Text = "100";
                }

                return txt != WordInputTextBox.Text;
            }
            if (await UserKeepsTyping()) return;

            copy_num = extract_num_fromstring(WordInputTextBox.Text);

            make_output();
        }

        private void CheckBoxCheck(object sender, RoutedEventArgs e)
        {
            make_output();
        }

        private void FontSizeChange(object sender, TextChangedEventArgs e)
        {

            if (int.TryParse(FontSizeBox.Text, out int n))
            {
                OutputTextBox.FontSize = n;
            }
            else
            {
                if (FontSizeBox.Text == "")
                {
                    OutputTextBox.FontSize = 16;
                }
                else
                {
                    FontSizeBox.Text = "16";
                }
            }

        }

        private void UseLabelsClick(object sender, RoutedEventArgs e)
        {
            if ((bool)UseLabelsCheck.IsChecked)
            {
                MainGrid.Children.Remove(OutputTextBox);
                MainGrid.Children.Add(Scroller);
            }
            else
            {
                MainGrid.Children.Add(OutputTextBox);
                MainGrid.Children.Remove(Scroller);
            }

            make_output();
        }

        public void ClickCopyButton(object sender, EventArgs e)
        {
            string wordtocopy = ((Button)sender).Name.Replace("__", "-").Replace("_"," ");
            Clipboard.SetText(wordtocopy);
        }
    }
}
