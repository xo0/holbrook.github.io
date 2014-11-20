---
layout: page
title: 心内求法与心外求法
---

<p>Hello Visitor,</p>
<p>Welcome to my humble blog. I mostly write about web development, but every now and then I write about technologies that I have been playing with. If you have any question, suggestion or correction feel free to leave a comment or you can always find me at adrian(-at-)ncona.com.</p>
<p>If you want to know more about me, you can take a look at LinkedIn profile: <a href="http://www.linkedin.com/in/adriananconanovelo" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://www.linkedin.com/in/adriananconanovelo', 'http://www.linkedin.com/in/adriananconanovelo']);"  title="Adrian Ancona LinkedIn account">http://www.linkedin.com/in/adriananconanovelo</a></p>
<p>Enjoy!</p>

<script type="text/javascript">
  /* <![CDATA[ */
    function grin(tag) {
      var myField;
      tag = ' ' + tag + ' ';
      if (document.getElementById('comment') && document.getElementById('comment').type == 'textarea') {
        myField = document.getElementById('comment');
      } else {
        return false;
      }
      if (document.selection) {
        myField.focus();
        sel = document.selection.createRange();
        sel.text = tag;
        myField.focus();
      }
      else if (myField.selectionStart || myField.selectionStart == '0') {
        var startPos = myField.selectionStart;
        var endPos = myField.selectionEnd;
        var cursorPos = endPos;
        myField.value = myField.value.substring(0, startPos)
                + tag
                + myField.value.substring(endPos, myField.value.length);
        cursorPos += tag.length;
        myField.focus();
        myField.selectionStart = cursorPos;
        myField.selectionEnd = cursorPos;
      }
      else {
        myField.value += tag;
        myField.focus();
      }
    }
  /* ]]> */
  </script>
