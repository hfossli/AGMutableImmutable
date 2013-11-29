### AGMutableImmutable

An attempt to make creation of immutable objects easier when subclassed. If you don't want to support subclassing I recommend doing as with NSParagraphStyle. 

Work here is based on http://www.jonmsterling.com/posts/2012-12-27-a-pattern-for-immutability.html

And https://github.com/nicklockwood/AutoCoding

I feel bad about

- Having to type the name of the property 4 times
- How important the semantics are (have a look at `AGCar.m`)
- That the `update:` and `new:` blocks is declared as `id mutableInstance`
- The automagic way of supporting NSCopying - even though it's quite handy

I hope there is some way to solve these issues

------
[![Agens | Digital craftsmanship](http://static.agens.no/images/agens_logo_w_slogan_avenir_small.png)](http://agens.no/)
