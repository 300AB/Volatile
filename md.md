# Markdown notes & examples

# h1
## h2
### h3 
#### h4
##### h5
###### h6
    # h1
    ## h2
    ### h3 
    #### h4
    ##### h5
    ###### h6

Plain text **bold text** though __underscore works__ same *here* and _here_  
Or __*such*__ ***mixing***  
Line broken with double space  

    Plain text **bold text** though __underscore works__ same *here* and _here_  
    Or __*such*__ ***mixing***  
    Line broken with double space  

| Column 1      | Column 2      |
| ------------- | ------------- |
| Cell 1, Row 1 | Cell 2, Row 1 |
| Cell 1, Row 2 | Cell 1, Row 2 |
    | Column 1      | Column 2      |
    | ------------- | ------------- |
    | Cell 1, Row 1 | Cell 2, Row 1 |
    | Cell 1, Row 2 | Cell 1, Row 2 |


## Some extended versions of md  
thus not all GFM (GitHub Flavored Markdown)

==highlight== ← Not CommonMark nor GFM  
<mark>highlighted via html tag</mark>

    <mark>highlighted via html tag</mark>

^superscript^  
Plain text <sup>sup html</sup>  
Plain text <sub>drop down</sub>

    Plain text <sup>sup html</sup>
    Plain text <sub>sub html</sub>

Pasted emote 😄  
:smile: using another method  

    :smile: using another method  

Plain text `mono spaced text or code` ← CommonMark  

```python
print("hello")
    print("hello")
```

    ```python
    print("hello")
        print("hello")
    ```
Tab spacing also works, which isn't extended version of md  

[GitHub file path](md.md) ← In CommonMark this is a label, else it depends on renderer  
[Link text](https://github.com/300AB/Volatile/blob/main/md.md) ← CommonMark  
<https://github.com/300AB/Volatile/blob/main/md.md> ← CommonMark autolink  

    [GitHub file path](md.md) ← In CommonMark this is a label, else it depends on renderer  
    [Link text](https://github.com/300AB/Volatile/blob/main/md.md) ← CommonMark  
    <https://github.com/300AB/Volatile/blob/main/md.md> ← CommonMark autolink  

And this is crossed ~~out~~ ← GFM, otherwise its just double tilda end caps  
And here is an html tag example <s>here</s>  

    And this is crossed ~~out~~ ← GFM, otherwise its just double tilda end caps  
    And here is an html tag example <s>here</s>  
