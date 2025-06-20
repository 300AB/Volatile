# Markdown notes & examples

# h1
## h2
### h3 
#### h4
##### h5
###### h6
###### I use indentations as shown here to show literal formatting
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

![image.png](image.png)  

    ![image.png](image.png)

- dash
  - nested dash
* asterisk
  * nested asterick
+ plus
  + nested plus

1. List item one
   1. nested list item one
   2. nested list item two
2. List item two

---
      - dash
        - nested dash
      * asterisk
        * nested asterick
      + plus
        + nested plus

      1. List item one
         1. nested list item one
         2. nested list item two
      2. List item two


## Some extended versions of md  
thus not all GFM (GitHub Flavored Markdown)

### Flavor Notes  
- **CommonMark** → Clean, strict, portable  
- **GFM** → Adds tables, task lists, emoji, strikethrough  
- **HTML-in-Markdown** → Rendered if allowed; varies by platform

| Column 1      | Column 2                   |
| ------------- | -------------------------- |
| Cell 1, Row 1 | Cell 2, Row 1 Column 2     |
| Cell 1, Row 2 | Cell 1, Row 2, in Column 2 |

    | Column 1      | Column 2                   |  ← Tables aren't CommonMark, GFM though
    | ------------- | -------------------------- |
    | Cell 1, Row 1 | Cell 2, Row 1 Column 2     |
    | Cell 1, Row 2 | Cell 1, Row 2, in Column 2 |


==highlight== ← Markdown-it & Obsidian support this; not CommonMark or GFM  
<mark>highlighted via html tag</mark>

    <mark>highlighted via html tag</mark>

^superscript^  
Plain text <sup>sup html</sup>  
Plain text <sub>drop down</sub>

    Plain text <sup>sup html</sup>
    Plain text <sub>sub html</sub>

Pasted emote 😄  
:smile: ← GFM emoji shortcode (may not render outside GitHub)  

    :smile: ← GFM emoji shortcode (may not render outside GitHub)  

Plain text `mono spaced text or code` ← CommonMark  

```python
print("hello")
    print("hello")
```

    ```python
    print("hello")
        print("hello")
    ```
Tab-indented blocks also works ← CommonMark  

[GitHub file path](md.md) ← CommonMark syntax; label, path resolution depends on the renderer  
[Link text](https://github.com/300AB/Volatile/blob/main/md.md) ← CommonMark  
<https://github.com/300AB/Volatile/blob/main/md.md> ← CommonMark autolink  

    [GitHub file path](md.md) ← CommonMark syntax; label, path resolution depends on the renderer  
    [Link text](https://github.com/300AB/Volatile/blob/main/md.md) ← CommonMark  
    <https://github.com/300AB/Volatile/blob/main/md.md> ← CommonMark autolink  

And this is crossed ~~out~~ ← GFM, otherwise its just double tilda end caps  
And here is an html tag example <s>here</s>  

    And this is crossed ~~out~~ ← GFM, otherwise its just double tilda end caps  
    And here is an html tag example <s>here</s>  

- [x] checked item ← GFM task list  
- [ ] unchecked item ← GFM task list

    - [x] checked item ← GFM task list  
    - [ ] unchecked item ← GFM task list  

