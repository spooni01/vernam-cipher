# Vernam cipher

The Vernam cipher is a method of encrypting alphabetic text. In this mechanism, add to each odd character of the ASCII text the value of the first character of the original text and to each even character of the ASCII text the value of the second character of the original text.

<h2>Encryption algorithm</h2>
<ul>
<li>save the first and second characters as ASCII table values</li>
<li>add the value of the first key to each odd character</li>
<li>subtract the value of the second key from each even character</li>
<li>continue until come across a number that indicates the end of encryption</li>
</ul>

<h2>Technical data</h2>
Architecture: MIPS64 
